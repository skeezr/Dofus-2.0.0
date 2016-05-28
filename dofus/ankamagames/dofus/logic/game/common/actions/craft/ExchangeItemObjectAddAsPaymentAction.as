package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeItemObjectAddAsPaymentAction implements Action
   {
       
      private var _onlySuccess:Boolean;
      
      private var _objectUID:uint;
      
      private var _quantity:int;
      
      private var _isAdd:Boolean;
      
      public function ExchangeItemObjectAddAsPaymentAction()
      {
         super();
      }
      
      public static function create(pOnlySuccess:Boolean, pObjectUID:uint, pIsAdd:Boolean, pQuantity:int) : ExchangeItemObjectAddAsPaymentAction
      {
         var action:ExchangeItemObjectAddAsPaymentAction = new ExchangeItemObjectAddAsPaymentAction();
         action._onlySuccess = pOnlySuccess;
         action._objectUID = pObjectUID;
         action._quantity = pQuantity;
         action._isAdd = pIsAdd;
         return action;
      }
      
      public function get onlySuccess() : Boolean
      {
         return this._onlySuccess;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get quantity() : int
      {
         return this._quantity;
      }
      
      public function get isAdd() : Boolean
      {
         return this._isAdd;
      }
   }
}
