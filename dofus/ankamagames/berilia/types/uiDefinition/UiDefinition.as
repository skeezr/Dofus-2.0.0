package com.ankamagames.berilia.types.uiDefinition
{
   public class UiDefinition
   {
       
      public var name:String;
      
      public var debug:Boolean = false;
      
      public var graphicTree:Array;
      
      public var kernelEvents:Array;
      
      public var shortcutsEvents:Array;
      
      public var constants:Array;
      
      public var className:String;
      
      public var useCache:Boolean = true;
      
      public var usePropertiesCache:Boolean = true;
      
      public var modal:Boolean = false;
      
      public var giveFocus:Boolean = true;
      
      public var scalable:Boolean = true;
      
      public function UiDefinition()
      {
         super();
         this.graphicTree = new Array();
         this.kernelEvents = new Array();
         this.shortcutsEvents = new Array();
         this.constants = new Array();
      }
   }
}
