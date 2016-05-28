package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeRequestOnTaxCollectorAction implements Action
   {
       
      private var _taxCollectorId:int;
      
      public function ExchangeRequestOnTaxCollectorAction()
      {
         super();
      }
      
      public static function create(taxCollectorId:int) : ExchangeRequestOnTaxCollectorAction
      {
         var a:ExchangeRequestOnTaxCollectorAction = new ExchangeRequestOnTaxCollectorAction();
         a._taxCollectorId = taxCollectorId;
         return a;
      }
      
      public function get taxCollectorId() : int
      {
         return this._taxCollectorId;
      }
   }
}
