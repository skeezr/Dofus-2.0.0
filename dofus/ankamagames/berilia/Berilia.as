package com.ankamagames.berilia
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.cache.Cache;
   import com.ankamagames.berilia.types.BeriliaOptions;
   import flash.display.Sprite;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.managers.UiGroupManager;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.berilia.types.event.UiRenderAskEvent;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.jerakine.types.DynamicSecureObject;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.api.SecureUiRootContainer;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.api.ApiBinder;
   import flash.display.InteractiveObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class Berilia extends EventDispatcher
   {
      
      private static var _self:com.ankamagames.berilia.Berilia;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.berilia.Berilia));
      
      private static const _uiCache:Dictionary = new Dictionary();
       
      private const _cache:Cache = new Cache(Cache.CHECK_SYSTEM_MEMORY,500000000,300000000);
      
      private var _UISoundListeners:Array;
      
      private var _bOptions:BeriliaOptions;
      
      private var _applicationVersion:uint;
      
      private var _docMain:Sprite;
      
      private var _aUiList:Array;
      
      private var _highestModalDepth:int;
      
      private var _aContainerList:Array;
      
      private var _docStrataWorld:Sprite;
      
      private var _docStrataLow:Sprite;
      
      private var _docStrataMedium:Sprite;
      
      private var _docStrataHight:Sprite;
      
      private var _docStrataTop:Sprite;
      
      private var _docStrataTooltip:Sprite;
      
      private var _handler:MessageHandler;
      
      private var _aLoadingUi:Array;
      
      private var _globalScale:Number = 1;
      
      private var _verboseException:Boolean = false;
      
      public var useIME:Boolean;
      
      public function Berilia()
      {
         this._UISoundListeners = new Array();
         super();
         if(_self != null)
         {
            throw new SingletonError("Berilia is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.berilia.Berilia
      {
         if(_self == null)
         {
            _self = new com.ankamagames.berilia.Berilia();
         }
         return _self;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(value:MessageHandler) : void
      {
         this._handler = value;
      }
      
      public function get docMain() : Sprite
      {
         return this._docMain;
      }
      
      public function get uiList() : Array
      {
         return this._aUiList;
      }
      
      public function get highestModalDepth() : int
      {
         return this._highestModalDepth;
      }
      
      public function get containerList() : Array
      {
         return this._aContainerList;
      }
      
      public function get strataLow() : DisplayObjectContainer
      {
         return this._docStrataLow;
      }
      
      public function get strataMedium() : DisplayObjectContainer
      {
         return this._docStrataMedium;
      }
      
      public function get strataHigh() : DisplayObjectContainer
      {
         return this._docStrataHight;
      }
      
      public function get strataTop() : DisplayObjectContainer
      {
         return this._docStrataTop;
      }
      
      public function get strataTooltip() : DisplayObjectContainer
      {
         return this._docStrataTooltip;
      }
      
      public function get loadingUi() : Array
      {
         return this._aLoadingUi;
      }
      
      public function get scale() : Number
      {
         return this._globalScale;
      }
      
      public function set scale(nScale:Number) : void
      {
         this._globalScale = nScale;
         this.updateUiScale();
      }
      
      public function get cache() : Cache
      {
         return this._cache;
      }
      
      public function get verboseException() : Boolean
      {
         return this._verboseException;
      }
      
      public function get UISoundListeners() : Array
      {
         return this._UISoundListeners;
      }
      
      public function get options() : BeriliaOptions
      {
         return this._bOptions;
      }
      
      public function get applicationVersion() : uint
      {
         return this._applicationVersion;
      }
      
      public function setDisplayOptions(bopt:BeriliaOptions) : void
      {
         this._bOptions = bopt;
      }
      
      public function addUIListener(pListener:IInterfaceListener) : void
      {
         FPS.getInstance().Nouvelle_Valeur(1,true);
         var index:int = this._UISoundListeners.indexOf(pListener);
         if(index == -1)
         {
            this._UISoundListeners.push(pListener);
         }
         FPS.getInstance().Nouvelle_Valeur(1);
      }
      
      public function removeUIListener(pListener:IInterfaceListener) : void
      {
         FPS.getInstance().Nouvelle_Valeur(1,true);
         var index:int = this._UISoundListeners.indexOf(pListener);
         if(index >= 0)
         {
            this._UISoundListeners.splice(index,1);
         }
         FPS.getInstance().Nouvelle_Valeur(1);
      }
      
      public function init(docContainer:Sprite, verboseException:Boolean, applicationVersion:uint) : void
      {
         this._docMain = docContainer;
         this._docMain.mouseEnabled = false;
         this._applicationVersion = applicationVersion;
         this._verboseException = verboseException;
         this._docStrataWorld = new Sprite();
         this._docStrataWorld.name = "strataWorld";
         this._docStrataLow = new Sprite();
         this._docStrataLow.name = "strataLow";
         this._docStrataMedium = new Sprite();
         this._docStrataMedium.name = "strataMedium";
         this._docStrataHight = new Sprite();
         this._docStrataHight.name = "strataHight";
         this._docStrataTop = new Sprite();
         this._docStrataTop.name = "strataTop";
         this._docStrataTooltip = new Sprite();
         this._docStrataTooltip.name = "strataTooltip";
         this._docStrataWorld.mouseEnabled = false;
         this._docStrataLow.mouseEnabled = false;
         this._docStrataMedium.mouseEnabled = false;
         this._docStrataHight.mouseEnabled = false;
         this._docStrataTop.mouseEnabled = false;
         this._docStrataTooltip.mouseChildren = false;
         this._docStrataTooltip.mouseEnabled = false;
         this._docMain.addChild(this._docStrataWorld);
         this._docMain.addChild(this._docStrataLow);
         this._docMain.addChild(this._docStrataMedium);
         this._docMain.addChild(this._docStrataHight);
         this._docMain.addChild(this._docStrataTop);
         this._docMain.addChild(this._docStrataTooltip);
         this._aUiList = new Array();
         this._aContainerList = new Array();
         this._aLoadingUi = new Array();
         BeriliaHookList.MouseClick;
      }
      
      public function reset() : void
      {
         var s:* = null;
         var m:UiModule = null;
         FPS.getInstance().Nouvelle_Valeur(1,true);
         for(s in this._aUiList)
         {
            this.unloadUi(s);
         }
         for each(m in UiModuleManager.getInstance().getModules())
         {
            KernelEventsManager.getInstance().removeEvent("__module_" + m.id);
            BindsManager.getInstance().removeEvent("__module_" + m.id);
         }
         UiGroupManager.getInstance().destroy();
         FPS.getInstance().Nouvelle_Valeur(1);
      }
      
      public function loadUi(uiModule:UiModule, uiData:UiData, sName:String, properties:* = null, bReplace:Boolean = false, nStrata:int = 1, hide:Boolean = false, cacheName:String = null) : UiRootContainer
      {
         var container:UiRootContainer = null;
         FPS.getInstance().Nouvelle_Valeur(1,true);
         if(cacheName)
         {
            container = _uiCache[cacheName];
            if(container)
            {
               container.name = sName;
               container.strata = nStrata;
               container.depth = nStrata * 10000 + Sprite(this._docMain.getChildAt(nStrata + 1)).numChildren;
               container.uiModule = uiModule;
               DisplayObjectContainer(this._docMain.getChildAt(nStrata + 1)).addChild(container);
               this._aUiList[sName] = container;
               container.uiClass.main(properties);
               return container;
            }
         }
         container = new UiRootContainer(this._docMain.stage,Sprite(this._docMain.getChildAt(nStrata + 1)));
         container.name = sName;
         container.strata = nStrata;
         container.depth = nStrata * 10000 + Sprite(this._docMain.getChildAt(nStrata + 1)).numChildren;
         container.uiModule = uiModule;
         if(cacheName)
         {
            container.cached = true;
            _uiCache[cacheName] = container;
         }
         if(!container.parent && !hide)
         {
            DisplayObjectContainer(this._docMain.getChildAt(nStrata + 1)).addChild(container);
         }
         this.loadUiInside(uiData,sName,container,properties,bReplace);
         FPS.getInstance().Nouvelle_Valeur(1);
         return container;
      }
      
      public function giveFocus(container:UiRootContainer) : void
      {
         var onTop:Boolean = false;
         var ui:Object = null;
         if(container.strata == 1)
         {
            onTop = true;
            for each(ui in this._aUiList)
            {
               if(Boolean(ui.visible) && Boolean(ui.depth > container.depth) && ui.strata == 1)
               {
                  onTop = false;
               }
            }
            if(Boolean(container.visible) && Boolean(onTop))
            {
               StageShareManager.stage.focus = container;
            }
         }
      }
      
      public function loadUiInside(uiData:UiData, sName:String, suiContainer:UiRootContainer, properties:* = null, bReplace:Boolean = false) : UiRootContainer
      {
         if(bReplace)
         {
            this.unloadUi(sName);
         }
         if(this.isRegisteredUiName(sName))
         {
            throw new BeriliaError(sName + " is already used by an other UI");
         }
         dispatchEvent(new UiRenderAskEvent(sName,uiData));
         suiContainer.name = sName;
         this._aLoadingUi[sName] = true;
         this._aUiList[sName] = suiContainer;
         suiContainer.addEventListener(UiRenderEvent.UIRenderComplete,this.onUiLoaded);
         UiRenderManager.getInstance().loadUi(uiData,suiContainer,properties);
         return suiContainer;
      }
      
      public function unloadUi(sName:String) : Boolean
      {
         var j:* = null;
         var currObj:Object = null;
         var i:* = null;
         var variables:Array = null;
         var varName:String = null;
         var u:Object = null;
         FPS.getInstance().Nouvelle_Valeur(1,true);
         var ui:UiRootContainer = this._aUiList[sName];
         if(ui == null)
         {
            return false;
         }
         var obj:DynamicSecureObject = new DynamicSecureObject();
         obj.cancel = false;
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiUnloading,sName,obj);
         if(obj.cancel)
         {
            return false;
         }
         if(ui.cached)
         {
            if(ui.parent)
            {
               ui.parent.removeChild(ui);
            }
            this.unloadUiEvents(sName,true);
            ui.hideAfterLoading = true;
            this._aUiList[sName] = null;
            delete this._aUiList[sName];
            if(ui.uiClass.unload)
            {
               ui.uiClass.unload();
            }
            return true;
         }
         ui.disableRender = true;
         if(UiRootContainer(ui).uiClass)
         {
            if(Object(UiRootContainer(ui).uiClass).hasOwnProperty("unload"))
            {
               UiRootContainer(ui).uiClass.unload();
            }
            variables = DescribeTypeCache.getVariables(UiRootContainer(ui).uiClass,true);
            for each(varName in variables)
            {
               if(UiRootContainer(ui).uiClass[varName] is Object)
               {
                  UiRootContainer(ui).uiClass[varName] = null;
               }
            }
         }
         for(j in UIEventManager.getInstance().instances)
         {
            if(j != "null" && UIEventManager.getInstance().instances[j].instance.getUi() == ui)
            {
               UIEventManager.getInstance().instances[j] = null;
               delete UIEventManager.getInstance().instances[j];
            }
         }
         UiRootContainer(ui).remove();
         for(i in ui.getElements())
         {
            currObj = ui.getElements()[i];
            if(currObj is GraphicContainer)
            {
               this._aContainerList[currObj["name"]] = null;
               delete this._aContainerList[currObj["name"]];
            }
            ui.getElements()[i] = null;
            delete ui.getElements()[i];
         }
         KernelEventsManager.getInstance().removeEvent(sName);
         BindsManager.getInstance().removeEvent(sName);
         SecureUiRootContainer.getSecureUi(ui).restricted_namespace::destroy();
         ui.restricted_namespace::destroy();
         if(ApiBinder.getApiData("currentUi") == ui)
         {
            ApiBinder.removeApiData("currentUi");
         }
         UiRootContainer(ui).free();
         this._aUiList[sName] = null;
         delete this._aUiList[sName];
         this.updateHighestModalDepth();
         var topUi:Object = null;
         if(ui.strata > 0 && ui.strata < 4)
         {
            for each(u in this._aUiList)
            {
               if(topUi == null)
               {
                  if(u.strata == 1 && Boolean(u.visible))
                  {
                     topUi = u;
                  }
               }
               else if(u.depth > topUi.depth && u.strata == 1 && Boolean(u.visible))
               {
                  topUi = u;
               }
            }
            StageShareManager.stage.focus = topUi == null?StageShareManager.stage:InteractiveObject(topUi);
         }
         FPS.getInstance().Nouvelle_Valeur(1);
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiUnloaded,sName);
         return true;
      }
      
      public function unloadUiEvents(sName:String, useCache:Boolean = false) : void
      {
         var currObj:Object = null;
         var i:* = null;
         var j:* = null;
         FPS.getInstance().Nouvelle_Valeur(1,true);
         if(this._aUiList[sName] == null)
         {
            return;
         }
         for(i in this._aUiList[sName].getElements())
         {
            currObj = this._aUiList[sName].getElements()[i];
            if(currObj is GraphicContainer)
            {
               this._aContainerList[currObj["name"]] = null;
               delete this._aContainerList[currObj["name"]];
            }
            if(!useCache)
            {
               this._aUiList[sName].getElements()[i] = null;
               delete this._aUiList[sName].getElements()[i];
            }
         }
         KernelEventsManager.getInstance().removeEvent(sName);
         BindsManager.getInstance().removeEvent(sName);
         for(j in UIEventManager.getInstance().instances)
         {
            if((Boolean(j != null || j != "null")) && Boolean(UIEventManager.getInstance().instances[j]) && Boolean(UIEventManager.getInstance().instances[j].instance) && Boolean(UIEventManager.getInstance().instances[j].instance.topParent) && UIEventManager.getInstance().instances[j].instance.topParent.name == sName)
            {
               if(UIEventManager.getInstance().instances[j].instance.topParent.name == sName)
               {
                  UIEventManager.getInstance().instances[j] = null;
                  delete UIEventManager.getInstance().instances[j];
               }
            }
         }
         FPS.getInstance().Nouvelle_Valeur(1);
      }
      
      public function getUi(sName:String) : UiRootContainer
      {
         return this._aUiList[sName];
      }
      
      public function isUiDisplayed(sName:String) : Boolean
      {
         return this._aUiList[sName] != null;
      }
      
      public function updateUiRender() : void
      {
         var i:* = null;
         for(i in this.uiList)
         {
            UiRootContainer(this.uiList[i]).render();
         }
      }
      
      public function updateUiScale() : void
      {
         var ui:UiRootContainer = null;
         var i:* = null;
         for(i in this.uiList)
         {
            ui = UiRootContainer(this.uiList[i]);
            if(ui.scalable)
            {
               ui.scale = this.scale;
               ui.render();
            }
         }
      }
      
      public function isRegisteredContainerId(sName:String) : Boolean
      {
         return this._aContainerList[sName] != null;
      }
      
      public function registerContainerId(sName:String, doc:DisplayObjectContainer) : Boolean
      {
         if(this.isRegisteredContainerId(sName))
         {
            return false;
         }
         this._aContainerList[sName] = doc;
         return true;
      }
      
      private function onUiLoaded(ure:UiRenderEvent) : void
      {
         this._aLoadingUi[ure.uiTarget.name] = false;
         this.updateHighestModalDepth();
         dispatchEvent(ure);
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.UiLoaded,ure.uiTarget.name);
      }
      
      private function updateHighestModalDepth() : void
      {
         var uiContainer:UiRootContainer = null;
         this._highestModalDepth = -1;
         for each(uiContainer in this._aUiList)
         {
            if(Boolean(uiContainer.modal) && this._highestModalDepth < uiContainer.depth)
            {
               this._highestModalDepth = uiContainer.depth;
            }
         }
      }
      
      private function isRegisteredUiName(sName:String) : Boolean
      {
         return this._aUiList[sName] != null;
      }
   }
}
