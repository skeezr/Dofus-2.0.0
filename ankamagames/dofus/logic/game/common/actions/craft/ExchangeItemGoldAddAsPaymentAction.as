package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeItemGoldAddAsPaymentAction implements Action
   {
       
      private var _onlySuccess:Boolean;
      
      private var _kamas:uint;
      
      public function ExchangeItemGoldAddAsPaymentAction()
      {
         super();
      }
      
      public static function create(pOnlySuccess:Boolean, pKamas:uint) : ExchangeItemGoldAddAsPaymentAction
      {
         var action:ExchangeItemGoldAddAsPaymentAction = new ExchangeItemGoldAddAsPaymentAction();
         action._onlySuccess = pOnlySuccess;
         action._kamas = pKamas;
         return action;
      }
      
      public function get onlySuccess() : Boolean
      {
         return this._onlySuccess;
      }
      
      public function get kamas() : uint
      {
         return this._kamas;
      }
   }
}
