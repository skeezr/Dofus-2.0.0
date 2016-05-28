package com.ankamagames.jerakine.resources.protocols.impl
{
   import com.ankamagames.jerakine.resources.protocols.IProtocol;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   
   public class ModProtocol extends FileProtocol implements IProtocol
   {
      
      public static var MODULE_ROOT_PATH:String;
       
      public function ModProtocol()
      {
         super();
      }
      
      public static function getAbsoluteUri(uri:Uri) : String
      {
         return MODULE_ROOT_PATH + uri.path;
      }
      
      override protected function loadDirectly(uri:Uri, observer:IResourceObserver, dispatchProgress:Boolean, forcedAdapter:Class) : void
      {
         getAdapter(uri,forcedAdapter);
         _adapter.loadDirectly(uri,MODULE_ROOT_PATH + uri.path,observer,dispatchProgress);
      }
   }
}
