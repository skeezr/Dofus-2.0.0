package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseLockFromInsideAction implements Action
   {
       
      private var _code:String;
      
      public function HouseLockFromInsideAction()
      {
         super();
      }
      
      public static function create(code:String) : HouseLockFromInsideAction
      {
         var action:HouseLockFromInsideAction = new HouseLockFromInsideAction();
         action._code = code;
         return action;
      }
      
      public function get code() : String
      {
         return this._code;
      }
   }
}
