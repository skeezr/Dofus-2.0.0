package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseSellFromInsideAction implements Action
   {
       
      private var _amount:uint;
      
      public function HouseSellFromInsideAction()
      {
         super();
      }
      
      public static function create(amount:uint) : HouseSellFromInsideAction
      {
         var action:HouseSellFromInsideAction = new HouseSellFromInsideAction();
         action._amount = amount;
         return action;
      }
      
      public function get amount() : uint
      {
         return this._amount;
      }
   }
}
