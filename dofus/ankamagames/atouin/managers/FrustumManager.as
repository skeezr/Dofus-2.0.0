package com.ankamagames.atouin.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import com.ankamagames.atouin.types.Frustum;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import flash.display.DisplayObject;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class FrustumManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.managers.FrustumManager));
      
      private static var _self:com.ankamagames.atouin.managers.FrustumManager;
       
      private var _frustumContainer:DisplayObjectContainer;
      
      private var _shapeTop:Sprite;
      
      private var _shapeRight:Sprite;
      
      private var _shapeBottom:Sprite;
      
      private var _shapeLeft:Sprite;
      
      private var _frustrum:Frustum;
      
      private var _lastCellId:int;
      
      public function FrustumManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.atouin.managers.FrustumManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.managers.FrustumManager();
         }
         return _self;
      }
      
      public function init(frustumContainer:DisplayObjectContainer) : void
      {
         this._frustumContainer = frustumContainer;
         this._shapeTop = new Sprite();
         this._shapeRight = new Sprite();
         this._shapeBottom = new Sprite();
         this._shapeLeft = new Sprite();
         this._frustumContainer.addChild(this._shapeLeft);
         this._frustumContainer.addChild(this._shapeTop);
         this._frustumContainer.addChild(this._shapeRight);
         this._frustumContainer.addChild(this._shapeBottom);
         this._shapeLeft.buttonMode = true;
         this._shapeTop.buttonMode = true;
         this._shapeRight.buttonMode = true;
         this._shapeBottom.buttonMode = true;
         this._shapeLeft.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeTop.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeRight.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeBottom.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.setBorderInteraction(false);
         this._lastCellId = -1;
      }
      
      public function setBorderInteraction(enable:Boolean) : void
      {
         this._shapeTop.mouseEnabled = enable;
         this._shapeRight.mouseEnabled = enable;
         this._shapeBottom.mouseEnabled = enable;
         this._shapeLeft.mouseEnabled = enable;
      }
      
      public function set frustum(rFrustum:Frustum) : void
      {
         this._frustrum = rFrustum;
         var pTopLeftInner:Point = new Point(rFrustum.x + AtouinConstants.CELL_HALF_WIDTH * rFrustum.scale,rFrustum.y + AtouinConstants.CELL_HALF_HEIGHT * rFrustum.scale);
         var pTopRightInner:Point = new Point(rFrustum.x - AtouinConstants.CELL_HALF_WIDTH * rFrustum.scale + rFrustum.width,rFrustum.y + AtouinConstants.CELL_HALF_HEIGHT * rFrustum.scale);
         var pBottomLeftInner:Point = new Point(rFrustum.x + AtouinConstants.CELL_HALF_WIDTH * rFrustum.scale,rFrustum.y - AtouinConstants.CELL_HEIGHT * rFrustum.scale + rFrustum.height);
         var pBottomRightInner:Point = new Point(rFrustum.x - AtouinConstants.CELL_HALF_WIDTH * rFrustum.scale + rFrustum.width,rFrustum.y - AtouinConstants.CELL_HEIGHT * rFrustum.scale + rFrustum.height);
         var pTopLeft:Point = new Point(rFrustum.x,rFrustum.y);
         var pTopRight:Point = new Point(rFrustum.x + rFrustum.width,rFrustum.y);
         var pBottomLeft:Point = new Point(rFrustum.x,rFrustum.y + rFrustum.height - AtouinConstants.CELL_HALF_HEIGHT * rFrustum.scale);
         var pBottomRight:Point = new Point(rFrustum.x + rFrustum.width,rFrustum.y + rFrustum.height - AtouinConstants.CELL_HALF_HEIGHT * rFrustum.scale);
         this._shapeTop.graphics.clear();
         this._shapeRight.graphics.clear();
         this._shapeBottom.graphics.clear();
         this._shapeLeft.graphics.clear();
         var alphaShape:Number = 0;
         this._shapeLeft.graphics.beginFill(16746564,alphaShape);
         this._shapeLeft.graphics.moveTo(0,pTopLeft.y);
         this._shapeLeft.graphics.lineTo(pTopLeft.x,pTopLeft.y);
         this._shapeLeft.graphics.lineTo(pTopLeftInner.x,pTopLeftInner.y);
         this._shapeLeft.graphics.lineTo(pBottomLeftInner.x,pBottomLeftInner.y);
         this._shapeLeft.graphics.lineTo(pBottomLeft.x,pBottomLeft.y);
         this._shapeLeft.graphics.lineTo(0,pBottomLeft.y);
         this._shapeLeft.graphics.lineTo(0,pTopLeft.y);
         this._shapeLeft.graphics.endFill();
         this._shapeTop.graphics.beginFill(7803289,alphaShape);
         this._shapeTop.graphics.moveTo(pTopLeft.x,0);
         this._shapeTop.graphics.lineTo(pTopLeft.x,pTopLeft.y);
         this._shapeTop.graphics.lineTo(pTopLeftInner.x,pTopLeftInner.y);
         this._shapeTop.graphics.lineTo(pTopRightInner.x,pTopRightInner.y);
         this._shapeTop.graphics.lineTo(pTopRight.x,pTopRight.y);
         this._shapeTop.graphics.lineTo(pTopRight.x,0);
         this._shapeTop.graphics.lineTo(0,0);
         this._shapeTop.graphics.endFill();
         this._shapeRight.graphics.beginFill(1218969,alphaShape);
         this._shapeRight.graphics.moveTo(StageShareManager.startWidth,pTopRight.y);
         this._shapeRight.graphics.lineTo(pTopRight.x,pTopRight.y);
         this._shapeRight.graphics.lineTo(pTopRightInner.x,pTopRightInner.y);
         this._shapeRight.graphics.lineTo(pBottomRightInner.x,pBottomRightInner.y);
         this._shapeRight.graphics.lineTo(pBottomRight.x,pBottomRight.y);
         this._shapeRight.graphics.lineTo(StageShareManager.startWidth,pBottomRight.y);
         this._shapeRight.graphics.lineTo(StageShareManager.startWidth,pTopRight.y);
         this._shapeRight.graphics.endFill();
         this._shapeBottom.graphics.beginFill(7807590,alphaShape);
         this._shapeBottom.graphics.moveTo(pBottomRight.x,StageShareManager.startHeight);
         this._shapeBottom.graphics.lineTo(pBottomRight.x,pBottomRight.y);
         this._shapeBottom.graphics.lineTo(pBottomRightInner.x,pBottomRightInner.y + 10);
         this._shapeBottom.graphics.lineTo(pBottomLeftInner.x,pBottomLeftInner.y + 10);
         this._shapeBottom.graphics.lineTo(pBottomLeft.x,pBottomLeft.y);
         this._shapeBottom.graphics.lineTo(pBottomLeft.x,StageShareManager.startHeight);
         this._shapeBottom.graphics.lineTo(pBottomRight.x,StageShareManager.startHeight);
         this._shapeBottom.graphics.endFill();
      }
      
      private function click(e:MouseEvent) : void
      {
         var cellId:int = 0;
         var destMapId:uint = 0;
         var currentMap:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         switch(e.target)
         {
            case this._shapeRight:
               destMapId = currentMap.rightNeighbourId;
               break;
            case this._shapeLeft:
               destMapId = currentMap.leftNeighbourId;
               break;
            case this._shapeBottom:
               destMapId = currentMap.bottomNeighbourId;
               break;
            case this._shapeTop:
               destMapId = currentMap.topNeighbourId;
         }
         cellId = this.findNearestCell(e.target as Sprite);
         if(cellId == -1)
         {
            return;
         }
         this.sendMsg(destMapId,cellId);
      }
      
      private function findNearestCell(target:Sprite) : int
      {
         var x:int = 0;
         var y:int = 0;
         var sx:int = 0;
         var sy:int = 0;
         var p:Point = null;
         var d:Number = NaN;
         var destMapId:uint = 0;
         var i:uint = 0;
         var cellId:int = 0;
         var near:Number = NaN;
         var mapChangeData:uint = 0;
         var cellData:CellData = null;
         var currentMap:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         switch(target)
         {
            case this._shapeRight:
               x = AtouinConstants.MAP_WIDTH - 1;
               y = AtouinConstants.MAP_WIDTH - 1;
               destMapId = currentMap.rightNeighbourId;
               break;
            case this._shapeLeft:
               x = 0;
               y = 0;
               destMapId = currentMap.leftNeighbourId;
               break;
            case this._shapeBottom:
               x = AtouinConstants.MAP_HEIGHT - 1;
               y = -(AtouinConstants.MAP_HEIGHT - 1);
               destMapId = currentMap.bottomNeighbourId;
               break;
            case this._shapeTop:
               x = 0;
               y = 0;
               destMapId = currentMap.topNeighbourId;
         }
         if(target == this._shapeRight || target == this._shapeLeft)
         {
            near = AtouinConstants.MAP_HEIGHT * AtouinConstants.CELL_HEIGHT * this._frustrum.scale;
            for(i = 0; i < AtouinConstants.MAP_HEIGHT * 2; )
            {
               cellId = CellIdConverter.coordToCellId(x,y);
               p = Cell.cellPixelCoords(CellIdConverter.coordToCellId(x,y));
               d = Math.abs(this._shapeRight.mouseY - this._frustrum.y - (p.y + AtouinConstants.CELL_HALF_HEIGHT) * this._frustrum.scale);
               if(d < near)
               {
                  cellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[cellId] as CellData;
                  mapChangeData = cellData.mapChangeData;
                  if(Boolean(mapChangeData) && (Boolean(target == this._shapeRight) && (Boolean(mapChangeData & 1 || (cellId + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && mapChangeData & 2 || (cellId + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && mapChangeData & 128)) || Boolean(target == this._shapeLeft) && (Boolean(x == -y && mapChangeData & 8 || mapChangeData & 16 || x == -y && mapChangeData & 32))))
                  {
                     sx = x;
                     sy = y;
                     near = d;
                  }
                  if(!(i % 2))
                  {
                     x++;
                  }
                  else
                  {
                     y--;
                  }
                  i++;
                  continue;
               }
               return CellIdConverter.coordToCellId(sx,sy);
            }
            if(near != AtouinConstants.MAP_HEIGHT * AtouinConstants.CELL_HEIGHT * this._frustrum.scale)
            {
               return CellIdConverter.coordToCellId(sx,sy);
            }
         }
         else
         {
            near = AtouinConstants.MAP_WIDTH * AtouinConstants.CELL_WIDTH * this._frustrum.scale;
            for(i = 0; i < AtouinConstants.MAP_WIDTH * 2; )
            {
               cellId = CellIdConverter.coordToCellId(x,y);
               p = Cell.cellPixelCoords(CellIdConverter.coordToCellId(x,y));
               d = Math.abs(this._shapeRight.mouseX - this._frustrum.x - (p.x + AtouinConstants.CELL_HALF_WIDTH) * this._frustrum.scale);
               if(d < near)
               {
                  cellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[cellId] as CellData;
                  mapChangeData = cellData.mapChangeData;
                  if(Boolean(mapChangeData) && (Boolean(target == this._shapeTop) && (Boolean(cellId < AtouinConstants.MAP_WIDTH && mapChangeData & 32 || mapChangeData & 64 || cellId < AtouinConstants.MAP_WIDTH && mapChangeData & 128)) || Boolean(target == this._shapeBottom) && (Boolean(cellId >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && mapChangeData & 2 || mapChangeData & 4 || cellId >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && mapChangeData & 8))))
                  {
                     sx = x;
                     sy = y;
                     near = d;
                  }
                  if(!(i % 2))
                  {
                     x++;
                  }
                  else
                  {
                     y++;
                  }
                  i++;
                  continue;
               }
               return CellIdConverter.coordToCellId(sx,sy);
            }
            if(near != AtouinConstants.MAP_WIDTH * AtouinConstants.CELL_WIDTH * this._frustrum.scale)
            {
               return CellIdConverter.coordToCellId(sx,sy);
            }
         }
         return -1;
      }
      
      private function sendMsg(mapId:uint, cellId:uint) : void
      {
         var msg:AdjacentMapClickMessage = new AdjacentMapClickMessage();
         msg.cellId = cellId;
         msg.adjacentMapId = mapId;
         Atouin.getInstance().handler.process(msg);
      }
      
      private function out(e:MouseEvent) : void
      {
         var n:uint = 0;
         switch(e.target)
         {
            case this._shapeRight:
               n = DirectionsEnum.RIGHT;
               break;
            case this._shapeLeft:
               n = DirectionsEnum.LEFT;
               break;
            case this._shapeBottom:
               n = DirectionsEnum.DOWN;
               break;
            case this._shapeTop:
               n = DirectionsEnum.UP;
         }
         this._lastCellId = -1;
         var msg:AdjacentMapOutMessage = new AdjacentMapOutMessage(n,DisplayObject(e.target));
         Atouin.getInstance().handler.process(msg);
      }
      
      private function mouseMove(e:MouseEvent) : void
      {
         var n:uint = 0;
         switch(e.target)
         {
            case this._shapeRight:
               n = DirectionsEnum.RIGHT;
               break;
            case this._shapeLeft:
               n = DirectionsEnum.LEFT;
               break;
            case this._shapeBottom:
               n = DirectionsEnum.DOWN;
               break;
            case this._shapeTop:
               n = DirectionsEnum.UP;
         }
         var cellId:int = this.findNearestCell(e.target as Sprite);
         if(cellId == -1 || cellId == this._lastCellId)
         {
            return;
         }
         this._lastCellId = cellId;
         var cellData:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[cellId] as CellData;
         var msg:AdjacentMapOverMessage = new AdjacentMapOverMessage(n,DisplayObject(e.target),cellId,cellData);
         Atouin.getInstance().handler.process(msg);
      }
   }
}
