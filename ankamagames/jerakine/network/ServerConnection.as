package com.ankamagames.jerakine.network
{
   import flash.net.Socket;
   import flash.events.IEventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import flash.utils.ByteArray;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.IDataInput;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import com.ankamagames.jerakine.network.messages.ServerConnectionClosedMessage;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   
   public class ServerConnection extends Socket implements IEventDispatcher, IServerConnection
   {
      
      private static const DEBUG_DATA:Boolean = true;
      
      private static const LATENCY_AVG_BUFFER_SIZE:uint = 50;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerConnection));
       
      private var _rawParser:com.ankamagames.jerakine.network.RawDataParser;
      
      private var _handler:MessageHandler;
      
      private var _remoteSrvHost:String;
      
      private var _remoteSrvPort:uint;
      
      private var _connecting:Boolean;
      
      private var _outputBuffer:Array;
      
      private var _splittedPacket:Boolean;
      
      private var _staticHeader:int;
      
      private var _splittedPacketId:uint;
      
      private var _splittedPacketLength:uint;
      
      private var _inputBuffer:ByteArray;
      
      private var _pauseBuffer:Array;
      
      private var _pause:Boolean;
      
      private var _latencyBuffer:Array;
      
      private var _latestSent:uint;
      
      public function ServerConnection(host:String = null, port:int = 0)
      {
         this._pauseBuffer = new Array();
         this._latencyBuffer = new Array();
         super(host,port);
         this._remoteSrvHost = host;
         this._remoteSrvPort = port;
      }
      
      public function get rawParser() : com.ankamagames.jerakine.network.RawDataParser
      {
         return this._rawParser;
      }
      
      public function set rawParser(value:com.ankamagames.jerakine.network.RawDataParser) : void
      {
         this._rawParser = value;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(value:MessageHandler) : void
      {
         this._handler = value;
      }
      
      public function get latencyAvg() : uint
      {
         var latency:uint = 0;
         if(this._latencyBuffer.length == 0)
         {
            return 0;
         }
         var total:uint = 0;
         for each(latency in this._latencyBuffer)
         {
            total = total + latency;
         }
         return total / this._latencyBuffer.length;
      }
      
      public function get latencySamplesCount() : uint
      {
         return this._latencyBuffer.length;
      }
      
      public function get latencySamplesMax() : uint
      {
         return LATENCY_AVG_BUFFER_SIZE;
      }
      
      override public function connect(host:String, port:int) : void
      {
         if(this._connecting)
         {
            return;
         }
         this._connecting = true;
         this._remoteSrvHost = host;
         this._remoteSrvPort = port;
         this.addListeners();
         _log.trace("Connecting to " + host + ":" + port + "...");
         super.connect(host,port);
      }
      
      public function send(msg:INetworkMessage) : void
      {
         if(DEBUG_DATA)
         {
            _log.trace("[SND] " + msg);
         }
         if(!msg.isInitialized)
         {
            _log.warn("Sending non-initialized packet " + msg + " !");
         }
         _log.logDirectly(new NetworkLogEvent(msg,false));
         if(!connected)
         {
            if(this._connecting)
            {
               this._outputBuffer.push(msg);
            }
            return;
         }
         this.lowSend(msg);
      }
      
      override public function toString() : String
      {
         var status:* = "Server connection status:\n";
         status = status + ("  Connected:       " + (!!connected?"Yes":"No") + "\n");
         if(connected)
         {
            status = status + ("  Connected to:    " + this._remoteSrvHost + ":" + this._remoteSrvPort + "\n");
         }
         else
         {
            status = status + ("  Connecting:      " + (!!this._connecting?"Yes":"No") + "\n");
         }
         if(this._connecting)
         {
            status = status + ("  Connecting to:   " + this._remoteSrvHost + ":" + this._remoteSrvPort + "\n");
         }
         status = status + ("  Raw parser:      " + this.rawParser + "\n");
         status = status + ("  Message handler: " + this.handler + "\n");
         if(this._outputBuffer)
         {
            status = status + ("  Output buffer:   " + this._outputBuffer.length + " message(s)\n");
         }
         if(this._inputBuffer)
         {
            status = status + ("  Input buffer:    " + this._inputBuffer.length + " byte(s)\n");
         }
         if(this._splittedPacket)
         {
            status = status + "  Splitted message in the input buffer:\n";
            status = status + ("    Message ID:      " + this._splittedPacketId + "\n");
            status = status + ("    Awaited length:  " + this._splittedPacketLength + "\n");
         }
         return status;
      }
      
      public function pause() : void
      {
         this._pause = true;
      }
      
      public function resume() : void
      {
         var msg:INetworkMessage = null;
         this._pause = false;
         for each(msg in this._pauseBuffer)
         {
            if(DEBUG_DATA)
            {
               _log.trace("[RCV] " + msg);
            }
            _log.logDirectly(new NetworkLogEvent(msg,true));
            this._handler.process(msg);
         }
         this._pauseBuffer = [];
      }
      
      private function addListeners() : void
      {
         addEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData,false,0,true);
         addEventListener(Event.CONNECT,this.onConnect,false,0,true);
         addEventListener(Event.CLOSE,this.onClose,false,0,true);
         addEventListener(IOErrorEvent.IO_ERROR,this.onSocketError,false,0,true);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
      }
      
      private function removeListeners() : void
      {
         removeEventListener(ProgressEvent.SOCKET_DATA,this.onSocketData);
         removeEventListener(Event.CONNECT,this.onConnect);
         removeEventListener(Event.CLOSE,this.onClose);
         removeEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
         removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
      }
      
      private function receive() : void
      {
         var msg:INetworkMessage = null;
         var count:uint = 0;
         try
         {
            while(this.bytesAvailable > 0)
            {
               msg = this.lowReceive();
               if(msg != null)
               {
                  if(!this._pause)
                  {
                     if(DEBUG_DATA)
                     {
                        _log.trace("[RCV] " + msg);
                     }
                     _log.logDirectly(new NetworkLogEvent(msg,true));
                     this._handler.process(msg);
                  }
                  else
                  {
                     this._pauseBuffer.push(msg);
                  }
                  count++;
                  continue;
               }
               break;
            }
         }
         catch(e:Error)
         {
            if(e.getStackTrace())
            {
               _log.error("Error while reading socket. " + e.getStackTrace());
            }
            else
            {
               _log.error("Error while reading socket. No stack trace available");
            }
            close();
         }
      }
      
      private function getMessageId(firstOctet:uint) : uint
      {
         return firstOctet >> NetworkMessage.BIT_RIGHT_SHIFT_LEN_PACKET_ID;
      }
      
      private function readMessageLength(staticHeader:uint, src:IDataInput) : uint
      {
         var byteLenDynamicHeader:uint = staticHeader & NetworkMessage.BIT_MASK;
         var messageLength:uint = 0;
         switch(byteLenDynamicHeader)
         {
            case 0:
               break;
            case 1:
               messageLength = src.readUnsignedByte();
               break;
            case 2:
               messageLength = src.readUnsignedShort();
               break;
            case 3:
               messageLength = ((src.readByte() & 255) << 16) + ((src.readByte() & 255) << 8) + (src.readByte() & 255);
         }
         return messageLength;
      }
      
      protected function lowSend(msg:INetworkMessage, autoFlush:Boolean = true) : void
      {
         msg.pack(this);
         this._latestSent = getTimer();
         if(autoFlush)
         {
            flush();
         }
      }
      
      protected function lowReceive() : INetworkMessage
      {
         var msg:INetworkMessage = null;
         var staticHeader:uint = 0;
         var messageId:uint = 0;
         var messageLength:uint = 0;
         if(!this._splittedPacket)
         {
            staticHeader = readUnsignedShort();
            messageId = this.getMessageId(staticHeader);
            if(bytesAvailable >= (staticHeader & NetworkMessage.BIT_MASK))
            {
               messageLength = this.readMessageLength(staticHeader,this);
               if(bytesAvailable >= messageLength)
               {
                  this.updateLatency();
                  msg = this._rawParser.parse(this,messageId,messageLength);
                  return msg;
               }
               this._staticHeader = -1;
               this._splittedPacketLength = messageLength;
               this._splittedPacketId = messageId;
               this._splittedPacket = true;
               readBytes(this._inputBuffer,0,bytesAvailable);
               return null;
            }
            this._staticHeader = staticHeader;
            this._splittedPacketLength = messageLength;
            this._splittedPacketId = messageId;
            this._splittedPacket = true;
            return null;
         }
         if(this._staticHeader != -1)
         {
            this._splittedPacketLength = this.readMessageLength(this._staticHeader,this);
            this._staticHeader = -1;
         }
         if(bytesAvailable + this._inputBuffer.length >= this._splittedPacketLength)
         {
            readBytes(this._inputBuffer,this._inputBuffer.length,this._splittedPacketLength - this._inputBuffer.length);
            this._inputBuffer.position = 0;
            this.updateLatency();
            msg = this._rawParser.parse(this._inputBuffer,this._splittedPacketId,this._splittedPacketLength);
            this._splittedPacket = false;
            this._inputBuffer = new ByteArray();
            return msg;
         }
         readBytes(this._inputBuffer,this._inputBuffer.length,bytesAvailable);
         return null;
      }
      
      private function updateLatency() : void
      {
         if(Boolean(this._pause) || this._pauseBuffer.length > 0 || this._latestSent == 0)
         {
            return;
         }
         var packetReceived:uint = getTimer();
         var latency:uint = packetReceived - this._latestSent;
         this._latestSent = 0;
         this._latencyBuffer.push(latency);
         if(this._latencyBuffer.length > LATENCY_AVG_BUFFER_SIZE)
         {
            this._latencyBuffer.shift();
         }
      }
      
      protected function onConnect(e:Event) : void
      {
         var msg:INetworkMessage = null;
         this._connecting = false;
         if(DEBUG_DATA)
         {
            _log.trace("Connection opened.");
         }
         for each(msg in this._outputBuffer)
         {
            this.lowSend(msg,false);
         }
         flush();
         this._inputBuffer = new ByteArray();
         this._outputBuffer = new Array();
      }
      
      protected function onClose(e:Event) : void
      {
         if(DEBUG_DATA)
         {
            _log.trace("Connection closed.");
         }
         setTimeout(this.removeListeners,30000);
         this._handler.process(new ServerConnectionClosedMessage(this));
         this._connecting = false;
         this._outputBuffer = new Array();
      }
      
      protected function onSocketData(pe:ProgressEvent) : void
      {
         this.receive();
      }
      
      protected function onSocketError(e:IOErrorEvent) : void
      {
         _log.error("Failure while opening socket.");
         this._connecting = false;
         this._handler.process(new ServerConnectionFailedMessage(this,e.text));
      }
      
      protected function onSecurityError(see:SecurityErrorEvent) : void
      {
         if(this.connected)
         {
            _log.error("Security error while connected : " + see.text);
            this._handler.process(new ServerConnectionFailedMessage(this,see.text));
         }
         else
         {
            _log.error("Security error while disconnected : " + see.text);
         }
      }
   }
}
