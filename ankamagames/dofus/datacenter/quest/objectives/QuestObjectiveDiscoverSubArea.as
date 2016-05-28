package com.ankamagames.dofus.datacenter.quest.objectives
{
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import flash.geom.Point;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   
   public class QuestObjectiveDiscoverSubArea extends QuestObjective
   {
       
      public function QuestObjectiveDiscoverSubArea()
      {
         super();
      }
      
      public static function create(id:int, stepId:uint, typeId:uint, parameters:Vector.<uint>, coords:Point) : QuestObjective
      {
         var o:QuestObjective = new QuestObjectiveDiscoverSubArea();
         o.id = id;
         o.stepId = stepId;
         o.typeId = typeId;
         o.parameters = parameters;
         o.coords = coords;
         return o;
      }
      
      public function get subAreaId() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[0];
      }
      
      override public function get text() : String
      {
         return PatternDecoder.getDescription(this.type.name,[SubArea.getSubAreaById(this.subAreaId)]);
      }
   }
}
