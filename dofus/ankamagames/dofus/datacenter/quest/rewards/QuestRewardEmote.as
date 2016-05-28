package com.ankamagames.dofus.datacenter.quest.rewards
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   
   public class QuestRewardEmote extends QuestReward
   {
       
      private var _emoteId:uint;
      
      public function QuestRewardEmote(emoteId:uint)
      {
         super(QuestRewardType.EMOTE);
         this._emoteId = emoteId;
      }
      
      public function get emoteId() : uint
      {
         return this._emoteId;
      }
      
      public function get emote() : Emoticon
      {
         return Emoticon.getEmoticonById(this._emoteId);
      }
   }
}
