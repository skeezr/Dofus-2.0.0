package com.ankamagames.dofus.datacenter.quest
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Quest
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Quest));
      
      private static const MODULE:String = "Quests";
       
      public var id:uint;
      
      public var nameId:uint;
      
      public var stepIds:Vector.<uint>;
      
      private var _steps:Vector.<com.ankamagames.dofus.datacenter.quest.QuestStep>;
      
      public function Quest()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, stepIds:Vector.<uint>) : Quest
      {
         var o:Quest = new Quest();
         o.id = id;
         o.nameId = nameId;
         o.stepIds = stepIds;
         return o;
      }
      
      public static function getQuestById(id:int) : Quest
      {
         return GameData.getObject(MODULE,id) as Quest;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get steps() : Vector.<com.ankamagames.dofus.datacenter.quest.QuestStep>
      {
         var i:uint = 0;
         if(!this._steps)
         {
            this._steps = new Vector.<com.ankamagames.dofus.datacenter.quest.QuestStep>(this.stepIds.length,true);
            for(i = 0; i < this.steps.length; i++)
            {
               this._steps[i] = com.ankamagames.dofus.datacenter.quest.QuestStep.getQuestStepById(this.stepIds[i]);
            }
         }
         return this._steps;
      }
   }
}
