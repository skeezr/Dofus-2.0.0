package com.ankamagames.berilia.types.uiDefinition
{
   import com.ankamagames.berilia.enums.StrataEnum;
   
   public class BasicElement
   {
       
      public var name:String;
      
      public var strata:uint;
      
      public var size:com.ankamagames.berilia.types.uiDefinition.SizeElement;
      
      public var minSize:com.ankamagames.berilia.types.uiDefinition.SizeElement;
      
      public var maxSize:com.ankamagames.berilia.types.uiDefinition.SizeElement;
      
      public var anchors:Array;
      
      public var event:Array;
      
      public var properties:Array;
      
      public var className:String;
      
      public var cachedWidth:int = 2.147483647E9;
      
      public var cachedHeight:int = 2.147483647E9;
      
      public var cachedX:int = 2.147483647E9;
      
      public var cachedY:int = 2.147483647E9;
      
      public function BasicElement()
      {
         this.strata = StrataEnum.STRATA_MEDIUM;
         this.event = new Array();
         this.properties = new Array();
         super();
      }
      
      public function setName(sName:String) : void
      {
         this.name = sName;
         this.properties["name"] = sName;
      }
      
      public function copy(target:BasicElement) : void
      {
         var key:* = null;
         target.strata = this.strata;
         target.size = this.size;
         target.minSize = this.minSize;
         target.maxSize = this.maxSize;
         target.anchors = this.anchors;
         target.event = this.event;
         target.properties = [];
         for(key in this.properties)
         {
            target.properties[key] = this.properties[key];
         }
         target.className = this.className;
         target.cachedWidth = this.cachedWidth;
         target.cachedHeight = this.cachedHeight;
         target.cachedX = this.cachedX;
         target.cachedY = this.cachedY;
         target.setName(this.name);
      }
   }
}
