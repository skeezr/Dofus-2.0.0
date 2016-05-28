package com.ankamagames.jerakine.resources.adapters.impl
{
   import com.ankamagames.jerakine.resources.adapters.IAdapter;
   import flash.media.Sound;
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
   
   public class MP3Adapter implements IAdapter
   {
       
      private var _sound:Sound;
      
      private var _observer:IResourceObserver;
      
      private var _uri:Uri;
      
      private var _dispatchProgress:Boolean;
      
      public function MP3Adapter()
      {
         super();
      }
      
      public function loadDirectly(uri:Uri, path:String, observer:IResourceObserver, dispatchProgress:Boolean) : void
      {
         if(this._sound)
         {
            throw new IllegalOperationError("A single adapter can\'t handle two simultaneous loadings.");
         }
         this._observer = observer;
         this._uri = uri;
         this._dispatchProgress = dispatchProgress;
         this.prepareLoader();
         this._sound.load(new URLRequest(path));
      }
      
      public function loadFromData(uri:Uri, data:ByteArray, observer:IResourceObserver, dispatchProgress:Boolean) : void
      {
         throw new IllegalOperationError("loadFromData can\'t be called from an MP3Adapter");
      }
      
      public function free() : void
      {
         this.releaseLoader();
         this._observer = null;
         this._uri = null;
      }
      
      protected function getResource(ldr:LoaderInfo) : *
      {
         return this._sound;
      }
      
      protected function getResourceType() : uint
      {
         return ResourceType.RESOURCE_MP3;
      }
      
      private function prepareLoader() : void
      {
         this._sound = new Sound();
         this._sound.addEventListener(Event.COMPLETE,this.onInit);
         this._sound.addEventListener(IOErrorEvent.IO_ERROR,this.onError);
         if(this._dispatchProgress)
         {
            this._sound.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
      }
      
      private function releaseLoader() : void
      {
         if(this._sound)
         {
            try
            {
               this._sound.close();
            }
            catch(e:Error)
            {
            }
            this._sound.removeEventListener(Event.COMPLETE,this.onInit);
            this._sound.removeEventListener(IOErrorEvent.IO_ERROR,this.onError);
            this._sound.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
         this._sound = null;
      }
      
      protected function onInit(e:Event) : void
      {
         var res:* = e.target as Sound;
         this.releaseLoader();
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
