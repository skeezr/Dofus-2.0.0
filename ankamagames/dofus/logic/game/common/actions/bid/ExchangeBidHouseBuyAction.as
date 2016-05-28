package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseBuyAction implements Action
   {
       
      private var _uid:uint;
      
      private var _qty:uint;
      
      private var _price:uint;
      
      public function ExchangeBidHouseBuyAction()
      {
         super();
      }
      
      public static function create(pUid:uint, pQty:uint, pPrice:uint) : ExchangeBidHouseBuyAction
      {
         var a:ExchangeBidHouseBuyAction = new ExchangeBidHouseBuyAction();
         a._uid = pUid;
         a._qty = pQty;
         a._price = pPrice;
         return a;
      }
      
      public function get uid() : uint
      {
         return this._uid;
      }
      
      public function get qty() : uint
      {
         return this._qty;
      }
      
      public function get price() : uint
      {
         return this._price;
      }
   }
}
