package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.ObjectEncoding;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.AsyncErrorEvent;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.messages.VideoConnectFailedMessage;
   import com.ankamagames.berilia.components.messages.VideoConnectSuccessMessage;
   import com.ankamagames.berilia.components.messages.VideoBufferChangeMessage;
   
   public class VideoPlayer extends GraphicContainer implements FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(VideoPlayer));
       
      private var _finalized:Boolean;
      
      private var _video:Video;
      
      private var _netConnection:NetConnection;
      
      private var _netStream:NetStream;
      
      private var _flv:String;
      
      private var _fms:String;
      
      private var _client:Object;
      
      private var _autoPlay:Boolean;
      
      public function VideoPlayer()
      {
         super();
      }
      
      public function finalize() : void
      {
         NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
         this._video = new Video(width,height);
         addChild(this._video);
         this._client = new Object();
         this._client.onBWDone = this.onBWDone;
         this._client.onMetaData = this.onMetaData;
         this._netConnection = new NetConnection();
         this._netConnection.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         this._netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this._netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onASyncError);
         this._netConnection.client = this._client;
         if(this._autoPlay)
         {
            this.connect();
         }
         this._finalized = true;
         getUi().iAmFinalized(this);
      }
      
      public function connect() : void
      {
         if(this._fms)
         {
            this._netConnection.connect(this._fms);
         }
         else
         {
            _log.error("No Media Server to connect to :(");
         }
      }
      
      public function play() : void
      {
         if(this._flv)
         {
            this._netStream = new NetStream(this._netConnection);
            this._netStream.client = this._client;
            this._netStream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
            this._netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onASyncError);
            this._video.attachNetStream(this._netStream);
            this._netStream.play(this._flv);
         }
         else
         {
            _log.error("No Video File to play :(");
         }
      }
      
      public function stop() : void
      {
         if(this._netStream)
         {
            this._netStream.close();
         }
         this._netConnection.close();
         this._video.clear();
      }
      
      private function onNetStatus(event:NetStatusEvent) : void
      {
         switch(event.info.code)
         {
            case "NetConnection.Connect.Failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Can\'t connect to media server " + this._fms);
               break;
            case "NetStream.Failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Can\'t connect to media server " + this._fms);
               break;
            case "NetStream.Play.StreamNotFound":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Video file " + this._flv + "doesn\'t exist");
               break;
            case "Netstream.Play.failed":
               Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
               _log.error("Video streaming failed for an unknown reason");
               break;
            case "NetConnection.Connect.Success":
               if(this._autoPlay)
               {
                  this.play();
               }
               Berilia.getInstance().handler.process(new VideoConnectSuccessMessage(this));
               break;
            case "NetStream.Buffer.Full":
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,0));
               break;
            case "NetStream.Buffer.Flush":
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,2));
               break;
            case "NetStream.Buffer.Empty":
               Berilia.getInstance().handler.process(new VideoBufferChangeMessage(this,1));
         }
      }
      
      private function onSecurityError(event:SecurityErrorEvent) : void
      {
         Berilia.getInstance().handler.process(new VideoConnectFailedMessage(this));
         _log.error("Security Error: " + event);
      }
      
      private function onASyncError(event:AsyncErrorEvent) : void
      {
         _log.warn("ASyncError: " + event);
      }
      
      private function onBWDone() : void
      {
      }
      
      private function onMetaData(info:Object) : void
      {
      }
      
      public function set flv(value:String) : void
      {
         this._flv = value;
      }
      
      public function set fms(value:String) : void
      {
         this._fms = value;
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function set autoPlay(value:Boolean) : void
      {
         this._autoPlay = value;
      }
      
      public function set finalized(value:Boolean) : void
      {
         this._finalized = value;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
   }
}
