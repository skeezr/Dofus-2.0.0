package com.ankamagames.jerakine.managers
{
   import flash.utils.Proxy;
   import flash.events.IEventDispatcher;
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.types.DataStoreType;
   import flash.events.Event;
   import flash.utils.flash_proxy;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   
   use namespace flash_proxy;
   
   public dynamic class OptionManager extends Proxy implements IEventDispatcher
   {
      
      private static var _optionsManager:Array = new Array();
       
      private var _defaultValue:Array;
      
      private var _properties:Array;
      
      private var _useCache:Array;
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _customName:String;
      
      private var _dataStore:DataStoreType;
      
      protected var _item:Array;
      
      public function OptionManager(customName:String = null)
      {
         this._defaultValue = new Array();
         this._properties = new Array();
         this._useCache = new Array();
         super();
         if(customName)
         {
            this._customName = customName;
         }
         else
         {
            this._customName = getQualifiedClassName(this).split("::").join("_");
         }
         if(_optionsManager[this._customName])
         {
            throw new Error(customName + " is already used by an other option manager.");
         }
         _optionsManager[this._customName] = this;
         this._eventDispatcher = new EventDispatcher(this);
         this._dataStore = new DataStoreType(this._customName,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      }
      
      public static function getOptionManager(name:String) : OptionManager
      {
         var o:* = _optionsManager;
         return _optionsManager[name];
      }
      
      public static function reset() : void
      {
         _optionsManager = new Array();
      }
      
      public function add(name:String, value:* = null, useCache:Boolean = true) : void
      {
         this._useCache[name] = useCache;
         this._defaultValue[name] = value;
         if(Boolean(useCache) && StoreDataManager.getInstance().getData(this._dataStore,name) != null)
         {
            this._properties[name] = StoreDataManager.getInstance().getData(this._dataStore,name);
         }
         else
         {
            this._properties[name] = value;
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         this._eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this._eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this._eventDispatcher.hasEventListener(type);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         this._eventDispatcher.removeEventListener(type,listener,useCapture);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this._eventDispatcher.willTrigger(type);
      }
      
      public function restaureDefaultValue(name:String) : void
      {
         if(this._useCache[name] != null)
         {
            this.setProperty(name,this._defaultValue[name]);
         }
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         return this._properties[name];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var oldValue:* = undefined;
         if(this._useCache[name] != null)
         {
            oldValue = this._properties[name];
            if(oldValue === value)
            {
               return;
            }
            this._properties[name] = value;
            if(Boolean(this._useCache[name]) && !(this._properties[name] is DisplayObject))
            {
               StoreDataManager.getInstance().setData(this._dataStore,name,value);
            }
            this._eventDispatcher.dispatchEvent(new PropertyChangeEvent(this,name,this._properties[name],oldValue));
         }
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         var x:* = undefined;
         if(index == 0)
         {
            this._item = new Array();
            for(x in this._properties)
            {
               this._item.push(x);
            }
         }
         if(index < this._item.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return this._item[index - 1];
      }
   }
}
