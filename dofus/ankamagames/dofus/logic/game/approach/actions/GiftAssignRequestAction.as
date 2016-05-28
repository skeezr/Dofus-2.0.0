package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GiftAssignRequestAction implements Action
   {
       
      private var _giftId:uint;
      
      private var _characterId:uint;
      
      public function GiftAssignRequestAction()
      {
         super();
      }
      
      public static function create(giftId:uint, characterId:uint) : GiftAssignRequestAction
      {
         var action:GiftAssignRequestAction = new GiftAssignRequestAction();
         action._giftId = giftId;
         action._characterId = characterId;
         return action;
      }
      
      public function get giftId() : uint
      {
         return this._giftId;
      }
      
      public function get characterId() : uint
      {
         return this._characterId;
      }
   }
}
