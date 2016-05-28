package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectMoveKamaAction implements Action
   {
       
      private var _kamas:uint;
      
      public function ExchangeObjectMoveKamaAction()
      {
         super();
      }
      
      public static function create(pKamas:uint) : ExchangeObjectMoveKamaAction
      {
         var a:ExchangeObjectMoveKamaAction = new ExchangeObjectMoveKamaAction();
         a._kamas = pKamas;
         return a;
      }
      
      public function get kamas() : uint
      {
         return this._kamas;
      }
   }
}
