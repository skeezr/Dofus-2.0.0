package com.ankamagames.jerakine.script
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.script.runners.IRunner;
   import com.ankamagames.jerakine.types.Callback;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.logger.Log;
   
   public class ScriptExec
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ScriptExec));
      
      private static const SCRIPT_CACHE_SIZE:uint = 5;
      
      private static var _prepared:Boolean;
      
      private static var _scriptCache:ICache;
      
      private static var _rld:IResourceLoader;
      
      private static var _runners:Dictionary;
       
      public function ScriptExec()
      {
         super();
      }
      
      public static function exec(scriptUri:Uri, runner:IRunner, useCache:Boolean = true, successCallback:Callback = null, errorCallback:Callback = null) : void
      {
         if(!_prepared)
         {
            prepare();
         }
         var obj:Object = new Object();
         obj.runner = runner;
         obj.success = successCallback;
         obj.error = errorCallback;
         var uriSum:String = scriptUri.toSum();
         if(!scriptUri.loaderContext)
         {
            scriptUri.loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         }
         if(_runners[uriSum])
         {
            (_runners[uriSum] as Array).push(obj);
         }
         else
         {
            _runners[uriSum] = [obj];
         }
         _rld.load(scriptUri,!!useCache?_scriptCache:null);
      }
      
      private static function prepare() : void
      {
         _rld = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         _rld.addEventListener(ResourceLoadedEvent.LOADED,onLoaded);
         _rld.addEventListener(ResourceErrorEvent.ERROR,onError);
         _scriptCache = Cache.create(SCRIPT_CACHE_SIZE,new LruGarbageCollector(),getQualifiedClassName(ScriptExec));
         _runners = new Dictionary(true);
         _prepared = true;
      }
      
      private static function onLoaded(rle:ResourceLoadedEvent) : void
      {
         var obj:Object = null;
         var returnCode:uint = 0;
         var uriSum:String = rle.uri.toSum();
         var isFailed:Boolean = false;
         if(rle.resourceType != ResourceType.RESOURCE_DX)
         {
            _log.error("Cannot execute " + rle.uri + "; not a script.");
            isFailed = true;
         }
         for each(obj in _runners[uriSum])
         {
            if(isFailed)
            {
               if(obj.error)
               {
                  Callback(obj.error).exec();
               }
            }
            else
            {
               returnCode = (obj.runner as IRunner).run(rle.resource as Class);
               if(returnCode)
               {
                  if(obj.error)
                  {
                     Callback(obj.error).exec();
                  }
               }
               else if(obj.success)
               {
                  Callback(obj.success).exec();
               }
            }
         }
         delete _runners[uriSum];
      }
      
      private static function onError(ree:ResourceErrorEvent) : void
      {
         var obj:Object = null;
         _log.error("Cannot execute " + ree.uri + "; script not found (" + ree.errorMsg + ").");
         var uriSum:String = ree.uri.toSum();
         for each(obj in _runners[uriSum])
         {
            if(obj.error)
            {
               Callback(obj.error).exec();
            }
         }
         delete _runners[uriSum];
      }
   }
}
