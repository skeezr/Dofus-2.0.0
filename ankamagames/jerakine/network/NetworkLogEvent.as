package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.logger.LogEvent;
   import flash.events.Event;
   
   public class NetworkLogEvent extends LogEvent
   {
       
      private var _msg:com.ankamagames.jerakine.network.INetworkMessage;
      
      private var _isServerMsg:Boolean;
      
      public function NetworkLogEvent(msg:com.ankamagames.jerakine.network.INetworkMessage, isServerMsg:Boolean)
      {
         super(null,null,0);
         this._msg = msg;
         this._isServerMsg = isServerMsg;
      }
      
      public function get networkMessage() : com.ankamagames.jerakine.network.INetworkMessage
      {
         return this._msg;
      }
      
      public function get isServerMsg() : Boolean
      {
         return this._isServerMsg;
      }
      
      override public function clone() : Event
      {
         return new NetworkLogEvent(this._msg,this._isServerMsg);
      }
   }
}
