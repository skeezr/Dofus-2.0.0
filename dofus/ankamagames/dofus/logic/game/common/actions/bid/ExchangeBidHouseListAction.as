package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseListAction implements Action
   {
       
      private var _id:uint;
      
      public function ExchangeBidHouseListAction()
      {
         super();
      }
      
      public static function create(pId:uint) : ExchangeBidHouseListAction
      {
         var a:ExchangeBidHouseListAction = new ExchangeBidHouseListAction();
         a._id = pId;
         return a;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
   }
}
