package com.ankamagames.dofus.datacenter.quest.rewards
{
   public class QuestRewardExperience extends QuestReward
   {
       
      private var _amount:uint;
      
      public function QuestRewardExperience(amount:uint)
      {
         super(QuestRewardType.EXPERIENCE);
         this._amount = amount;
      }
      
      public function get amount() : uint
      {
         return this._amount;
      }
   }
}
