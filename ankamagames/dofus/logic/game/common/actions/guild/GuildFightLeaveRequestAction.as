package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildFightLeaveRequestAction implements Action
   {
       
      private var _taxCollectorId:uint;
      
      private var _characterId:uint;
      
      private var _warning:Boolean;
      
      public function GuildFightLeaveRequestAction()
      {
         super();
      }
      
      public static function create(pTaxCollectorId:uint, pCharacterId:uint, pWarning:Boolean = false) : GuildFightLeaveRequestAction
      {
         var action:GuildFightLeaveRequestAction = new GuildFightLeaveRequestAction();
         action._taxCollectorId = pTaxCollectorId;
         action._characterId = pCharacterId;
         action._warning = pWarning;
         return action;
      }
      
      public function get taxCollectorId() : uint
      {
         return this._taxCollectorId;
      }
      
      public function get characterId() : uint
      {
         return this._characterId;
      }
      
      public function get warning() : Boolean
      {
         return this._warning;
      }
   }
}
