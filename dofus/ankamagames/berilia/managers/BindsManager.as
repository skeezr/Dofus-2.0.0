package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.berilia.BeriliaConstants;
   import flash.filesystem.File;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.enums.ShortcutsEnum;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.types.shortcut.LocalizedKeyboard;
   import flash.ui.Keyboard;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class BindsManager extends GenericEventsManager
   {
      
      private static var _self:com.ankamagames.berilia.managers.BindsManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.berilia.managers.BindsManager));
       
      private var _aRegisterKey:Array;
      
      private var _loader:IResourceLoader;
      
      private var _loaderKeyboard:IResourceLoader;
      
      private var _avaibleKeyboard:Array;
      
      public function BindsManager()
      {
         this._avaibleKeyboard = new Array();
         super();
         if(_self != null)
         {
            throw new SingletonError("ShortcutsManager constructor should not be called directly.");
         }
         _self = this;
         this.initialize();
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.BindsManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.berilia.managers.BindsManager();
         }
         return _self;
      }
      
      public function get avaibleKeyboard() : Array
      {
         return this._avaibleKeyboard;
      }
      
      public function get currentLocale() : String
      {
         return StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_BINDS,"locale");
      }
      
      override public function initialize() : void
      {
         var file:File = null;
         var s:Bind = null;
         super.initialize();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.objectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.objectLoadedFailed);
         this._loaderKeyboard = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loaderKeyboard.addEventListener(ResourceLoadedEvent.LOADED,this.keyboardFileLoaded);
         this._loaderKeyboard.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.keyboardFileAllLoaded);
         this._loaderKeyboard.addEventListener(ResourceErrorEvent.ERROR,this.objectLoadedFailed);
         StoreDataManager.getInstance().registerClass(new Bind());
         this._aRegisterKey = StoreDataManager.getInstance().getSetData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",new Array());
         this.fillShortcutsEnum();
         var bindFilesPath:File = File.applicationDirectory.resolvePath(LangManager.getInstance().getEntry("config.binds.path.root").split("file://").join(""));
         var bindFiles:Array = bindFilesPath.getDirectoryListing();
         var uris:Array = new Array();
         for each(file in bindFiles)
         {
            if(!file.isDirectory && file.extension == "xml")
            {
               uris.push(new Uri(file.url));
            }
         }
         this._loaderKeyboard.load(uris);
         s = new Bind("ALL","ALL",true,true,true);
         this._aRegisterKey.push(s);
      }
      
      public function get binds() : Array
      {
         return this._aRegisterKey;
      }
      
      public function getShortcutString(nKeyCode:uint, nCharCode:uint) : String
      {
         if(ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[nKeyCode] != null)
         {
            return ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[nKeyCode];
         }
         if(nCharCode == 0)
         {
            return null;
         }
         return String.fromCharCode(nCharCode);
      }
      
      public function getBind(s:Bind) : Bind
      {
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].equals(s))
            {
               return this._aRegisterKey[i];
            }
         }
         return null;
      }
      
      public function isRegister(s:Bind) : Boolean
      {
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].equals(s))
            {
               return true;
            }
         }
         return false;
      }
      
      public function isPermanent(s:Bind) : Boolean
      {
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].equals(s))
            {
               if(!Shortcut.getShortcutByName(this._aRegisterKey[i].targetedShortcut).bindable)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function isRegisteredName(s:String) : Boolean
      {
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].targetedShortcut == s)
            {
               return true;
            }
         }
         return false;
      }
      
      public function canBind(s:Bind) : Boolean
      {
         for(var i:uint = 0; i < ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.length; i++)
         {
            if(ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN[i].equals(s))
            {
               return false;
            }
         }
         return true;
      }
      
      public function removeBind(b:Bind) : void
      {
         var target:String = null;
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].equals(b))
            {
               target = Bind(this._aRegisterKey[i]).targetedShortcut;
               this._aRegisterKey.splice(i,1);
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
               KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,target,null);
               break;
            }
         }
      }
      
      public function addBind(bind:Bind) : void
      {
         if(!this.canBind(bind))
         {
            _log.error(bind.toString() + " cannot be bind.");
            return;
         }
         this.removeBind(bind);
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(Bind(this._aRegisterKey[i]).targetedShortcut == bind.targetedShortcut)
            {
               this._aRegisterKey.splice(i,1,bind);
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
               KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,bind.targetedShortcut,bind);
               return;
            }
         }
         this._aRegisterKey.push(bind);
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,bind.targetedShortcut,bind);
      }
      
      public function isRegisteredShortcut(s:Bind, disableGenericBind:Boolean = false) : Boolean
      {
         return _aEvent[s.targetedShortcut] != null || !disableGenericBind && Boolean(_aEvent["ALL"]);
      }
      
      public function getBindFromShortcut(shorcutName:String) : Bind
      {
         var b:Bind = null;
         for each(b in this._aRegisterKey)
         {
            if(b.targetedShortcut == shorcutName)
            {
               return b;
            }
         }
         return null;
      }
      
      public function processCallback(o:*, ... args) : void
      {
         var e:GenericListener = null;
         var aGe:Array = null;
         var i:* = null;
         var result:* = undefined;
         var s:Bind = Bind(o);
         if(!this.isRegisteredShortcut(s))
         {
            return;
         }
         var bContinue:* = true;
         if(_aEvent[s.targetedShortcut])
         {
            aGe = _aEvent[s.targetedShortcut].concat(_aEvent["ALL"]);
            aGe.sortOn("sortIndex",Array.DESCENDING | Array.NUMERIC);
            for(i in aGe)
            {
               if(!bContinue)
               {
                  break;
               }
               e = aGe[i];
               if(e)
               {
                  if(Boolean(Berilia.getInstance().getUi(e.listener)) && Berilia.getInstance().getUi(e.listener).depth < Berilia.getInstance().highestModalDepth)
                  {
                     return;
                  }
                  _log.debug("Dispatch " + args + "to " + e.listener);
                  result = e.getCallback().apply(null,args);
                  if(result === null || !(result is Boolean))
                  {
                     throw new ApiError(e.getCallback() + " does not return a Boolean value");
                  }
                  bContinue = !result;
               }
            }
         }
      }
      
      public function reset() : void
      {
         var bind:Bind = null;
         var shortcut:Shortcut = null;
         var nameIndexed:Array = new Array();
         for each(bind in this._aRegisterKey)
         {
            nameIndexed[bind.targetedShortcut] = bind;
         }
         for each(shortcut in Shortcut.getShortcuts())
         {
            if(shortcut.defaultBind != nameIndexed[shortcut.name])
            {
               if(shortcut.defaultBind)
               {
                  this.addBind(shortcut.defaultBind);
               }
               else
               {
                  this.removeBind(nameIndexed[shortcut.name]);
               }
            }
         }
      }
      
      public function changeKeyboard(locale:String, removeOldBind:Boolean = false) : void
      {
         var k:LocalizedKeyboard = null;
         for each(k in this._avaibleKeyboard)
         {
            if(k.locale == locale)
            {
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"locale",locale);
               k.uri.tag = removeOldBind;
               this._loader.load(k.uri);
               break;
            }
         }
      }
      
      public function getRegisteredBind(s:Bind) : Bind
      {
         for(var i:uint = 0; i < this._aRegisterKey.length; i++)
         {
            if(this._aRegisterKey[i].equals(s))
            {
               return this._aRegisterKey[i];
            }
         }
         return null;
      }
      
      private function fillShortcutsEnum() : void
      {
         var i:String = null;
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("C","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("V","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(f4)","",true,false));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(del)","",true,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(tab)","",true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(backspace)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(insert)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(del)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(locknum)"));
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.ESCAPE] = "(escape)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.ENTER] = "(enter)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.TAB] = "(tab)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.BACKSPACE] = "(backspace)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.UP] = "(upArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.RIGHT] = "(rightArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.DOWN] = "(downArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.LEFT] = "(leftArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.SPACE] = "(space)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.PAGE_UP] = "(pageUp)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.PAGE_DOWN] = "(pageDown)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.DELETE] = "(delete)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[144] = "(numLock)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.INSERT] = "(insert)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.END] = "(end)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F1] = "(f1)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F2] = "(f2)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F3] = "(f3)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F4] = "(f4)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F5] = "(f5)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F6] = "(f6)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F7] = "(f7)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F8] = "(f8)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F9] = "(f9)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F10] = "(f10)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F11] = "(f11)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F12] = "(f12)";
         for(ShortcutsEnum.BASIC_SHORTCUT_NAME[ShortcutsEnum.BASIC_SHORTCUT_KEYCODE] in ShortcutsEnum.BASIC_SHORTCUT_KEYCODE)
         {
         }
      }
      
      private function parseBindsXml(sXml:String, removeOldbinds:Boolean) : void
      {
         var s:Bind = null;
         var shortcut:Shortcut = null;
         var bind:Bind = null;
         var xBind:XML = null;
         var binds:XML = XML(sXml);
         var nameIndexed:Array = new Array();
         for each(bind in this._aRegisterKey)
         {
            nameIndexed[bind.targetedShortcut] = bind;
         }
         for each(xBind in binds..bind)
         {
            shortcut = Shortcut.getShortcutByName(xBind..@shortcut);
            if(!shortcut)
            {
               _log.warn("Shortcut [" + xBind..@shortcut + "] is not define");
            }
            else
            {
               s = new Bind(xBind,xBind..@shortcut,xBind..@alt == true,xBind..@ctrl == true,xBind..@shift == true);
               if(!this.canBind(s))
               {
                  _log.error(s.toString() + " cannot be bind.");
               }
               else if(!this.isRegister(s))
               {
                  shortcut.defaultBind = s;
                  if(nameIndexed[s.targetedShortcut])
                  {
                     if(removeOldbinds)
                     {
                        this.addBind(s);
                     }
                     else
                     {
                        continue;
                     }
                  }
                  else
                  {
                     this._aRegisterKey.push(s);
                  }
                  _log.debug("add " + s);
               }
            }
         }
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
      }
      
      public function objectLoaded(e:ResourceLoadedEvent) : void
      {
         this.parseBindsXml(e.resource,e.uri.tag);
      }
      
      public function keyboardFileLoaded(e:ResourceLoadedEvent) : void
      {
         var xml:XML = XML(e.resource);
         this._avaibleKeyboard.push(new LocalizedKeyboard(e.uri,xml.@locale,xml.@description));
      }
      
      public function keyboardFileAllLoaded(e:ResourceLoaderProgressEvent) : void
      {
         var locale:String = StoreDataManager.getInstance().getSetData(BeriliaConstants.DATASTORE_BINDS,"locale",LangManager.getInstance().getEntry("config.binds.current"));
         this.changeKeyboard(locale);
      }
      
      public function objectLoadedFailed(e:ResourceErrorEvent) : void
      {
         _log.debug("objectLoadedFailed : " + e.uri + ", " + e.errorMsg);
      }
   }
}
