package com.ankamagames.atouin.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.atouin.renderers.MapRenderer;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.messages.MapsLoadingStartedMessage;
   import flash.utils.getTimer;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.atouin.utils.map.getMapUriFromId;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Rectangle;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.InteractiveObject;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.types.events.RenderMapEvent;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.atouin.resources.adapters.MapsAdapter;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.messages.MapLoadingMessage;
   import flash.events.Event;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class MapDisplayManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.managers.MapDisplayManager));
      
      private static var _self:com.ankamagames.atouin.managers.MapDisplayManager;
       
      private var _currentMap:WorldPoint;
      
      private var _lastMap:WorldPoint;
      
      private var _loader:IResourceLoader;
      
      private var _currentDataMap:DataMapContainer;
      
      private var _mapFileCache:ICache;
      
      private var _renderer:MapRenderer;
      
      private var _screenshot:Bitmap;
      
      private var _screenshotData:BitmapData;
      
      private var _nMapLoadStart:uint;
      
      private var _nMapLoadEnd:uint;
      
      private var _nGfxLoadStart:uint;
      
      private var _nGfxLoadEnd:uint;
      
      private var _nRenderMapStart:uint;
      
      private var _nRenderMapEnd:uint;
      
      public function MapDisplayManager()
      {
         this._mapFileCache = new Cache(20,new LruGarbageCollector());
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.init();
      }
      
      public static function getInstance() : com.ankamagames.atouin.managers.MapDisplayManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.managers.MapDisplayManager();
         }
         return _self;
      }
      
      public function display(pMap:WorldPoint) : void
      {
         var msg:MapsLoadingCompleteMessage = null;
         _log.debug("Ask render map " + pMap.mapId);
         Atouin.getInstance().showWorld(true);
         this._renderer.initRenderContainer(Atouin.getInstance().worldContainer);
         if(Boolean(this._currentMap) && Boolean(this._currentMap.mapId == pMap.mapId) && !Atouin.getInstance().options.reloadLoadedMap)
         {
            msg = new MapsLoadingCompleteMessage(this._currentMap,com.ankamagames.atouin.managers.MapDisplayManager.getInstance().getDataMapContainer().dataMap);
            Atouin.getInstance().handler.process(msg);
            return;
         }
         this._lastMap = this._currentMap;
         this._currentMap = pMap;
         var msg2:MapsLoadingStartedMessage = new MapsLoadingStartedMessage();
         Atouin.getInstance().handler.process(msg2);
         this._nMapLoadStart = getTimer();
         this._loader.cancel();
         this._loader.load(new Uri(getMapUriFromId(pMap.mapId)),null);
      }
      
      public function get currentMapPoint() : WorldPoint
      {
         return this._currentMap;
      }
      
      public function getDataMapContainer() : DataMapContainer
      {
         return this._currentDataMap;
      }
      
      public function activeIdentifiedElements(active:Boolean) : void
      {
         var ie:Object = null;
         var identifiedElements:Dictionary = this._renderer.identifiedElements;
         for each(ie in identifiedElements)
         {
            ie.sprite.mouseEnabled = active;
         }
      }
      
      public function setDataMapContainer(wp:WorldPoint, data:DataMapContainer) : void
      {
      }
      
      public function unloadMap() : void
      {
         this._renderer.unload();
      }
      
      public function capture() : void
      {
         if(Atouin.getInstance().options.tweentInterMap)
         {
            if(!this._screenshotData)
            {
               this._screenshotData = new BitmapData(StageShareManager.startWidth,StageShareManager.startHeight,true,0);
               this._screenshot = new Bitmap(this._screenshotData);
               this._screenshot.smoothing = true;
            }
            this._screenshotData.fillRect(new Rectangle(0,0,this._screenshotData.width,this._screenshotData.height),4278190080);
            this._screenshotData.draw(Atouin.getInstance().rootContainer);
            this._screenshot.alpha = 1;
            Atouin.getInstance().rootContainer.addChild(this._screenshot);
         }
      }
      
      public function getIdentifiedEntityElement(id:uint) : TiphonSprite
      {
         if(Boolean(this._renderer) && Boolean(this._renderer.identifiedElements) && Boolean(this._renderer.identifiedElements[id]))
         {
            if(this._renderer.identifiedElements[id].sprite is TiphonSprite)
            {
               return this._renderer.identifiedElements[id].sprite as TiphonSprite;
            }
         }
         return null;
      }
      
      public function getIdentifiedElement(id:uint) : InteractiveObject
      {
         if(Boolean(this._renderer) && Boolean(this._renderer.identifiedElements) && Boolean(this._renderer.identifiedElements[id]))
         {
            return this._renderer.identifiedElements[id].sprite;
         }
         return null;
      }
      
      public function getIdentifiedElementPosition(id:uint) : MapPoint
      {
         if(Boolean(this._renderer) && Boolean(this._renderer.identifiedElements) && Boolean(this._renderer.identifiedElements[id]))
         {
            return this._renderer.identifiedElements[id].position;
         }
         return null;
      }
      
      public function reset() : void
      {
         this.unloadMap();
         this._currentMap = null;
      }
      
      private function init() : void
      {
         this._renderer = new MapRenderer(Atouin.getInstance().worldContainer,Elements.getInstance());
         this._renderer.addEventListener(RenderMapEvent.GFX_LOADING_START,this.logGfxLoadTime,false,0,true);
         this._renderer.addEventListener(RenderMapEvent.GFX_LOADING_END,this.logGfxLoadTime,false,0,true);
         this._renderer.addEventListener(RenderMapEvent.MAP_RENDER_START,this.mapRendered,false,0,true);
         this._renderer.addEventListener(RenderMapEvent.MAP_RENDER_END,this.mapRendered,false,0,true);
         AdapterFactory.addAdapter("dlm",MapsAdapter);
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onMapLoaded,false,0,true);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onMapFailed,false,0,true);
      }
      
      private function mapDisplayed() : void
      {
         InteractiveCellManager.getInstance().updateInteractiveCell(this._currentDataMap);
         var msg:MapsLoadingCompleteMessage = new MapsLoadingCompleteMessage(this._currentMap,com.ankamagames.atouin.managers.MapDisplayManager.getInstance().getDataMapContainer().dataMap);
         Atouin.getInstance().handler.process(msg);
      }
      
      private function onMapLoaded(e:ResourceLoadedEvent) : void
      {
         this._nMapLoadEnd = getTimer();
         var mapClass:Class = Map;
         var b:* = e.resource is Map;
         var map:Map = e.resource as Map;
         this.unloadMap();
         this._currentDataMap = new DataMapContainer(map);
         this._renderer.render(this._currentDataMap);
      }
      
      private function onMapFailed(e:ResourceErrorEvent) : void
      {
         _log.error("Impossible de charger la map " + e.uri);
         var msg:MapLoadingMessage = new MapLoadingMessage();
         Atouin.getInstance().handler.process(msg);
      }
      
      private function logGfxLoadTime(e:Event) : void
      {
         if(e.type == RenderMapEvent.GFX_LOADING_START)
         {
            this._nGfxLoadStart = getTimer();
         }
         if(e.type == RenderMapEvent.GFX_LOADING_END)
         {
            this._nGfxLoadEnd = getTimer();
         }
      }
      
      private function tweenInterMap(e:Event) : void
      {
         this._screenshot.alpha = this._screenshot.alpha - this._screenshot.alpha / 3;
         if(this._screenshot.alpha < 0.01)
         {
            Atouin.getInstance().worldContainer.cacheAsBitmap = false;
            Atouin.getInstance().rootContainer.removeChild(this._screenshot);
            EnterFrameDispatcher.removeEventListener(this.tweenInterMap);
         }
      }
      
      private function mapRendered(e:RenderMapEvent) : void
      {
         var tt:uint = 0;
         var tml:uint = 0;
         var tgl:int = 0;
         var msg:MapLoadingMessage = null;
         if(e.type == RenderMapEvent.MAP_RENDER_START)
         {
            this._nRenderMapStart = getTimer();
         }
         if(e.type == RenderMapEvent.MAP_RENDER_END)
         {
            this.mapDisplayed();
            this._nRenderMapEnd = getTimer();
            tt = this._nRenderMapEnd - this._nMapLoadStart;
            tml = this._nMapLoadEnd - this._nMapLoadStart;
            tgl = this._nGfxLoadEnd - this._nGfxLoadStart;
            _log.info("map rendered [total : " + tt + "ms, " + (tt < 100?" " + (tt < 10?" ":""):"") + "map load : " + tml + "ms, " + (tml < 100?" " + (tml < 10?" ":""):"") + "gfx load : " + tgl + "ms, " + (tgl < 100?" " + (tgl < 10?" ":""):"") + "render : " + (this._nRenderMapEnd - this._nRenderMapStart) + "ms] file : " + (!!this._currentMap?this._currentMap.mapId:"???") + ".dlm");
            if(Boolean(this._screenshot) && Boolean(this._screenshot.parent))
            {
               Atouin.getInstance().worldContainer.cacheAsBitmap = true;
               EnterFrameDispatcher.addEventListener(this.tweenInterMap,"tweentInterMap");
            }
            msg = new MapLoadingMessage();
            Atouin.getInstance().handler.process(msg);
         }
      }
   }
}
