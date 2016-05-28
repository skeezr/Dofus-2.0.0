package com.ankamagames.atouin
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Shape;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.atouin.types.AtouinOptions;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import flash.display.InteractiveObject;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.interfaces.ISoundPositionListener;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.atouin.utils.errors.AtouinError;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.atouin.resources.adapters.ElementsAdapter;
   import com.ankamagames.atouin.resources.adapters.MapsAdapter;
   
   public class Atouin
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.Atouin));
      
      private static var _self:com.ankamagames.atouin.Atouin;
       
      private var _worldContainer:DisplayObjectContainer;
      
      private var _overlayContainer:Sprite;
      
      private var _spMapContainer:Sprite;
      
      private var _spGfxontainer:Sprite;
      
      private var _spChgMapContainer:Sprite;
      
      private var _worldMask:Shape;
      
      private var _movementListeners:Array;
      
      private var _handler:MessageHandler;
      
      private var _aSprites:Array;
      
      private var _aoOptions:AtouinOptions;
      
      public function Atouin()
      {
         super();
         if(_self)
         {
            throw new AtouinError("Atouin is a singleton class. Please acces it through getInstance()");
         }
         AdapterFactory.addAdapter("ele",ElementsAdapter);
         AdapterFactory.addAdapter("dlm",MapsAdapter);
      }
      
      public static function getInstance() : com.ankamagames.atouin.Atouin
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.Atouin();
         }
         return _self;
      }
      
      public function get movementListeners() : Array
      {
         return this._movementListeners;
      }
      
      public function get worldContainer() : DisplayObjectContainer
      {
         return this._spMapContainer;
      }
      
      public function get chgMapContainer() : DisplayObjectContainer
      {
         return this._spChgMapContainer;
      }
      
      public function get gfxContainer() : DisplayObjectContainer
      {
         return this._spGfxontainer;
      }
      
      public function get overlayContainer() : DisplayObjectContainer
      {
         return this._overlayContainer;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(value:MessageHandler) : void
      {
         this._handler = value;
      }
      
      public function get options() : AtouinOptions
      {
         return this._aoOptions;
      }
      
      public function get cellOverEnabled() : Boolean
      {
         return InteractiveCellManager.getInstance().cellOverEnabled;
      }
      
      public function set cellOverEnabled(value:Boolean) : void
      {
         InteractiveCellManager.getInstance().cellOverEnabled = value;
      }
      
      public function get rootContainer() : DisplayObjectContainer
      {
         return this._worldContainer;
      }
      
      public function get worldIsVisible() : Boolean
      {
         return this._worldContainer.contains(this._spMapContainer);
      }
      
      public function setDisplayOptions(ao:AtouinOptions) : void
      {
         this._aoOptions = ao;
         this._worldContainer = ao.container;
         this._handler = ao.handler;
         for(var i:uint = 0; i < this._worldContainer.numChildren; i++)
         {
            this._worldContainer.removeChildAt(i);
         }
         this._overlayContainer = new Sprite();
         this._spMapContainer = new Sprite();
         this._spChgMapContainer = new Sprite();
         this._spGfxontainer = new Sprite();
         this._worldContainer.mouseEnabled = false;
         this._spMapContainer.tabChildren = false;
         this._spMapContainer.mouseEnabled = false;
         this._spChgMapContainer.tabChildren = false;
         this._spChgMapContainer.mouseEnabled = false;
         this._spGfxontainer.tabChildren = false;
         this._spGfxontainer.mouseEnabled = false;
         this._spGfxontainer.mouseChildren = false;
         this._overlayContainer.tabChildren = false;
         this._overlayContainer.mouseEnabled = false;
         this._worldContainer.addChild(this._spMapContainer);
         this._worldContainer.addChild(this._spChgMapContainer);
         this._worldContainer.addChild(this._spGfxontainer);
         this._worldContainer.addChild(this._overlayContainer);
         FrustumManager.getInstance().init(this._spChgMapContainer);
         this._worldMask = new Shape();
         this._worldMask.graphics.beginFill(0);
         var w:int = StageShareManager.startWidth;
         var h:int = StageShareManager.startHeight;
         this._worldMask.graphics.drawRect(-2000,-2000,4000 + w,4000 + h);
         this._worldMask.graphics.drawRect(0,0,w,h);
         this._worldMask.graphics.endFill();
         this._worldContainer.addChild(this._worldMask);
         this.setFrustrum(ao.frustum);
         FPS.getInstance().watchSprite("[Atouin World Container]",this._spMapContainer);
         this.init();
      }
      
      public function showWorld(b:Boolean) : void
      {
         if(b)
         {
            this._worldContainer.addChild(this._spMapContainer);
            this._worldContainer.addChild(this._spChgMapContainer);
            this._worldContainer.addChild(this._spGfxontainer);
            this._worldContainer.addChild(this._overlayContainer);
            this._worldContainer.addChild(this._worldMask);
         }
         else
         {
            if(this._spMapContainer.parent)
            {
               this._worldContainer.removeChild(this._spMapContainer);
            }
            if(this._spChgMapContainer.parent)
            {
               this._worldContainer.removeChild(this._spChgMapContainer);
            }
            if(this._spGfxontainer.parent)
            {
               this._worldContainer.removeChild(this._spGfxontainer);
            }
            if(this._overlayContainer.parent)
            {
               this._worldContainer.removeChild(this._overlayContainer);
            }
            if(this._worldMask.parent)
            {
               this._worldContainer.removeChild(this._worldMask);
            }
         }
      }
      
      public function setFrustrum(f:Frustum) : void
      {
         if(!this._aoOptions)
         {
            _log.error("Please call setDisplayOptions once before calling setFrustrum");
            return;
         }
         this._aoOptions.frustum = f;
         this.worldContainer.scaleX = this._aoOptions.frustum.scale;
         this.worldContainer.scaleY = this._aoOptions.frustum.scale;
         this.worldContainer.x = this._aoOptions.frustum.x;
         this.worldContainer.y = this._aoOptions.frustum.y;
         this.gfxContainer.scaleX = this._aoOptions.frustum.scale;
         this.gfxContainer.scaleY = this._aoOptions.frustum.scale;
         this.gfxContainer.x = this._aoOptions.frustum.x;
         this.gfxContainer.y = this._aoOptions.frustum.y;
         this.overlayContainer.x = this._aoOptions.frustum.x;
         this.overlayContainer.y = this._aoOptions.frustum.y;
         this.overlayContainer.scaleX = this._aoOptions.frustum.scale;
         this.overlayContainer.scaleY = this._aoOptions.frustum.scale;
         FrustumManager.getInstance().frustum = f;
      }
      
      public function initPreDisplay(wp:WorldPoint) : void
      {
         if(Boolean(wp && MapDisplayManager.getInstance()) && Boolean(MapDisplayManager.getInstance().currentMapPoint) && MapDisplayManager.getInstance().currentMapPoint.mapId == wp.mapId)
         {
            return;
         }
         MapDisplayManager.getInstance().capture();
      }
      
      public function display(wpMap:WorldPoint) : void
      {
         MapDisplayManager.getInstance().display(wpMap);
      }
      
      public function getEntity(id:int) : IEntity
      {
         return EntitiesManager.getInstance().getEntity(id);
      }
      
      public function getEntityOnCell(cellId:uint, oClass:* = null) : IEntity
      {
         return EntitiesManager.getInstance().getEntityOnCell(cellId,oClass);
      }
      
      public function clearEntities() : void
      {
         EntitiesManager.getInstance().clearEntities();
      }
      
      public function reset() : void
      {
         InteractiveCellManager.getInstance().clean();
         MapDisplayManager.getInstance().reset();
         EntitiesManager.getInstance().clearEntities();
         this.showWorld(false);
      }
      
      public function displayGrid(b:Boolean) : void
      {
         InteractiveCellManager.getInstance().show(Boolean(b) || Boolean(this.options.alwaysShowGrid));
      }
      
      public function getIdentifiedElement(id:uint) : InteractiveObject
      {
         return MapDisplayManager.getInstance().getIdentifiedElement(id);
      }
      
      public function getIdentifiedElementPosition(id:uint) : MapPoint
      {
         return MapDisplayManager.getInstance().getIdentifiedElementPosition(id);
      }
      
      public function addListener(pListener:ISoundPositionListener) : void
      {
         if(this._movementListeners == null)
         {
            this._movementListeners = new Array();
         }
         this._movementListeners.push(pListener);
      }
      
      public function removeListener(pListener:ISoundPositionListener) : void
      {
         var index:int = com.ankamagames.atouin.Atouin.getInstance()._movementListeners.indexOf(pListener);
         if(index)
         {
            com.ankamagames.atouin.Atouin.getInstance()._movementListeners.splice(index,1);
         }
      }
      
      private function init() : void
      {
         var elementsLoader:IResourceLoader = null;
         this._aSprites = new Array();
         if(!Elements.getInstance().parsed)
         {
            elementsLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
            elementsLoader.addEventListener(ResourceErrorEvent.ERROR,this.onElementsError);
            elementsLoader.load(new Uri(com.ankamagames.atouin.Atouin.getInstance().options.elementsIndexPath));
         }
         Pathfinding.init(AtouinConstants.PATHFINDER_MIN_X,AtouinConstants.PATHFINDER_MAX_X,AtouinConstants.PATHFINDER_MIN_Y,AtouinConstants.PATHFINDER_MAX_Y);
      }
      
      private function onElementsError(ree:ResourceErrorEvent) : void
      {
      }
   }
}
