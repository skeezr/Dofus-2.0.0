package com.ankamagames.dofus.datacenter.monsters
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class MonsterRace
   {
      
      private static const MODULE:String = "MonsterRaces";
       
      public var id:int;
      
      public var superRaceId:int;
      
      public var nameId:uint;
      
      public function MonsterRace()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, superRaceId:int) : MonsterRace
      {
         var o:MonsterRace = new MonsterRace();
         o.id = id;
         o.nameId = nameId;
         o.superRaceId = superRaceId;
         return o;
      }
      
      public static function getMonsterRaceById(id:uint) : MonsterRace
      {
         return GameData.getObject(MODULE,id) as MonsterRace;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
