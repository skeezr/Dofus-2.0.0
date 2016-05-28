package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedMessage;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeKamaModifiedMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   
   public class CommonExchangeManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CommonExchangeManagementFrame));
       
      private var _exchangeType:uint;
      
      private var _roleplayContextFrame:RoleplayContextFrame;
      
      private var _craftFrame:com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
      
      private var _displayedInventory:Array;
      
      private var _displayedKamas:uint;
      
      public function CommonExchangeManagementFrame(parentFrame:RoleplayContextFrame, pExchangeType:uint)
      {
         super();
         this._exchangeType = pExchangeType;
         this._roleplayContextFrame = parentFrame;
         switch(pExchangeType)
         {
            case ExchangeTypeEnum.CRAFT:
               this._craftFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.common.frames.CraftFrame) as com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
         }
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get craftFrame() : com.ankamagames.dofus.logic.game.common.frames.CraftFrame
      {
         if(this._craftFrame == null)
         {
            this._craftFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.common.frames.CraftFrame) as com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
         }
         return this._craftFrame;
      }
      
      public function get displayedInventory() : Array
      {
         return this._displayedInventory;
      }
      
      public function get displayedKamas() : uint
      {
         return this._displayedKamas;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var ldrmsg:LeaveDialogRequestMessage = null;
         var eommsg:ExchangeObjectModifiedMessage = null;
         var iwModified:ItemWrapper = null;
         var eomsgqty:int = 0;
         var eoamsg:ExchangeObjectAddedMessage = null;
         var iwAdded:ItemWrapper = null;
         var eormsg:ExchangeObjectRemovedMessage = null;
         var ekmmsg:ExchangeKamaModifiedMessage = null;
         var eomitem:ItemWrapper = null;
         var eormsgqty:int = 0;
         var eormitem:ItemWrapper = null;
         switch(true)
         {
            case msg is LeaveShopStockAction:
               ldrmsg = new LeaveDialogRequestMessage();
               ldrmsg.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(ldrmsg);
               return true;
            case msg is ExchangeObjectModifiedMessage:
               eommsg = msg as ExchangeObjectModifiedMessage;
               iwModified = ItemWrapper.create(eommsg.object.position,eommsg.object.objectUID,eommsg.object.objectGID,eommsg.object.quantity,eommsg.object.effects,false);
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.modifyCraftComponent(eommsg.remote,iwModified);
               }
               for each(eomitem in PlayedCharacterManager.getInstance().inventory)
               {
                  if(eomitem.objectUID == iwModified.objectUID)
                  {
                     eomsgqty = eomitem.quantity - iwModified.quantity;
                     eomitem.effects = iwModified.effects;
                     this.updateDisplayedInventoryObject(iwModified,true,eomsgqty,false);
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this.displayedInventory,this.displayedKamas);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectModified,iwModified);
               return true;
            case msg is ExchangeObjectAddedMessage:
               eoamsg = msg as ExchangeObjectAddedMessage;
               iwAdded = ItemWrapper.create(eoamsg.object.position,eoamsg.object.objectUID,eoamsg.object.objectGID,eoamsg.object.quantity,eoamsg.object.effects,false);
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.addCraftComponent(eoamsg.remote,iwAdded);
               }
               if(!eoamsg.remote)
               {
                  this.updateDisplayedInventoryObject(iwAdded,false,-iwAdded.quantity);
                  if(this._exchangeType != ExchangeTypeEnum.CRAFT)
                  {
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this.displayedInventory,this.displayedKamas);
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectAdded,iwAdded);
               return true;
            case msg is ExchangeObjectRemovedMessage:
               eormsg = msg as ExchangeObjectRemovedMessage;
               switch(this._exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                     this.craftFrame.removeCraftComponent(eormsg.remote,eormsg.objectUID);
               }
               if(!eormsg.remote)
               {
                  for each(eormitem in PlayedCharacterManager.getInstance().inventory)
                  {
                     if(eormitem.objectUID == eormsg.objectUID)
                     {
                        this.updateDisplayedInventoryObject(eormitem,true,eormitem.quantity);
                        if(this._exchangeType != ExchangeTypeEnum.CRAFT)
                        {
                           KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this.displayedInventory,this.displayedKamas);
                        }
                        break;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeObjectRemoved,eormsg.objectUID);
               return true;
            case msg is ExchangeKamaModifiedMessage:
               ekmmsg = msg as ExchangeKamaModifiedMessage;
               if(!ekmmsg.remote)
               {
                  this._displayedKamas = PlayedCharacterManager.getInstance().characteristics.kamas - ekmmsg.quantity;
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this.displayedInventory,this.displayedKamas);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeKamaModified,ekmmsg.quantity,ekmmsg.remote);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function synchronizeDisplayedInventory() : void
      {
         var item:Object = null;
         var pcm:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         this._displayedInventory = new Array();
         for each(item in pcm.inventory)
         {
            this._displayedInventory.push(item.clone());
         }
         this._displayedKamas = pcm.characteristics.kamas;
      }
      
      public function updateDisplayedInventoryObject(object:ItemWrapper, absolute:Boolean, qty:int, addIfNotExist:Boolean = true) : void
      {
         var newqty:int = 0;
         var newItem:ItemWrapper = null;
         for(var i:int = 0; i < this._displayedInventory.length; i++)
         {
            if(this._displayedInventory[i].objectUID == object.objectUID)
            {
               if(absolute)
               {
                  newqty = qty;
               }
               else
               {
                  newqty = this._displayedInventory[i].quantity + qty;
               }
               if(newqty <= 0)
               {
                  this._displayedInventory.splice(i,1);
               }
               else
               {
                  this._displayedInventory[i].quantity = newqty;
                  this._displayedInventory[i].effects = object.effects;
               }
               return;
            }
         }
         if(addIfNotExist)
         {
            newItem = object.clone();
            newItem.quantity = qty;
            this._displayedInventory.push(newItem);
         }
      }
   }
}
