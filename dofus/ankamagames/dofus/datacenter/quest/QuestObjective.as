package com.ankamagames.dofus.datacenter.quest
{
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Point;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class QuestObjective
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestObjective));
      
      private static const MODULE:String = "QuestObjectives";
       
      public var id:uint;
      
      public var stepId:uint;
      
      public var typeId:uint;
      
      public var parameters:Vector.<uint>;
      
      public var coords:Point;
      
      public function QuestObjective()
      {
         super();
      }
      
      public static function create(id:int, stepId:uint, typeId:uint, parameters:Vector.<uint>, coords:Point) : QuestObjective
      {
         var o:QuestObjective = new QuestObjective();
         o.id = id;
         o.stepId = stepId;
         o.typeId = typeId;
         o.parameters = parameters;
         o.coords = coords;
         return o;
      }
      
      public static function getQuestObjectiveById(id:int) : QuestObjective
      {
         return GameData.getObject(MODULE,id) as QuestObjective;
      }
      
      public function get step() : QuestStep
      {
         return QuestStep.getQuestStepById(this.stepId);
      }
      
      public function get type() : QuestObjectiveType
      {
         return QuestObjectiveType.getQuestObjectiveTypeById(this.typeId);
      }
      
      public function get text() : String
      {
         _log.warn("Unknown objective type " + this.typeId + ", cannot display specific, parametrized text.");
         return this.type.name;
      }
   }
}
