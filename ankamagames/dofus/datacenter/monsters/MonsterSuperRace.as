package com.ankamagames.dofus.datacenter.monsters
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class MonsterSuperRace
   {
      
      private static const MODULE:String = "MonsterSuperRaces";
       
      public var id:int;
      
      public var nameId:uint;
      
      public function MonsterSuperRace()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint) : MonsterSuperRace
      {
         var o:MonsterSuperRace = new MonsterSuperRace();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public static function getMonsterSuperRaceById(id:uint) : MonsterSuperRace
      {
         return GameData.getObject(MODULE,id) as MonsterSuperRace;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
