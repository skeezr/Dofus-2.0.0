package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatTextOutputAction implements Action
   {
       
      private var _content:String;
      
      private var _channel:uint;
      
      private var _receiverName:String;
      
      private var _objects:Array;
      
      public function ChatTextOutputAction()
      {
         super();
      }
      
      public static function create(msg:String, channel:uint = 0, receiverName:String = "", objects:Array = null) : ChatTextOutputAction
      {
         var a:ChatTextOutputAction = new ChatTextOutputAction();
         a._content = msg;
         a._channel = channel;
         a._receiverName = receiverName;
         a._objects = objects;
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
      
      public function get receiverName() : String
      {
         return this._receiverName;
      }
      
      public function get objects() : Array
      {
         return this._objects;
      }
   }
}
