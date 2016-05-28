package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   
   [InstanciedApi]
   public class MountApi
   {
       
      private var _mountFrame:MountFrame = null;
      
      private var _inventoryFrame:InventoryManagementFrame = null;
      
      private var _roleplayContextFrame:RoleplayContextFrame = null;
      
      public function MountApi()
      {
         super();
      }
      
      private function get mountFrame() : MountFrame
      {
         if(!this._mountFrame)
         {
            this._mountFrame = Kernel.getWorker().getFrame(MountFrame) as MountFrame;
         }
         return this._mountFrame;
      }
      
      private function get inventoryFrame() : InventoryManagementFrame
      {
         if(!this._inventoryFrame)
         {
            this._inventoryFrame = Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame;
         }
         return this._inventoryFrame;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         if(!this._roleplayContextFrame)
         {
            this._roleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         }
         return this._roleplayContextFrame;
      }
      
      [Untrusted]
      public function getMount(modelId:uint) : Mount
      {
         return Mount.getMountById(modelId);
      }
      
      [Untrusted]
      public function getStableList() : Array
      {
         return this.mountFrame.stableList;
      }
      
      [Untrusted]
      public function getPaddockList() : Array
      {
         return this.mountFrame.paddockList;
      }
      
      [Untrusted]
      public function getInventoryList() : Array
      {
         return this.inventoryFrame.mountCertificateList;
      }
      
      [Untrusted]
      public function getCurrentPaddock() : Object
      {
         return this.roleplayContextFrame.currentPaddock;
      }
   }
}
