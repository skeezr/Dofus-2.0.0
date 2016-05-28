package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatClientMultiAction implements Action
   {
       
      private var _content:String;
      
      private var _channel:uint;
      
      public function ChatClientMultiAction()
      {
         super();
      }
      
      public static function create(content:String, channel:uint) : ChatClientMultiAction
      {
         var a:ChatClientMultiAction = new ChatClientMultiAction();
         a._channel = channel;
         a._content = content;
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
   }
}
