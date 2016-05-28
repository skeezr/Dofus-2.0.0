package com.ankamagames.atouin.data.map
{
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Point;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.data.map.elements.BasicElement;
   
   public class Cell
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Cell));
       
      public var cellId:int;
      
      public var elementsCount:int;
      
      public var elements:Array;
      
      private var _layer:com.ankamagames.atouin.data.map.Layer;
      
      public function Cell(layer:com.ankamagames.atouin.data.map.Layer)
      {
         super();
         this._layer = layer;
      }
      
      public static function cellCoords(cellId:uint) : Point
      {
         return new Point(cellId % AtouinConstants.MAP_WIDTH,Math.floor(cellId / AtouinConstants.MAP_WIDTH));
      }
      
      public static function cellId(p:Point) : uint
      {
         return CellIdConverter.coordToCellId(p.x,p.y);
      }
      
      public static function cellIdByXY(x:uint, y:uint) : uint
      {
         return CellIdConverter.coordToCellId(x,y);
      }
      
      public static function cellPixelCoords(cellId:uint) : Point
      {
         var p:Point = cellCoords(cellId);
         p.x = p.x * AtouinConstants.CELL_WIDTH + (p.y % 2 == 1?AtouinConstants.CELL_HALF_WIDTH:0);
         p.y = p.y * AtouinConstants.CELL_HALF_HEIGHT;
         return p;
      }
      
      public function get layer() : com.ankamagames.atouin.data.map.Layer
      {
         return this._layer;
      }
      
      public function get coords() : Point
      {
         return CellIdConverter.cellIdToCoord(this.cellId);
      }
      
      public function get pixelCoords() : Point
      {
         return cellPixelCoords(this.cellId);
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         var be:BasicElement = null;
         var i:int = 0;
         try
         {
            this.cellId = raw.readShort();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("    (Cell) Id : " + this.cellId);
            }
            this.elementsCount = raw.readShort();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("    (Cell) Elements count : " + this.elementsCount);
            }
            this.elements = new Array();
            for(i = 0; i < this.elementsCount; i++)
            {
               be = BasicElement.getElementFromType(raw.readByte(),this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("    (Cell) Element at index " + i + " :");
               }
               be.fromRaw(raw);
               this.elements.push(be);
            }
         }
         catch(e:*)
         {
            throw e;
         }
      }
   }
}
