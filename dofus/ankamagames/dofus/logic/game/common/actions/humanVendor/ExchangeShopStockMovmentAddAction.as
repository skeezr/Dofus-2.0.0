package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShopStockMovmentAddAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:uint;
      
      private var _price:uint;
      
      public function ExchangeShopStockMovmentAddAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:uint, pPrice:uint) : ExchangeShopStockMovmentAddAction
      {
         var a:ExchangeShopStockMovmentAddAction = new ExchangeShopStockMovmentAddAction();
         a._objectUID = pObjectUID;
         a._quantity = pQuantity;
         a._price = pPrice;
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
      
      public function get price() : uint
      {
         return this._price;
      }
   }
}
