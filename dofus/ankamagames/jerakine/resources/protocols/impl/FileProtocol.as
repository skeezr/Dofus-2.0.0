package com.ankamagames.jerakine.resources.protocols.impl
{
   import com.ankamagames.jerakine.resources.protocols.AbstractProtocol;
   import com.ankamagames.jerakine.resources.protocols.IProtocol;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.newCache.ICache;
   
   public class FileProtocol extends AbstractProtocol implements IProtocol, IResourceObserver
   {
      
      private static var _loadingFile:Dictionary = new Dictionary(true);
       
      public function FileProtocol()
      {
         super();
      }
      
      public function load(uri:Uri, observer:IResourceObserver, dispatchProgress:Boolean, cache:ICache, forcedAdapter:Class) : void
      {
         if(_loadingFile[uri.normalizedUri])
         {
            _loadingFile[uri.normalizedUri].push(observer);
         }
         else
         {
            _loadingFile[uri.normalizedUri] = [observer];
            loadDirectly(uri,this,dispatchProgress,forcedAdapter);
         }
      }
      
      override protected function release() : void
      {
      }
      
      public function onLoaded(uri:Uri, resourceType:uint, resource:*) : void
      {
         var waiting:Array = null;
         var observer:IResourceObserver = null;
         if(Boolean(_loadingFile[uri.normalizedUri]) && Boolean(_loadingFile[uri.normalizedUri].length))
         {
            waiting = _loadingFile[uri.normalizedUri];
            delete _loadingFile[uri.normalizedUri];
            for each(observer in waiting)
            {
               IResourceObserver(observer).onLoaded(uri,resourceType,resource);
            }
         }
      }
      
      public function onFailed(uri:Uri, errorMsg:String, errorCode:uint) : void
      {
         var waiting:Array = null;
         var observer:IResourceObserver = null;
         if(Boolean(_loadingFile[uri.normalizedUri]) && Boolean(_loadingFile[uri.normalizedUri].length))
         {
            waiting = _loadingFile[uri.normalizedUri];
            delete _loadingFile[uri.normalizedUri];
            for each(observer in waiting)
            {
               IResourceObserver(observer).onFailed(uri,errorMsg,errorCode);
            }
         }
      }
      
      public function onProgress(uri:Uri, bytesLoaded:uint, bytesTotal:uint) : void
      {
         var waiting:Array = null;
         var observer:IResourceObserver = null;
         if(Boolean(_loadingFile[uri.normalizedUri]) && Boolean(_loadingFile[uri.normalizedUri]) && Boolean(_loadingFile[uri.normalizedUri].length))
         {
            waiting = _loadingFile[uri.normalizedUri];
            delete _loadingFile[uri.normalizedUri];
            for each(observer in waiting)
            {
               IResourceObserver(observer).onProgress(uri,bytesLoaded,bytesTotal);
            }
         }
      }
   }
}
