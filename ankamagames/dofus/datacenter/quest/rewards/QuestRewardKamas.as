package com.ankamagames.dofus.datacenter.quest.rewards
{
   public class QuestRewardKamas extends QuestReward
   {
       
      private var _amount:uint;
      
      public function QuestRewardKamas(amount:uint)
      {
         super(QuestRewardType.KAMAS);
         this._amount = amount;
      }
      
      public function get amount() : uint
      {
         return this._amount;
      }
   }
}
