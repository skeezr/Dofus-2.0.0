package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectSetPositionAction;
   import com.ankamagames.dofus.network.enums.CharacterInventoryPositionEnum;
   
   public class MountFeedRequestAction extends ObjectSetPositionAction
   {
       
      public function MountFeedRequestAction()
      {
         super();
      }
      
      public static function create(objectUID:uint, quantity:uint = 1) : ObjectSetPositionAction
      {
         return ObjectSetPositionAction.create(objectUID,CharacterInventoryPositionEnum.INVENTORY_POSITION_MOUNT,quantity);
      }
   }
}
