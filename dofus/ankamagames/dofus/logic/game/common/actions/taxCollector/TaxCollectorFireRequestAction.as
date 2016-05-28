package com.ankamagames.dofus.logic.game.common.actions.taxCollector
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TaxCollectorFireRequestAction implements Action
   {
       
      private var _taxCollectorId:uint;
      
      public function TaxCollectorFireRequestAction()
      {
         super();
      }
      
      public static function create(pTaxCollectorId:uint) : TaxCollectorFireRequestAction
      {
         var action:TaxCollectorFireRequestAction = new TaxCollectorFireRequestAction();
         action._taxCollectorId = pTaxCollectorId;
         return action;
      }
      
      public function get taxCollectorId() : uint
      {
         return this._taxCollectorId;
      }
   }
}
