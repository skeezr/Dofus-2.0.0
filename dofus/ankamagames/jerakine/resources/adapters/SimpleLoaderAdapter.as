package com.ankamagames.jerakine.resources.adapters
{
   import flash.display.Loader;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.types.Uri;
   import flash.errors.IllegalOperationError;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.display.LoaderInfo;
   import com.ankamagames.jerakine.resources.ResourceType;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.ErrorEvent;
   import com.ankamagames.jerakine.resources.ResourceErrorCode;
   
   public class SimpleLoaderAdapter implements IAdapter
   {
       
      private var _ldr:Loader;
      
      private var _observer:IResourceObserver;
      
      private var _uri:Uri;
      
      private var _dispatchProgress:Boolean;
      
      public function SimpleLoaderAdapter()
      {
         super();
      }
      
      public function loadDirectly(uri:Uri, path:String, observer:IResourceObserver, dispatchProgress:Boolean) : void
      {
         if(this._ldr)
         {
            throw new IllegalOperationError("A single adapter can\'t handle two simultaneous loadings.");
         }
         this._observer = observer;
         this._uri = uri;
         this._dispatchProgress = dispatchProgress;
         this.prepareLoader();
         this._ldr.load(new URLRequest(path),uri.loaderContext);
      }
      
      public function loadFromData(uri:Uri, data:ByteArray, observer:IResourceObserver, dispatchProgress:Boolean) : void
      {
         if(this._ldr)
         {
            throw new IllegalOperationError("A single adapter can\'t handle two simultaneous loadings.");
         }
         this._observer = observer;
         this._uri = uri;
         this.prepareLoader();
         this._ldr.loadBytes(data);
      }
      
      public function free() : void
      {
         this.releaseLoader();
         this._observer = null;
         this._uri = null;
      }
      
      protected function getResource(ldr:LoaderInfo) : *
      {
         return this._ldr;
      }
      
      protected function getResourceType() : uint
      {
         return ResourceType.RESOURCE_NONE;
      }
      
      private function prepareLoader() : void
      {
         this._ldr = new Loader();
         this._ldr.contentLoaderInfo.addEventListener(Event.INIT,this.onInit);
         this._ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         if(this._dispatchProgress)
         {
            this._ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
      }
      
      private function releaseLoader() : void
      {
         if(this._ldr)
         {
            try
            {
               this._ldr.close();
            }
            catch(e:Error)
            {
            }
            this._ldr.contentLoaderInfo.removeEventListener(Event.INIT,this.onInit);
            this._ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._ldr.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
         this._ldr = null;
      }
      
      protected function onInit(e:Event) : void
      {
         var res:* = this.getResource(LoaderInfo(e.target));
         this._observer.onLoaded(this._uri,this.getResourceType(),res);
      }
      
      protected function onError(ee:ErrorEvent) : void
      {
         this.releaseLoader();
         this._observer.onFailed(this._uri,ee.text,ResourceErrorCode.RESOURCE_NOT_FOUND);
      }
      
      protected function onProgress(pe:ProgressEvent) : void
      {
         this._observer.onProgress(this._uri,pe.bytesLoaded,pe.bytesTotal);
      }
   }
}
