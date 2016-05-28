package com.ankamagames.jerakine.types.positions
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.utils.errors.JerakineError;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class MovementPath
   {
       
      protected var _log:Logger;
      
      protected var _oStart:com.ankamagames.jerakine.types.positions.MapPoint;
      
      protected var _oEnd:com.ankamagames.jerakine.types.positions.MapPoint;
      
      protected var _aPath:Array;
      
      public function MovementPath()
      {
         this._log = Log.getLogger(getQualifiedClassName(MovementPath));
         super();
         this._oEnd = new com.ankamagames.jerakine.types.positions.MapPoint();
         this._oStart = new com.ankamagames.jerakine.types.positions.MapPoint();
         this._aPath = new Array();
      }
      
      public function get start() : com.ankamagames.jerakine.types.positions.MapPoint
      {
         return this._oStart;
      }
      
      public function set start(nValue:com.ankamagames.jerakine.types.positions.MapPoint) : void
      {
         this._oStart = nValue;
      }
      
      public function get end() : com.ankamagames.jerakine.types.positions.MapPoint
      {
         return this._oEnd;
      }
      
      public function set end(nValue:com.ankamagames.jerakine.types.positions.MapPoint) : void
      {
         this._oEnd = nValue;
      }
      
      public function get path() : Array
      {
         return this._aPath;
      }
      
      public function addPoint(pathElem:PathElement) : void
      {
         this._aPath.push(pathElem);
      }
      
      public function getPointAtIndex(index:uint) : PathElement
      {
         return this._aPath[index];
      }
      
      public function deletePoint(index:uint) : void
      {
         this._aPath.splice(index,1);
      }
      
      public function toString() : String
      {
         var str:* = "\ndepart : [" + this._oStart.x + ", " + this._oStart.y + "]";
         str = str + ("\narrivée : [" + this._oEnd.x + ", " + this._oEnd.y + "]\nchemin :");
         for(var i:uint = 0; i < this._aPath.length; i++)
         {
            str = str + ("[" + PathElement(this._aPath[i]).step.x + ", " + PathElement(this._aPath[i]).step.y + ", " + PathElement(this._aPath[i]).orientation + "]  ");
         }
         return str;
      }
      
      public function compress() : void
      {
         var elem:uint = 0;
         if(this._aPath.length > 0)
         {
            elem = this._aPath.length - 1;
            while(elem > 0)
            {
               if(this._aPath[elem].orientation == this._aPath[elem - 1].orientation)
               {
                  this.deletePoint(elem);
                  elem--;
               }
               else
               {
                  elem--;
               }
            }
         }
      }
      
      public function fill() : void
      {
         var elem:int = 0;
         var pFinal:PathElement = null;
         var pe:PathElement = null;
         if(this._aPath.length > 0)
         {
            elem = 0;
            pFinal = new PathElement();
            pFinal.orientation = 0;
            pFinal.step = this._oEnd;
            this._aPath.push(pFinal);
            while(elem < this._aPath.length - 1)
            {
               if(Math.abs(this._aPath[elem].step.x - this._aPath[elem + 1].step.x) > 1 || Math.abs(this._aPath[elem].step.y - this._aPath[elem + 1].step.y) > 1)
               {
                  pe = new PathElement();
                  pe.orientation = this._aPath[elem].orientation;
                  switch(pe.orientation)
                  {
                     case DirectionsEnum.RIGHT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x + 1,this._aPath[elem].step.y + 1);
                        break;
                     case DirectionsEnum.DOWN_RIGHT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x + 1,this._aPath[elem].step.y);
                        break;
                     case DirectionsEnum.DOWN:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x + 1,this._aPath[elem].step.y - 1);
                        break;
                     case DirectionsEnum.DOWN_LEFT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x,this._aPath[elem].step.y - 1);
                        break;
                     case DirectionsEnum.LEFT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x - 1,this._aPath[elem].step.y - 1);
                        break;
                     case DirectionsEnum.UP_LEFT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x - 1,this._aPath[elem].step.y);
                        break;
                     case DirectionsEnum.UP:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x - 1,this._aPath[elem].step.y + 1);
                        break;
                     case DirectionsEnum.UP_RIGHT:
                        pe.step = com.ankamagames.jerakine.types.positions.MapPoint.fromCoords(this._aPath[elem].step.x,this._aPath[elem].step.y + 1);
                  }
                  this._aPath.splice(elem + 1,0,pe);
                  elem++;
               }
               else
               {
                  elem++;
               }
               if(elem > com.ankamagames.jerakine.types.positions.MapPoint.MAP_HEIGHT * 2 + com.ankamagames.jerakine.types.positions.MapPoint.MAP_WIDTH)
               {
                  throw new JerakineError("Path too long. Maybe an orientation problem?");
               }
            }
         }
         this._aPath.pop();
      }
      
      public function getCells() : Vector.<uint>
      {
         var mp:com.ankamagames.jerakine.types.positions.MapPoint = null;
         var cells:Vector.<uint> = new Vector.<uint>();
         for(var i:uint = 0; i < this._aPath.length; i++)
         {
            mp = this._aPath[i].step;
            cells.push(mp.cellId);
         }
         cells.push(this._oEnd.cellId);
         return cells;
      }
      
      public function replaceEnd(newEnd:com.ankamagames.jerakine.types.positions.MapPoint) : void
      {
         this._oEnd = newEnd;
      }
   }
}
