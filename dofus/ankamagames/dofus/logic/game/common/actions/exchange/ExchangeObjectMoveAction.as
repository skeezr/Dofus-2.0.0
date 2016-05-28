package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectMoveAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:int;
      
      public function ExchangeObjectMoveAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pQuantity:int) : ExchangeObjectMoveAction
      {
         var a:ExchangeObjectMoveAction = new ExchangeObjectMoveAction();
         a._objectUID = pObjectUID;
         a._quantity = pQuantity;
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
