package com.ankamagames.jerakine.resources.adapters.impl
{
   import com.ankamagames.jerakine.resources.adapters.AbstractUrlLoaderAdapter;
   import com.ankamagames.jerakine.resources.adapters.IAdapter;
   import com.ankamagames.jerakine.resources.ResourceType;
   
   public class TxtAdapter extends AbstractUrlLoaderAdapter implements IAdapter
   {
       
      public function TxtAdapter()
      {
         super();
      }
      
      override protected function getResource(dataFormat:String, data:*) : *
      {
         return data as String;
      }
      
      override protected function getResourceType() : uint
      {
         return ResourceType.RESOURCE_TXT;
      }
   }
}
