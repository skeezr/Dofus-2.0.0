package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.data.GameData;
   
   public class WorldMap
   {
      
      private static const MODULE:String = "WorldMaps";
       
      public var id:int;
      
      public var origineX:int;
      
      public var origineY:int;
      
      public var mapWidth:Number;
      
      public var mapHeight:Number;
      
      public var horizontalChunck:uint;
      
      public var verticalChunck:uint;
      
      public var viewableEverywhere:Boolean;
      
      public var minScale:Number;
      
      public var maxScale:Number;
      
      public var startScale:Number;
      
      public var centerX:int;
      
      public var centerY:int;
      
      public var totalWidth:int;
      
      public var totalHeight:int;
      
      public function WorldMap()
      {
         super();
      }
      
      public static function create(id:uint, origineX:int, origineY:int, mapWidth:Number, mapHeight:Number, horizontalChunck:uint, verticalChunck:uint, viewableEverywhere:Boolean, minScale:Number, maxScale:Number, startScale:Number, centerX:int, centerY:int, totalWidth:int, totalHeight:int) : WorldMap
      {
         var o:WorldMap = new WorldMap();
         o.id = id;
         o.origineX = origineX;
         o.origineY = origineY;
         o.mapWidth = mapWidth;
         o.mapHeight = mapHeight;
         o.horizontalChunck = horizontalChunck;
         o.verticalChunck = verticalChunck;
         o.viewableEverywhere = viewableEverywhere;
         o.minScale = minScale;
         o.maxScale = maxScale;
         o.startScale = startScale;
         o.centerX = centerX;
         o.centerY = centerY;
         o.totalWidth = totalWidth;
         o.totalHeight = totalHeight;
         return o;
      }
      
      public static function getWorldMapById(id:int) : WorldMap
      {
         return GameData.getObject(MODULE,id) as WorldMap;
      }
   }
}
