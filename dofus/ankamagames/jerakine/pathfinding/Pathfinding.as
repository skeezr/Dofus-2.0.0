package com.ankamagames.jerakine.pathfinding
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class Pathfinding
   {
      
      private static var _minX:int;
      
      private static var _maxX:int;
      
      private static var _minY:int;
      
      private static var _maxY:int;
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.pathfinding.Pathfinding));
      
      private static var _self:com.ankamagames.jerakine.pathfinding.Pathfinding;
       
      private var _mapStatus:Array;
      
      private var _openList:Array;
      
      private var _movPath:MovementPath;
      
      private var _nHVCost:uint = 10;
      
      private var _nDCost:uint = 15;
      
      private var _nHeuristicCost:uint = 10;
      
      private var _bAllowDiagCornering:Boolean = false;
      
      private var _bAllowTroughEntity:Boolean;
      
      private var _callBackFunction:Function;
      
      private var _argsFunction:Array;
      
      private var _enterFrameIsActive:Boolean = false;
      
      private var _map:IDataMapProvider;
      
      private var _start:MapPoint;
      
      private var _end:MapPoint;
      
      private var _allowDiag:Boolean;
      
      private var _endX:int;
      
      private var _endY:int;
      
      private var _endPoint:MapPoint;
      
      private var _startPoint:MapPoint;
      
      private var _startX:int;
      
      private var _startY:int;
      
      private var _endPointAux:MapPoint;
      
      private var _endAuxX:int;
      
      private var _endAuxY:int;
      
      private var _distanceToEnd:int;
      
      private var _nowY:int;
      
      private var _nowX:int;
      
      private var _currentTime:int;
      
      private var _maxTime:int = 30;
      
      private var _findAnotherEndInLine:Boolean;
      
      public function Pathfinding()
      {
         super();
      }
      
      public static function init(minX:int, maxX:int, minY:int, maxY:int) : void
      {
         _minX = minX;
         _maxX = maxX;
         _minY = minY;
         _maxY = maxY;
      }
      
      public static function findPath(map:IDataMapProvider, start:MapPoint, end:MapPoint, allowDiag:Boolean = true, bAllowTroughEntity:Boolean = true, callBack:Function = null, args:Array = null) : MovementPath
      {
         return new com.ankamagames.jerakine.pathfinding.Pathfinding().processFindPath(map,start,end,allowDiag,bAllowTroughEntity,callBack,args);
      }
      
      public function processFindPath(map:IDataMapProvider, start:MapPoint, end:MapPoint, allowDiag:Boolean = true, bAllowTroughEntity:Boolean = true, callBack:Function = null, args:Array = null) : MovementPath
      {
         this._callBackFunction = callBack;
         this._argsFunction = args;
         this._movPath = new MovementPath();
         this._movPath.start = start;
         this._movPath.end = end;
         this._bAllowTroughEntity = bAllowTroughEntity;
         if(map.height == 0 || map.width == 0 || start == null)
         {
            return this._movPath;
         }
         this.findPathInternal(map,start,end,allowDiag);
         if(this._callBackFunction == null)
         {
            return this._movPath;
         }
         return null;
      }
      
      private function isOpened(y:int, x:int) : Boolean
      {
         return this._mapStatus[y][x].opened;
      }
      
      private function isClosed(y:int, x:int) : Boolean
      {
         var cellInfo:CellInfo = this._mapStatus[y][x];
         if(!cellInfo || !cellInfo.closed)
         {
            return false;
         }
         return cellInfo.closed;
      }
      
      private function nearerSquare() : uint
      {
         var thisF:Number = NaN;
         var minimum:Number = 9999999;
         var indexFound:uint = 0;
         var i:int = -1;
         var len:int = this._openList.length;
         while(++i < len)
         {
            thisF = this._mapStatus[this._openList[i][0]][this._openList[i][1]].heuristic + this._mapStatus[this._openList[i][0]][this._openList[i][1]].movementCost;
            if(thisF <= minimum)
            {
               minimum = thisF;
               indexFound = i;
            }
         }
         return indexFound;
      }
      
      private function closeSquare(y:int, x:int) : void
      {
         var len:uint = this._openList.length;
         var i:int = -1;
         while(++i < len)
         {
            if(this._openList[i][0] == y)
            {
               if(this._openList[i][1] == x)
               {
                  this._openList.splice(i,1);
                  break;
               }
            }
         }
         var cellInfo:CellInfo = this._mapStatus[y][x];
         cellInfo.opened = false;
         cellInfo.closed = true;
      }
      
      private function openSquare(y:int, x:int, parent:Array, movementCost:uint, heuristic:Number, replacing:Boolean) : void
      {
         var len:int = 0;
         var i:int = 0;
         if(!replacing)
         {
            len = this._openList.length;
            i = -1;
            while(++i < len)
            {
               if(this._openList[i][0] == y && this._openList[i][1] == x)
               {
                  replacing = true;
                  break;
               }
            }
         }
         if(!replacing)
         {
            this._openList.push([y,x]);
            this._mapStatus[y][x] = new CellInfo(heuristic,null,true,false);
         }
         var cellInfo:CellInfo = this._mapStatus[y][x];
         cellInfo.parent = parent;
         cellInfo.movementCost = movementCost;
      }
      
      private function movementPathFromArray(returnPath:Array) : void
      {
         var pElem:PathElement = null;
         for(var i:uint = 0; i < returnPath.length - 1; i++)
         {
            pElem = new PathElement();
            pElem.step.x = returnPath[i].x;
            pElem.step.y = returnPath[i].y;
            pElem.orientation = returnPath[i].orientationTo(returnPath[i + 1]);
            this._movPath.addPoint(pElem);
         }
         this._movPath.compress();
         this._movPath.fill();
      }
      
      private function initFindPath() : void
      {
         if(!this._enterFrameIsActive)
         {
            this._enterFrameIsActive = true;
            EnterFrameDispatcher.addEventListener(this.pathFrame,"pathFrame");
         }
         this._currentTime = 0;
         if(this._callBackFunction == null)
         {
            this._maxTime = 2000000;
            this.pathFrame(null);
         }
         else
         {
            this._maxTime = 20;
         }
      }
      
      private function pathFrame(E:Event) : void
      {
         var n:int = 0;
         var j:int = 0;
         var time:int = 0;
         var i:int = 0;
         var pointWeight:uint = 0;
         var movementCost:int = 0;
         var cellOnEndColumn:* = false;
         var cellOnStartColumn:* = false;
         var cellOnEndLine:* = false;
         var cellOnStartLine:* = false;
         var mp:MapPoint = null;
         var distanceTmpToEnd:int = 0;
         var heuristic:Number = NaN;
         if(this._currentTime == 0)
         {
            this._currentTime = getTimer();
         }
         if(this._openList.length > 0 && !this.isClosed(this._endY,this._endX))
         {
            n = this.nearerSquare();
            this._nowY = this._openList[n][0];
            this._nowX = this._openList[n][1];
            this.closeSquare(this._nowY,this._nowX);
            for(j = this._nowY - 1; j < this._nowY + 2; j++)
            {
               for(i = this._nowX - 1; i < this._nowX + 2; i++)
               {
                  if(j >= _minY && j < _maxY && i >= _minX && i < _maxX && !(j == this._nowY && i == this._nowX) && (Boolean(this._allowDiag) || j == this._nowY || i == this._nowX) && (Boolean(this._bAllowDiagCornering) || j == this._nowY || i == this._nowX || Boolean(this._map.pointMov(this._nowX,j,this._bAllowTroughEntity)) && Boolean(this._map.pointMov(i,this._nowY,this._bAllowTroughEntity))))
                  {
                     if(this._map.pointMov(i,j,this._bAllowTroughEntity))
                     {
                        if(!this.isClosed(j,i))
                        {
                           if(i == this._endX && j == this._endY)
                           {
                              pointWeight = 1;
                           }
                           else
                           {
                              pointWeight = this._map.pointWeight(i,j,this._bAllowTroughEntity);
                           }
                           movementCost = this._mapStatus[this._nowY][this._nowX].movementCost + (j == this._nowY || i == this._nowX?this._nHVCost:this._nDCost) * pointWeight;
                           if(this._bAllowTroughEntity)
                           {
                              cellOnEndColumn = i + j == this._endX + this._endY;
                              cellOnStartColumn = i + j == this._startX + this._startY;
                              cellOnEndLine = i - j == this._endX - this._endY;
                              cellOnStartLine = i - j == this._startX - this._startY;
                              mp = MapPoint.fromCoords(i,j);
                              if(!cellOnEndColumn && !cellOnEndLine || !cellOnStartColumn && !cellOnStartLine)
                              {
                                 movementCost = movementCost + mp.distanceToCell(this._endPoint);
                                 movementCost = movementCost + mp.distanceToCell(this._startPoint);
                              }
                              if(i == this._endX || j == this._endY)
                              {
                                 movementCost = movementCost - 3;
                              }
                              if(Boolean(cellOnEndColumn) || Boolean(cellOnEndLine) || i + j == this._nowX + this._nowY || i - j == this._nowX - this._nowY)
                              {
                                 movementCost = movementCost - 2;
                              }
                              if(i == this._startX || j == this._startY)
                              {
                                 movementCost = movementCost - 3;
                              }
                              if(Boolean(cellOnStartColumn) || Boolean(cellOnStartLine))
                              {
                                 movementCost = movementCost - 2;
                              }
                              distanceTmpToEnd = mp.distanceTo(this._endPoint);
                              if(distanceTmpToEnd < this._distanceToEnd)
                              {
                                 if(i == this._endX || j == this._endY)
                                 {
                                    this._endPointAux = mp;
                                    this._endAuxX = i;
                                    this._endAuxY = j;
                                    this._distanceToEnd = distanceTmpToEnd;
                                 }
                                 else if(!this._findAnotherEndInLine && (i + j == this._endX + this._endY || i - j == this._endX - this._endY))
                                 {
                                    this._endPointAux = mp;
                                    this._endAuxX = i;
                                    this._endAuxY = j;
                                    this._distanceToEnd = distanceTmpToEnd;
                                 }
                              }
                           }
                           if(this.isOpened(j,i))
                           {
                              if(movementCost < this._mapStatus[j][i].movementCost)
                              {
                                 this.openSquare(j,i,[this._nowY,this._nowX],movementCost,undefined,true);
                              }
                           }
                           else
                           {
                              heuristic = this._nHeuristicCost * Math.sqrt((this._endY - j) * (this._endY - j) + (this._endX - i) * (this._endX - i));
                              this.openSquare(j,i,[this._nowY,this._nowX],movementCost,heuristic,false);
                           }
                        }
                     }
                  }
               }
            }
            time = getTimer();
            if(time - this._currentTime < this._maxTime)
            {
               this.pathFrame(null);
            }
            else
            {
               this._currentTime = 0;
            }
         }
         else
         {
            this.endPathFrame();
         }
      }
      
      private function endPathFrame() : void
      {
         var returnPath:Array = null;
         var newY:int = 0;
         var newX:int = 0;
         var returnPathOpti:Array = null;
         var k:uint = 0;
         var kX:int = 0;
         var kY:int = 0;
         var nextX:int = 0;
         var nextY:int = 0;
         var interX:int = 0;
         var interY:int = 0;
         this._enterFrameIsActive = false;
         EnterFrameDispatcher.removeEventListener(this.pathFrame);
         var pFound:Boolean = this.isClosed(this._endY,this._endX);
         if(!pFound)
         {
            this._endY = this._endAuxY;
            this._endX = this._endAuxX;
            this._endPoint = this._endPointAux;
            pFound = true;
            this._movPath.replaceEnd(this._endPoint);
         }
         if(pFound)
         {
            returnPath = new Array();
            this._nowY = this._endY;
            this._nowX = this._endX;
            while(this._nowY != this._startY || this._nowX != this._startX)
            {
               returnPath.push(MapPoint.fromCoords(this._nowX,this._nowY));
               newY = this._mapStatus[this._nowY][this._nowX].parent[0];
               newX = this._mapStatus[this._nowY][this._nowX].parent[1];
               this._nowY = newY;
               this._nowX = newX;
            }
            returnPath.push(this._startPoint);
            if(this._allowDiag)
            {
               returnPathOpti = new Array();
               for(k = 0; k < returnPath.length; k++)
               {
                  returnPathOpti.push(returnPath[k]);
                  if(Boolean(returnPath[k + 2]) && MapPoint(returnPath[k]).distanceTo(returnPath[k + 2]) == 1)
                  {
                     k++;
                  }
                  else if(Boolean(returnPath[k + 3]) && MapPoint(returnPath[k]).distanceTo(returnPath[k + 3]) == 2)
                  {
                     kX = returnPath[k].x;
                     kY = returnPath[k].y;
                     nextX = returnPath[k + 3].x;
                     nextY = returnPath[k + 3].y;
                     interX = kX + Math.round((nextX - kX) / 2);
                     interY = kY + Math.round((nextY - kY) / 2);
                     if(Boolean(this._map.pointMov(interX,interY,true)) && this._map.pointWeight(interX,interY) < 2)
                     {
                        returnPathOpti.push(MapPoint.fromCoords(interX,interY));
                        k++;
                        k++;
                     }
                  }
                  else if(Boolean(returnPath[k + 2]) && MapPoint(returnPath[k]).distanceToCell(returnPath[k + 2]) == 2)
                  {
                     kX = returnPath[k].x;
                     kY = returnPath[k].y;
                     nextX = returnPath[k + 2].x;
                     nextY = returnPath[k + 2].y;
                     interX = returnPath[k + 1].x;
                     interY = returnPath[k + 1].y;
                     if(kX + kY == nextX + nextY && kX - kY != interX - interY)
                     {
                        k++;
                     }
                     else if(kX - kY == nextX - nextY && kX - kY != interX - interY)
                     {
                        k++;
                     }
                     else if(kX == nextX && kX != interX && this._map.pointWeight(kX,interY) < 2)
                     {
                        returnPathOpti.push(MapPoint.fromCoords(kX,interY));
                        k++;
                     }
                     else if(kY == nextY && kY != interY && this._map.pointWeight(interX,kY) < 2)
                     {
                        returnPathOpti.push(MapPoint.fromCoords(interX,kY));
                        k++;
                     }
                  }
               }
               returnPath = returnPathOpti;
            }
            if(returnPath.length == 1)
            {
               returnPath = new Array();
            }
            returnPath.reverse();
            this.movementPathFromArray(returnPath);
         }
         if(this._callBackFunction != null)
         {
            if(this._argsFunction)
            {
               this._callBackFunction(this._movPath,this._argsFunction);
            }
            else
            {
               this._callBackFunction(this._movPath);
            }
         }
      }
      
      private function findPathInternal(map:IDataMapProvider, start:MapPoint, end:MapPoint, allowDiag:Boolean) : void
      {
         var x:uint = 0;
         this._findAnotherEndInLine = !map.pointMov(end.x,end.y,true);
         this._map = map;
         this._start = start;
         this._end = end;
         this._allowDiag = allowDiag;
         this._endPoint = MapPoint.fromCoords(end.x,end.y);
         this._startPoint = MapPoint.fromCoords(start.x,start.y);
         this._endX = end.x;
         this._endY = end.y;
         this._startX = start.x;
         this._startY = start.y;
         this._endPointAux = this._startPoint;
         this._endAuxX = this._startX;
         this._endAuxY = this._startY;
         this._distanceToEnd = this._startPoint.distanceTo(this._endPoint);
         this._mapStatus = new Array();
         for(var y:int = _minY; y < _maxY; y++)
         {
            this._mapStatus[y] = new Array();
            for(x = _minX; x <= _maxX; x++)
            {
               this._mapStatus[y][x] = new CellInfo(0,new Array(),false,false);
            }
         }
         this._openList = new Array();
         this.openSquare(this._startY,this._startX,undefined,0,undefined,false);
         this.initFindPath();
      }
      
      private function tracePath(returnPath:Array) : void
      {
         var point:MapPoint = null;
         var cheminEnChaine:String = new String("");
         for(var i:uint = 0; i < returnPath.length; i++)
         {
            point = returnPath[i] as MapPoint;
            cheminEnChaine = cheminEnChaine.concat(" " + point.cellId);
         }
         trace(cheminEnChaine);
      }
      
      private function nearObstacle(x:int, y:int, map:IDataMapProvider) : int
      {
         var j:int = 0;
         var distanceMaxToCheck:int = 2;
         var distanceMin:int = 42;
         for(var i:int = -distanceMaxToCheck; i < distanceMaxToCheck; i++)
         {
            for(j = -distanceMaxToCheck; j < distanceMaxToCheck; j++)
            {
               if(!map.pointMov(x + i,y + j,true))
               {
                  distanceMin = Math.min(distanceMin,MapPoint(MapPoint.fromCoords(x,y)).distanceTo(MapPoint.fromCoords(x + i,y + j)));
               }
            }
         }
         return distanceMin;
      }
   }
}
