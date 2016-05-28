package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AuthorizedCommandAction implements Action
   {
       
      private var _command:String;
      
      public function AuthorizedCommandAction()
      {
         super();
      }
      
      public static function create(command:String) : AuthorizedCommandAction
      {
         var a:AuthorizedCommandAction = new AuthorizedCommandAction();
         a._command = command;
         return a;
      }
      
      public function get command() : String
      {
         return this._command;
      }
   }
}
