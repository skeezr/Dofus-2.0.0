package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class Cross implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Cross));
       
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 0;
      
      private var _dataMapProvider:IDataMapProvider;
      
      private var _direction:uint;
      
      public var disabledDirection:Array;
      
      public var onlyPerpendicular:Boolean = false;
      
      public function Cross(nMinRadius:uint, nMaxRadius:uint, dataMapProvider:IDataMapProvider)
      {
         this.disabledDirection = [];
         super();
         this.minRadius = nMinRadius;
         this.radius = nMaxRadius;
         this._dataMapProvider = dataMapProvider;
      }
      
      public function get radius() : uint
      {
         return this._radius;
      }
      
      public function set radius(n:uint) : void
      {
         this._radius = n;
      }
      
      public function get surface() : uint
      {
         return null;
      }
      
      public function set minRadius(r:uint) : void
      {
         this._minRadius = r;
      }
      
      public function get minRadius() : uint
      {
         return this._minRadius;
      }
      
      public function set direction(d:uint) : void
      {
         this._direction = d;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function getCells(cellId:uint = 0) : Vector.<uint>
      {
         var aCells:Vector.<uint> = new Vector.<uint>();
         if(this._minRadius == 0)
         {
            aCells.push(cellId);
         }
         if(this.onlyPerpendicular)
         {
            switch(this._direction)
            {
               case DirectionsEnum.DOWN_RIGHT:
               case DirectionsEnum.UP_LEFT:
                  this.disabledDirection = [DirectionsEnum.DOWN_RIGHT,DirectionsEnum.UP_LEFT];
                  break;
               case DirectionsEnum.UP_RIGHT:
               case DirectionsEnum.DOWN_LEFT:
                  this.disabledDirection = [DirectionsEnum.UP_RIGHT,DirectionsEnum.DOWN_LEFT];
            }
         }
         var origin:MapPoint = MapPoint.fromCellId(cellId);
         var x:int = origin.x;
         var y:int = origin.y;
         for(var r:int = this._radius; r > 0; r--)
         {
            if(r >= this._minRadius)
            {
               if(Boolean(MapPoint.isInMap(x + r,y)) && this.disabledDirection.indexOf(DirectionsEnum.DOWN_RIGHT) == -1)
               {
                  this.addCell(x + r,y,aCells);
               }
               if(Boolean(MapPoint.isInMap(x - r,y)) && this.disabledDirection.indexOf(DirectionsEnum.UP_LEFT) == -1)
               {
                  this.addCell(x - r,y,aCells);
               }
               if(Boolean(MapPoint.isInMap(x,y + r)) && this.disabledDirection.indexOf(DirectionsEnum.UP_RIGHT) == -1)
               {
                  this.addCell(x,y + r,aCells);
               }
               if(Boolean(MapPoint.isInMap(x,y - r)) && this.disabledDirection.indexOf(DirectionsEnum.DOWN_LEFT) == -1)
               {
                  this.addCell(x,y - r,aCells);
               }
            }
         }
         return aCells;
      }
      
      private function addCell(x:int, y:int, cellMap:Vector.<uint>) : void
      {
         if(this._dataMapProvider == null || Boolean(this._dataMapProvider.pointMov(x,y)))
         {
            cellMap.push(MapPoint.fromCoords(x,y).cellId);
         }
      }
   }
}
