package com.ankamagames.dofus.datacenter.quest.objectives
{
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import flash.geom.Point;
   import com.ankamagames.jerakine.data.I18n;
   
   public class QuestObjectiveFreeForm extends QuestObjective
   {
       
      public function QuestObjectiveFreeForm()
      {
         super();
      }
      
      public static function create(id:int, stepId:uint, typeId:uint, parameters:Vector.<uint>, coords:Point) : QuestObjective
      {
         var o:QuestObjective = new QuestObjectiveFreeForm();
         o.id = id;
         o.stepId = stepId;
         o.typeId = typeId;
         o.parameters = parameters;
         o.coords = coords;
         return o;
      }
      
      public function get freeFormTextId() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[0];
      }
      
      public function get freeFormText() : String
      {
         return I18n.getText(this.freeFormTextId);
      }
      
      override public function get text() : String
      {
         return this.freeFormText;
      }
   }
}
