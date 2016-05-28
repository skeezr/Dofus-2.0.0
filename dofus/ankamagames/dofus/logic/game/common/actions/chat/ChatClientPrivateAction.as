package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatClientPrivateAction implements Action
   {
       
      private var _content:String;
      
      private var _receiver:String;
      
      public function ChatClientPrivateAction()
      {
         super();
      }
      
      public static function create(content:String, receiver:String) : ChatClientPrivateAction
      {
         var a:ChatClientPrivateAction = new ChatClientPrivateAction();
         a._receiver = receiver;
         a._content = content;
         return a;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get receiver() : String
      {
         return this._receiver;
      }
   }
}
