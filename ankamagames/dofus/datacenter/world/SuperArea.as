package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SuperArea
   {
      
      private static const MODULE:String = "SuperAreas";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var worldmapId:uint;
      
      public function SuperArea()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, worldmapId:uint) : SuperArea
      {
         var o:SuperArea = new SuperArea();
         o.id = id;
         o.nameId = nameId;
         o.worldmapId = worldmapId;
         return o;
      }
      
      public static function getSuperAreaById(id:int) : SuperArea
      {
         return GameData.getObject(MODULE,id) as SuperArea;
      }
      
      public static function getAllSuperArea() : Array
      {
         return GameData.getObjects(MODULE) as Array;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get worldmap() : WorldMap
      {
         return WorldMap.getWorldMapById(this.worldmapId);
      }
   }
}
