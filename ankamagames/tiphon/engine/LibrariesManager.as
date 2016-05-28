package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Timer;
   import flash.events.Event;
   import com.ankamagames.tiphon.types.GraphicLibrary;
   import flash.system.System;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.types.AnimLibrary;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import flash.events.TimerEvent;
   
   public class LibrariesManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(LibrariesManager));
      
      public static const TYPE_BONE:uint = 0;
      
      public static const TYPE_SKIN:uint = 1;
      
      private static var _url:String;
      
      private static var numLM:int = 0;
       
      private var _cache:Cache;
      
      private var _aResources:Dictionary;
      
      private var _aResourcesUri:Array;
      
      private var _aResourceStates:Array;
      
      private var _aWaiting:Array;
      
      private var _loader:IResourceLoader;
      
      private var _type:uint;
      
      private var _GarbageCollectorTimer:Timer;
      
      private var _currentCacheSize:int = 0;
      
      private var _libCurrentlyUsed:Dictionary;
      
      public var name:String;
      
      public function LibrariesManager(n:String, type:uint)
      {
         this._libCurrentlyUsed = new Dictionary(true);
         super();
         this.name = n;
         this._cache = Cache.create(30,new LruGarbageCollector(),getQualifiedClassName(this));
         this._aResources = new Dictionary();
         this._aResourceStates = new Array();
         this._aWaiting = new Array();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoadResource);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadFailedResource);
         this._type = type;
         numLM++;
         FPS.getInstance().watchArray("[Tiphon] _aResources " + numLM,this._aResources);
         FPS.getInstance().watchArray("[Tiphon] _libCurrentlyUsed " + numLM,this._libCurrentlyUsed);
         this._GarbageCollectorTimer = new Timer(2000);
         this._GarbageCollectorTimer.addEventListener(TimerEvent.TIMER,this.onGarbageCollector);
         this._GarbageCollectorTimer.start();
      }
      
      private function onGarbageCollector(E:Event) : void
      {
         var i:* = null;
         var librairy:GraphicLibrary = null;
         var gfxId:uint = 0;
         var clearBones:Boolean = false;
         var rl:Array = null;
         var num:int = 0;
         var k:int = 0;
         var weight:int = int(this._currentCacheSize / 10) + int(System.totalMemory / 50000000);
         this._currentCacheSize = 0;
         for(i in this._aResources)
         {
            librairy = this._aResources[i];
            if(librairy)
            {
               this._currentCacheSize++;
               if(librairy.weight < 0)
               {
                  gfxId = librairy.gfxId;
                  clearBones = true;
                  for each(rl in this._libCurrentlyUsed)
                  {
                     num = rl.length;
                     for(k = 0; k < num; k++)
                     {
                        if(gfxId == rl[k])
                        {
                           clearBones = false;
                           break;
                        }
                     }
                  }
                  if(clearBones)
                  {
                     delete this._aResources[i];
                  }
               }
               else
               {
                  librairy.weight = librairy.weight - weight;
               }
            }
         }
      }
      
      public function watchRessource(ts:TiphonSprite, id:uint) : void
      {
         var ressourcesList:Array = this._libCurrentlyUsed[ts];
         if(ressourcesList)
         {
            ressourcesList.push(id);
         }
         else
         {
            ressourcesList = new Array(1);
            ressourcesList[0] = id;
            this._libCurrentlyUsed[ts] = ressourcesList;
         }
      }
      
      public function addResource(id:uint, sUrl:String) : void
      {
         var gl:GraphicLibrary = null;
         var uri:Uri = null;
         if(_url == null)
         {
            _url = TiphonConstants.SWF_SKULL_PATH + "666.swl";
         }
         if(!this._aResources[id])
         {
            if(this._type == TYPE_BONE)
            {
               gl = new AnimLibrary(id,true);
            }
            else
            {
               gl = new GraphicLibrary(id,false);
            }
            this._aResources[id] = gl;
         }
         else
         {
            gl = this._aResources[id];
         }
         if(!gl.hasSwl(sUrl))
         {
            uri = new Uri(sUrl);
            uri.tag = id;
            _log.info("[" + this.name + "] Load " + uri);
            gl.updateSwfState(sUrl);
            this._loader.load(uri,null);
         }
      }
      
      public function askResource(id:uint, className:String, callback:Callback, errorCallback:Callback = null) : void
      {
         var gl:GraphicLibrary = null;
         if(!this.hasResource(id,className))
         {
            _log.error("Tiphon cache does not contains ressource " + id);
         }
         else
         {
            gl = this._aResources[id];
            if(gl.hasClassAvaible(className))
            {
               callback.exec();
            }
            else
            {
               if(!this._aWaiting[id])
               {
                  this._aWaiting[id] = new Object();
                  this._aWaiting[id]["ok"] = new Array();
                  this._aWaiting[id]["ko"] = new Array();
               }
               this._aWaiting[id]["ok"].push(callback);
               if(errorCallback)
               {
                  this._aWaiting[id]["ko"].push(errorCallback);
               }
            }
         }
      }
      
      public function removeResource(id:uint) : void
      {
         if(this._aWaiting[id])
         {
            delete this._aWaiting[id];
         }
         delete this._aResources[id];
      }
      
      public function isLoaded(id:uint, animClass:String = null) : Boolean
      {
         if(this._aResources[id] == false)
         {
            return false;
         }
         var lib:GraphicLibrary = this._aResources[id];
         if(animClass)
         {
            return lib != null && Boolean(lib.hasClassAvaible(animClass));
         }
         return Boolean(lib) && lib.getSwl() != null;
      }
      
      public function hasResource(id:uint, animClass:String = null) : Boolean
      {
         var lib:GraphicLibrary = this._aResources[id];
         return Boolean(lib) && Boolean(lib.hasClass(animClass));
      }
      
      public function getResourceById(resName:uint, animClass:String = null) : Swl
      {
         var lib:GraphicLibrary = this._aResources[resName];
         if(lib.isSingleFile)
         {
            return lib.getSwl();
         }
         return lib.getSwl(animClass);
      }
      
      private function onLoadResource(re:ResourceLoadedEvent) : void
      {
         var i:uint = 0;
         GraphicLibrary(this._aResources[re.uri.tag]).addSwl(re.resource,re.uri.uri);
         if(Boolean(this._aWaiting[re.uri.tag]) && Boolean(this._aWaiting[re.uri.tag]["ok"]))
         {
            for(i = 0; i < this._aWaiting[re.uri.tag]["ok"].length; i++)
            {
               Callback(this._aWaiting[re.uri.tag]["ok"][i]).exec();
            }
            delete this._aWaiting[re.uri.tag];
         }
      }
      
      private function onLoadFailedResource(re:ResourceErrorEvent) : void
      {
         _log.error("Unable to load " + re.uri + " (" + re.errorMsg + ")");
         delete this._aResources[re.uri.tag];
         this.addResource(re.uri.tag,_url);
      }
   }
}
