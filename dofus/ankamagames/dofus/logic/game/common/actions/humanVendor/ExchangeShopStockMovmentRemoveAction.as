package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShopStockMovmentRemoveAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:int;
      
      public function ExchangeShopStockMovmentRemoveAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:int) : ExchangeShopStockMovmentRemoveAction
      {
         var a:ExchangeShopStockMovmentRemoveAction = new ExchangeShopStockMovmentRemoveAction();
         a._objectUID = pObjectUID;
         a._quantity = -Math.abs(pQuantity);
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
   }
}
