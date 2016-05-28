package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.inventory.items.InventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectAddedMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectsAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectQuantityMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.KamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.InventoryWeightMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectMovementMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectSetPositionAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectSetPositionMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDeletedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectsDeletedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.DeleteObjectAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDeleteMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectUseAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectDropAction;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectUseOnCellMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectUseOnCellAction;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDropMessage;
   import com.ankamagames.dofus.network.enums.CharacterInventoryPositionEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.kernel.sound.enum.SoundTypeEnum;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectDice;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectUseOnCharacterMessage;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectUseMessage;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayPointCellFrame;
   
   public class InventoryManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InventoryManagementFrame));
       
      private var _mountFrame:com.ankamagames.dofus.logic.game.common.frames.MountFrame = null;
      
      private var _objectUIDToDrop:int;
      
      private var _objectGIDToDrop:uint;
      
      private var _quantityToDrop:uint;
      
      private var _currentPointUseUIDObject:uint;
      
      private var _movingObjectUID:int;
      
      private var _movingObjectPreviousPosition:int;
      
      private var _inventoryDictionary:Dictionary;
      
      private var _equipmentDictionary:Dictionary;
      
      private var _soundApi:SoundApi;
      
      private var _mountCertificateList:Array;
      
      public function InventoryManagementFrame()
      {
         this._inventoryDictionary = new Dictionary();
         this._equipmentDictionary = new Dictionary();
         this._soundApi = new SoundApi();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get mountFrame() : com.ankamagames.dofus.logic.game.common.frames.MountFrame
      {
         if(this._mountFrame == null)
         {
            this._mountFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.common.frames.MountFrame) as com.ankamagames.dofus.logic.game.common.frames.MountFrame;
         }
         return this._mountFrame;
      }
      
      public function get inventoryDictionary() : Dictionary
      {
         return this._inventoryDictionary;
      }
      
      public function get equipmentDictionary() : Dictionary
      {
         return this._equipmentDictionary;
      }
      
      public function get mountCertificateList() : Array
      {
         return this._mountCertificateList;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var icmsg:InventoryContentMessage = null;
         var inventory:Array = null;
         var oam:ObjectAddedMessage = null;
         var item2:ObjectItem = null;
         var iwAdded:ItemWrapper = null;
         var osam:ObjectsAddedMessage = null;
         var oqm:ObjectQuantityMessage = null;
         var changedItem:ItemWrapper = null;
         var kumsg:KamasUpdateMessage = null;
         var iwmsg:InventoryWeightMessage = null;
         var ommsg:ObjectMovementMessage = null;
         var itemMoved:ItemWrapper = null;
         var ospa:ObjectSetPositionAction = null;
         var itw:ItemWrapper = null;
         var ospmsg:ObjectSetPositionMessage = null;
         var omdmsg:ObjectModifiedMessage = null;
         var itemModified:ItemWrapper = null;
         var odmsg:ObjectDeletedMessage = null;
         var itemDeleted:ItemWrapper = null;
         var osdmsg:ObjectsDeletedMessage = null;
         var doa:DeleteObjectAction = null;
         var odmsg2:ObjectDeleteMessage = null;
         var oua:ObjectUseAction = null;
         var iw:ItemWrapper = null;
         var oda:ObjectDropAction = null;
         var itemItem:Item = null;
         var objectName:String = null;
         var ouocmsg:ObjectUseOnCellMessage = null;
         var ouoca:ObjectUseOnCellAction = null;
         var item:ObjectItem = null;
         var itemWra:ItemWrapper = null;
         var osait:ObjectItem = null;
         var osaiw:ItemWrapper = null;
         var modified:Boolean = false;
         var it:ItemWrapper = null;
         var lastPosition:uint = 0;
         var effect:ObjectEffect = null;
         var inventoryDelete:Array = null;
         var dicIndex:uint = 0;
         var osdit:uint = 0;
         var osdid:ItemWrapper = null;
         var osdind:Array = null;
         var osddi:uint = 0;
         var commonMod:Object = null;
         var f:Function = null;
         var odropmsg:ObjectDropMessage = null;
         switch(true)
         {
            case msg is InventoryContentMessage:
               if(getQualifiedClassName(msg) != getQualifiedClassName(InventoryContentMessage))
               {
                  return false;
               }
               icmsg = msg as InventoryContentMessage;
               this._mountCertificateList = new Array();
               inventory = new Array();
               for each(item in icmsg.objects)
               {
                  if(this._inventoryDictionary[item.objectGID] == null)
                  {
                     this._inventoryDictionary[item.objectGID] = new Vector.<ItemWrapper>();
                  }
                  itemWra = ItemWrapper.create(item.position,item.objectUID,item.objectGID,item.quantity,item.effects);
                  inventory.push(itemWra);
                  if(item.position <= 15)
                  {
                     this._equipmentDictionary[item.position] = itemWra;
                  }
                  this._inventoryDictionary[item.objectGID].push(itemWra);
                  if(item.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON)
                  {
                     PlayedCharacterManager.getInstance().currentWeapon = itemWra;
                  }
                  if(itemWra.isCertificate)
                  {
                     this.pushCertificate(itemWra);
                  }
               }
               PlayedCharacterManager.getInstance().inventory = inventory;
               if(PlayedCharacterManager.getInstance().characteristics)
               {
                  PlayedCharacterManager.getInstance().characteristics.kamas = icmsg.kamas;
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,inventory,icmsg.kamas);
               return true;
            case msg is ObjectAddedMessage:
               oam = msg as ObjectAddedMessage;
               item2 = oam.object;
               iwAdded = ItemWrapper.create(item2.position,item2.objectUID,item2.objectGID,item2.quantity,item2.effects);
               if(item2.position <= 15)
               {
                  this._equipmentDictionary[item2.position] = iwAdded;
               }
               if(this._inventoryDictionary[item2.objectGID] == null)
               {
                  this._inventoryDictionary[item2.objectGID] = new Vector.<ItemWrapper>();
               }
               this._inventoryDictionary[item2.objectGID].push(iwAdded);
               if(iwAdded.isCertificate)
               {
                  this.pushCertificate(iwAdded);
               }
               if(item2.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON)
               {
                  PlayedCharacterManager.getInstance().currentWeapon = iwAdded;
               }
               PlayedCharacterManager.getInstance().inventory.push(iwAdded);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,PlayedCharacterManager.getInstance().inventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               if(oam.object.position <= 15)
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectWrapperMovement,iwAdded);
               }
               if(item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_MUTATION || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_BOOST_FOOD || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FIRST_BONUS || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_SECOND_BONUS || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FIRST_MALUS || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_SECOND_MALUS || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_ROLEPLAY_BUFFER || item2.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FOLLOWER)
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.BuffAdded,iwAdded);
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectAdded,iwAdded);
               return true;
            case msg is ObjectsAddedMessage:
               osam = msg as ObjectsAddedMessage;
               for each(osait in osam.object)
               {
                  osaiw = ItemWrapper.create(osait.position,osait.objectUID,osait.objectGID,osait.quantity,osait.effects);
                  if(osaiw.isCertificate)
                  {
                     this.pushCertificate(osaiw);
                  }
                  modified = false;
                  if(osait.position <= 15)
                  {
                     this._equipmentDictionary[osait.position] = osaiw;
                  }
                  if(this._inventoryDictionary[osait.objectGID] == null)
                  {
                     this._inventoryDictionary[osait.objectGID] = new Vector.<ItemWrapper>();
                  }
                  else
                  {
                     for each(it in this._inventoryDictionary[osait.objectGID])
                     {
                        if(it.objectUID == osaiw.objectUID)
                        {
                           it.update(osait.position,osait.objectUID,osait.objectGID,osait.quantity,osait.effects);
                           if(osait.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON)
                           {
                              PlayedCharacterManager.getInstance().currentWeapon = it;
                           }
                           modified = true;
                           break;
                        }
                     }
                  }
                  if(!modified)
                  {
                     this._inventoryDictionary[osait.objectGID].push(osaiw);
                     PlayedCharacterManager.getInstance().inventory.push(osaiw);
                  }
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,PlayedCharacterManager.getInstance().inventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectAdded,null);
               return true;
            case msg is ObjectQuantityMessage:
               oqm = msg as ObjectQuantityMessage;
               if(this._objectUIDToDrop == oqm.objectUID)
               {
                  this._soundApi.playSound(SoundTypeEnum.DROP_ITEM);
                  this._objectUIDToDrop = -1;
               }
               changedItem = ItemWrapper.getItemFromUId(oqm.objectUID);
               if(changedItem)
               {
                  if(oqm.quantity > changedItem.quantity)
                  {
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectQuantity,changedItem,changedItem.quantity,oqm.quantity);
                  }
                  changedItem.quantity = oqm.quantity;
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,PlayedCharacterManager.getInstance().inventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               }
               else
               {
                  _log.error("Item UID " + oqm.objectUID + " not found into player inventory");
               }
               return true;
            case msg is KamasUpdateMessage:
               kumsg = msg as KamasUpdateMessage;
               if(PlayedCharacterManager.getInstance().characteristics)
               {
                  PlayedCharacterManager.getInstance().characteristics.kamas = kumsg.kamasTotal;
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.KamasUpdate,kumsg.kamasTotal);
               return true;
            case msg is InventoryWeightMessage:
               iwmsg = msg as InventoryWeightMessage;
               PlayedCharacterManager.getInstance().inventoryWeight = iwmsg.weight;
               PlayedCharacterManager.getInstance().inventoryWeightMax = iwmsg.weightMax;
               KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryWeight,iwmsg.weight,iwmsg.weightMax);
               return true;
            case msg is ObjectMovementMessage:
               ommsg = msg as ObjectMovementMessage;
               itemMoved = ItemWrapper.getItemFromUId(ommsg.objectUID);
               if(itemMoved)
               {
                  lastPosition = itemMoved.position;
                  itemMoved.position = ommsg.position;
                  if(ommsg.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON)
                  {
                     PlayedCharacterManager.getInstance().currentWeapon = itemMoved;
                  }
                  if(ommsg.position <= 15)
                  {
                     this._equipmentDictionary[ommsg.position] = itemMoved;
                  }
                  if(itemMoved.position <= 15)
                  {
                     this._equipmentDictionary[itemMoved.position] = null;
                  }
                  if(lastPosition != 63)
                  {
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.EquipmentObjectMove,lastPosition);
                  }
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectMovement,ommsg.objectUID,ommsg.position);
                  if(this._movingObjectUID == itemMoved.objectUID)
                  {
                     this._soundApi.playSound(SoundTypeEnum.MOVE_ITEM_TO_BAG);
                  }
                  this._movingObjectUID = -1;
                  this._movingObjectPreviousPosition = -1;
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectWrapperMovement,itemMoved);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,PlayedCharacterManager.getInstance().inventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               }
               return true;
            case msg is ObjectSetPositionAction:
               ospa = msg as ObjectSetPositionAction;
               itw = ItemWrapper.getItemFromUId(ospa.objectUID);
               this._movingObjectUID = ospa.objectUID;
               this._movingObjectPreviousPosition = itw.position;
               ospmsg = new ObjectSetPositionMessage();
               ospmsg.initObjectSetPositionMessage(ospa.objectUID,ospa.position,ospa.quantity);
               ConnectionsHandler.getConnection().send(ospmsg);
               return true;
            case msg is ObjectModifiedMessage:
               omdmsg = msg as ObjectModifiedMessage;
               itemModified = ItemWrapper.getItemFromUId(omdmsg.object.objectUID);
               if(itemModified)
               {
                  for each(effect in omdmsg.object.effects)
                  {
                     if(effect.actionId == 972)
                     {
                        itemModified.livingObjectSkin = (effect as ObjectEffectDice).diceConst;
                        break;
                     }
                  }
                  itemModified.update(omdmsg.object.position,omdmsg.object.objectUID,omdmsg.object.objectGID,omdmsg.object.quantity,omdmsg.object.effects);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectModified,itemModified);
               }
               return true;
            case msg is ObjectDeletedMessage:
               odmsg = msg as ObjectDeletedMessage;
               if(this._objectUIDToDrop == odmsg.objectUID)
               {
                  this._soundApi.playSound(SoundTypeEnum.DROP_ITEM);
                  this._objectUIDToDrop = -1;
               }
               itemDeleted = ItemWrapper.getItemFromUId(odmsg.objectUID);
               if(itemDeleted)
               {
                  if(itemDeleted.isCertificate)
                  {
                     this.removeCertificate(itemDeleted);
                  }
                  inventoryDelete = PlayedCharacterManager.getInstance().inventory;
                  if(itemDeleted.position <= 15)
                  {
                     this._equipmentDictionary[itemDeleted.position] = null;
                     delete this._equipmentDictionary[itemDeleted.position];
                  }
                  if(itemDeleted.position != 63)
                  {
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.EquipmentObjectMove,itemDeleted.position);
                  }
                  dicIndex = this._inventoryDictionary[itemDeleted.objectGID].indexOf(itemDeleted);
                  this._inventoryDictionary[itemDeleted.objectGID].splice([dicIndex],1);
                  inventoryDelete.splice(inventoryDelete.indexOf(itemDeleted),1);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectDeleted,odmsg.objectUID);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,inventoryDelete,PlayedCharacterManager.getInstance().characteristics.kamas);
                  if(itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_MUTATION || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_BOOST_FOOD || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FIRST_BONUS || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_SECOND_BONUS || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FIRST_MALUS || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_SECOND_MALUS || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_ROLEPLAY_BUFFER || itemDeleted.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_FOLLOWER)
                  {
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.BuffRemoved,itemDeleted);
                  }
               }
               return true;
            case msg is ObjectsDeletedMessage:
               osdmsg = msg as ObjectsDeletedMessage;
               for each(osdit in osdmsg.objectUID)
               {
                  osdid = ItemWrapper.getItemFromUId(osdit);
                  if(osdid)
                  {
                     osdind = PlayedCharacterManager.getInstance().inventory;
                     if(osdid.isCertificate)
                     {
                        this.removeCertificate(osdid);
                     }
                     if(osdid.position <= 15)
                     {
                        this._equipmentDictionary[osdid.position] = null;
                        delete this._equipmentDictionary[osdid.position];
                     }
                     osddi = this._inventoryDictionary[osdid.objectGID].indexOf(itemDeleted);
                     this._inventoryDictionary[osdid.objectGID].splice([osddi],1);
                     osdind.splice(osdind.indexOf(osdid),1);
                  }
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.ObjectDeleted,odmsg.objectUID);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,inventoryDelete,PlayedCharacterManager.getInstance().characteristics.kamas);
               return true;
            case msg is DeleteObjectAction:
               doa = msg as DeleteObjectAction;
               odmsg2 = new ObjectDeleteMessage();
               odmsg2.initObjectDeleteMessage(doa.objectUID,doa.quantity);
               ConnectionsHandler.getConnection().send(odmsg2);
               return true;
            case msg is ObjectUseAction:
               oua = msg as ObjectUseAction;
               iw = ItemWrapper.getItemFromUId(oua.objectUID);
               if(!iw)
               {
                  _log.error("Impossible de retrouver l\'objet d\'UID " + oua.objectUID);
                  return true;
               }
               if(!iw.usable && !iw.targetable)
               {
                  _log.error("L\'objet " + iw.name + " n\'est pas utilisable.");
                  return true;
               }
               if(iw.type.needUseConfirm)
               {
                  commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                  f = function():void
                  {
                     useItem(oua,iw);
                  };
                  commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.common.confirm")),I18n.getText(I18nProxy.getKeyId("ui.common.confirmationUseItem"),[iw.name]),[I18n.getText(I18nProxy.getKeyId("ui.common.yes")),I18n.getText(I18nProxy.getKeyId("ui.common.no"))],[f,null],f);
               }
               else
               {
                  this.useItem(oua,iw);
               }
               return true;
            case msg is ObjectDropAction:
               oda = msg as ObjectDropAction;
               if(Kernel.getWorker().contains(FightContextFrame))
               {
                  return true;
               }
               this._objectUIDToDrop = oda.objectUID;
               this._objectGIDToDrop = oda.objectGID;
               this._quantityToDrop = oda.quantity;
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               itemItem = Item.getItemById(oda.objectGID);
               objectName = itemItem.name;
               if(Dofus.getInstance().options.confirmItemDrop)
               {
                  commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.common.confirm")),I18n.getText(I18nProxy.getKeyId("ui.common.confirmationDropItem"),[oda.quantity,objectName]),[I18n.getText(I18nProxy.getKeyId("ui.common.yes")),I18n.getText(I18nProxy.getKeyId("ui.common.no"))],[this.onAcceptDrop,this.onRefuseDrop],this.onAcceptDrop,this.onRefuseDrop);
               }
               else
               {
                  odropmsg = new ObjectDropMessage();
                  odropmsg.initObjectDropMessage(this._objectUIDToDrop,this._quantityToDrop);
                  ConnectionsHandler.getConnection().send(odropmsg);
               }
               return true;
            case msg is ObjectUseOnCellAction:
               ouocmsg = new ObjectUseOnCellMessage();
               ouoca = msg as ObjectUseOnCellAction;
               ouocmsg.initObjectUseOnCellMessage(ouoca.objectUID,ouoca.targetedCell);
               ConnectionsHandler.getConnection().send(ouocmsg);
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function pushCertificate(itemWrapper:ItemWrapper) : void
      {
         this._mountCertificateList.push(itemWrapper);
         this.mountFrame.inventoryListUpdated(this._mountCertificateList);
      }
      
      public function removeCertificate(itemWrapper:ItemWrapper) : void
      {
         this._mountCertificateList.splice(this._mountCertificateList.indexOf(itemWrapper),1);
         this.mountFrame.inventoryListUpdated(this._mountCertificateList);
      }
      
      public function onAcceptDrop() : void
      {
         var odropmsg:ObjectDropMessage = new ObjectDropMessage();
         odropmsg.initObjectDropMessage(this._objectUIDToDrop,this._quantityToDrop);
         ConnectionsHandler.getConnection().send(odropmsg);
      }
      
      public function onRefuseDrop() : void
      {
      }
      
      private function onCellPointed(success:Boolean, cellId:uint, entityId:int) : void
      {
         var oucmsg:ObjectUseOnCellMessage = null;
         var ouCharmsg:ObjectUseOnCharacterMessage = null;
         if(success)
         {
            if(entityId < 0)
            {
               oucmsg = new ObjectUseOnCellMessage();
               oucmsg.initObjectUseOnCellMessage(this._currentPointUseUIDObject,cellId);
               ConnectionsHandler.getConnection().send(oucmsg);
            }
            else
            {
               ouCharmsg = new ObjectUseOnCharacterMessage();
               ouCharmsg.initObjectUseOnCharacterMessage(this._currentPointUseUIDObject,entityId);
               ConnectionsHandler.getConnection().send(ouCharmsg);
            }
         }
      }
      
      private function useItem(oua:ObjectUseAction, iw:ItemWrapper) : void
      {
         var cursorIcon:Texture = null;
         var oumsg:ObjectUseMessage = null;
         if(Boolean(oua.useOnCell) && Boolean(iw.targetable))
         {
            this._currentPointUseUIDObject = oua.objectUID;
            cursorIcon = new Texture();
            cursorIcon.uri = iw.iconUri;
            cursorIcon.finalize();
            Kernel.getWorker().addFrame(new RoleplayPointCellFrame(this.onCellPointed,cursorIcon));
         }
         else
         {
            oumsg = new ObjectUseMessage();
            oumsg.initObjectUseMessage(oua.objectUID);
            ConnectionsHandler.getConnection().send(oumsg);
         }
      }
   }
}
