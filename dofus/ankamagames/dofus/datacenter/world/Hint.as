package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Hint
   {
      
      private static const MODULE:String = "Hints";
       
      public var id:int;
      
      public var categoryId:uint;
      
      public var gfx:uint;
      
      public var nameId:uint;
      
      public var mapId:uint;
      
      public function Hint()
      {
         super();
      }
      
      public static function create(id:int, categoryId:uint, gfx:int, nameId:uint, mapId:uint) : Hint
      {
         var o:Hint = new Hint();
         o.id = id;
         o.categoryId = categoryId;
         o.gfx = gfx;
         o.nameId = nameId;
         o.mapId = mapId;
         return o;
      }
      
      public static function getHintById(id:int) : Hint
      {
         return GameData.getObject(MODULE,id) as Hint;
      }
      
      public static function getHints() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
