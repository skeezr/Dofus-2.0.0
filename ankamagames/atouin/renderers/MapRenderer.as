package com.ankamagames.atouin.renderers
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.atouin.data.map.Fixture;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.elements.subtypes.AnimatedGraphicalElementData;
   import com.ankamagames.atouin.types.events.RenderMapEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.tiphon.display.RasterizedAnimation;
   import com.ankamagames.atouin.types.CellContainer;
   import flash.geom.Point;
   import flash.display.Sprite;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.Layer;
   import flash.geom.ColorTransform;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.types.InteractiveCell;
   import com.ankamagames.atouin.data.map.CellData;
   import flash.display.DisplayObject;
   import com.ankamagames.atouin.data.map.elements.GraphicalElement;
   import flash.geom.Rectangle;
   import com.ankamagames.atouin.data.map.elements.BasicElement;
   import com.ankamagames.atouin.data.elements.subtypes.EntityGraphicalElementData;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.atouin.data.elements.subtypes.ParticlesGraphicalElementData;
   import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
   import flash.display.Shape;
   import com.ankamagames.jerakine.types.ASwf;
   import flash.display.MovieClip;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.display.MovieClipUtils;
   import flash.display.Bitmap;
   import com.ankamagames.atouin.data.elements.subtypes.BoundingBoxGraphicalElementData;
   import flash.display.InteractiveObject;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.jerakine.script.ScriptExec;
   import com.ankamagames.sweevo.runners.EmitterRunner;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.enums.ElementTypesEnum;
   import flash.geom.Matrix;
   import flash.geom.Transform;
   import flash.events.Event;
   
   public class MapRenderer extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapRenderer));
      
      private static var _cachedAsBitmapElement:Array = new Array();
       
      private var _container:DisplayObjectContainer;
      
      private var _elements:Elements;
      
      private var _gfxLoader:IResourceLoader;
      
      private var _swfLoader:IResourceLoader;
      
      private var _map:Map;
      
      private var _useSmooth:Boolean;
      
      private var _cacheRef:Array;
      
      private var _bitmapsGfx:Array;
      
      private var _swfGfx:Array;
      
      private var _dataMapContainer:DataMapContainer;
      
      private var _icm:InteractiveCellManager;
      
      private var _hideForeground:Boolean;
      
      private var _identifiedElements:Dictionary;
      
      private var _gfxPath:String;
      
      private var _particlesPath:String;
      
      private var _hasSwfGxf:Boolean;
      
      private var _hasBitmapGxf:Boolean;
      
      private var _loadedGfxListCount:uint = 0;
      
      private var _pictoAsBitmap:Boolean;
      
      private var _mapLoaded:Boolean = true;
      
      public function MapRenderer(container:DisplayObjectContainer, elements:Elements)
      {
         this._bitmapsGfx = [];
         this._swfGfx = [];
         this._hideForeground = Atouin.getInstance().options.hideForeground;
         super();
         this._container = container;
         this._elements = elements;
         this._icm = InteractiveCellManager.getInstance();
         this._gfxPath = Atouin.getInstance().options.elementsPath;
         this._particlesPath = Atouin.getInstance().options.particlesScriptsPath;
         this._gfxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._gfxLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded,false,0,true);
         this._gfxLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onBitmapGfxLoaded,false,0,true);
         this._gfxLoader.addEventListener(ResourceErrorEvent.ERROR,this.onGfxError,false,0,true);
         this._swfLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._swfLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded,false,0,true);
         this._swfLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onSwfGfxLoaded,false,0,true);
         this._swfLoader.addEventListener(ResourceErrorEvent.ERROR,this.onGfxError,false,0,true);
      }
      
      public function get identifiedElements() : Dictionary
      {
         return this._identifiedElements;
      }
      
      public function initRenderContainer(container:DisplayObjectContainer) : void
      {
         this._container = container;
      }
      
      public function render(dataContainer:DataMapContainer) : void
      {
         var uri:Uri = null;
         var elementData:GraphicalElementData = null;
         var bg:Fixture = null;
         var fg:Fixture = null;
         var nged:NormalGraphicalElementData = null;
         var newLoader:* = !this._mapLoaded;
         this._mapLoaded = false;
         this._map = dataContainer.dataMap;
         this._cacheRef = new Array();
         var bitmapsGfx:Array = new Array();
         var swfGfx:Array = new Array();
         this._useSmooth = Atouin.getInstance().options.useSmooth;
         this._dataMapContainer = dataContainer;
         this._identifiedElements = new Dictionary(true);
         this._loadedGfxListCount = 0;
         this._hasSwfGxf = false;
         this._hasBitmapGxf = false;
         var gfxUri:Array = new Array();
         var swfUri:Array = new Array();
         var gfxList:Array = this._map.getGfxList();
         for each(elementData in gfxList)
         {
            if(elementData is NormalGraphicalElementData)
            {
               nged = elementData as NormalGraphicalElementData;
               if(nged is AnimatedGraphicalElementData)
               {
                  _log.debug("Chargement d\'un picto animé!!!11 OMFG LOL " + nged.gfxId);
                  uri = new Uri(this._gfxPath + "/swf/" + nged.gfxId + ".swf");
                  swfUri.push(uri);
                  this._hasSwfGxf = true;
                  uri.tag = nged.gfxId;
                  this._cacheRef[nged.gfxId] = "RES_" + uri.toSum();
               }
               else if(this._bitmapsGfx[nged.gfxId])
               {
                  bitmapsGfx[nged.gfxId] = this._bitmapsGfx[nged.gfxId];
               }
               else
               {
                  uri = new Uri(this._gfxPath + "/png/" + nged.gfxId + ".png");
                  gfxUri.push(uri);
                  this._hasBitmapGxf = true;
                  uri.tag = nged.gfxId;
                  this._cacheRef[nged.gfxId] = "RES_" + uri.toSum();
               }
            }
         }
         for each(bg in this._map.backgroundFixtures)
         {
            if(this._bitmapsGfx[bg.fixtureId])
            {
               bitmapsGfx[bg.fixtureId] = this._bitmapsGfx[bg.fixtureId];
            }
            else
            {
               uri = new Uri(this._gfxPath + "/png/" + bg.fixtureId + ".png");
               uri.tag = bg.fixtureId;
               gfxUri.push(uri);
               this._hasBitmapGxf = true;
               this._cacheRef[bg.fixtureId] = "RES_" + uri.toSum();
            }
         }
         for each(fg in this._map.foregroundFixtures)
         {
            if(this._bitmapsGfx[fg.fixtureId])
            {
               bitmapsGfx[fg.fixtureId] = this._bitmapsGfx[fg.fixtureId];
            }
            else
            {
               uri = new Uri(this._gfxPath + "/png/" + fg.fixtureId + ".png");
               uri.tag = fg.fixtureId;
               gfxUri.push(uri);
               this._hasBitmapGxf = true;
               this._cacheRef[fg.fixtureId] = "RES_" + uri.toSum();
            }
         }
         dispatchEvent(new RenderMapEvent(RenderMapEvent.GFX_LOADING_START));
         this._bitmapsGfx = bitmapsGfx;
         this._swfGfx = new Array();
         if(newLoader)
         {
            this._gfxLoader.removeEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded);
            this._gfxLoader.removeEventListener(ResourceLoadedEvent.LOADED,this.onBitmapGfxLoaded);
            this._gfxLoader.removeEventListener(ResourceErrorEvent.ERROR,this.onGfxError);
            this._swfLoader.removeEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded);
            this._swfLoader.removeEventListener(ResourceLoadedEvent.LOADED,this.onSwfGfxLoaded);
            this._swfLoader.removeEventListener(ResourceErrorEvent.ERROR,this.onGfxError);
            this._gfxLoader.cancel();
            this._swfLoader.cancel();
            this._gfxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
            this._gfxLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded,false,0,true);
            this._gfxLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onBitmapGfxLoaded,false,0,true);
            this._gfxLoader.addEventListener(ResourceErrorEvent.ERROR,this.onGfxError,false,0,true);
            this._swfLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
            this._swfLoader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllGfxLoaded,false,0,true);
            this._swfLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onSwfGfxLoaded,false,0,true);
            this._swfLoader.addEventListener(ResourceErrorEvent.ERROR,this.onGfxError,false,0,true);
         }
         this._gfxLoader.load(gfxUri,null);
         this._swfLoader.load(swfUri,null,AdvancedSwfAdapter);
         if(gfxUri.length == 0 && swfUri.length == 0)
         {
            this.onAllGfxLoaded(null);
         }
      }
      
      public function unload() : void
      {
         RasterizedAnimation.optimize(1);
         while(_cachedAsBitmapElement.length)
         {
            _cachedAsBitmapElement.shift().cacheAsBitmap = false;
         }
         this._map = null;
         if(this._dataMapContainer)
         {
            this._dataMapContainer.removeContainer();
         }
         while(this._container.numChildren)
         {
            this._container.removeChildAt(0);
         }
      }
      
      private function makeMap() : void
      {
         var layerCtr:DisplayObjectContainer = null;
         var cellInteractionCtr:DisplayObjectContainer = null;
         var cellCtr:CellContainer = null;
         var cellPnt:Point = null;
         var cellDisabled:Boolean = false;
         var hideFg:Boolean = false;
         var groundLayerCtr:Sprite = null;
         var skipLayer:Boolean = false;
         var i:uint = 0;
         var nbCell:uint = 0;
         var cell:Cell = null;
         var layer:Layer = null;
         var endCell:Cell = null;
         var t:ColorTransform = null;
         this._pictoAsBitmap = Atouin.getInstance().options.useCacheAsBitmap;
         var aInteractiveCell:Array = new Array();
         dispatchEvent(new RenderMapEvent(RenderMapEvent.MAP_RENDER_START));
         this.renderFixture(this._map.backgroundFixtures);
         InteractiveCellManager.getInstance().initManager();
         var layerId:uint = 0;
         var groundOnly:Boolean = OptionManager.getOptionManager("atouin").groundOnly;
         var lastCellId:int = 0;
         var currentCellId:uint = 0;
         for each(layer in this._map.layers)
         {
            layerId = layer.layerId;
            if(layer.layerId == Layer.LAYER_ADDITIONAL_GROUND && Boolean(groundLayerCtr))
            {
               layerCtr = groundLayerCtr;
            }
            else
            {
               layerCtr = new Sprite();
               layerCtr.name = "layer" + layerId;
            }
            if(groundLayerCtr == null)
            {
               groundLayerCtr = layerCtr as Sprite;
            }
            layerCtr.mouseEnabled = false;
            hideFg = Boolean(layerId) && Boolean(this._hideForeground);
            skipLayer = Boolean(groundOnly) && groundLayerCtr != layerCtr;
            if((layer.cells[layer.cells.length - 1] as Cell).cellId != AtouinConstants.MAP_CELLS_COUNT - 1)
            {
               endCell = new Cell(layer);
               endCell.cellId = AtouinConstants.MAP_CELLS_COUNT - 1;
               endCell.elementsCount = 0;
               endCell.elements = [];
               layer.cells.push(endCell);
            }
            i = 0;
            nbCell = layer.cells.length;
            while(i < nbCell)
            {
               cell = layer.cells[i];
               currentCellId = cell.cellId;
               if(layerId == Layer.LAYER_GROUND)
               {
                  if(currentCellId - lastCellId > 1)
                  {
                     currentCellId = lastCellId + 1;
                     cell = null;
                  }
                  else
                  {
                     i++;
                  }
               }
               else
               {
                  i++;
               }
               cellCtr = new CellContainer(currentCellId);
               cellCtr.mouseEnabled = false;
               if(cell)
               {
                  cellPnt = cell.pixelCoords;
                  cellCtr.x = cellCtr.startX = int(Math.round(cellPnt.x));
                  cellCtr.y = cellCtr.startY = int(Math.round(cellPnt.y));
                  if(!skipLayer)
                  {
                     cellDisabled = this.addCellBitmapsElements(cell,cellCtr,hideFg);
                  }
               }
               else
               {
                  cellDisabled = false;
                  cellPnt = Cell.cellPixelCoords(currentCellId);
                  cellCtr.x = cellCtr.startX = cellPnt.x;
                  cellCtr.y = cellCtr.startY = cellPnt.y;
               }
               layerCtr.addChild(cellCtr);
               this._dataMapContainer.getCellReference(currentCellId).addSprite(cellCtr);
               this._dataMapContainer.getCellReference(currentCellId).x = cellCtr.x;
               this._dataMapContainer.getCellReference(currentCellId).y = cellCtr.y;
               this._dataMapContainer.getCellReference(currentCellId).isDisabled = cellDisabled;
               if(layerId == Layer.LAYER_DECOR)
               {
                  this._dataMapContainer.getCellReference(currentCellId).heightestDecor = cellCtr;
               }
               if(!aInteractiveCell[currentCellId])
               {
                  aInteractiveCell[currentCellId] = true;
                  cellInteractionCtr = this._icm.getCell(currentCellId);
                  cellInteractionCtr.y = cellCtr.y - this._map.cells[currentCellId].floor;
                  cellInteractionCtr.x = cellCtr.x;
                  if(!this._dataMapContainer.getChildByName(currentCellId.toString()))
                  {
                     DataMapContainer.interactiveCell[currentCellId] = new InteractiveCell(currentCellId,cellInteractionCtr,cellCtr.x,cellCtr.y - this._map.cells[currentCellId].floor);
                  }
                  this._dataMapContainer.getCellReference(currentCellId).elevation = cellCtr.y - this._map.cells[currentCellId].floor;
                  this._dataMapContainer.getCellReference(currentCellId).mov = CellData(this._map.cells[currentCellId]).mov;
               }
               lastCellId = currentCellId;
            }
            layerCtr.mouseEnabled = false;
            if(Atouin.getInstance().options.debugLayer)
            {
               t = new ColorTransform();
               t.color = Math.random() * 16777215;
               layerCtr.transform.colorTransform = t;
            }
            this._container.addChild(layerCtr);
         }
         this.renderFixture(this._map.foregroundFixtures);
         groundLayerCtr.cacheAsBitmap = true;
         _cachedAsBitmapElement.push(groundLayerCtr);
         groundLayerCtr.mouseChildren = false;
         groundLayerCtr.mouseEnabled = false;
         dispatchEvent(new RenderMapEvent(RenderMapEvent.MAP_RENDER_END));
      }
      
      private function addCellBitmapsElements(cell:Cell, cellCtr:CellContainer, transparent:Boolean = false) : Boolean
      {
         var elementDo:DisplayObject = null;
         var ge:GraphicalElement = null;
         var ed:GraphicalElementData = null;
         var bounds:Rectangle = null;
         var element:BasicElement = null;
         var ged:NormalGraphicalElementData = null;
         var eed:EntityGraphicalElementData = null;
         var elementLook:TiphonEntityLook = null;
         var ts:TiphonSprite = null;
         var ped:ParticlesGraphicalElementData = null;
         var ra:RasterizedAnimation = null;
         var renderer:DisplayObjectRenderer = null;
         var ie:Object = null;
         var namedSprite:Sprite = null;
         var elementDOC:DisplayObjectContainer = null;
         var shape:Shape = null;
         var disabled:Boolean = false;
         var mouseChildren:Boolean = false;
         var cacheAsBitmap:Boolean = true;
         var lsElements:Array = cell.elements;
         var nbElements:int = lsElements.length;
         for(var i:int = 0; i < nbElements; i++)
         {
            element = lsElements[i];
            switch(element.elementType)
            {
               case ElementTypesEnum.GRAPHICAL:
                  ge = GraphicalElement(element);
                  ed = this._elements.getElementData(ge.elementId);
                  if(ge.elementId == 33421)
                  {
                     trace("Lol");
                  }
                  if(!ed)
                  {
                     continue;
                  }
                  switch(true)
                  {
                     case ed is NormalGraphicalElementData:
                        ged = ed as NormalGraphicalElementData;
                        if(ged is AnimatedGraphicalElementData)
                        {
                           if(this._map.getGfxCount(ged.gfxId) > 1)
                           {
                              ra = new RasterizedAnimation(ASwf(this._swfGfx[ged.gfxId]).content as MovieClip,String(ged.gfxId));
                              ra.gotoAndStop("1");
                              ra.smoothing = true;
                              elementDo = FpsControler.controlFps(ra,uint.MAX_VALUE);
                              cacheAsBitmap = false;
                           }
                           else
                           {
                              elementDo = ASwf(this._swfGfx[ged.gfxId]).content;
                              if(elementDo is MovieClip)
                              {
                                 if(!MovieClipUtils.isSingleFrame(elementDo as MovieClip))
                                 {
                                    cacheAsBitmap = false;
                                 }
                              }
                           }
                           elementDo.scaleX = 1;
                           elementDo.x = 0;
                           elementDo.y = 0;
                        }
                        else
                        {
                           elementDo = new Bitmap(this._bitmapsGfx[ged.gfxId]);
                           (elementDo as Bitmap).smoothing = this._useSmooth;
                           elementDo.cacheAsBitmap = this._pictoAsBitmap;
                           _cachedAsBitmapElement.push(elementDo);
                        }
                        elementDo.x = elementDo.x - ged.origin.x;
                        elementDo.y = elementDo.y - ged.origin.y;
                        if(ged.horizontalSymmetry)
                        {
                           elementDo.scaleX = elementDo.scaleX * -1;
                           if(ged is AnimatedGraphicalElementData)
                           {
                              elementDo.x = elementDo.x + ASwf(this._swfGfx[ged.gfxId]).loaderWidth;
                           }
                           else
                           {
                              elementDo.x = elementDo.x + elementDo.width;
                           }
                        }
                        if(!ge.colorMultiplicator.isOne())
                        {
                           elementDo.transform.colorTransform = new ColorTransform(ge.colorMultiplicator.red / 255,ge.colorMultiplicator.green / 255,ge.colorMultiplicator.blue / 255);
                        }
                        if(ged is BoundingBoxGraphicalElementData)
                        {
                           disabled = true;
                           elementDo.alpha = 0;
                        }
                        if(elementDo is InteractiveObject)
                        {
                           (elementDo as InteractiveObject).mouseEnabled = false;
                           if(elementDo is DisplayObjectContainer)
                           {
                              (elementDo as DisplayObjectContainer).mouseChildren = false;
                           }
                        }
                        break;
                     case ed is EntityGraphicalElementData:
                        eed = ed as EntityGraphicalElementData;
                        elementLook = null;
                        try
                        {
                           elementLook = TiphonEntityLook.fromString(eed.entityLook);
                        }
                        catch(e:Error)
                        {
                           _log.warn("Error in the Entity Element " + ed.id + "; misconstructed look string.");
                           break;
                        }
                        ts = new TiphonSprite(elementLook);
                        if(Atouin.getInstance().options.allowParticlesFx)
                        {
                           ts.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityRendered,false,0,true);
                        }
                        ts.setDirection(0);
                        ts.mouseChildren = false;
                        ts.mouseEnabled = false;
                        ts.cacheAsBitmap = this._pictoAsBitmap;
                        _cachedAsBitmapElement.push(ts);
                        if(eed.horizontalSymmetry)
                        {
                           ts.scaleX = ts.scaleX * -1;
                        }
                        elementDo = ts;
                        break;
                     case ed is ParticlesGraphicalElementData:
                        ped = ed as ParticlesGraphicalElementData;
                        _log.debug("Rendering a particle element !");
                        if(Atouin.getInstance().options.allowParticlesFx)
                        {
                           _log.debug("Particle element allowed !");
                           renderer = new DisplayObjectRenderer();
                           renderer.mouseChildren = false;
                           renderer.mouseEnabled = false;
                           cacheAsBitmap = false;
                           ScriptExec.exec(new Uri(this._particlesPath + ped.scriptId + ".dx"),new EmitterRunner(renderer,null),true,null);
                           elementDo = renderer as DisplayObject;
                        }
                  }
                  if(!elementDo)
                  {
                     _log.warn("A graphical element was missed (Element ID " + ge.elementId + "; Cell " + ge.cell.cellId + ").");
                     break;
                  }
                  if(transparent)
                  {
                     elementDo.alpha = 0.5;
                  }
                  if(ge.identifier > 0)
                  {
                     if(!(elementDo is InteractiveObject) || elementDo is DisplayObjectContainer)
                     {
                        namedSprite = new Sprite();
                        namedSprite.addChild(elementDo);
                        namedSprite.alpha = elementDo.alpha;
                        elementDo.alpha = 1;
                        elementDo = namedSprite;
                     }
                     mouseChildren = true;
                     elementDo.cacheAsBitmap = true;
                     _cachedAsBitmapElement.push(elementDo);
                     if(elementDo is DisplayObjectContainer)
                     {
                        elementDOC = elementDo as DisplayObjectContainer;
                        elementDOC.mouseChildren = false;
                     }
                     ie = new Object();
                     this._identifiedElements[ge.identifier] = ie;
                     ie.sprite = elementDo;
                     ie.position = MapPoint.fromCellId(cell.cellId);
                  }
                  elementDo.x = int(elementDo.x + (AtouinConstants.CELL_HALF_WIDTH + ge.offset.x * AtouinConstants.CELL_HALF_WIDTH));
                  elementDo.y = int(elementDo.y + (AtouinConstants.CELL_HALF_HEIGHT - ge.altitude * 10 + ge.offset.y * AtouinConstants.CELL_HALF_HEIGHT));
                  elementDo.x = int(Math.round(elementDo.x));
                  elementDo.y = int(Math.round(elementDo.y));
                  break;
            }
            if(elementDo)
            {
               cellCtr.addChild(elementDo);
            }
            else if(element.elementType != ElementTypesEnum.SOUND)
            {
               shape = new Shape();
               shape.graphics.beginFill(13369548);
               shape.graphics.drawRect(0,0,AtouinConstants.CELL_WIDTH,AtouinConstants.CELL_HEIGHT);
               cellCtr.addChild(shape);
               continue;
            }
         }
         if(this._pictoAsBitmap)
         {
            cellCtr.cacheAsBitmap = cacheAsBitmap;
            _cachedAsBitmapElement.push(cellCtr);
         }
         else
         {
            cellCtr.cacheAsBitmap = false;
         }
         cellCtr.mouseChildren = mouseChildren;
         return disabled;
      }
      
      private function renderFixture(fixtures:Array) : void
      {
         var fixture:Fixture = null;
         var fixtureBmp:Bitmap = null;
         var matrix:Matrix = null;
         var ts:Transform = null;
         var ct:ColorTransform = null;
         var t:Transform = null;
         if(!fixtures || fixtures.length == 0)
         {
            return;
         }
         var smoothing:Boolean = OptionManager.getOptionManager("atouin").useSmooth;
         var ctr:Sprite = new Sprite();
         ctr.x = AtouinConstants.CELL_HALF_WIDTH;
         ctr.y = AtouinConstants.CELL_HEIGHT;
         for each(fixture in fixtures)
         {
            fixtureBmp = new Bitmap(this._bitmapsGfx[fixture.fixtureId]);
            fixtureBmp.alpha = fixture.alpha / 255;
            matrix = new Matrix();
            matrix.translate(-fixtureBmp.width / 2,-fixtureBmp.height / 2);
            matrix.scale(fixture.xScale / 1000,fixture.yScale / 1000);
            matrix.rotate(fixture.rotation / 100);
            matrix.translate(fixture.offset.x,fixture.offset.y);
            matrix.translate(fixtureBmp.width / 2,fixtureBmp.height / 2);
            ts = new Transform(fixtureBmp);
            ts.matrix = matrix;
            fixtureBmp.smoothing = smoothing;
            if(Boolean(int(fixture.redMultiplier)) || Boolean(int(fixture.greenMultiplier)) || Boolean(fixture.blueMultiplier))
            {
               ct = new ColorTransform();
               ct.redMultiplier = fixture.redMultiplier / 128 + 1;
               ct.greenMultiplier = fixture.greenMultiplier / 128 + 1;
               ct.blueMultiplier = fixture.blueMultiplier / 128 + 1;
               t = new Transform(fixtureBmp);
               t.colorTransform = ct;
               fixtureBmp.transform = t;
            }
            _log.trace(fixtureBmp.scaleX + " / " + fixtureBmp.scaleY);
            ctr.addChild(fixtureBmp);
         }
         ctr.mouseEnabled = false;
         ctr.mouseChildren = false;
         ctr.cacheAsBitmap = this._pictoAsBitmap;
         _cachedAsBitmapElement.push(ctr);
         this._container.addChild(ctr);
      }
      
      private function onAllGfxLoaded(e:ResourceLoaderProgressEvent) : void
      {
         this._loadedGfxListCount++;
         if(Boolean(this._hasBitmapGxf) && Boolean(this._hasSwfGxf) && this._loadedGfxListCount != 2)
         {
            return;
         }
         this._mapLoaded = true;
         dispatchEvent(new Event(RenderMapEvent.GFX_LOADING_END));
         this.makeMap();
      }
      
      private function onBitmapGfxLoaded(e:ResourceLoadedEvent) : void
      {
         this._bitmapsGfx[e.uri.tag] = e.resource;
      }
      
      private function onSwfGfxLoaded(e:ResourceLoadedEvent) : void
      {
         this._swfGfx[e.uri.tag] = e.resource;
      }
      
      private function onGfxError(e:ResourceErrorEvent) : void
      {
         _log.error("Unable to load " + e.uri);
      }
      
      private function onEntityRendered(e:TiphonEvent) : void
      {
         _log.error("Entité rendue " + e.sprite + " : " + e.sprite.maxFrame);
         if(e.sprite.maxFrame > 1)
         {
            _log.error("picto animé");
            e.sprite.stopAnimation();
            e.target.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityRendered);
         }
      }
   }
}
