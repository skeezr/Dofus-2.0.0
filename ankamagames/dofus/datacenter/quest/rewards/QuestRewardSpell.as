package com.ankamagames.dofus.datacenter.quest.rewards
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   
   public class QuestRewardSpell extends QuestReward
   {
       
      private var _spellId:uint;
      
      public function QuestRewardSpell(spellId:uint)
      {
         super(QuestRewardType.SPELL);
         this._spellId = spellId;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this._spellId);
      }
   }
}
