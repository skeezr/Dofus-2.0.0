package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SaveMessageAction implements Action
   {
       
      private var _content:String;
      
      private var _channel:uint;
      
      private var _timestamp:Number;
      
      public function SaveMessageAction()
      {
         super();
      }
      
      public static function create(msg:String, channel:uint, timestamp:Number) : SaveMessageAction
      {
         var a:SaveMessageAction = new SaveMessageAction();
         a._content = msg;
         a._channel = channel;
         a._timestamp = timestamp;
         return a;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
      
      public function get timestamp() : Number
      {
         return this._timestamp;
      }
   }
}
