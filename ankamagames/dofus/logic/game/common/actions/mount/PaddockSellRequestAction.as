package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockSellRequestAction implements Action
   {
       
      private var _price:uint;
      
      public function PaddockSellRequestAction()
      {
         super();
      }
      
      public static function create(price:uint) : PaddockSellRequestAction
      {
         var o:PaddockSellRequestAction = new PaddockSellRequestAction();
         o._price = price;
         return o;
      }
      
      public function get price() : uint
      {
         return this._price;
      }
   }
}
