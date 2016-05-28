package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.types.events.SendActionLogEvent;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.data.XmlConfig;
   import flash.utils.getDefinitionByName;
   import com.ankamagames.dofus.Constants;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.types.Version;
   import com.ankamagames.dofus.BuildInfos;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class SystemApi
   {
       
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      protected var _log:Logger;
      
      private var _characterDataStore:DataStoreType;
      
      private var _accountDataStore:DataStoreType;
      
      private var _hooks:Array;
      
      public function SystemApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(SystemApi));
         this._hooks = new Array();
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(value:UiRootContainer) : void
      {
         this._currentUi = value;
      }
      
      [Untrusted]
      public function addHook(hookName:String, callback:Function) : void
      {
         var targetedHook:Hook = Hook.getHookByName(hookName);
         if(!targetedHook)
         {
            targetedHook = new Hook(hookName,false,false);
         }
         if(Boolean(targetedHook.trusted) && !this._module.trusted)
         {
            throw new UntrustedApiCallError("Hook " + hookName + " cannot be listen from an untrusted module");
         }
         var listener:GenericListener = new GenericListener(hookName,!!this._currentUi?this._currentUi.name:"__module_" + this._module.id,callback);
         this._hooks[hookName] = listener;
         KernelEventsManager.getInstance().registerEvent(listener);
      }
      
      [Untrusted]
      public function removeHook(hookName:String) : void
      {
         if(this._hooks[hookName])
         {
            KernelEventsManager.getInstance().removeEventListener(this._hooks[hookName]);
            delete this._hooks[hookName];
         }
      }
      
      [Untrusted]
      public function createHook(name:String) : void
      {
         new Hook(name,false,false);
      }
      
      [Untrusted]
      public function dispatchHook(hookName:String, ... params) : void
      {
         var targetedHook:Hook = Hook.getHookByName(hookName);
         if(!targetedHook)
         {
            throw new ApiError("Hook [" + hookName + "] does not exist");
         }
         if(targetedHook.nativeHook)
         {
            throw new UntrustedApiCallError("Hook " + hookName + " is a native hook. Native hooks cannot be dispatch by module");
         }
         CallWithParameters.call(KernelEventsManager.getInstance().processCallback,new Array(targetedHook).concat(params));
      }
      
      [Untrusted]
      public function sendAction(actionName:String, ... params) : void
      {
         var apiAction:ApiAction = ApiAction.getApiActionByName(actionName);
         if(!apiAction)
         {
            throw new ApiError("Action [" + actionName + "] does not exist");
         }
         if(Boolean(apiAction.trusted) && !this._module.trusted)
         {
            throw new UntrustedApiCallError("Action " + actionName + " cannot be launch from an untrusted module");
         }
         var action:Action = CallWithParameters.callR(apiAction.actionClass["create"],params);
         this._log.logDirectly(new SendActionLogEvent(actionName,params));
         Kernel.getWorker().process(action);
      }
      
      [Trusted]
      public function log(level:uint, text:String) : void
      {
         var ui:String = !!this._currentUi?this._currentUi.uiModule.name + "/" + this._currentUi.uiClass:"?";
         this._log.log(level,"[" + ui + "] " + text);
      }
      
      [Trusted]
      public function setConfigEntry(sKey:String, sValue:*) : void
      {
         XmlConfig.getInstance().setEntry(sKey,sValue);
      }
      
      [Trusted]
      public function getConfigEntry(sKey:String) : *
      {
         return XmlConfig.getInstance().getEntry(sKey);
      }
      
      [Trusted]
      public function getEnum(name:String) : Class
      {
         var ClassReference:Class = getDefinitionByName(name) as Class;
         return ClassReference;
      }
      
      [Trusted]
      public function isEventMode() : Boolean
      {
         return Constants.EVENT_MODE;
      }
      
      [Trusted]
      public function isCharacterCreationAllowed() : Boolean
      {
         return Constants.CHARACTER_CREATION_ALLOWED;
      }
      
      [Trusted]
      public function getConfigKey(key:String) : String
      {
         return XmlConfig.getInstance().getEntry("config." + key);
      }
      
      [Trusted]
      public function goToUrl(url:String) : void
      {
         navigateToURL(new URLRequest(url));
      }
      
      [Trusted]
      public function getPlayerManager() : PlayerManager
      {
         return PlayerManager.getInstance();
      }
      
      [Untrusted]
      public function setData(name:String, value:*, shareWithAccount:Boolean = false) : void
      {
         var dst:DataStoreType = null;
         if(shareWithAccount)
         {
            if(!this._accountDataStore)
            {
               this.initAccountDataStore();
            }
            dst = this._accountDataStore;
         }
         else
         {
            if(!this._characterDataStore)
            {
               this.initCharacterDataStore();
            }
            dst = this._characterDataStore;
         }
         StoreDataManager.getInstance().setData(dst,name,value);
      }
      
      [NoBoxing]
      [Untrusted]
      public function getData(name:String, shareWithAccount:Boolean = false) : *
      {
         var dst:DataStoreType = null;
         if(shareWithAccount)
         {
            if(!this._accountDataStore)
            {
               this.initAccountDataStore();
            }
            dst = this._accountDataStore;
         }
         else
         {
            if(!this._characterDataStore)
            {
               this.initCharacterDataStore();
            }
            dst = this._characterDataStore;
         }
         return StoreDataManager.getInstance().getData(dst,name);
      }
      
      [Untrusted]
      public function getOption(name:String, moduleName:String) : *
      {
         return OptionManager.getOptionManager(moduleName)[name];
      }
      
      [Untrusted]
      public function getModuleList() : Array
      {
         return UiModuleManager.getInstance().getModules();
      }
      
      [Untrusted]
      public function callbackHook(hook:Hook, ... params) : void
      {
         KernelEventsManager.getInstance().processCallback(hook,params);
      }
      
      [Untrusted]
      public function showWorld(b:Boolean) : void
      {
         Atouin.getInstance().showWorld(b);
      }
      
      [Untrusted]
      public function worldIsVisible() : Boolean
      {
         return Atouin.getInstance().worldIsVisible;
      }
      
      [Deprecated(help="debugApi")]
      public function getConsoleAutoCompletion(cmd:String) : String
      {
         return ConsolesManager.getConsole("debug").autoComplete(cmd);
      }
      
      [Trusted]
      public function addEventListener(listener:Function, name:String, frameRate:uint = 25) : void
      {
         EnterFrameDispatcher.addEventListener(listener,name,frameRate);
      }
      
      [Trusted]
      public function removeEventListener(listener:Function) : void
      {
         EnterFrameDispatcher.removeEventListener(listener);
      }
      
      [Trusted]
      public function disableWorldInteraction() : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
      }
      
      [Trusted]
      public function enableWorldInteraction() : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
      }
      
      [Trusted]
      public function hasRight() : Boolean
      {
         return PlayerManager.getInstance().hasRights;
      }
      
      [Untrusted]
      public function isFightContext() : Boolean
      {
         return Kernel.getWorker().contains(FightContextFrame);
      }
      
      [Untrusted]
      public function getEntityLookFromString(s:String) : TiphonEntityLook
      {
         return TiphonEntityLook.fromString(s);
      }
      
      [Untrusted]
      public function getCurrentVersion() : Version
      {
         return BuildInfos.BUILD_VERSION;
      }
      
      [Untrusted]
      public function getBuildType() : uint
      {
         return BuildInfos.BUILD_TYPE;
      }
      
      [Untrusted]
      public function getCurrentLanguage() : String
      {
         return XmlConfig.getInstance().getEntry("config.lang.current");
      }
      
      [Trusted]
      public function clearCache() : void
      {
         Dofus.getInstance().selectiveClearCache();
         NativeApplication.nativeApplication.dispatchEvent(new Event(InvokeEvent.INVOKE));
         Dofus.getInstance().quit();
      }
      
      private function initAccountDataStore() : void
      {
         this._accountDataStore = new DataStoreType("AccountModule_" + this._module.name,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function initCharacterDataStore() : void
      {
         this._characterDataStore = new DataStoreType("Module_" + this._module.name,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
      }
   }
}
