package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseSellAction implements Action
   {
       
      private var _amount:uint;
      
      public function HouseSellAction()
      {
         super();
      }
      
      public static function create(amount:uint) : HouseSellAction
      {
         var action:HouseSellAction = new HouseSellAction();
         action._amount = amount;
         return action;
      }
      
      public function get amount() : uint
      {
         return this._amount;
      }
   }
}
