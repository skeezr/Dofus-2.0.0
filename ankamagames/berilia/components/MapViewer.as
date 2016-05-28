package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.display.Sprite;
   import flash.display.Shape;
   import com.ankamagames.berilia.types.graphic.MapGroupElement;
   import flash.utils.Dictionary;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.berilia.types.data.MapIconElement;
   import com.ankamagames.berilia.types.graphic.MapAreaShape;
   import flash.display.Graphics;
   import com.ankamagames.berilia.types.data.MapElement;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.messages.MapMoveMessage;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import flash.display.DisplayObjectContainer;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.events.Event;
   import com.ankamagames.jerakine.resources.events.ResourceEvent;
   import com.ankamagames.berilia.components.messages.ComponentReadyMessage;
   import com.ankamagames.berilia.components.messages.MapRollOverMessage;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   
   public class MapViewer extends GraphicContainer implements FinalizableUIComponent
   {
       
      private var _finalized:Boolean;
      
      private var _folderUri:Uri;
      
      private var _verticalChunck:uint;
      
      private var _horizontalChunck:uint;
      
      private var _showGrid:Boolean = true;
      
      private var _loader:IResourceLoader;
      
      private var _mapBitmapContainer:Sprite;
      
      private var _mapContainer:Sprite;
      
      private var _grid:Shape;
      
      private var _layersContainer:Sprite;
      
      private var _openedMapGroupElement:MapGroupElement;
      
      private var _elementsGraphicRef:Dictionary;
      
      private var _lastMx:int;
      
      private var _lastMy:int;
      
      private var _layers:Array;
      
      private var _mapElements:Array;
      
      public var mapWidth:Number;
      
      public var mapHeight:Number;
      
      public var origineX:int;
      
      public var origineY:int;
      
      public var maxScale:Number = 2;
      
      public var minScale:Number = 0.5;
      
      public var startScale:Number = 0.8;
      
      public var roundCornerRadius:uint = 0;
      
      public var enabledDrag:Boolean = true;
      
      private var _chunkBuffer:Array;
      
      public function MapViewer()
      {
         this._chunkBuffer = [];
         super();
         MapElement.removeAllElements();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onMapChunckLoaded);
         this._loader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllMapChunckLoaded);
      }
      
      public function set folderUri(url:*) : void
      {
         if(url is String)
         {
            url = new Uri(url);
         }
         this._folderUri = url;
      }
      
      public function get folderUri() : *
      {
         return this._folderUri;
      }
      
      public function set verticalChunck(n:uint) : void
      {
         this._verticalChunck = n;
      }
      
      public function get verticalChunck() : uint
      {
         return this._horizontalChunck;
      }
      
      public function set horizontalChunck(n:uint) : void
      {
         this._horizontalChunck = n;
      }
      
      public function get horizontalChunck() : uint
      {
         return this._horizontalChunck;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
      
      public function get showGrid() : Boolean
      {
         return this._showGrid;
      }
      
      public function set showGrid(b:Boolean) : void
      {
         this._showGrid = b;
         this.drawGrid();
      }
      
      public function get visibleMaps() : Rectangle
      {
         var vX:Number = -(this._mapContainer.x / this._mapContainer.scaleX + this.origineX) / this.mapWidth;
         var vY:Number = -(this._mapContainer.y / this._mapContainer.scaleY + this.origineY) / this.mapHeight;
         var vWidth:Number = width / (this.mapWidth * this._mapContainer.scaleX);
         var vHeihgt:Number = height / (this.mapHeight * this._mapContainer.scaleY);
         return new Rectangle(Math.floor(vX),Math.floor(vY),Math.ceil(vWidth),Math.ceil(vHeihgt));
      }
      
      public function get currentMouseMapX() : int
      {
         return this._lastMx;
      }
      
      public function get currentMouseMapY() : int
      {
         return this._lastMy;
      }
      
      public function get mapBounds() : Rectangle
      {
         var rect:Rectangle = new Rectangle();
         rect.x = Math.floor(-this.origineX / this.mapWidth);
         rect.y = Math.floor(-this.origineY / this.mapHeight);
         rect.width = Math.floor(this._mapBitmapContainer.width / this.mapWidth);
         rect.height = Math.floor(this._mapBitmapContainer.height / this.mapHeight);
         return rect;
      }
      
      public function get mapPixelPosition() : Point
      {
         return new Point(this._mapContainer.x,this._mapContainer.y);
      }
      
      public function get zoomFactor() : Number
      {
         return this._mapContainer.scaleX;
      }
      
      public function finalize() : void
      {
         var chunckUri:Uri = null;
         var c:ICache = null;
         destroy(this._mapBitmapContainer);
         destroy(this._mapContainer);
         destroy(this._layersContainer);
         this._mapBitmapContainer = new Sprite();
         this._mapContainer = new Sprite();
         this._grid = new Shape();
         this._layersContainer = new Sprite();
         this._elementsGraphicRef = new Dictionary();
         this._layers = [];
         this._mapElements = [];
         var chunckTotalCount:uint = this._horizontalChunck * this._verticalChunck;
         var chunckList:Array = new Array();
         for(var i:uint = 1; i <= chunckTotalCount; i++)
         {
            chunckUri = new Uri(this._folderUri.uri + "/" + i + ".jpg");
            chunckUri.tag = i;
            chunckList.push(chunckUri);
         }
         if(Boolean(chunckList.length) && Boolean(this._folderUri))
         {
            c = UriCacheFactory.getCacheFromUri(this._folderUri);
            this._loader.load(chunckList,c);
         }
         this._finalized = true;
         this.initMap();
         getUi().iAmFinalized(this);
      }
      
      public function addLayer(name:String) : void
      {
         var s:Sprite = null;
         if(!this._layers[name])
         {
            s = new Sprite();
            s.name = "layer_" + name;
            s.mouseEnabled = false;
            this._layers[name] = s;
         }
         this._layersContainer.addChild(this._layers[name]);
      }
      
      public function addIcon(layer:String, id:String, uri:*, x:int, y:int, scale:Number = 1, legend:String = null) : MapIconElement
      {
         var t:Texture = null;
         var mie:MapIconElement = null;
         if(uri is String)
         {
            uri = new Uri(uri);
         }
         if(this._layers[layer])
         {
            t = new Texture();
            t.uri = uri;
            t.mouseChildren = false;
            t.cacheAsBitmap = true;
            t.scaleX = scale;
            t.scaleY = scale;
            t.finalize();
            mie = new MapIconElement(id,x,y,layer,t,legend);
            this._mapElements.push(mie);
            this._elementsGraphicRef[t] = mie;
            return mie;
         }
         return null;
      }
      
      public function addAreaShape(layer:String, id:String, coordList:Vector.<int>, lineColor:uint = 0, lineAlpha:Number = 1, fillColor:uint = 0, fillAlpha:Number = 0.4, thickness:int = 4) : MapAreaShape
      {
         var oldAreaShape:MapAreaShape = null;
         var shapeZone:Texture = null;
         var graphic:Graphics = null;
         var nCoords:int = 0;
         var i:int = 0;
         var mapAreaShape:MapAreaShape = null;
         var posX:int = 0;
         var posY:int = 0;
         if(Boolean(this._layers[layer]) && Boolean(coordList))
         {
            oldAreaShape = MapAreaShape(MapElement.getElementById(id));
            if(oldAreaShape)
            {
               if(oldAreaShape.lineColor == lineColor && oldAreaShape.fillColor == fillColor)
               {
                  return oldAreaShape;
               }
               oldAreaShape.remove();
               this._mapElements.splice(this._mapElements.indexOf(oldAreaShape),1);
            }
            shapeZone = new Texture();
            shapeZone.mouseEnabled = false;
            shapeZone.mouseChildren = false;
            graphic = shapeZone.graphics;
            graphic.lineStyle(thickness,lineColor,lineAlpha,true);
            graphic.beginFill(fillColor,fillAlpha);
            nCoords = coordList.length;
            for(i = 0; i < nCoords; i = i + 2)
            {
               posX = coordList[i];
               posY = coordList[i + 1];
               if(posX > 10000)
               {
                  graphic.moveTo((posX - 11000) * this.mapWidth,(posY - 11000) * this.mapHeight);
               }
               else
               {
                  graphic.lineTo(posX * this.mapWidth,posY * this.mapHeight);
               }
            }
            mapAreaShape = new MapAreaShape(id,layer,shapeZone,this.origineX,this.origineY,lineColor,fillColor);
            this._mapElements.push(mapAreaShape);
            return mapAreaShape;
         }
         return null;
      }
      
      public function areaShapeColorTransform(me:MapAreaShape, duration:int, rM:Number = 1, gM:Number = 1, bM:Number = 1, aM:Number = 1, rO:Number = 0, gO:Number = 0, bO:Number = 0, aO:Number = 0) : void
      {
         me.colorTransform(duration,rM,gM,bM,aM,rO,gO,bO,aO);
      }
      
      public function getMapElement(id:String) : MapElement
      {
         return MapElement.getElementById(id);
      }
      
      public function getMapElementsByLayer(layerId:String) : Array
      {
         var mapElement:MapElement = null;
         var nbElements:int = this._mapElements.length;
         var elements:Array = new Array();
         for(var i:int = 0; i < nbElements; i++)
         {
            mapElement = this._mapElements[i];
            if(mapElement.layer == layerId)
            {
               elements.push(mapElement);
            }
         }
         return elements;
      }
      
      public function removeMapElement(me:MapElement) : void
      {
         var element:MapElement = null;
         if(!me)
         {
            return;
         }
         var index:int = this._mapElements.indexOf(me);
         if(index != -1)
         {
            element = this._mapElements[index];
            element.remove();
            this._mapElements.splice(index,1);
         }
      }
      
      public function updateMapElements() : void
      {
         var elem:MapElement = null;
         var elems:Array = null;
         var iconNum:uint = 0;
         var group:MapGroupElement = null;
         var icon:MapIconElement = null;
         var mapAreaShape:MapAreaShape = null;
         var visibleIconCount:uint = 0;
         var iconIndex:uint = 0;
         this.clearLayer();
         var sortedMapElements:Array = new Array();
         for each(elem in this._mapElements)
         {
            if(!sortedMapElements[elem.x + "_" + elem.y])
            {
               sortedMapElements[elem.x + "_" + elem.y] = new Array();
            }
            sortedMapElements[elem.x + "_" + elem.y].push(elem);
         }
         for each(elems in sortedMapElements)
         {
            iconNum = 0;
            group = null;
            for each(elem in elems)
            {
               switch(true)
               {
                  case elem is MapIconElement:
                     icon = elem as MapIconElement;
                     icon.restricted_namespace::_texture.x = icon.x * this.mapWidth + this.origineX + this.mapWidth / 2;
                     icon.restricted_namespace::_texture.y = icon.y * this.mapHeight + this.origineY + this.mapHeight / 2;
                     if(elems.length != 1)
                     {
                        if(!group)
                        {
                           group = new MapGroupElement(icon.restricted_namespace::_texture.width * 1.5,icon.restricted_namespace::_texture.height * 1.5);
                           group.x = icon.x * this.mapWidth + this.origineX + this.mapWidth / 2;
                           group.y = icon.y * this.mapHeight + this.origineY + this.mapHeight / 2;
                           this._layers[elem.layer].addChild(group);
                        }
                        visibleIconCount = elems.length;
                        if(visibleIconCount > 2)
                        {
                           visibleIconCount = 2;
                        }
                        iconIndex = Math.min(visibleIconCount,iconNum);
                        icon.restricted_namespace::_texture.x = 4 * iconIndex - visibleIconCount * 4 / 2;
                        icon.restricted_namespace::_texture.y = 4 * iconIndex - visibleIconCount * 4 / 2;
                        group.addChild(icon.restricted_namespace::_texture);
                     }
                     else
                     {
                        this._layers[elem.layer].addChild(icon.restricted_namespace::_texture);
                     }
                     break;
                  case elem is MapAreaShape:
                     mapAreaShape = elem as MapAreaShape;
                     this._layers[elem.layer].addChild(mapAreaShape.shape);
                     mapAreaShape.shape.x = mapAreaShape.x;
                     mapAreaShape.shape.y = mapAreaShape.y;
               }
               iconNum++;
            }
         }
      }
      
      public function showLayer(name:String, display:Boolean = true) : void
      {
         if(this._layers[name])
         {
            this._layers[name].visible = display;
         }
      }
      
      public function moveToPixel(x:int, y:int, zoomFactor:Number) : void
      {
         this._mapContainer.x = x;
         this._mapContainer.y = y;
         this._mapContainer.scaleX = zoomFactor;
         this._mapContainer.scaleY = zoomFactor;
      }
      
      public function moveTo(x:int, y:int, width:uint = 1, height:uint = 1, center:Boolean = true, autoZoom:Boolean = true) : void
      {
         var zoneWidth:int = 0;
         var zoneHeight:int = 0;
         var newX:int = 0;
         var newY:int = 0;
         var viewRect:Rectangle = this.mapBounds;
         if(viewRect.left > x)
         {
            x = viewRect.left;
         }
         if(viewRect.top > y)
         {
            y = viewRect.top;
         }
         if(center)
         {
            zoneWidth = width * this.mapWidth * this._mapContainer.scaleX;
            if(zoneWidth > this.width && Boolean(autoZoom))
            {
               this._mapContainer.scaleX = this.width / (this.mapWidth * width);
               this._mapContainer.scaleY = this._mapContainer.scaleX;
            }
            zoneHeight = height * this.mapHeight * this._mapContainer.scaleY;
            if(zoneHeight > this.height && Boolean(autoZoom))
            {
               this._mapContainer.scaleY = this.height / (this.mapHeight * height);
               this._mapContainer.scaleX = this._mapContainer.scaleY;
            }
            newX = -(x * this.mapWidth + this.origineX) * this._mapContainer.scaleX;
            newY = -(y * this.mapHeight + this.origineY) * this._mapContainer.scaleY;
            this._mapContainer.x = newX + (this.width - width * this.mapWidth * this._mapContainer.scaleX) / 2;
            this._mapContainer.y = newY + (this.height - height * this.mapHeight * this._mapContainer.scaleY) / 2;
         }
         else
         {
            this._mapContainer.x = -(x * this.mapWidth + this.origineX) * this._mapContainer.scaleX;
            this._mapContainer.y = -(y * this.mapHeight + this.origineY) * this._mapContainer.scaleY;
         }
         if(this._mapContainer.x < width - this._mapBitmapContainer.width)
         {
            this._mapContainer.x = width - this._mapBitmapContainer.width;
         }
         if(this._mapContainer.y < height - this._mapBitmapContainer.height)
         {
            this._mapContainer.y = height - this._mapBitmapContainer.height;
         }
         if(this._mapContainer.x > 0)
         {
            this._mapContainer.x = 0;
         }
         if(this._mapContainer.y > 0)
         {
            this._mapContainer.y = 0;
         }
         Berilia.getInstance().handler.process(new MapMoveMessage(this));
      }
      
      public function zoom(scale:Number, coord:Point = null) : void
      {
         var r:Rectangle = null;
         var p:Point = null;
         if(scale > this.maxScale)
         {
            scale = this.maxScale;
         }
         if(scale < this.minScale)
         {
            scale = this.minScale;
         }
         if(coord)
         {
            this._mapContainer.x = this._mapContainer.x - (coord.x * scale - coord.x * this._mapContainer.scaleX);
            this._mapContainer.y = this._mapContainer.y - (coord.y * scale - coord.y * this._mapContainer.scaleY);
            this._mapContainer.scaleX = this._mapContainer.scaleY = scale;
            if(this._mapContainer.x < width - this._mapBitmapContainer.width * scale)
            {
               this._mapContainer.x = width - this._mapBitmapContainer.width * scale;
            }
            if(this._mapContainer.y < height - this._mapBitmapContainer.height * scale)
            {
               this._mapContainer.y = height - this._mapBitmapContainer.height * scale;
            }
            if(this._mapContainer.x > 0)
            {
               this._mapContainer.x = 0;
            }
            if(this._mapContainer.y > 0)
            {
               this._mapContainer.y = 0;
            }
         }
         else
         {
            r = this.visibleMaps;
            p = new Point((r.x + r.width / 2) * this.mapWidth + this.origineX,(r.y + r.height / 2) * this.mapHeight + this.origineY);
            this.zoom(scale,p);
         }
      }
      
      override public function remove() : void
      {
         var me:MapElement = null;
         var k:* = null;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onMapChunckLoaded);
         this._loader.removeEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllMapChunckLoaded);
         if(this._grid)
         {
            this._grid.cacheAsBitmap = false;
            if(this._mapContainer.contains(this._grid))
            {
               this._mapContainer.removeChild(this._grid);
            }
         }
         for each(me in MapElement._elementRef)
         {
            me.remove();
         }
         for(k in this._elementsGraphicRef)
         {
            delete this._elementsGraphicRef[k];
         }
         this._mapElements = null;
         this._elementsGraphicRef = null;
         MapElement._elementRef = new Dictionary(true);
         super.remove();
      }
      
      private function initMap() : void
      {
         this._mapContainer = new Sprite();
         var maskCtr:Sprite = new Sprite();
         maskCtr.graphics.beginFill(7798784,0);
         if(!this.roundCornerRadius)
         {
            maskCtr.graphics.drawRect(0,0,width,height);
         }
         else
         {
            maskCtr.graphics.drawRoundRectComplex(0,0,width,height,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius);
         }
         addChild(maskCtr);
         this._mapContainer.mask = maskCtr;
         this._mapContainer.addChild(this._mapBitmapContainer);
         this._grid = new Shape();
         this.drawGrid();
         this._mapContainer.addChild(this._grid);
         this._layersContainer = new Sprite();
         this._mapContainer.addChild(this._layersContainer);
         this._layersContainer.mouseEnabled = false;
         this.zoom(this.startScale);
         addChild(this._mapContainer);
         this._mapElements = new Array();
         this._layers = new Array();
         this._elementsGraphicRef = new Dictionary(true);
      }
      
      private function drawGrid() : void
      {
         var i:uint = 0;
         var verticalLineCount:uint = 0;
         var horizontalLineCount:uint = 0;
         var offsetX:int = this.origineX % this.mapWidth;
         var offsetY:int = this.origineY % this.mapHeight;
         if(!this._showGrid)
         {
            this._grid.graphics.clear();
         }
         else
         {
            this._grid.cacheAsBitmap = false;
            this._grid.graphics.lineStyle(1,7829367,0.5);
            verticalLineCount = this._mapBitmapContainer.width / this.mapWidth;
            for(i = 0; i < verticalLineCount; i++)
            {
               this._grid.graphics.moveTo(i * this.mapWidth + offsetX,0);
               this._grid.graphics.lineTo(i * this.mapWidth + offsetX,this._mapBitmapContainer.height);
            }
            horizontalLineCount = this._mapBitmapContainer.height / this.mapHeight;
            for(i = 0; i < horizontalLineCount; i++)
            {
               this._grid.graphics.moveTo(0,i * this.mapHeight + offsetY);
               this._grid.graphics.lineTo(this._mapBitmapContainer.width,i * this.mapHeight + offsetY);
            }
            this._grid.cacheAsBitmap = true;
         }
      }
      
      private function getXYFromMapChunckNum(num:uint) : Point
      {
         var res:Point = new Point();
         res.y = Math.floor((num - 1) / this._horizontalChunck);
         res.x = num - res.y * this._horizontalChunck - 1;
         return res;
      }
      
      private function clearLayer(target:DisplayObjectContainer = null) : void
      {
         var child:DisplayObject = null;
         var l:DisplayObjectContainer = null;
         for each(l in this._layers)
         {
            if(!target || target == l)
            {
               while(l.numChildren)
               {
                  child = l.removeChildAt(0);
                  if(child is MapGroupElement)
                  {
                     MapGroupElement(child).remove();
                  }
               }
               continue;
            }
         }
      }
      
      override public function process(msg:Message) : Boolean
      {
         var movmsg:MouseOverMessage = null;
         var moumsg:MouseOutMessage = null;
         var mwmsg:MouseWheelMessage = null;
         var newScale:Number = NaN;
         var zoomPoint:Point = null;
         switch(true)
         {
            case msg is MouseOverMessage:
               movmsg = msg as MouseOverMessage;
               if(movmsg.target == this || movmsg.target.parent == this || movmsg.target.parent.parent == this)
               {
                  if(!EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                  {
                     EnterFrameDispatcher.addEventListener(this.onMapEnterFrame,"mapMouse");
                  }
                  return true;
               }
               if(movmsg.target is MapGroupElement || movmsg.target.parent is MapGroupElement && this._openedMapGroupElement != movmsg.target.parent)
               {
                  if(movmsg.target is MapGroupElement)
                  {
                     this._openedMapGroupElement = MapGroupElement(movmsg.target);
                  }
                  else
                  {
                     this._openedMapGroupElement = MapGroupElement(movmsg.target.parent);
                  }
                  if(!this._openedMapGroupElement.opened)
                  {
                     this._openedMapGroupElement.parent.addChild(this._openedMapGroupElement);
                     this._openedMapGroupElement.open();
                  }
               }
               else if(this._elementsGraphicRef[movmsg.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsGraphicRef[movmsg.target]));
               }
               break;
            case msg is MouseOutMessage:
               moumsg = msg as MouseOutMessage;
               if(moumsg.target == this || moumsg.target.parent == this || moumsg.target.parent.parent == this)
               {
                  if(!EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                  {
                     EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
                  }
                  return true;
               }
               if(Boolean(moumsg.mouseEvent.relatedObject && moumsg.mouseEvent.relatedObject.parent != this._openedMapGroupElement) && Boolean(moumsg.mouseEvent.relatedObject != this._openedMapGroupElement) && Boolean(this._openedMapGroupElement))
               {
                  this._openedMapGroupElement.close();
                  this._openedMapGroupElement = null;
               }
               if(this._elementsGraphicRef[moumsg.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsGraphicRef[moumsg.target]));
               }
               break;
            case msg is MouseDownMessage:
               if(!this.enabledDrag)
               {
                  return true;
               }
               this._mapContainer.startDrag(false,new Rectangle(width - this._mapBitmapContainer.width * this._mapContainer.scaleX,height - this._mapBitmapContainer.height * this._mapContainer.scaleY,this._mapBitmapContainer.width * this._mapContainer.scaleX - width,this._mapBitmapContainer.height * this._mapContainer.scaleY - height));
               return true;
            case msg is MouseReleaseOutsideMessage:
            case msg is MouseUpMessage:
               this._mapContainer.stopDrag();
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               return true;
            case msg is MouseWheelMessage:
               mwmsg = msg as MouseWheelMessage;
               newScale = this._mapContainer.scaleX + mwmsg.mouseEvent.delta * 0.2 / Math.abs(mwmsg.mouseEvent.delta);
               zoomPoint = new Point(mwmsg.mouseEvent.localX,mwmsg.mouseEvent.localY);
               switch(true)
               {
                  case mwmsg.mouseEvent.target.parent is MapGroupElement:
                     zoomPoint.x = mwmsg.mouseEvent.target.parent.x;
                     zoomPoint.y = mwmsg.mouseEvent.target.parent.y;
                     break;
                  case mwmsg.mouseEvent.target is MapGroupElement:
                  case mwmsg.mouseEvent.target is Texture:
                     zoomPoint.x = mwmsg.mouseEvent.target.x;
                     zoomPoint.y = mwmsg.mouseEvent.target.y;
               }
               this.zoom(newScale,zoomPoint);
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               return true;
         }
         return false;
      }
      
      private function onMapChunckLoaded(e:ResourceLoadedEvent) : void
      {
         var chunck:BitmapData = e.resource;
         this._chunkBuffer.push({
            "chunkID":e.uri.tag,
            "bitmapData":e.resource
         });
         var p:Point = this.getXYFromMapChunckNum(e.uri.tag);
         var bitMap:Bitmap = new Bitmap(chunck);
         bitMap.x = p.x * chunck.width;
         bitMap.y = p.y * chunck.height;
         this._mapBitmapContainer.addChild(bitMap);
         if(this._chunkBuffer.length == 1)
         {
            EnterFrameDispatcher.addEventListener(this.onEnterFrameSmoothInit,"mapViwer");
         }
      }
      
      private function onEnterFrameSmoothInit(e:Event) : void
      {
         var item:Object = null;
         var chunck:BitmapData = null;
         var p:Point = null;
         var bitMap:Bitmap = null;
         if(this._chunkBuffer.length)
         {
            item = this._chunkBuffer.shift();
            chunck = item.bitmapData;
            p = this.getXYFromMapChunckNum(item.chunkID);
            bitMap = new Bitmap(chunck);
            bitMap.x = p.x * chunck.width;
            bitMap.y = p.y * chunck.height;
            this._mapBitmapContainer.addChild(bitMap);
         }
         else
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterFrameSmoothInit);
         }
      }
      
      private function onAllMapChunckLoaded(e:ResourceEvent) : void
      {
         if(!EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
         {
            EnterFrameDispatcher.addEventListener(this.onMapEnterFrame,"mapMouse");
         }
         Berilia.getInstance().handler.process(new ComponentReadyMessage(this));
      }
      
      private function onMapEnterFrame(e:Event) : void
      {
         var mx:int = Math.floor((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth);
         var my:int = Math.floor((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight);
         if(!this._openedMapGroupElement && (mx != this._lastMx || my != this._lastMy))
         {
            this._lastMx = mx;
            this._lastMy = my;
            Berilia.getInstance().handler.process(new MapRollOverMessage(this,mx,my));
         }
      }
   }
}
