package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildHouseTeleportRequestAction implements Action
   {
       
      private var _houseId:uint;
      
      public function GuildHouseTeleportRequestAction()
      {
         super();
      }
      
      public static function create(pHouseId:uint) : GuildHouseTeleportRequestAction
      {
         var action:GuildHouseTeleportRequestAction = new GuildHouseTeleportRequestAction();
         action._houseId = pHouseId;
         return action;
      }
      
      public function get houseId() : uint
      {
         return this._houseId;
      }
   }
}
