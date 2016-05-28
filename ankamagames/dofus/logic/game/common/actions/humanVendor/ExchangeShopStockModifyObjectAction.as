package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShopStockModifyObjectAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:uint;
      
      private var _price:int;
      
      public function ExchangeShopStockModifyObjectAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:uint, pPrice:int) : ExchangeShopStockModifyObjectAction
      {
         var a:ExchangeShopStockModifyObjectAction = new ExchangeShopStockModifyObjectAction();
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
      
      public function get price() : int
      {
         return this._price;
      }
   }
}
