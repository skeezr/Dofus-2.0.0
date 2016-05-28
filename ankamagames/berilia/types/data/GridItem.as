package com.ankamagames.berilia.types.data
{
   import flash.display.DisplayObject;
   
   public class GridItem
   {
       
      public var index:uint;
      
      public var container:DisplayObject;
      
      public var data;
      
      public function GridItem(id:uint, c:DisplayObject, d:*)
      {
         super();
         this.index = id;
         this.container = c;
         this.data = d;
      }
   }
}
