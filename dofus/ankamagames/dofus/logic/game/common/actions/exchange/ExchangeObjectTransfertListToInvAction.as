package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectTransfertListToInvAction implements Action
   {
       
      public var _ids:Vector.<uint>;
      
      public function ExchangeObjectTransfertListToInvAction()
      {
         this._ids = new Vector.<uint>();
         super();
      }
      
      public static function create(pIds:Vector.<uint>) : ExchangeObjectTransfertListToInvAction
      {
         var a:ExchangeObjectTransfertListToInvAction = new ExchangeObjectTransfertListToInvAction();
         a._ids = pIds;
         return a;
      }
      
      public function get ids() : Vector.<uint>
      {
         return this._ids;
      }
   }
}
