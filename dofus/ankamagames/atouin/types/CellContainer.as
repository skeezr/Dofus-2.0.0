package com.ankamagames.atouin.types
{
   import flash.display.Sprite;
   
   public class CellContainer extends Sprite
   {
       
      public var cellId:uint = 0;
      
      public var startX:int = 0;
      
      public var startY:int = 0;
      
      public var depth:int = 0;
      
      public function CellContainer(id:uint)
      {
         super();
         this.cellId = id;
         name = "Cell_" + this.cellId;
      }
   }
}
