package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.types.DataStoreType;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SubArea
   {
      
      private static const MODULE:String = "SubAreas";
      
      private static const DST:DataStoreType = new DataStoreType(MODULE,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      private static var _mapsDic:Dictionary;
       
      private var _bounds:Rectangle;
      
      public var id:int;
      
      public var nameId:uint;
      
      public var areaId:int;
      
      public var ambientSounds:Vector.<AmbientSound>;
      
      public var mapIds:Vector.<uint>;
      
      public var bounds:Rectangle;
      
      public var shape:Vector.<int>;
      
      public var customWorldMap:Vector.<uint>;
      
      public function SubArea()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, areaId:int, ambientSounds:Vector.<AmbientSound>, mapIds:Vector.<uint>, bounds:Rectangle, shape:Vector.<int>, customWorldMap:Vector.<uint>) : SubArea
      {
         var mapId:uint = 0;
         var o:SubArea = new SubArea();
         o.id = id;
         o.nameId = nameId;
         o.areaId = areaId;
         o.ambientSounds = ambientSounds;
         o.mapIds = mapIds;
         o.bounds = bounds;
         o.shape = shape;
         o.customWorldMap = customWorldMap;
         if(!_mapsDic)
         {
            _mapsDic = new Dictionary();
         }
         for each(mapId in mapIds)
         {
            _mapsDic[mapId] = o;
         }
         return o;
      }
      
      public static function endCreateSequence() : void
      {
         StoreDataManager.getInstance().setData(DST,"mapsDic",_mapsDic);
      }
      
      public static function getSubAreaById(id:int) : SubArea
      {
         return GameData.getObject(MODULE,id) as SubArea;
      }
      
      public static function getSubAreaByMapId(mapId:uint) : SubArea
      {
         if(!_mapsDic)
         {
            _mapsDic = StoreDataManager.getInstance().getData(DST,"mapsDic");
         }
         return _mapsDic[mapId];
      }
      
      public static function getAllSubArea() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get area() : Area
      {
         return Area.getAreaById(this.areaId);
      }
      
      public function get worldmap() : WorldMap
      {
         if(Boolean(this.customWorldMap) && Boolean(this.customWorldMap.length))
         {
            return WorldMap.getWorldMapById(this.customWorldMap[0]);
         }
         return null;
      }
   }
}
