package com.ankamagames.dofus.datacenter.spells
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SpellType
   {
      
      private static const MODULE:String = "SpellTypes";
       
      public var id:int;
      
      public var longNameId:uint;
      
      public var shortNameId:uint;
      
      public function SpellType()
      {
         super();
      }
      
      public static function getSpellTypeById(id:int) : SpellType
      {
         return GameData.getObject(MODULE,id) as SpellType;
      }
      
      public static function create(id:int, shortNameId:uint, longNameId:uint) : SpellType
      {
         var o:SpellType = new SpellType();
         o.id = id;
         o.shortNameId = shortNameId;
         o.longNameId = longNameId;
         return o;
      }
      
      public function get longName() : String
      {
         return I18n.getText(this.longNameId);
      }
      
      public function get shortName() : String
      {
         return I18n.getText(this.shortNameId);
      }
   }
}
