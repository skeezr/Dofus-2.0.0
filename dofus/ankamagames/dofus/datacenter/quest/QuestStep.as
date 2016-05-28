package com.ankamagames.dofus.datacenter.quest
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestReward;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardExperience;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardKamas;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardItem;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardEmote;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardJob;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardSpell;
   
   public class QuestStep
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestStep));
      
      private static const MODULE:String = "QuestSteps";
       
      public var id:uint;
      
      public var questId:uint;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public var experienceReward:uint;
      
      public var kamasReward:uint;
      
      public var itemsReward:Vector.<Vector.<uint>>;
      
      public var emotesReward:Vector.<uint>;
      
      public var jobsReward:Vector.<uint>;
      
      public var spellsReward:Vector.<uint>;
      
      public var objectiveIds:Vector.<uint>;
      
      private var _rewards:Vector.<QuestReward>;
      
      private var _objectives:Vector.<com.ankamagames.dofus.datacenter.quest.QuestObjective>;
      
      public function QuestStep()
      {
         super();
      }
      
      public static function create(id:int, questId:uint, nameId:uint, descriptionId:uint, experienceReward:uint, kamasReward:uint, itemsReward:Vector.<Vector.<uint>>, emotesReward:Vector.<uint>, jobsReward:Vector.<uint>, spellsReward:Vector.<uint>, objectiveIds:Vector.<uint>) : QuestStep
      {
         var o:QuestStep = new QuestStep();
         o.id = id;
         o.questId = questId;
         o.nameId = nameId;
         o.descriptionId = descriptionId;
         o.experienceReward = experienceReward;
         o.kamasReward = kamasReward;
         o.itemsReward = itemsReward;
         o.emotesReward = emotesReward;
         o.jobsReward = jobsReward;
         o.spellsReward = spellsReward;
         o.objectiveIds = objectiveIds;
         return o;
      }
      
      public static function getQuestStepById(id:int) : QuestStep
      {
         return GameData.getObject(MODULE,id) as QuestStep;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
      
      public function get rewards() : Vector.<QuestReward>
      {
         if(!this._rewards)
         {
            this.formatRewards();
         }
         return this._rewards;
      }
      
      public function get objectives() : Vector.<com.ankamagames.dofus.datacenter.quest.QuestObjective>
      {
         var i:uint = 0;
         if(!this._objectives)
         {
            this._objectives = new Vector.<com.ankamagames.dofus.datacenter.quest.QuestObjective>(this.objectiveIds.length,true);
            for(i = 0; i < this.objectiveIds.length; i++)
            {
               this._objectives[i] = com.ankamagames.dofus.datacenter.quest.QuestObjective.getQuestObjectiveById(this.objectiveIds[i]);
            }
         }
         return this._objectives;
      }
      
      private function formatRewards() : void
      {
         var pair:Vector.<uint> = null;
         var emoteId:uint = 0;
         var jobId:uint = 0;
         var spellId:uint = 0;
         this._rewards = new Vector.<QuestReward>(0,false);
         if(this.experienceReward > 0)
         {
            this._rewards.push(new QuestRewardExperience(this.experienceReward));
         }
         if(this.kamasReward > 0)
         {
            this._rewards.push(new QuestRewardKamas(this.kamasReward));
         }
         for each(pair in this.itemsReward)
         {
            this._rewards.push(new QuestRewardItem(pair[0],pair[1]));
         }
         for each(emoteId in this.emotesReward)
         {
            this._rewards.push(new QuestRewardEmote(emoteId));
         }
         for each(jobId in this.jobsReward)
         {
            this._rewards.push(new QuestRewardJob(jobId));
         }
         for each(spellId in this.spellsReward)
         {
            this._rewards.push(new QuestRewardSpell(spellId));
         }
      }
   }
}
