package com.ankamagames.dofus.datacenter.quest.objectives
{
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import flash.geom.Point;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   
   public class QuestObjectiveDiscoverMap extends QuestObjective
   {
       
      public function QuestObjectiveDiscoverMap()
      {
         super();
      }
      
      public static function create(id:int, stepId:uint, typeId:uint, parameters:Vector.<uint>, coords:Point) : QuestObjective
      {
         var o:QuestObjective = new QuestObjectiveDiscoverMap();
         o.id = id;
         o.stepId = stepId;
         o.typeId = typeId;
         o.parameters = parameters;
         o.coords = coords;
         return o;
      }
      
      public function get mapDescriptionTextId() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[0];
      }
      
      public function get mapDescriptionText() : String
      {
         return I18n.getText(this.mapDescriptionTextId);
      }
      
      override public function get text() : String
      {
         return PatternDecoder.getDescription(this.type.name,[this.mapDescriptionText]);
      }
   }
}
