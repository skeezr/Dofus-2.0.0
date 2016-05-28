package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LockableChangeCodeAction implements Action
   {
       
      private var _code:String;
      
      public function LockableChangeCodeAction()
      {
         super();
      }
      
      public static function create(code:String) : LockableChangeCodeAction
      {
         var action:LockableChangeCodeAction = new LockableChangeCodeAction();
         action._code = code;
         return action;
      }
      
      public function get code() : String
      {
         return this._code;
      }
   }
}
