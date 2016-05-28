package com.ankamagames.dofus.datacenter.interactives
{
   import com.ankamagames.jerakine.data.GameData;
   
   public class MapInteractive
   {
      
      private static const MODULE:String = "MapInteractives";
       
      public var id:int;
      
      public var mapId:int;
      
      public var cellId:uint;
      
      public var typeId:int;
      
      public function MapInteractive()
      {
         super();
      }
      
      public static function create(id:int, mapId:int, cellId:uint, typeId:int) : MapInteractive
      {
         var o:MapInteractive = new MapInteractive();
         o.id = id;
         o.mapId = mapId;
         o.cellId = cellId;
         o.typeId = typeId;
         return o;
      }
      
      public static function getMapInteractiveById(id:int) : MapInteractive
      {
         return GameData.getObject(MODULE,id) as MapInteractive;
      }
   }
}
