package com.ankamagames.jerakine.utils.display.spellZone
{
   import flash.display.Sprite;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   
   public class SpellZoneCellManager extends Sprite
   {
      
      public static const RANGE_COLOR:uint = 65280;
      
      public static const CHARACTER_COLOR:uint = 16711680;
      
      public static const SPELL_COLOR:uint = 255;
       
      private var _centerCell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell;
      
      public var cells:Vector.<com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell>;
      
      private var _spellLevel:com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
      
      private var _spellCellsId:Vector.<uint>;
      
      private var _rollOverCell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _paddingTop:uint;
      
      private var _paddingLeft:uint;
      
      private var _zoneDisplay:Sprite;
      
      public function SpellZoneCellManager()
      {
         super();
         this._zoneDisplay = new Sprite();
         addChild(this._zoneDisplay);
         this.cells = new Vector.<com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell>();
         this._spellCellsId = new Vector.<uint>();
      }
      
      public function setDisplayZone(pWidth:uint, pHeight:uint) : void
      {
         this._width = pWidth;
         this._height = pHeight;
      }
      
      public function set spellLevel(spellLevel:com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider) : void
      {
         this._spellLevel = spellLevel;
      }
      
      private function addListeners() : void
      {
         addEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
         addEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
      }
      
      private function removeListeners() : void
      {
         removeEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
         removeEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
      }
      
      private function onCellRollOver(e:SpellZoneEvent) : void
      {
         this._rollOverCell = e.cell;
         this.showSpellZone(e.cell);
      }
      
      private function onCellRollOut(e:SpellZoneEvent) : void
      {
         this.setLastSpellCellToNormal();
      }
      
      public function showSpellZone(cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell) : void
      {
         if(this._spellCellsId.length > 0)
         {
            this.setLastSpellCellToNormal();
         }
         this._spellCellsId = this.getSpellZone().getCells(cell.cellId);
         this.setSpellZone(this._spellCellsId);
      }
      
      private function setLastSpellCellToNormal() : void
      {
         var cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         var id:uint = 0;
         for each(cell in this.cells)
         {
            for each(id in this._spellCellsId)
            {
               if(id == cell.cellId)
               {
                  cell.changeColorToDefault();
               }
            }
         }
      }
      
      private function resetCells() : void
      {
         var cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         for each(cell in this.cells)
         {
            cell.setNormalCell();
         }
      }
      
      public function show() : void
      {
         var zone:IZone = null;
         var posX:int = 0;
         var posY:int = 0;
         var nbHorCell:uint = 0;
         var nbVerCell:uint = 0;
         var changementId:uint = 0;
         var dataMapProvider:IDataMapProvider = null;
         var cellWidth:uint = 0;
         var cellHeight:uint = 0;
         var i:int = 0;
         var j:int = 0;
         var graphicCell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         if(this._spellLevel == null)
         {
            return;
         }
         this.resetCells();
         if(this._spellLevel.castZoneInLine)
         {
            zone = new Cross(this._spellLevel.minimalRange,this._spellLevel.maximalRange,dataMapProvider);
         }
         else
         {
            zone = new Lozenge(this._spellLevel.minimalRange,this._spellLevel.maximalRange,dataMapProvider);
         }
         if(this.cells.length == 0)
         {
            posX = 0;
            posY = 0;
            nbVerCell = 40;
            nbHorCell = 14;
            changementId = 0;
            cellWidth = this._width / (nbHorCell + 0.5);
            cellHeight = this._height / (nbVerCell / 2 + 0.5);
            for(i = 0; i < nbVerCell; i++)
            {
               posX = Math.ceil(i / 2);
               posY = -Math.floor(i / 2);
               for(j = 0; j < nbHorCell; j++)
               {
                  graphicCell = new com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell(cellWidth,cellHeight,MapPoint.fromCoords(posX,posY).cellId);
                  if(graphicCell.cellId == SpellZoneConstant.CENTER_CELL_ID + changementId)
                  {
                     this._centerCell = graphicCell;
                  }
                  else
                  {
                     graphicCell.changeColorToDefault();
                  }
                  graphicCell.addEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
                  graphicCell.addEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
                  this.cells.push(graphicCell);
                  graphicCell.posX = posX;
                  graphicCell.posY = posY;
                  if(i == 0 || i % 2 == 0)
                  {
                     graphicCell.x = j * cellWidth;
                  }
                  else
                  {
                     graphicCell.x = j * cellWidth + cellWidth / 2;
                  }
                  graphicCell.y = i * cellHeight / 2;
                  this._zoneDisplay.addChild(graphicCell);
                  posX++;
                  posY++;
               }
            }
         }
         this.colorCell(this._centerCell,CHARACTER_COLOR,true);
         var scale:Number = 14.5 / (1 + Math.ceil(this._spellLevel.maximalRange) + Math.ceil(this.getSpellZone().radius));
         this._zoneDisplay.scaleX = this._zoneDisplay.scaleY = scale;
         this._zoneDisplay.x = (this._width - this._zoneDisplay.width) / 2 + 0.5 / 14.5 * this._zoneDisplay.width / 2;
         this._zoneDisplay.y = (this._height - this._zoneDisplay.height) / 2 + 0.5 / 20.5 * this._zoneDisplay.height / 2;
         if(this._centerCell)
         {
            this.setRangedCells(zone.getCells(this._centerCell.cellId));
         }
         if(mask != null)
         {
            return;
         }
         var squareMask:Sprite = new Sprite();
         squareMask.graphics.beginFill(16711680);
         squareMask.graphics.drawRoundRect(0,0,this._width,this._height - 3,30,30);
         addChild(squareMask);
         this.mask = squareMask;
      }
      
      private function isInSpellArea(cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell, lozenge:Lozenge) : Boolean
      {
         var cellId:uint = 0;
         if(lozenge == null)
         {
            return false;
         }
         var cellsId:Vector.<uint> = lozenge.getCells(this._centerCell.cellId);
         for each(cellId in cellsId)
         {
            if(cellId == cell.cellId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function remove() : void
      {
         var graphicCell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         var vectorLength:uint = this.cells.length;
         for(var i:uint = vectorLength; i > 0; i--)
         {
            graphicCell = this.cells.pop();
            this._zoneDisplay.removeChild(graphicCell);
            graphicCell = null;
         }
      }
      
      public function setRangedCells(cellsId:Vector.<uint>) : void
      {
         var cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         var id:uint = 0;
         for each(cell in this.cells)
         {
            for each(id in cellsId)
            {
               if(id == cell.cellId)
               {
                  cell.setRangeCell();
               }
            }
         }
      }
      
      public function setSpellZone(cellsId:Vector.<uint>) : void
      {
         var cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         var id:uint = 0;
         for each(cell in this.cells)
         {
            for each(id in cellsId)
            {
               if(id == cell.cellId)
               {
                  cell.setSpellCell();
               }
            }
         }
      }
      
      public function colorCell(cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell, color:uint, setDefault:Boolean = false) : void
      {
         cell.colorCell(color,setDefault);
      }
      
      public function colorCells(cellsId:Vector.<uint>, color:uint, setDefault:Boolean = false) : void
      {
         var cell:com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCell = null;
         var id:uint = 0;
         for each(cell in this.cells)
         {
            for each(id in cellsId)
            {
               if(id == cell.cellId)
               {
                  this.colorCell(cell,color,setDefault);
               }
            }
         }
      }
      
      private function getSpellZone() : IZone
      {
         var ray:uint = 0;
         var dataMapParovider:IDataMapProvider = null;
         var i:IZoneShape = null;
         var shape:IZone = null;
         var line:Line = null;
         var shapeT:Cross = null;
         var diffPosX:int = 0;
         var diffPosY:int = 0;
         var shapeCode:uint = 88;
         ray = 666;
         for each(i in this._spellLevel.spellZoneEffects)
         {
            if(i.zoneShape != 0 && i.zoneSize < ray && i.zoneSize > 0)
            {
               ray = i.zoneSize;
               shapeCode = i.zoneShape;
            }
         }
         if(ray == 666)
         {
            ray = 0;
         }
         switch(shapeCode)
         {
            case SpellShapeEnum.X:
               shape = new Cross(0,ray,dataMapParovider);
               break;
            case SpellShapeEnum.L:
               line = new Line(ray,dataMapParovider);
               shape = line;
               break;
            case SpellShapeEnum.T:
               shapeT = new Cross(0,ray,dataMapParovider);
               shapeT.onlyPerpendicular = true;
               shape = shapeT;
               break;
            case SpellShapeEnum.D:
               shape = new Cross(0,ray,dataMapParovider);
               break;
            case SpellShapeEnum.C:
               shape = new Lozenge(0,ray,dataMapParovider);
               break;
            case SpellShapeEnum.O:
               shape = new Cross(ray - 1,ray,dataMapParovider);
               break;
            case SpellShapeEnum.P:
            default:
               shape = new Cross(0,0,dataMapParovider);
         }
         if(this._rollOverCell)
         {
            diffPosX = this._centerCell.posX - this._rollOverCell.posX;
            diffPosY = this._centerCell.posY - this._rollOverCell.posY;
            shape.direction = DirectionsEnum.DOWN_RIGHT;
            if(diffPosX == 0 && diffPosY > 0)
            {
               shape.direction = DirectionsEnum.DOWN_LEFT;
            }
            if(diffPosX == 0 && diffPosY < 0)
            {
               shape.direction = DirectionsEnum.UP_RIGHT;
            }
            if(diffPosX > 0 && diffPosY == 0)
            {
               shape.direction = DirectionsEnum.UP_LEFT;
            }
         }
         return shape;
      }
   }
}
