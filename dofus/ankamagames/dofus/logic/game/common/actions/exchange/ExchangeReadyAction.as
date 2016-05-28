package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeReadyAction implements Action
   {
       
      private var _isReady:Boolean;
      
      public function ExchangeReadyAction()
      {
         super();
      }
      
      public static function create(pIsReady:Boolean) : ExchangeReadyAction
      {
         var a:ExchangeReadyAction = new ExchangeReadyAction();
         a._isReady = pIsReady;
         return a;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
   }
}
