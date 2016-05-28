package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.display.BitmapData;
   import com.ankamagames.berilia.types.data.MapIconElement;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import flash.geom.Matrix;
   import com.ankamagames.jerakine.resources.events.ResourceEvent;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   
   public class MiniMapViewer extends GraphicContainer implements FinalizableUIComponent
   {
       
      private var _finalized:Boolean;
      
      private var _folderUri:Uri;
      
      private var _loader:IResourceLoader;
      
      private var _mapBitmapContainer:Sprite;
      
      private var _chunksToLoad:Array;
      
      private var _mask:Sprite;
      
      private var _mapBitmap:Bitmap;
      
      private var _squareShape:Shape;
      
      private var _zoom:Number = 0.5;
      
      private var _currentPosition:Point;
      
      private var _visibleZone:Rectangle;
      
      private var _iconsLayer:Sprite;
      
      private var _flagsLayer:Sprite;
      
      private var _arrowLayer:Sprite;
      
      private var _masked:Sprite;
      
      private var _elementsGraphicRef:Dictionary;
      
      private var _mapElements:Array;
      
      private var _flags:Array;
      
      public function MiniMapViewer()
      {
         super();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onMapChunckLoaded);
         this._loader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllMapChunckLoaded);
      }
      
      public function finalize() : void
      {
         this._masked = new Sprite();
         addChild(this._masked);
         this._currentPosition = new Point();
         this._mapBitmapContainer = new Sprite();
         this._masked.addChild(this._mapBitmapContainer);
         this._mapBitmap = new Bitmap(new BitmapData(width,height));
         this._mapBitmapContainer.addChild(this._mapBitmap);
         this._mask = new Sprite();
         this._mask.graphics.beginFill(0);
         this._mask.graphics.drawCircle(width * 0.25,width * 0.25,width * 0.25);
         this._masked.addChild(this._mask);
         this._masked.mask = this._mask;
         this._squareShape = new Shape();
         this._squareShape.graphics.beginFill(0,0);
         this._squareShape.graphics.lineStyle(1,16711680);
         this._squareShape.graphics.drawRect(62 - 42 * this._zoom * 0.5,height * 0.25 - 30 * this._zoom * 0.5,42 * this._zoom,30 * this._zoom);
         this._masked.addChild(this._squareShape);
         this._iconsLayer = new Sprite();
         this._masked.addChild(this._iconsLayer);
         this._flagsLayer = new Sprite();
         this._masked.addChild(this._flagsLayer);
         this._arrowLayer = new Sprite();
         addChild(this._arrowLayer);
         this._visibleZone = this.getVisibleZone();
         this._finalized = true;
         getUi().iAmFinalized(this);
      }
      
      public function update(playerPosition:Object, worldMapInfo:Object) : void
      {
         var id:int = 0;
         while(this._iconsLayer.numChildren)
         {
            this._iconsLayer.removeChildAt(0);
         }
         this._mapElements = new Array();
         this._elementsGraphicRef = new Dictionary(true);
         var worldId:int = worldMapInfo.id;
         var zoom:Number = 42 / worldMapInfo.mapWidth;
         var chunkWidth:int = 378;
         var chunkHeight:int = 390;
         var offsetX:int = worldMapInfo.origineX % worldMapInfo.mapWidth * zoom;
         var offsetY:int = worldMapInfo.origineY % worldMapInfo.mapHeight * zoom;
         var origineX:int = worldMapInfo.origineX * zoom;
         var origineY:int = worldMapInfo.origineY * zoom;
         this._currentPosition.x = playerPosition.x;
         this._currentPosition.y = playerPosition.y;
         var mapWidth:int = worldMapInfo.totalWidth * zoom;
         var mapHeight:int = worldMapInfo.totalHeight * zoom;
         var mapNumChunks:int = Math.ceil(mapWidth / 378) * Math.ceil(mapHeight / 390);
         var origineOffsetX:int = (origineX + playerPosition.x * 42) % chunkWidth;
         var origineOffsetY:int = (origineY + playerPosition.y * 30) % chunkHeight;
         var chunkId:int = Math.ceil((origineX - offsetX + (playerPosition.x + 1) * 42) / chunkWidth) + (Math.ceil((origineY - offsetY + playerPosition.y * 30) / chunkHeight) - 1) * Math.ceil(mapWidth / chunkWidth);
         this._mapBitmap.bitmapData.lock();
         this._chunksToLoad = new Array();
         if(chunkId > 0 && chunkId <= mapNumChunks)
         {
            this.addChunk(chunkId,worldId,origineOffsetX,origineOffsetY);
         }
         if(origineOffsetX > 168 && chunkId < mapNumChunks)
         {
            this.addChunk(chunkId + 1,worldId,origineOffsetX - 378,origineOffsetY);
         }
         else if(chunkId > 1)
         {
            this.addChunk(chunkId - 1,worldId,origineOffsetX + 378,origineOffsetY);
         }
         if(origineOffsetY > 180)
         {
            id = chunkId + Math.ceil(mapWidth / 378);
            if(id < mapNumChunks)
            {
               this.addChunk(id,worldId,origineOffsetX,origineOffsetY - 390);
               if(origineOffsetX > 168 && id + 1 < mapNumChunks)
               {
                  this.addChunk(id + 1,worldId,origineOffsetX - 378,origineOffsetY - 390);
               }
               else if(id - 1 > 0)
               {
                  this.addChunk(id - 1,worldId,origineOffsetX + 378,origineOffsetY - 390);
               }
            }
         }
         else
         {
            id = chunkId - Math.ceil(mapWidth / 378);
            if(id > 0)
            {
               this.addChunk(id,worldId,origineOffsetX,origineOffsetY + 390);
               if(origineOffsetX > 168 && id + 1 < mapNumChunks)
               {
                  this.addChunk(id + 1,worldId,origineOffsetX - 378,origineOffsetY + 390);
               }
               else if(id - 1 > 0)
               {
                  this.addChunk(id - 1,worldId,origineOffsetX + 378,origineOffsetY + 390);
               }
            }
         }
         this._loader.load(this._chunksToLoad);
         this._visibleZone = this.getVisibleZone();
         this.updateFlags(this._flags);
      }
      
      public function addIcon(id:String, uri:String, x:int, y:int, legend:String = null) : void
      {
         this.internalAddIcon(id,uri,x,y,null,legend);
      }
      
      private function internalAddIcon(id:String, uri:String, x:int, y:int, layer:Sprite = null, legend:String = null) : void
      {
         if(layer == null)
         {
            layer = this._iconsLayer;
         }
         var u:Uri = new Uri(uri);
         var t:Texture = new Texture();
         t.uri = u;
         t.x = (x - this._visibleZone.x) * 42 * this._zoom;
         t.y = (y - this._visibleZone.y) * 30 * this._zoom + 30 * this._zoom * 0.25;
         t.mouseChildren = false;
         t.cacheAsBitmap = true;
         t.scale = this._zoom;
         t.finalize();
         var mie:MapIconElement = new MapIconElement(id,x,y,"",t,legend);
         this._mapElements.push(mie);
         this._elementsGraphicRef[t] = mie;
         layer.addChild(t);
      }
      
      public function updateFlags(flags:Array) : void
      {
         var flag:Object = null;
         var r:Rectangle = null;
         this._flags = flags;
         while(this._flagsLayer.numChildren)
         {
            this._flagsLayer.removeChildAt(0);
         }
         while(this._arrowLayer.numChildren)
         {
            this._arrowLayer.removeChildAt(0);
         }
         var i:int = 0;
         for each(flag in this._flags)
         {
            r = new Rectangle(this._visibleZone.x + 1,this._visibleZone.y + 1,this._visibleZone.width - 2,this._visibleZone.height - 2);
            if(r.contains(flag.position.x,flag.position.y))
            {
               this.internalAddIcon("flag_" + i,"file://content/gfx/icons/assets.swf|flag1",flag.position.x,flag.position.y,this._flagsLayer);
            }
            if(flag.position.x != this._currentPosition.x || flag.position.y != this._currentPosition.y)
            {
               this.addArrow(flag.position.x,flag.position.y);
            }
            i++;
         }
      }
      
      private function addArrow(x:int, y:int) : void
      {
         var arrow:Texture = new Texture();
         arrow.uri = new Uri("file://content/gfx/icons/assets.swf|arrow0");
         arrow.finalize();
         var vr:Number = Math.atan2(-y + this._currentPosition.y,-x + this._currentPosition.x);
         var angle:Number = Math.atan2(0,-64);
         arrow.x = 64 + Math.cos(angle + vr) * 64;
         arrow.y = 64 + Math.sin(angle + vr) * 64;
         arrow.rotation = vr * (180 / Math.PI);
         if(arrow.rotation > -90 && arrow.rotation < 90)
         {
            arrow.scaleY = -1;
         }
         this._arrowLayer.addChild(arrow);
      }
      
      private function onMapChunckLoaded(e:ResourceLoadedEvent) : void
      {
         var chunkData:BitmapData = e.resource;
         var offsetPoint:Point = e.uri.tag;
         this._mapBitmap.bitmapData.fillRect(new Rectangle(100,100),255);
         this._mapBitmap.bitmapData.draw(chunkData,new Matrix(1,0,0,1,-offsetPoint.x + width * 0.25 + 42,-offsetPoint.y + width * 0.25 + 30 * 2));
      }
      
      public function getVisibleZone() : Rectangle
      {
         var mpw:Number = 42 * this._zoom;
         var mph:Number = 30 * this._zoom;
         var hMapsCount:int = Math.ceil(width * 0.5 / mpw);
         var vMapsCount:int = Math.ceil(height * 0.5 / mph);
         return new Rectangle(this._currentPosition.x - (hMapsCount - 1) * 0.5,this._currentPosition.y - (vMapsCount - 1) * 0.5,hMapsCount,vMapsCount);
      }
      
      private function addChunk(id:int, worldId:int, offsetX:Number, offsetY:Number) : void
      {
         var uri:Uri = new Uri(this._folderUri + "/" + worldId + "/" + id + ".jpg");
         uri.tag = new Point(offsetX,offsetY);
         this._chunksToLoad.push(uri);
      }
      
      private function onAllMapChunckLoaded(e:ResourceEvent) : void
      {
         this._mapBitmap.bitmapData.unlock();
         this._mapBitmapContainer.x = -width * 0.5 + 42 * 1.5 + width * (1 - this._zoom) * 0.5;
         this._mapBitmapContainer.y = -height * 0.5 + 30 * 2 + height * (1 - this._zoom) * 0.5;
         this._mapBitmapContainer.scaleX = this._mapBitmapContainer.scaleY = this._zoom;
      }
      
      override public function process(msg:Message) : Boolean
      {
         var movmsg:MouseOverMessage = null;
         var moumsg:MouseOutMessage = null;
         switch(true)
         {
            case msg is MouseOverMessage:
               movmsg = msg as MouseOverMessage;
               if(movmsg.target is Texture)
               {
                  if(this._elementsGraphicRef[movmsg.target] != null)
                  {
                     Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsGraphicRef[movmsg.target]));
                  }
               }
               return true;
            case msg is MouseOutMessage:
               moumsg = msg as MouseOutMessage;
               if(moumsg.target is Texture)
               {
                  if(this._elementsGraphicRef[moumsg.target] != null)
                  {
                     Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsGraphicRef[moumsg.target]));
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      public function getcurrentMouseMap() : Point
      {
         return new Point(this._currentPosition.x + Math.round((mouseX - 64) / (42 * this._zoom)),this._currentPosition.y + Math.round((mouseY - 64) / (30 * this._zoom)));
      }
      
      public function set folderUri(url:Uri) : void
      {
         this._folderUri = url;
      }
      
      public function get folderUri() : Uri
      {
         return this._folderUri;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
   }
}
