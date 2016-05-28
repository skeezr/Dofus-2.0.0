package com.ankamagames.jerakine.resources.adapters.impl
{
   import com.ankamagames.jerakine.resources.adapters.AbstractLoaderAdapter;
   import com.ankamagames.jerakine.resources.adapters.IAdapter;
   import com.ankamagames.jerakine.types.ASwf;
   import flash.display.LoaderInfo;
   import com.ankamagames.jerakine.resources.ResourceType;
   import flash.events.Event;
   
   public class AdvancedSwfAdapter extends AbstractLoaderAdapter implements IAdapter
   {
       
      private var _aswf:ASwf;
      
      public function AdvancedSwfAdapter()
      {
         super();
      }
      
      override protected function getResource(ldr:LoaderInfo) : *
      {
         return this._aswf;
      }
      
      override protected function getResourceType() : uint
      {
         return ResourceType.RESOURCE_ASWF;
      }
      
      override protected function onInit(e:Event) : void
      {
         this._aswf = new ASwf(LoaderInfo(e.target).loader.content,LoaderInfo(e.target).applicationDomain,LoaderInfo(e.target).width,LoaderInfo(e.target).height);
         super.onInit(e);
      }
   }
}
