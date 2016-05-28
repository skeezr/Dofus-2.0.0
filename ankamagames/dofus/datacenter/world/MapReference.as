package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.data.GameData;
   
   public class MapReference
   {
      
      private static const MODULE:String = "MapReferences";
       
      public var id:int;
      
      public var mapId:uint;
      
      public var cellId:int;
      
      public function MapReference()
      {
         super();
      }
      
      public static function create(id:int, mapId:uint, cellId:int) : MapReference
      {
         var o:MapReference = new MapReference();
         o.id = id;
         o.mapId = mapId;
         o.cellId = cellId;
         return o;
      }
      
      public static function getMapReferenceById(id:int) : MapReference
      {
         var gd:Object = GameData.getObject(MODULE,id);
         return GameData.getObject(MODULE,id) as MapReference;
      }
      
      public static function getAllMapReference() : Array
      {
         return GameData.getObjects(MODULE) as Array;
      }
   }
}
