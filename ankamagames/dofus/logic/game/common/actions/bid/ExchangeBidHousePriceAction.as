package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHousePriceAction implements Action
   {
       
      private var _genId:uint;
      
      public function ExchangeBidHousePriceAction()
      {
         super();
      }
      
      public static function create(pGid:uint) : ExchangeBidHousePriceAction
      {
         var a:ExchangeBidHousePriceAction = new ExchangeBidHousePriceAction();
         a._genId = pGid;
         return a;
      }
      
      public function get genId() : uint
      {
         return this._genId;
      }
   }
}
