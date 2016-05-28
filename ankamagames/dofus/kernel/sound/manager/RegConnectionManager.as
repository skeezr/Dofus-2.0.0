package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.net.Socket;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   
   public class RegConnectionManager
   {
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager));
      
      private static var _self:com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager;
       
      private var _sock:Socket;
      
      private var _socketClientID:Number;
      
      private var _socketAvaible:Boolean;
      
      private var _buffer:Array;
      
      private var _isMain:Boolean = true;
      
      public function RegConnectionManager(pSingletonEnforcer:SingletonEnforcer)
      {
         super();
         if(_self)
         {
            throw new Error("RegConnectionManager is a Singleton");
         }
         this.init();
      }
      
      public static function getInstance() : com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager(new SingletonEnforcer());
         }
         return _self;
      }
      
      public function get socketClientID() : Number
      {
         return this._socketClientID;
      }
      
      public function get isMain() : Boolean
      {
         return this._isMain;
      }
      
      public function send(pMethodName:String, ... params) : void
      {
         if(!this._socketAvaible)
         {
            this._buffer.push({
               "method":pMethodName,
               "params":params
            });
            return;
         }
         if(pMethodName == ProtocolEnum.SAY_GOODBYE)
         {
            this._sock.writeUTFBytes(String(0));
            this._sock.writeUTFBytes("=>" + pMethodName + "();" + this._socketClientID + "=>" + ProtocolEnum.PLAY_SOUND + "(10,100)");
            this._sock.writeUTFBytes("|");
            this._sock.flush();
         }
         else
         {
            this._sock.writeUTFBytes(String(this._socketClientID));
            this._sock.writeUTFBytes("=>" + pMethodName + "(" + params + ")");
            this._sock.writeUTFBytes("|");
            this._sock.flush();
         }
      }
      
      private function init() : void
      {
         this._socketClientID = new Date().time;
         this._sock = new Socket();
         this._sock.addEventListener(ProgressEvent.SOCKET_DATA,this.onData);
         this._sock.addEventListener(Event.CONNECT,this.onSocketConnect);
         this._sock.addEventListener(Event.CLOSE,this.onSocketClose);
         this._sock.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
         this._sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         this._sock.connect("localhost",8081);
         this._buffer = [];
      }
      
      private function showInformationPopup() : void
      {
         var commonMod:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.warning")),I18n.getText(I18nProxy.getKeyId("ui.common.soundsDeactivated")),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
      }
      
      private function onSocketClose(e:Event) : void
      {
         this._socketAvaible = false;
         _log.error("The socket has been closed");
         this.showInformationPopup();
      }
      
      private function onData(pEvent:ProgressEvent) : void
      {
         var cmd:String = null;
         var functionName:String = null;
         var clientId:Number = NaN;
         var cmds:Array = this._sock.readUTFBytes(pEvent.bytesLoaded).split("|");
         for each(cmd in cmds)
         {
            if(cmd == "")
            {
               return;
            }
            functionName = cmd.split("(")[0];
            switch(functionName)
            {
               case ProtocolEnum.REG_SHUT_DOWN:
                  this._socketAvaible = false;
                  _log.error("The socket connection with REG has been lost");
                  this.showInformationPopup();
                  continue;
               case ProtocolEnum.REG_IS_UP:
                  this._socketAvaible = true;
                  _log.info("The socket connection with REG has been established");
                  continue;
               case ProtocolEnum.MAIN_CLIENT_IS:
                  clientId = Number(cmd.split(":")[1]);
                  if(clientId == this._socketClientID && !this._isMain)
                  {
                     this._isMain = true;
                     (SoundManager.getInstance().manager as RegSoundManager).activateSound();
                  }
                  else if(this._isMain)
                  {
                     this._isMain = false;
                     (SoundManager.getInstance().manager as RegSoundManager).deactivateSound();
                  }
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function onSocketError(e:Event) : void
      {
         this._socketAvaible = false;
         _log.error("Connection to Reg failed");
      }
      
      private function onSocketSecurityError(e:Event) : void
      {
      }
      
      private function onSocketConnect(e:Event) : void
      {
         var cmd:Object = null;
         this._socketAvaible = true;
         if(this._buffer.length)
         {
            while(this._buffer.length)
            {
               cmd = this._buffer.shift();
               CallWithParameters.call(this.send,([cmd.method] as Array).concat(cmd.params));
            }
         }
      }
   }
}

class SingletonEnforcer
{
    
   function SingletonEnforcer()
   {
      super();
   }
}
