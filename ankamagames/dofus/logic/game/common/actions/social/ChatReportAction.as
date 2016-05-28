package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatReportAction implements Action
   {
       
      private var _reportedId:uint;
      
      private var _reason:uint;
      
      private var _channel:uint;
      
      private var _timestamp:Number;
      
      private var _fingerprint:String;
      
      private var _message:String;
      
      private var _name:String;
      
      public function ChatReportAction()
      {
         super();
      }
      
      public static function create(reportedId:uint, reason:uint, name:String, channel:uint, fingerprint:String, message:String, timestamp:Number) : ChatReportAction
      {
         var a:ChatReportAction = new ChatReportAction();
         a._reportedId = reportedId;
         a._reason = reason;
         a._channel = channel;
         a._timestamp = timestamp;
         a._fingerprint = fingerprint;
         a._message = message;
         a._name = name;
         return a;
      }
      
      public function get reportedId() : uint
      {
         return this._reportedId;
      }
      
      public function get reason() : uint
      {
         return this._reason;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
      
      public function get timestamp() : Number
      {
         return this._timestamp;
      }
      
      public function get fingerprint() : String
      {
         return this._fingerprint;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
