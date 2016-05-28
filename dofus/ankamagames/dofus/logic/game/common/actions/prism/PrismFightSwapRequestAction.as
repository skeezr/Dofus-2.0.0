package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismFightSwapRequestAction implements Action
   {
       
      private var _targetId:uint;
      
      public function PrismFightSwapRequestAction()
      {
         super();
      }
      
      public static function create(targetId:uint) : PrismFightSwapRequestAction
      {
         var action:PrismFightSwapRequestAction = new PrismFightSwapRequestAction();
         action._targetId = targetId;
         return action;
      }
      
      public function get targetId() : uint
      {
         return this._targetId;
      }
   }
}
