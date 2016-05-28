package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class InventoryHookList
   {
      
      public static const StorageInventoryContent:Hook = new Hook("StorageInventoryContent",true);
      
      public static const StorageObjectUpdate:Hook = new Hook("StorageObjectUpdate",true);
      
      public static const StorageKamasUpdate:Hook = new Hook("StorageKamasUpdate",true);
      
      public static const StorageObjectRemove:Hook = new Hook("StorageObjectRemove",true);
      
      public static const ObjectMovement:Hook = new Hook("ObjectMovement",false);
      
      public static const EquipmentObjectMove:Hook = new Hook("EquipmentObjectMove",false);
      
      public static const ObjectWrapperMovement:Hook = new Hook("ObjectWrapperMovement",false);
      
      public static const InventoryWeight:Hook = new Hook("InventoryWeight",false);
      
      public static const ObjectAdded:Hook = new Hook("ObjectAdded",false);
      
      public static const ObjectDeleted:Hook = new Hook("ObjectDeleted",false);
      
      public static const ObjectQuantity:Hook = new Hook("ObjectQuantity",false);
      
      public static const ObjectModified:Hook = new Hook("ObjectModified",false);
      
      public static const InventoryContent:Hook = new Hook("InventoryContent",false);
      
      public static const StorageModChanged:Hook = new Hook("StorageModChanged",false);
      
      public static const KamasUpdate:Hook = new Hook("KamasUpdate",false);
      
      public static const BuffAdded:Hook = new Hook("BuffAdded",false);
      
      public static const BuffRemoved:Hook = new Hook("BuffRemoved",false);
      
      public static const OpenLivingObject:Hook = new Hook("OpenLivingObject",false);
       
      public function InventoryHookList()
      {
         super();
      }
   }
}
