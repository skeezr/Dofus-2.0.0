package com.ankamagames.jerakine.resources.loaders
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.resources.CacheableResource;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.ResourceError;
   import com.ankamagames.jerakine.resources.events.ResourceProgressEvent;
   
   public class AbstractRessourceLoader extends EventDispatcher implements IResourceObserver
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractRessourceLoader));
      
      protected static const RES_CACHE_PREFIX:String = "RES_";
       
      protected var _cache:ICache;
      
      protected var _completed:Boolean;
      
      protected var _filesLoaded:uint = 0;
      
      protected var _filesTotal:uint = 0;
      
      public function AbstractRessourceLoader()
      {
         super();
      }
      
      protected function checkCache(uri:Uri) : Boolean
      {
         var cr:CacheableResource = null;
         if(Boolean(this._cache) && Boolean(this._cache.contains(RES_CACHE_PREFIX + uri.toSum())))
         {
            cr = this._cache.peek(RES_CACHE_PREFIX + uri.toSum());
            this.dispatchSuccess(uri,cr.resourceType,cr.resource);
            return true;
         }
         return false;
      }
      
      protected function dispatchSuccess(uri:Uri, resourceType:uint, resource:*) : void
      {
         var rle:ResourceLoadedEvent = null;
         var rlpe:ResourceLoaderProgressEvent = null;
         this._filesLoaded++;
         if(hasEventListener(ResourceLoadedEvent.LOADED))
         {
            rle = new ResourceLoadedEvent(ResourceLoadedEvent.LOADED);
            rle.uri = uri;
            rle.resourceType = resourceType;
            rle.resource = resource;
            dispatchEvent(rle);
         }
         if(hasEventListener(ResourceLoaderProgressEvent.LOADER_PROGRESS))
         {
            rlpe = new ResourceLoaderProgressEvent(ResourceLoaderProgressEvent.LOADER_PROGRESS);
            rlpe.filesTotal = this._filesTotal;
            rlpe.filesLoaded = this._filesLoaded;
            dispatchEvent(rlpe);
         }
         if(this._filesLoaded == this._filesTotal)
         {
            this.dispatchComplete();
         }
      }
      
      protected function dispatchFailure(uri:Uri, errorMsg:String, errorCode:uint) : void
      {
         var ree:ResourceErrorEvent = null;
         this._filesLoaded++;
         if(hasEventListener(ResourceErrorEvent.ERROR))
         {
            ree = new ResourceErrorEvent(ResourceErrorEvent.ERROR);
            ree.uri = uri;
            ree.errorMsg = errorMsg;
            ree.errorCode = errorCode;
            dispatchEvent(ree);
            if(this._filesLoaded == this._filesTotal)
            {
               this.dispatchComplete();
            }
            return;
         }
         throw new ResourceError("[Error code " + errorCode.toString(16) + "] Unable to load resource " + uri + ": " + errorMsg);
      }
      
      private function dispatchComplete() : void
      {
         var rlpe:ResourceLoaderProgressEvent = null;
         if(!this._completed)
         {
            this._completed = true;
            rlpe = new ResourceLoaderProgressEvent(ResourceLoaderProgressEvent.LOADER_COMPLETE);
            rlpe.filesTotal = this._filesTotal;
            rlpe.filesLoaded = this._filesLoaded;
            dispatchEvent(rlpe);
         }
      }
      
      public function onLoaded(uri:Uri, resourceType:uint, resource:*) : void
      {
         var cr:CacheableResource = null;
         if(this._cache)
         {
            cr = new CacheableResource(resourceType,resource);
            this._cache.store(RES_CACHE_PREFIX + uri.toSum(),cr);
         }
         this.dispatchSuccess(uri,resourceType,resource);
      }
      
      public function onFailed(uri:Uri, errorMsg:String, errorCode:uint) : void
      {
         this.dispatchFailure(uri,errorMsg,errorCode);
      }
      
      public function onProgress(uri:Uri, bytesLoaded:uint, bytesTotal:uint) : void
      {
         var rpe:ResourceProgressEvent = new ResourceProgressEvent(ResourceProgressEvent.PROGRESS);
         rpe.uri = uri;
         rpe.bytesLoaded = bytesLoaded;
         rpe.bytesTotal = bytesTotal;
         dispatchEvent(rpe);
      }
   }
}
