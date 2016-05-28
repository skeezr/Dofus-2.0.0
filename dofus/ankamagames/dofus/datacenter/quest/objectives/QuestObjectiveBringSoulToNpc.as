package com.ankamagames.dofus.datacenter.quest.objectives
{
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import flash.geom.Point;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   
   public class QuestObjectiveBringSoulToNpc extends QuestObjective
   {
       
      public function QuestObjectiveBringSoulToNpc()
      {
         super();
      }
      
      public static function create(id:int, stepId:uint, typeId:uint, parameters:Vector.<uint>, coords:Point) : QuestObjective
      {
         var o:QuestObjective = new QuestObjectiveBringSoulToNpc();
         o.id = id;
         o.stepId = stepId;
         o.typeId = typeId;
         o.parameters = parameters;
         o.coords = coords;
         return o;
      }
      
      public function get npcId() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[0];
      }
      
      public function get npc() : Npc
      {
         return Npc.getNpcById(this.npcId);
      }
      
      public function get monsterId() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[1];
      }
      
      public function get monster() : Monster
      {
         return Monster.getMonsterById(this.monsterId);
      }
      
      public function get quantity() : uint
      {
         if(!this.parameters)
         {
            return 0;
         }
         return this.parameters[2];
      }
      
      override public function get text() : String
      {
         return PatternDecoder.getDescription(this.type.name,[this.npc.name,this.monster.name,this.quantity]);
      }
   }
}
