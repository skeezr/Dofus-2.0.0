package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseTypeAction implements Action
   {
       
      private var _type:uint;
      
      public function ExchangeBidHouseTypeAction()
      {
         super();
      }
      
      public static function create(pType:uint) : ExchangeBidHouseTypeAction
      {
         var a:ExchangeBidHouseTypeAction = new ExchangeBidHouseTypeAction();
         a._type = pType;
         return a;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
   }
}
