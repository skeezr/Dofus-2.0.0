package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.Sprite;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.atouin.utils.VisibleCellDetection;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import flash.display.DisplayObject;
   
   public class DataMapContainer
   {
      
      private static var _aInteractiveCell:Array;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DataMapContainer));
       
      private var _spMap:Sprite;
      
      private var _aLayers:Array;
      
      private var _aCell:Array;
      
      private var _map:Map;
      
      public var layerDepth:Array;
      
      public var id:int;
      
      public var rendered:Boolean = false;
      
      public function DataMapContainer(mapData:Map)
      {
         super();
         if(!this._spMap)
         {
            this._spMap = new Sprite();
            this._aLayers = new Array();
            _aInteractiveCell = new Array();
         }
         this.id = mapData.id;
         this.layerDepth = new Array();
         this._aCell = new Array();
         this._map = mapData;
      }
      
      public static function get interactiveCell() : Array
      {
         return _aInteractiveCell;
      }
      
      public function removeContainer() : void
      {
         var sprite:Sprite = null;
         var parentSprite:Sprite = null;
         var cellReference:CellReference = null;
         var i:uint = 0;
         for(var k:uint = 0; k < this._aCell.length; k++)
         {
            cellReference = this._aCell[k];
            if(cellReference)
            {
               for(i = 0; i < cellReference.listSprites.length; i++)
               {
                  sprite = cellReference.listSprites[i];
                  if(sprite)
                  {
                     sprite.cacheAsBitmap = false;
                     parentSprite = Sprite(sprite.parent);
                     parentSprite.removeChild(sprite);
                     delete cellReference.listSprites[i];
                     if(!parentSprite.numChildren)
                     {
                        parentSprite.parent.removeChild(parentSprite);
                     }
                  }
               }
               delete this._aCell[k];
            }
         }
      }
      
      public function getCellReference(nId:uint) : CellReference
      {
         if(!this._aCell[nId])
         {
            this._aCell[nId] = new CellReference(nId);
         }
         return this._aCell[nId];
      }
      
      public function isRegisteredCell(nId:uint) : Boolean
      {
         return this._aCell[nId] != null;
      }
      
      public function getCell() : Array
      {
         return this._aCell;
      }
      
      public function getLayer(nId:int) : LayerContainer
      {
         if(!this._aLayers[nId])
         {
            this._aLayers[nId] = new LayerContainer(nId);
         }
         return this._aLayers[nId];
      }
      
      public function clean(bForceCleaning:Boolean = false) : Boolean
      {
         var sprite:Sprite = null;
         var parentSprite:Sprite = null;
         var cellReference:CellReference = null;
         var i:uint = 0;
         var provider:Array = null;
         var k:* = null;
         var p:WorldPoint = null;
         if(!bForceCleaning)
         {
            provider = VisibleCellDetection.detectCell(false,this._map,WorldPoint.fromMapId(this.id),Atouin.getInstance().options.frustum,MapDisplayManager.getInstance().currentMapPoint).cell;
         }
         else
         {
            provider = new Array();
            for(i = 0; i < this._aCell.length; i++)
            {
               provider[i] = i;
            }
         }
         for(k in provider)
         {
            cellReference = this._aCell[k];
            if(cellReference)
            {
               for(i = 0; i < cellReference.listSprites.length; i++)
               {
                  sprite = cellReference.listSprites[i];
                  if(sprite)
                  {
                     sprite.cacheAsBitmap = false;
                     parentSprite = Sprite(sprite.parent);
                     parentSprite.removeChild(sprite);
                     delete cellReference.listSprites[i];
                     if(!parentSprite.numChildren)
                     {
                        parentSprite.parent.removeChild(parentSprite);
                     }
                  }
               }
               delete this._aCell[k];
            }
         }
         p = WorldPoint.fromMapId(this._map.id);
         p.x = p.x - MapDisplayManager.getInstance().currentMapPoint.x;
         p.y = p.y - MapDisplayManager.getInstance().currentMapPoint.y;
         return Math.abs(p.x) > 1 || Math.abs(p.y) > 1;
      }
      
      public function get mapContainer() : Sprite
      {
         return this._spMap;
      }
      
      public function get dataMap() : Map
      {
         return this._map;
      }
      
      public function get x() : Number
      {
         return this._spMap.x;
      }
      
      public function get y() : Number
      {
         return this._spMap.y;
      }
      
      public function set x(nValue:Number) : void
      {
         this._spMap.x = nValue;
      }
      
      public function set y(nValue:Number) : void
      {
         this._spMap.y = nValue;
      }
      
      public function get scaleX() : Number
      {
         return this._spMap.scaleX;
      }
      
      public function get scaleY() : Number
      {
         return this._spMap.scaleY;
      }
      
      public function set scaleX(nValue:Number) : void
      {
         this._spMap.scaleX = nValue;
      }
      
      public function set scaleY(nValue:Number) : void
      {
         this._spMap.scaleX = nValue;
      }
      
      public function addChild(item:DisplayObject) : DisplayObject
      {
         return this._spMap.addChild(item);
      }
      
      public function addChildAt(item:DisplayObject, index:int) : DisplayObject
      {
         return this._spMap.addChildAt(item,index);
      }
      
      public function getChildIndex(item:DisplayObject) : int
      {
         return this._spMap.getChildIndex(item);
      }
      
      public function contains(item:DisplayObject) : Boolean
      {
         return this._spMap.contains(item);
      }
      
      public function getChildByName(name:String) : DisplayObject
      {
         return this._spMap.getChildByName(name);
      }
      
      public function removeChild(item:DisplayObject) : DisplayObject
      {
         if(Boolean(item.parent) && item.parent == this._spMap)
         {
            return this._spMap.removeChild(item);
         }
         return null;
      }
   }
}
