package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectUseInWorkshopAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:int;
      
      public function ExchangeObjectUseInWorkshopAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:uint) : ExchangeObjectUseInWorkshopAction
      {
         var action:ExchangeObjectUseInWorkshopAction = new ExchangeObjectUseInWorkshopAction();
         action._objectUID = pObjectUID;
         action._quantity = pQuantity;
         return action;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
   }
}
