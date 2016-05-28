package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatCommandAction implements Action
   {
       
      private var _command:String;
      
      public function ChatCommandAction()
      {
         super();
      }
      
      public static function create(command:String) : ChatCommandAction
      {
         var a:ChatCommandAction = new ChatCommandAction();
         a._command = command;
         return a;
      }
      
      public function get command() : String
      {
         return this._command;
      }
   }
}
