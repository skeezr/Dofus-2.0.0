package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseKickIndoorMerchantAction implements Action
   {
       
      private var _cellId:uint;
      
      public function HouseKickIndoorMerchantAction()
      {
         super();
      }
      
      public static function create(cellId:uint) : HouseKickIndoorMerchantAction
      {
         var action:HouseKickIndoorMerchantAction = new HouseKickIndoorMerchantAction();
         action._cellId = cellId;
         return action;
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
   }
}
