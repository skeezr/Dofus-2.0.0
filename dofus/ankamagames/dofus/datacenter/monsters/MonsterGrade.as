package com.ankamagames.dofus.datacenter.monsters
{
   public class MonsterGrade
   {
       
      public var grade:uint;
      
      public var monsterId:int;
      
      public var level:uint;
      
      public var paDodge:int;
      
      public var pmDodge:int;
      
      public var earthResistance:int;
      
      public var airResistance:int;
      
      public var fireResistance:int;
      
      public var waterResistance:int;
      
      public var neutralResistance:int;
      
      public function MonsterGrade()
      {
         super();
      }
      
      public static function create(grade:uint, monsterId:int, level:uint, paDodge:int, pmDodge:int, earthResistance:int, airResistance:int, fireResistance:int, waterResistance:int, neutralResistance:int) : MonsterGrade
      {
         var o:MonsterGrade = new MonsterGrade();
         o.grade = grade;
         o.monsterId = monsterId;
         o.level = level;
         o.paDodge = paDodge;
         o.pmDodge = pmDodge;
         o.earthResistance = earthResistance;
         o.airResistance = airResistance;
         o.fireResistance = fireResistance;
         o.waterResistance = waterResistance;
         o.neutralResistance = neutralResistance;
         return o;
      }
      
      public function get monster() : Monster
      {
         return Monster.getMonsterById(this.monsterId);
      }
   }
}
