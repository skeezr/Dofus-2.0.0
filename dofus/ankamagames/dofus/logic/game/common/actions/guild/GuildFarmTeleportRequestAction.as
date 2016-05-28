package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildFarmTeleportRequestAction implements Action
   {
       
      private var _farmId:uint;
      
      public function GuildFarmTeleportRequestAction()
      {
         super();
      }
      
      public static function create(pFarmId:uint) : GuildFarmTeleportRequestAction
      {
         var action:GuildFarmTeleportRequestAction = new GuildFarmTeleportRequestAction();
         action._farmId = pFarmId;
         return action;
      }
      
      public function get farmId() : uint
      {
         return this._farmId;
      }
   }
}
