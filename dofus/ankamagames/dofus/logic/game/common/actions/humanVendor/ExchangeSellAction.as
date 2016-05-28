package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeSellAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:uint;
      
      public function ExchangeSellAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:uint) : ExchangeSellAction
      {
         var a:ExchangeSellAction = new ExchangeSellAction();
         a._objectUID = pObjectUID;
         a._quantity = pQuantity;
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
   }
}
