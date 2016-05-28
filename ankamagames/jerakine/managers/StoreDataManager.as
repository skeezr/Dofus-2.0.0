package com.ankamagames.jerakine.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.DataStoreType;
   import flash.net.SharedObject;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import flash.utils.IExternalizable;
   import com.ankamagames.jerakine.interfaces.Secure;
   import com.ankamagames.jerakine.utils.crypto.MD5;
   import com.ankamagames.jerakine.types.events.RegisterClassLogEvent;
   import flash.net.registerClassAlias;
   import flash.utils.getDefinitionByName;
   import com.ankamagames.jerakine.JerakineConstants;
   import flash.utils.Dictionary;
   import flash.net.ObjectEncoding;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class StoreDataManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.managers.StoreDataManager));
      
      private static var _self:com.ankamagames.jerakine.managers.StoreDataManager;
       
      private var _aData:Array;
      
      private var _bStoreSequence:Boolean;
      
      private var _nCurrentSequenceNum:uint = 0;
      
      private var _aStoreSequence:Array;
      
      private var _aSharedObjectCache:Array;
      
      private var _aRegisteredClassAlias:Array;
      
      private var _describeType:Function;
      
      public function StoreDataManager()
      {
         var oClass:Class = null;
         var s:String = null;
         this._describeType = DescribeTypeCache.typeDescription;
         super();
         if(_self != null)
         {
            throw new SingletonError("DataManager is a singleton and should not be instanciated directly.");
         }
         this._bStoreSequence = false;
         this._aData = new Array();
         this._aSharedObjectCache = new Array();
         this._aRegisteredClassAlias = new Array();
         var aClass:Array = this.getData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList");
         for(s in aClass)
         {
            _log.logDirectly(new RegisterClassLogEvent(s));
            try
            {
               oClass = Class(getDefinitionByName(s));
               registerClassAlias(aClass[s],oClass);
            }
            catch(e:ReferenceError)
            {
               _log.warn("Impossible de trouver la classe " + s);
            }
            this._aRegisteredClassAlias[s] = true;
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.managers.StoreDataManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.jerakine.managers.StoreDataManager();
         }
         return _self;
      }
      
      public function getData(dataType:DataStoreType, sKey:String) : *
      {
         var so:SharedObject = null;
         if(dataType.persistant)
         {
            switch(dataType.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  so = this.getSharedObject(dataType.category);
                  return so.data[sKey];
               case DataStoreEnum.LOCATION_SERVER:
            }
            return;
         }
         if(this._aData[dataType.category] != null)
         {
            return this._aData[dataType.category][sKey];
         }
         return null;
      }
      
      public function registerClass(oInstance:*, deepClassScan:Boolean = false, keepClassInSo:Boolean = true) : void
      {
         var className:String = null;
         var sAlias:String = null;
         var aClassAlias:Array = null;
         var desc:Object = null;
         var key:String = null;
         if(oInstance is IExternalizable)
         {
            throw new ArgumentError("Can\'t store a customized IExternalizable in a shared object.");
         }
         if(oInstance is Secure)
         {
            throw new ArgumentError("Can\'t store a Secure class");
         }
         if(this.isComplexType(oInstance))
         {
            className = getQualifiedClassName(oInstance);
            if(this._aRegisteredClassAlias[className] == null)
            {
               sAlias = MD5.hash(className);
               _log.logDirectly(new RegisterClassLogEvent(className));
               try
               {
                  registerClassAlias(sAlias,Class(getDefinitionByName(className)));
               }
               catch(e:Error)
               {
                  _aRegisteredClassAlias[className] = true;
                  _log.fatal("Impossible de trouver la classe " + className + " dans l\'application domain courant");
                  return;
               }
               if(keepClassInSo)
               {
                  aClassAlias = this.getSetData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList",new Array());
                  aClassAlias[className] = sAlias;
                  this.setData(JerakineConstants.DATASTORE_CLASS_ALIAS,"classAliasList",aClassAlias);
               }
               this._aRegisteredClassAlias[className] = true;
            }
            else
            {
               return;
            }
         }
         if(deepClassScan)
         {
            if(oInstance is Array || oInstance is Vector.<*> || oInstance is Vector.<uint>)
            {
               desc = oInstance;
            }
            else
            {
               desc = this.scanType(oInstance);
            }
            for(key in desc)
            {
               if(this.isComplexType(oInstance[key]))
               {
                  this.registerClass(oInstance[key],true);
               }
               if(desc === oInstance)
               {
                  break;
               }
            }
         }
      }
      
      public function getClass(item:Object) : void
      {
         var s:* = undefined;
         var description:XML = this._describeType(item);
         this.registerClass(item);
         for(s in description..accessor)
         {
            if(this.isComplexType(s))
            {
               this.getClass(s);
            }
         }
      }
      
      public function setData(dataType:DataStoreType, sKey:String, oValue:*, deepClassScan:Boolean = false) : void
      {
         var so:SharedObject = null;
         if(this._aData[dataType.category] == null)
         {
            this._aData[dataType.category] = new Dictionary(true);
         }
         this._aData[dataType.category][sKey] = oValue;
         if(dataType.persistant)
         {
            switch(dataType.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  this.registerClass(oValue,deepClassScan);
                  so = this.getSharedObject(dataType.category);
                  so.data[sKey] = oValue;
                  if(!this._bStoreSequence)
                  {
                     so.flush();
                  }
                  else
                  {
                     this._aStoreSequence[dataType.category] = dataType;
                  }
                  break;
               case DataStoreEnum.LOCATION_SERVER:
            }
         }
      }
      
      public function getSetData(dataType:DataStoreType, sKey:String, oValue:*) : *
      {
         var o:* = this.getData(dataType,sKey);
         if(o != null)
         {
            return o;
         }
         this.setData(dataType,sKey,oValue);
         return oValue;
      }
      
      public function startStoreSequence() : void
      {
         this._bStoreSequence = true;
         if(!this._nCurrentSequenceNum)
         {
            this._aStoreSequence = new Array();
         }
         this._nCurrentSequenceNum++;
      }
      
      public function stopStoreSequence() : void
      {
         var dt:DataStoreType = null;
         var s:* = null;
         this._bStoreSequence = --this._nCurrentSequenceNum != 0;
         if(this._bStoreSequence)
         {
            return;
         }
         for(s in this._aStoreSequence)
         {
            dt = this._aStoreSequence[s];
            switch(dt.location)
            {
               case DataStoreEnum.LOCATION_LOCAL:
                  this.getSharedObject(dt.category).flush();
                  continue;
               case DataStoreEnum.LOCATION_SERVER:
                  continue;
               default:
                  continue;
            }
         }
         this._aStoreSequence = null;
      }
      
      public function clear(dataType:DataStoreType) : void
      {
         this._aData = new Array();
         var so:SharedObject = this.getSharedObject(dataType.category);
         so.clear();
         so.flush();
      }
      
      public function reset() : void
      {
         var s:SharedObject = null;
         for each(s in this._aSharedObjectCache)
         {
            s.clear();
            s.flush();
            s.close();
         }
         this._aSharedObjectCache = [];
         _self = null;
      }
      
      public function close(dataType:DataStoreType) : void
      {
         switch(dataType.location)
         {
            case DataStoreEnum.LOCATION_LOCAL:
               this._aSharedObjectCache[dataType.category].close();
               delete this._aSharedObjectCache[dataType.category];
         }
      }
      
      private function getSharedObject(sName:String) : SharedObject
      {
         if(this._aSharedObjectCache[sName] != null)
         {
            return this._aSharedObjectCache[sName];
         }
         var so:SharedObject = SharedObject.getLocal(sName);
         so.objectEncoding = ObjectEncoding.AMF3;
         this._aSharedObjectCache[sName] = so;
         return so;
      }
      
      private function isComplexType(o:*) : Boolean
      {
         switch(true)
         {
            case o is int:
            case o is uint:
            case o is Number:
            case o is Boolean:
            case o is Array:
            case o is String:
            case o == null:
            case o == undefined:
               return false;
            default:
               return true;
         }
      }
      
      private function isComplexTypeFromString(name:String) : Boolean
      {
         switch(name)
         {
            case "int":
            case "uint":
            case "Number":
            case "Boolean":
            case "Array":
            case "String":
               return false;
            default:
               if(this._aRegisteredClassAlias[name])
               {
                  return false;
               }
               return true;
         }
      }
      
      private function scanType(obj:*) : Object
      {
         var accessor:XML = null;
         var variable:XML = null;
         var result:Object = new Object();
         var def:XML = this._describeType(obj);
         for each(accessor in def..accessor)
         {
            if(this.isComplexTypeFromString(accessor.@type))
            {
               result[accessor.@name] = true;
            }
         }
         for each(variable in def..variable)
         {
            if(this.isComplexTypeFromString(variable.@type))
            {
               result[variable.@name] = true;
            }
         }
         return result;
      }
   }
}
