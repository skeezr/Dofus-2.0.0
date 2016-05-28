package com.ankamagames.dofus.datacenter.monsters
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Monster
   {
      
      private static const MODULE:String = "Monsters";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var gfxId:uint;
      
      public var race:int;
      
      public var grades:Vector.<com.ankamagames.dofus.datacenter.monsters.MonsterGrade>;
      
      public function Monster()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, gfxId:uint, race:int, grades:Vector.<com.ankamagames.dofus.datacenter.monsters.MonsterGrade>) : Monster
      {
         var o:Monster = new Monster();
         o.id = id;
         o.nameId = nameId;
         o.gfxId = gfxId;
         o.race = race;
         o.grades = grades;
         return o;
      }
      
      public static function getMonsterById(id:uint) : Monster
      {
         return GameData.getObject(MODULE,id) as Monster;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function getMonsterGrade(grade:uint) : com.ankamagames.dofus.datacenter.monsters.MonsterGrade
      {
         return this.grades[grade - 1] as com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
      }
   }
}
