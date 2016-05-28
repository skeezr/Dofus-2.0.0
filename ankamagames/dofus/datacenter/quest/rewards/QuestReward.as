package com.ankamagames.dofus.datacenter.quest.rewards
{
   public class QuestReward
   {
       
      private var _rewardType:String;
      
      public function QuestReward(rewardType:String)
      {
         super();
         this._rewardType = rewardType;
      }
      
      public function get rewardType() : String
      {
         return this._rewardType;
      }
   }
}
