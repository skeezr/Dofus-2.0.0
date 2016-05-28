package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildSpellUpgradeRequestAction implements Action
   {
       
      private var _spellId:uint;
      
      public function GuildSpellUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(pSpellId:uint) : GuildSpellUpgradeRequestAction
      {
         var action:GuildSpellUpgradeRequestAction = new GuildSpellUpgradeRequestAction();
         action._spellId = pSpellId;
         return action;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
   }
}
