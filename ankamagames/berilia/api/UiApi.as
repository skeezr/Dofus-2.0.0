package com.ankamagames.berilia.api
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.berilia.managers.UIEventManager;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import flash.utils.getDefinitionByName;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.interfaces.IRadioItem;
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.jerakine.utils.display.KeyPoll;
   import com.ankamagames.berilia.types.data.TreeData;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.components.Texture;
   import flash.geom.Point;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import flash.display.StageDisplayState;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   
   [InstanciedApi]
   public class UiApi
   {
      
      public static const _log:Logger = Log.getLogger(getQualifiedClassName(UiApi));
      
      api_namespace static var defaultTooltipUiScript:Class;
       
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      public function UiApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         if(!this._module)
         {
            this._module = value;
         }
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(value:UiRootContainer) : void
      {
         if(!this._currentUi)
         {
            this._currentUi = value;
         }
      }
      
      [Untrusted]
      public function loadUi(name:String, instanceName:String = null, params:* = null, strata:uint = 1, cacheName:String = null) : Object
      {
         var tmp:Array = null;
         var mod:UiModule = this._module;
         var uiName:String = name;
         if(!this._module.uis[name])
         {
            if(name.indexOf("::") != -1)
            {
               tmp = name.split("::");
               mod = UiModuleManager.getInstance().getModule(tmp[0]);
               if(!mod)
               {
                  throw new BeriliaError("Module [" + tmp[0] + "] does not exist");
               }
               if(Boolean(mod.trusted) && !this._module.trusted)
               {
                  throw new ApiError("You cannot load trusted UI");
               }
               uiName = tmp[1];
            }
            else
            {
               throw new BeriliaError(name + " not found in module " + this._module.name);
            }
         }
         if(!instanceName)
         {
            instanceName = uiName;
         }
         if(mod.uis[uiName])
         {
            return SecureUiRootContainer.getSecureUi(Berilia.getInstance().loadUi(mod,mod.uis[uiName],instanceName,params,false,strata,false,cacheName),mod.trusted);
         }
         return null;
      }
      
      [Untrusted]
      public function loadUiInside(name:String, container:GraphicContainer, instanceName:String = null, params:* = null) : Object
      {
         var tmp:Array = null;
         var newContainer:UiRootContainer = null;
         var mod:UiModule = this._module;
         var uiName:String = name;
         if(!this._module.uis[name])
         {
            if(name.indexOf("::") != -1)
            {
               tmp = name.split("::");
               mod = UiModuleManager.getInstance().getModule(tmp[0]);
               if(!mod)
               {
                  throw new BeriliaError("Module [" + tmp[0] + "] does not exist");
               }
               if(Boolean(mod.trusted) && !this._module.trusted)
               {
                  throw new ApiError("You cannot load trusted UI");
               }
               uiName = tmp[1];
            }
            else
            {
               throw new BeriliaError(name + " not found in module " + this._module.name);
            }
         }
         if(!instanceName)
         {
            instanceName = uiName;
         }
         if(mod.uis[uiName])
         {
            newContainer = new UiRootContainer(StageShareManager.stage);
            newContainer.uiModule = mod;
            newContainer.strata = container.getUi().strata;
            newContainer.depth = container.getUi().depth + 1;
            Berilia.getInstance().loadUiInside(mod.uis[uiName],instanceName,newContainer,params,false);
            container.addChild(newContainer);
            return SecureUiRootContainer.getSecureUi(newContainer,mod.trusted);
         }
         return null;
      }
      
      [Untrusted]
      public function unloadUi(name:String) : void
      {
         Berilia.getInstance().unloadUi(name);
      }
      
      [Untrusted]
      public function getUi(instanceName:String) : SecureUiRootContainer
      {
         var sui:UiRootContainer = Berilia.getInstance().getUi(instanceName);
         if(!sui)
         {
            return null;
         }
         if(sui.uiModule != this._module && !this._module.trusted)
         {
            throw new ArgumentError("Cannot get access to an UI owned by another module.");
         }
         var u:* = SecureUiRootContainer.getSecureUi(sui,this._module.trusted);
         return SecureUiRootContainer.getSecureUi(sui,this._module.trusted);
      }
      
      [Deprecated(help="you can add secure objet directly on SecureComponent")]
      public function addChild(target:Object, child:Object) : void
      {
         BoxingUnBoxing.unbox(target).addChild(BoxingUnBoxing.unbox(child));
      }
      
      [Untrusted]
      public function me() : SecureUiRootContainer
      {
         return SecureUiRootContainer.getSecureUi(this._currentUi,this._module.trusted);
      }
      
      [Trusted]
      public function initDefaultBinds() : void
      {
         BindsManager.getInstance();
      }
      
      [Untrusted]
      public function addShortcutHook(shortcutName:String, hook:Function) : void
      {
         var targetedShortcut:Shortcut = Shortcut.getShortcutByName(shortcutName);
         if(!targetedShortcut)
         {
            throw new ApiError("Shortcut [" + shortcutName + "] does not exist");
         }
         var listener:GenericListener = new GenericListener(shortcutName,!!this._currentUi?this._currentUi.name:"__module_" + this._module.id,hook,!!this._currentUi?int(this._currentUi.depth):0);
         BindsManager.getInstance().registerEvent(listener);
      }
      
      [Untrusted]
      public function addComponentHook(target:GraphicContainer, hookName:String) : void
      {
         var ie:InstanceEvent = null;
         var eventMsg:String = this.getEventClassName(hookName);
         if(!eventMsg)
         {
            throw new ApiError("Hook [" + hookName + "] does not exist");
         }
         if(!UIEventManager.getInstance().instances[target])
         {
            ie = new InstanceEvent(target,this._currentUi.uiClass);
            UIEventManager.getInstance().registerInstance(ie);
         }
         else
         {
            ie = UIEventManager.getInstance().instances[target];
         }
         ie.events[eventMsg] = eventMsg;
      }
      
      [Trusted]
      public function createComponent(type:String, ... params) : DisplayObject
      {
         return CallWithParameters.callConstructor(getDefinitionByName("com.ankamagames.berilia.components::" + type) as Class,params);
      }
      
      [Trusted]
      public function createContainer(type:String, ... params) : *
      {
         return CallWithParameters.callConstructor(getDefinitionByName("com.ankamagames.berilia.types.graphic::" + type) as Class,params);
      }
      
      [Deprecated(help="use addComponentHook to add event")]
      [Trusted]
      public function createInstanceEvent(target:DisplayObject, instance:*) : InstanceEvent
      {
         return new InstanceEvent(target,instance);
      }
      
      [Trusted]
      public function getEventClassName(event:String) : String
      {
         switch(event)
         {
            case EventEnums.EVENT_ONPRESS:
               return EventEnums.EVENT_ONPRESS_MSG;
            case EventEnums.EVENT_ONRELEASE:
               return EventEnums.EVENT_ONRELEASE_MSG;
            case EventEnums.EVENT_ONROLLOUT:
               return EventEnums.EVENT_ONROLLOUT_MSG;
            case EventEnums.EVENT_ONROLLOVER:
               return EventEnums.EVENT_ONROLLOVER_MSG;
            case EventEnums.EVENT_ONRELEASEOUTSIDE:
               return EventEnums.EVENT_ONRELEASEOUTSIDE_MSG;
            case EventEnums.EVENT_ONDOUBLECLICK:
               return EventEnums.EVENT_ONDOUBLECLICK_MSG;
            case EventEnums.EVENT_ONRIGHTCLICK:
               return EventEnums.EVENT_ONRIGHTCLICK_MSG;
            case EventEnums.EVENT_ONCOLORCHANGE:
               return EventEnums.EVENT_ONCOLORCHANGE_MSG;
            case EventEnums.EVENT_ONSELECTITEM:
               return EventEnums.EVENT_ONSELECTITEM_MSG;
            case EventEnums.EVENT_ONCREATETAB:
               return EventEnums.EVENT_ONCREATETAB_MSG;
            case EventEnums.EVENT_ONDELETETAB:
               return EventEnums.EVENT_ONDELETETAB_MSG;
            case EventEnums.EVENT_ONRENAMETAB:
               return EventEnums.EVENT_ONRENAMETAB_MSG;
            case EventEnums.EVENT_ONITEMROLLOUT:
               return EventEnums.EVENT_ONITEMROLLOUT_MSG;
            case EventEnums.EVENT_ONITEMROLLOVER:
               return EventEnums.EVENT_ONITEMROLLOVER_MSG;
            case EventEnums.EVENT_ONITEMRIGHTCLICK:
               return EventEnums.EVENT_ONITEMRIGHTCLICK_MSG;
            case EventEnums.EVENT_ONTEXTUREREADY:
               return EventEnums.EVENT_ONTEXTUREREADY_MSG;
            case EventEnums.EVENT_ONMAPELEMENTROLLOUT:
               return EventEnums.EVENT_ONMAPELEMENTROLLOUT_MSG;
            case EventEnums.EVENT_ONMAPELEMENTROLLOVER:
               return EventEnums.EVENT_ONMAPELEMENTROLLOVER_MSG;
            case EventEnums.EVENT_ONMAPMOVE:
               return EventEnums.EVENT_ONMAPMOVE_MSG;
            case EventEnums.EVENT_ONMAPROLLOVER:
               return EventEnums.EVENT_ONMAPROLLOVER_MSG;
            case EventEnums.EVENT_ONVIDEOCONNECTFAILED:
               return EventEnums.EVENT_ONVIDEOCONNECTFAILED_MSG;
            case EventEnums.EVENT_ONVIDEOCONNECTSUCCESS:
               return EventEnums.EVENT_ONVIDEOCONNECTSUCCESS_MSG;
            case EventEnums.EVENT_ONVIDEOBUFFERCHANGE:
               return EventEnums.EVENT_ONVIDEOBUFFERCHANGE_MSG;
            case EventEnums.EVENT_ONCOMPONENTREADY:
               return EventEnums.EVENT_ONCOMPONENTREADY_MSG;
            default:
               return null;
         }
      }
      
      [Deprecated(help="use addComponentHook to add event")]
      [Trusted]
      public function addInstanceEvent(event:InstanceEvent) : void
      {
         UIEventManager.getInstance().registerInstance(event);
      }
      
      [NoBoxing]
      [Untrusted]
      public function createUri(uri:String) : Uri
      {
         if(Boolean(uri) && uri.indexOf(":") == -1)
         {
            uri = "mod://" + this._module.id + "/" + uri;
         }
         return new Uri(uri);
      }
      
      [Untrusted]
      public function showTooltip(data:*, target:*, autoHide:Boolean = false, name:String = "standard", point:uint = 0, relativePoint:uint = 2, offset:int = 3, tooltipMaker:String = null, script:Class = null, makerParam:Object = null, cacheName:String = null) : void
      {
         if(!script)
         {
            script = api_namespace::defaultTooltipUiScript;
         }
         TooltipManager.show(data,target,this._module,autoHide,name,point,relativePoint,offset,true,tooltipMaker,script,makerParam,cacheName);
      }
      
      [Untrusted]
      public function hideTooltip(name:String = null) : void
      {
         TooltipManager.hide(name);
      }
      
      [Untrusted]
      public function getRadioGroupSelectedItem(rgName:String, me:UiRootContainer) : IRadioItem
      {
         var rg:RadioGroup = me.getRadioGroup(rgName);
         return rg.selectedItem;
      }
      
      [Untrusted]
      public function setRadioGroupSelectedItem(rgName:String, item:IRadioItem, me:UiRootContainer) : void
      {
         var rg:RadioGroup = me.getRadioGroup(rgName);
         rg.selectedItem = item;
      }
      
      [Untrusted]
      public function keyIsDown(keyCode:uint) : Boolean
      {
         return KeyPoll.getInstance().isDown(keyCode);
      }
      
      [Untrusted]
      public function keyIsUp(keyCode:uint) : Boolean
      {
         return KeyPoll.getInstance().isUp(keyCode);
      }
      
      [NoBoxing]
      [Untrusted]
      public function convertToTreeData(array:*) : Vector.<TreeData>
      {
         return TreeData.fromArray(array);
      }
      
      [Untrusted]
      public function setFollowCursorUri(uri:*, lockX:Boolean = false, lockY:Boolean = false, xOffset:int = 0, yOffset:int = 0, scale:Number = 1) : void
      {
         var cd:LinkedCursorData = null;
         if(uri)
         {
            cd = new LinkedCursorData();
            cd.sprite = new Texture();
            Texture(cd.sprite).uri = uri is String?new Uri(uri):uri;
            cd.sprite.scaleX = scale;
            cd.sprite.scaleY = scale;
            Texture(cd.sprite).finalize();
            cd.lockX = lockX;
            cd.lockY = lockY;
            cd.offset = new Point(xOffset,yOffset);
            LinkedCursorSpriteManager.getInstance().addItem("customUserCursor",cd);
         }
         else
         {
            LinkedCursorSpriteManager.getInstance().removeItem("customUserCursor");
         }
      }
      
      [Untrusted]
      public function getFollowCursorUri() : Object
      {
         return LinkedCursorSpriteManager.getInstance().getItem("customUserCursor");
      }
      
      [Untrusted]
      public function getMouseX() : int
      {
         return StageShareManager.mouseX;
      }
      
      [Untrusted]
      public function getMouseY() : int
      {
         return StageShareManager.mouseY;
      }
      
      [Untrusted]
      public function getStageWidth() : int
      {
         return StageShareManager.startWidth;
      }
      
      [Untrusted]
      public function getStageHeight() : int
      {
         return StageShareManager.startHeight;
      }
      
      [Trusted]
      public function setFullScreen(enabled:Boolean) : void
      {
         _log.trace(StageShareManager.rootContainer.name);
         if(enabled)
         {
            StageShareManager.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         else
         {
            StageShareManager.stage.displayState = StageDisplayState.NORMAL;
         }
      }
      
      [Untrusted]
      public function useIME() : Boolean
      {
         return Berilia.getInstance().useIME;
      }
      
      [Untrusted]
      public function replaceKey(text:String) : String
      {
         return LangManager.getInstance().replaceKey(text,true);
      }
      
      [Untrusted]
      public function getText(key:String, ... params) : String
      {
         if(I18nProxy.containKey(key))
         {
            return I18n.getText(I18nProxy.getKeyId(key),params);
         }
         return "!" + key + "!";
      }
      
      [Untrusted]
      public function getTextFromKey(key:uint, replace:String = "%", ... params) : String
      {
         return I18n.getText(key,params,replace);
      }
      
      [Untrusted]
      public function processText(str:String, gender:String, singular:Boolean = true) : String
      {
         return PatternDecoder.combine(str,gender,singular);
      }
   }
}
