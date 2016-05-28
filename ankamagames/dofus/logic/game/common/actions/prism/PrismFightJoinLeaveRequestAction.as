package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismFightJoinLeaveRequestAction implements Action
   {
       
      private var _join:Boolean;
      
      public function PrismFightJoinLeaveRequestAction()
      {
         super();
      }
      
      public static function create(join:Boolean) : PrismFightJoinLeaveRequestAction
      {
         var action:PrismFightJoinLeaveRequestAction = new PrismFightJoinLeaveRequestAction();
         action._join = join;
         return action;
      }
      
      public function get join() : Boolean
      {
         return this._join;
      }
   }
}
