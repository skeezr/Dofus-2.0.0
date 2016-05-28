package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   
   public class Line implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Line));
       
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 0;
      
      private var _nDirection:uint = 1;
      
      private var _dataMapProvider:IDataMapProvider;
      
      public function Line(nRadius:uint, dataMapProvider:IDataMapProvider)
      {
         super();
         this.radius = nRadius;
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
         this._nDirection = d;
      }
      
      public function get direction() : uint
      {
         return this._nDirection;
      }
      
      public function getCells(cellId:uint = 0) : Vector.<uint>
      {
         var aCells:Vector.<uint> = new Vector.<uint>();
         var origin:MapPoint = MapPoint.fromCellId(cellId);
         var x:int = origin.x;
         var y:int = origin.y;
         for(var r:int = this._minRadius; r <= this._radius; r++)
         {
            switch(this._nDirection)
            {
               case DirectionsEnum.UP_LEFT:
                  if(MapPoint.isInMap(x - r,y))
                  {
                     this.addCell(x - r,y,aCells);
                  }
                  break;
               case DirectionsEnum.DOWN_LEFT:
                  if(MapPoint.isInMap(x,y - r))
                  {
                     this.addCell(x,y - r,aCells);
                  }
                  break;
               case DirectionsEnum.DOWN_RIGHT:
                  if(MapPoint.isInMap(x + r,y))
                  {
                     this.addCell(x + r,y,aCells);
                  }
                  break;
               case DirectionsEnum.UP_RIGHT:
                  if(MapPoint.isInMap(x,y + r))
                  {
                     this.addCell(x,y + r,aCells);
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
