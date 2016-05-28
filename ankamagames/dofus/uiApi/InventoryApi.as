package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import flash.utils.Dictionary;
   import com.ankamagames.dofusModuleLibrary.enum.inventory.EquipementItemPosition;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class InventoryApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function InventoryApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(InventoryApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getStorageObjectGID(pObjectGID:uint, quantity:uint = 1) : Object
      {
         var iw:ItemWrapper = null;
         var inventoryDictionary:Dictionary = (Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame).inventoryDictionary;
         var returnItems:Array = new Array();
         var numberReturn:uint = 0;
         if(inventoryDictionary[pObjectGID] != null)
         {
            for each(iw in inventoryDictionary[pObjectGID])
            {
               if(iw.position >= 63)
               {
                  if(iw.quantity >= quantity - numberReturn)
                  {
                     returnItems.push({
                        "objectUID":iw.objectUID,
                        "quantity":quantity - numberReturn
                     });
                     numberReturn = quantity;
                     return returnItems;
                  }
                  returnItems.push({
                     "objectUID":iw.objectUID,
                     "quantity":iw.quantity
                  });
                  numberReturn = numberReturn + iw.quantity;
               }
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getItemQty(pObjectGID:uint) : uint
      {
         var item:ItemWrapper = null;
         var quantity:uint = 0;
         var inventoryDictionary:Dictionary = (Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame).inventoryDictionary;
         if(inventoryDictionary[pObjectGID] == null)
         {
            return 0;
         }
         for each(item in inventoryDictionary[pObjectGID])
         {
            if(item.position >= 63)
            {
               quantity = quantity + item.quantity;
            }
         }
         return quantity;
      }
      
      [Untrusted]
      public function getEquipementItemByPosition(pPosition:uint) : Object
      {
         if(pPosition > 15)
         {
            return null;
         }
         var equipementDictionary:Dictionary = (Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame).equipmentDictionary;
         return equipementDictionary[pPosition];
      }
      
      [Untrusted]
      public function getCurrentWeapon() : ItemWrapper
      {
         return this.getEquipementItemByPosition(EquipementItemPosition.WEAPON_POSITION) as ItemWrapper;
      }
   }
}
