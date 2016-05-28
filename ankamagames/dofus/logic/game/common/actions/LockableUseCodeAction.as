package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LockableUseCodeAction implements Action
   {
       
      private var _code:String;
      
      public function LockableUseCodeAction()
      {
         super();
      }
      
      public static function create(code:String) : LockableUseCodeAction
      {
         var action:LockableUseCodeAction = new LockableUseCodeAction();
         action._code = code;
         return action;
      }
      
      public function get code() : String
      {
         return this._code;
      }
   }
}
