package com.ankamagames.atouin.data.map
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.data.DataFormatError;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.elements.BasicElement;
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.enums.ElementTypesEnum;
   import com.ankamagames.atouin.data.map.elements.GraphicalElement;
   
   public class Map
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Map));
       
      public var mapClass:Class;
      
      public var mapVersion:int;
      
      public var groundCRC:int;
      
      public var id:int;
      
      public var relativeId:int;
      
      public var mapType:int;
      
      public var backgroundsCount:int;
      
      public var backgroundFixtures:Array;
      
      public var foregroundsCount:int;
      
      public var foregroundFixtures:Array;
      
      public var subareaId:int;
      
      public var shadowBonusOnEntities:int;
      
      public var topNeighbourId:int;
      
      public var bottomNeighbourId:int;
      
      public var leftNeighbourId:int;
      
      public var rightNeighbourId:int;
      
      public var cellsCount:int;
      
      public var layersCount:int;
      
      public var layers:Array;
      
      public var cells:Array;
      
      private var _parsed:Boolean;
      
      private var _failed:Boolean;
      
      private var _gfxList:Array;
      
      private var _gfxCount:Array;
      
      public function Map()
      {
         this.mapClass = Map;
         super();
      }
      
      public function get parsed() : Boolean
      {
         return this._parsed;
      }
      
      public function get failed() : Boolean
      {
         return this._failed;
      }
      
      public function getGfxList() : Array
      {
         if(!this._gfxList)
         {
            this.computeGfxList();
         }
         return this._gfxList;
      }
      
      public function getGfxCount(gfxId:uint) : uint
      {
         if(!this._gfxList)
         {
            this.computeGfxList();
         }
         return this._gfxCount[gfxId];
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         var header:int = 0;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var l:int = 0;
         var bg:Fixture = null;
         var fg:Fixture = null;
         var la:Layer = null;
         var cd:CellData = null;
         try
         {
            header = raw.readByte();
            if(header != 77)
            {
               throw new DataFormatError("Unknown file format");
            }
            this.mapVersion = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map version : " + this.mapVersion);
            }
            this.id = raw.readUnsignedInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map id : " + this.id);
            }
            this.relativeId = raw.readUnsignedInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map relativeId: " + this.relativeId);
            }
            this.mapType = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Map type : " + this.mapType);
            }
            this.subareaId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Subarea id : " + this.subareaId);
            }
            this.topNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("topNeighbourId : " + this.topNeighbourId);
            }
            this.bottomNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("bottomNeighbourId : " + this.bottomNeighbourId);
            }
            this.leftNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("leftNeighbourId : " + this.leftNeighbourId);
            }
            this.rightNeighbourId = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("rightNeighbourId : " + this.rightNeighbourId);
            }
            this.shadowBonusOnEntities = raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("ShadowBonusOnEntities : " + this.shadowBonusOnEntities);
            }
            this.backgroundsCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Backgrounds count : " + this.backgroundsCount);
            }
            this.backgroundFixtures = new Array();
            for(i = 0; i < this.backgroundsCount; i++)
            {
               bg = new Fixture(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Background at index " + i + " :");
               }
               bg.fromRaw(raw);
               this.backgroundFixtures.push(bg);
            }
            this.foregroundsCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Foregrounds count : " + this.foregroundsCount);
            }
            this.foregroundFixtures = new Array();
            for(j = 0; j < this.foregroundsCount; j++)
            {
               fg = new Fixture(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Foreground at index " + j + " :");
               }
               fg.fromRaw(raw);
               this.foregroundFixtures.push(fg);
            }
            this.cellsCount = AtouinConstants.MAP_CELLS_COUNT;
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Cells count : " + this.cellsCount);
            }
            this.groundCRC = raw.readInt();
            raw.readInt();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("groundCRC : " + this.groundCRC);
            }
            this.layersCount = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("Layers count : " + this.layersCount);
            }
            this.layers = new Array();
            for(k = 0; k < this.layersCount; k++)
            {
               la = new Layer(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Layer at index " + k + " :");
               }
               la.fromRaw(raw);
               this.layers.push(la);
            }
            this.cells = new Array();
            for(l = 0; l < this.cellsCount; l++)
            {
               cd = new CellData(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("Cell data at index " + l + " :");
               }
               cd.fromRaw(raw);
               this.cells.push(cd);
            }
            this._parsed = true;
         }
         catch(e:*)
         {
            _failed = true;
            throw e;
         }
      }
      
      private function computeGfxList() : void
      {
         var layer:Layer = null;
         var s:* = null;
         var cell:Cell = null;
         var element:BasicElement = null;
         var elementId:int = 0;
         var elementData:GraphicalElementData = null;
         var graphicalElementData:NormalGraphicalElementData = null;
         var ele:Elements = Elements.getInstance();
         var gfxList:Array = new Array();
         this._gfxCount = new Array();
         for each(layer in this.layers)
         {
            for each(cell in layer.cells)
            {
               for each(element in cell.elements)
               {
                  if(element.elementType == ElementTypesEnum.GRAPHICAL)
                  {
                     elementId = GraphicalElement(element).elementId;
                     elementData = ele.getElementData(elementId);
                     if(elementData == null)
                     {
                        _log.error("Unknown graphical element ID " + elementId);
                     }
                     else if(elementData is NormalGraphicalElementData)
                     {
                        graphicalElementData = elementData as NormalGraphicalElementData;
                        gfxList[graphicalElementData.gfxId] = graphicalElementData;
                        if(this._gfxCount[graphicalElementData.gfxId])
                        {
                           this._gfxCount[graphicalElementData.gfxId]++;
                        }
                        else
                        {
                           this._gfxCount[graphicalElementData.gfxId] = 1;
                        }
                     }
                  }
               }
            }
         }
         this._gfxList = new Array();
         for(s in gfxList)
         {
            this._gfxList.push(gfxList[s]);
         }
      }
   }
}
