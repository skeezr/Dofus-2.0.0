package com.ankamagames.berilia.components.messages
{
   import com.ankamagames.berilia.types.data.GridItem;
   import com.ankamagames.berilia.components.Grid;
   
   public class ItemRollOverMessage extends ComponentMessage
   {
       
      private var _gridItem:GridItem;
      
      public function ItemRollOverMessage(grid:Grid, gridItem:GridItem)
      {
         super(grid);
         this._gridItem = gridItem;
      }
      
      public function get item() : GridItem
      {
         return this._gridItem;
      }
   }
}
