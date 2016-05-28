package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangePlayerRequestAction implements Action
   {
       
      private var _exchangeType:int;
      
      private var _target:uint;
      
      public function ExchangePlayerRequestAction()
      {
         super();
      }
      
      public static function create(exchangeType:int, target:uint) : ExchangePlayerRequestAction
      {
         var a:ExchangePlayerRequestAction = new ExchangePlayerRequestAction();
         a._exchangeType = exchangeType;
         a._target = target;
         return a;
      }
      
      public function get exchangeType() : int
      {
         return this._exchangeType;
      }
      
      public function get target() : int
      {
         return this._target;
      }
   }
}
