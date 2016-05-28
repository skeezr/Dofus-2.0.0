package com.ankamagames.jerakine.resources.loaders
{
   import flash.events.IEventDispatcher;
   import com.ankamagames.jerakine.newCache.ICache;
   
   public interface IResourceLoader extends IEventDispatcher
   {
       
      function load(param1:*, param2:ICache = null, param3:Class = null) : void;
      
      function cancel() : void;
   }
}
