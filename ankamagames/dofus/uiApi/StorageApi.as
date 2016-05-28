package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   
   public class StorageApi
   {
      
      public static const ITEM_TYPE_TO_SERVER_POSITION:Array = [[],[0],[1],[2,4],[3],[5],[],[15],[1],[],[6],[7],[8],[9,10,11,12,13,14]];
       
      public function StorageApi()
      {
         super();
      }
      
      [Untrusted]
      public static function itemSuperTypeToServerPosition(superTypeId:uint) : Array
      {
         return ITEM_TYPE_TO_SERVER_POSITION[superTypeId];
      }
      
      [Untrusted]
      public static function getFood(itemType:int) : Vector.<ItemWrapper>
      {
         var item:ItemWrapper = null;
         var itemList:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         var inventory:Array = PlayedCharacterManager.getInstance().inventory;
         var nb:int = inventory.length;
         for(var i:int = 0; i < nb; i++)
         {
            item = inventory[i];
            if(!item.isLivingObject && item.type.id == itemType)
            {
               itemList.push(item);
            }
         }
         return itemList;
      }
   }
}
