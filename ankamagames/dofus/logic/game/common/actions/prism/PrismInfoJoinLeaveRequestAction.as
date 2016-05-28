package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismInfoJoinLeaveRequestAction implements Action
   {
       
      private var _join:Boolean;
      
      public function PrismInfoJoinLeaveRequestAction()
      {
         super();
      }
      
      public static function create(join:Boolean) : PrismInfoJoinLeaveRequestAction
      {
         var action:PrismInfoJoinLeaveRequestAction = new PrismInfoJoinLeaveRequestAction();
         action._join = join;
         return action;
      }
      
      public function get join() : Boolean
      {
         return this._join;
      }
   }
}
