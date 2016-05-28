package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseSearchAction implements Action
   {
       
      private var _type:uint;
      
      private var _genId:uint;
      
      public function ExchangeBidHouseSearchAction()
      {
         super();
      }
      
      public static function create(pType:uint, pGenId:uint) : ExchangeBidHouseSearchAction
      {
         var a:ExchangeBidHouseSearchAction = new ExchangeBidHouseSearchAction();
         a._type = pType;
         a._genId = pGenId;
         return a;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get genId() : uint
      {
         return this._genId;
      }
   }
}
