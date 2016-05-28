package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeHandleMountStableAction implements Action
   {
       
      private var _mountId:uint;
      
      private var _actionType:uint;
      
      public function ExchangeHandleMountStableAction()
      {
         super();
      }
      
      public static function create(actionType:uint, mountId:uint) : ExchangeHandleMountStableAction
      {
         var act:ExchangeHandleMountStableAction = new ExchangeHandleMountStableAction();
         act._actionType = actionType;
         act._mountId = mountId;
         return act;
      }
      
      public function get rideId() : uint
      {
         return this._mountId;
      }
      
      public function get actionType() : int
      {
         return this._actionType;
      }
   }
}
