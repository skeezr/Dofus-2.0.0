package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildFightJoinRequestAction implements Action
   {
       
      private var _taxCollectorId:uint;
      
      public function GuildFightJoinRequestAction()
      {
         super();
      }
      
      public static function create(pTaxCollectorId:uint) : GuildFightJoinRequestAction
      {
         var action:GuildFightJoinRequestAction = new GuildFightJoinRequestAction();
         action._taxCollectorId = pTaxCollectorId;
         return action;
      }
      
      public function get taxCollectorId() : uint
      {
         return this._taxCollectorId;
      }
   }
}
