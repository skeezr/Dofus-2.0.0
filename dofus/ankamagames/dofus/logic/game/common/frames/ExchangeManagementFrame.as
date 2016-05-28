package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageInventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkTaxCollectorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageKamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeAcceptMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeReadyAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReadyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeIsReadyMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveKamaAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveKamaMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllToInvAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertAllToInvMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListToInvAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectTransfertListToInvMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemMinimalInformation;
   import com.ankamagames.dofus.misc.lists.StorageModList;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeAcceptAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRefuseAction;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   
   public class ExchangeManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExchangeManagementFrame));
       
      private var _roleplayContextFrame:RoleplayContextFrame;
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _movementFrame:RoleplayMovementFrame;
      
      private var _sourceInformations:GameRolePlayNamedActorInformations;
      
      private var _targetInformations:GameRolePlayNamedActorInformations;
      
      private var _meReady:Boolean = false;
      
      private var _youReady:Boolean = false;
      
      private var _exchangeInventory:Array;
      
      public function ExchangeManagementFrame(parentFrame:RoleplayContextFrame, movementframe:RoleplayMovementFrame)
      {
         super();
         this._roleplayContextFrame = parentFrame;
         this._roleplayEntitiesFrame = this._roleplayContextFrame.entitiesFrame;
         this._movementFrame = movementframe;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function initMountStock(objectsInfos:Vector.<ObjectItem>) : void
      {
         var item:ObjectItem = null;
         this._exchangeInventory = new Array();
         var nb:int = objectsInfos.length;
         for(var i:int = 0; i < nb; i++)
         {
            item = objectsInfos[i];
            this._exchangeInventory.push(ItemWrapper.create(item.position,item.objectUID,item.objectGID,item.quantity,item.effects));
         }
         this._kernelEventsManager.processCallback(InventoryHookList.StorageInventoryContent,this._exchangeInventory,0);
      }
      
      public function processExchangeRequestedTradeMessage(msg:ExchangeRequestedTradeMessage) : void
      {
         if(msg.exchangeType != ExchangeTypeEnum.PLAYER_TRADE)
         {
            return;
         }
         this._sourceInformations = this._roleplayEntitiesFrame.getEntityInfos(msg.source) as GameRolePlayNamedActorInformations;
         this._targetInformations = this._roleplayEntitiesFrame.getEntityInfos(msg.target) as GameRolePlayNamedActorInformations;
         var sourceName:String = this._sourceInformations.name;
         var targetName:String = this._targetInformations.name;
         if(msg.source == PlayedCharacterManager.getInstance().id)
         {
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterFromMe,sourceName,targetName);
         }
         else
         {
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterToMe,targetName,sourceName);
         }
      }
      
      public function processExchangeStartOkNpcTradeMessage(msg:ExchangeStartOkNpcTradeMessage) : void
      {
         var sourceName:String = PlayedCharacterManager.getInstance().infos.name;
         var NPCId:int = this._roleplayEntitiesFrame.getEntityInfos(msg.npcId).contextualId;
         var NPC:Npc = Npc.getNpcById(NPCId);
         var targetName:String = Npc.getNpcById((this._roleplayEntitiesFrame.getEntityInfos(msg.npcId) as GameRolePlayNpcInformations).npcId).name;
         var sourceLook:TiphonEntityLook = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
         var targetLook:TiphonEntityLook = EntityLookAdapter.fromNetwork(this._roleplayContextFrame.entitiesFrame.getEntityInfos(msg.npcId).look);
         var esonmsg:ExchangeStartOkNpcTradeMessage = msg as ExchangeStartOkNpcTradeMessage;
         PlayedCharacterManager.getInstance().isInExchange = true;
         this._roleplayContextFrame.commonExchangeFrame.synchronizeDisplayedInventory();
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcTrade,esonmsg.npcId,sourceName,targetName,sourceLook,targetLook);
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.NPC_TRADE);
      }
      
      public function process(msg:Message) : Boolean
      {
         var i:int = 0;
         var inventorySize:int = 0;
         var esmsg:ExchangeStartedMessage = null;
         var sicmsg:StorageInventoryContentMessage = null;
         var esotcmsg:ExchangeStartOkTaxCollectorMessage = null;
         var num:int = 0;
         var soumsg:StorageObjectUpdateMessage = null;
         var object:ObjectItem = null;
         var itemChanged:ItemWrapper = null;
         var newItem:Boolean = false;
         var sormsg:StorageObjectRemoveMessage = null;
         var sosumsg:StorageObjectsUpdateMessage = null;
         var sosrmsg:StorageObjectsRemoveMessage = null;
         var newExchangeInventory:Array = null;
         var skumsg:StorageKamasUpdateMessage = null;
         var exchangeAcceptMessage:ExchangeAcceptMessage = null;
         var ldrmsg:LeaveDialogRequestMessage = null;
         var era:ExchangeReadyAction = null;
         var ermsg:ExchangeReadyMessage = null;
         var eirmsg:ExchangeIsReadyMessage = null;
         var playerName:String = null;
         var eoma:ExchangeObjectMoveAction = null;
         var eommsg:ExchangeObjectMoveMessage = null;
         var eomka:ExchangeObjectMoveKamaAction = null;
         var eomkmsg:ExchangeObjectMoveKamaMessage = null;
         var eotatia:ExchangeObjectTransfertAllToInvAction = null;
         var eotatimsg:ExchangeObjectTransfertAllToInvMessage = null;
         var eotltia:ExchangeObjectTransfertListToInvAction = null;
         var esonmsg:ExchangeStartOkNpcShopMessage = null;
         var merchant:GameContextActorInformations = null;
         var merchantLook:TiphonEntityLook = null;
         var NPCShopItems:Array = null;
         var sourceName:String = null;
         var targetName:String = null;
         var sourceLook:TiphonEntityLook = null;
         var targetLook:TiphonEntityLook = null;
         var item:ObjectItem = null;
         var k:int = 0;
         var objectItem:ObjectItem = null;
         var sosuit:ObjectItem = null;
         var sosuobj:ObjectItem = null;
         var sosuic:ItemWrapper = null;
         var sosuni:Boolean = false;
         var sosruid:uint = 0;
         var soris:int = 0;
         var eotltimsg:ExchangeObjectTransfertListToInvMessage = null;
         var oimi:ObjectItemMinimalInformation = null;
         var itemwra:ItemWrapper = null;
         switch(true)
         {
            case msg is ExchangeStartedMessage:
               esmsg = msg as ExchangeStartedMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               switch(esmsg.exchangeType)
               {
                  case ExchangeTypeEnum.PLAYER_TRADE:
                     sourceName = this._sourceInformations.name;
                     targetName = this._targetInformations.name;
                     sourceLook = EntityLookAdapter.fromNetwork(this._sourceInformations.look);
                     targetLook = EntityLookAdapter.fromNetwork(this._targetInformations.look);
                     this._roleplayContextFrame.commonExchangeFrame.synchronizeDisplayedInventory();
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStarted,sourceName,targetName,sourceLook,targetLook);
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,esmsg.exchangeType);
                     this._kernelEventsManager.processCallback(InventoryHookList.StorageModChanged,StorageModList.EXCHANGE_MOD);
                     return true;
                  case ExchangeTypeEnum.STORAGE:
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,esmsg.exchangeType);
                     this._kernelEventsManager.processCallback(InventoryHookList.StorageModChanged,StorageModList.BANK_MOD);
                     return true;
                  case ExchangeTypeEnum.TAXCOLLECTOR:
                     this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType,esmsg.exchangeType);
                     this._kernelEventsManager.processCallback(InventoryHookList.StorageModChanged,StorageModList.TAXCOLLECTOR_MOD);
                     return true;
                  default:
                     return false;
               }
            case msg is StorageInventoryContentMessage:
               sicmsg = msg as StorageInventoryContentMessage;
               this._exchangeInventory = new Array();
               for each(item in sicmsg.objects)
               {
                  this._exchangeInventory.push(ItemWrapper.create(item.position,item.objectUID,item.objectGID,item.quantity,item.effects));
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageInventoryContent,this._exchangeInventory,sicmsg.kamas);
               return false;
            case msg is ExchangeStartOkTaxCollectorMessage:
               esotcmsg = msg as ExchangeStartOkTaxCollectorMessage;
               num = esotcmsg.objectsInfos.length;
               this._exchangeInventory = new Array(num);
               for(k = 0; k < num; k++)
               {
                  objectItem = esotcmsg.objectsInfos[k];
                  this._exchangeInventory[k] = ItemWrapper.create(objectItem.position,objectItem.objectUID,objectItem.objectGID,objectItem.quantity,objectItem.effects);
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageInventoryContent,this._exchangeInventory,esotcmsg.goldInfo);
               return false;
            case msg is StorageObjectUpdateMessage:
               soumsg = msg as StorageObjectUpdateMessage;
               object = soumsg.object;
               itemChanged = ItemWrapper.create(object.position,object.objectUID,object.objectGID,object.quantity,object.effects);
               newItem = true;
               inventorySize = this._exchangeInventory.length;
               for(i = 0; i < inventorySize; i++)
               {
                  if(this._exchangeInventory[i].objectUID == itemChanged.objectUID)
                  {
                     this._exchangeInventory.splice(i,1,itemChanged);
                     newItem = false;
                     break;
                  }
               }
               if(newItem)
               {
                  this._exchangeInventory.push(itemChanged);
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageObjectUpdate,this._exchangeInventory);
               return false;
            case msg is StorageObjectRemoveMessage:
               sormsg = msg as StorageObjectRemoveMessage;
               inventorySize = this._exchangeInventory.length;
               for(i = 0; i < inventorySize; i++)
               {
                  if(this._exchangeInventory[i].objectUID == sormsg.objectUID)
                  {
                     this._exchangeInventory.splice(i,1);
                     break;
                  }
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageObjectRemove,this._exchangeInventory);
               return false;
            case msg is StorageObjectsUpdateMessage:
               sosumsg = msg as StorageObjectsUpdateMessage;
               for each(sosuit in sosumsg.objectList)
               {
                  sosuobj = sosuit;
                  sosuic = ItemWrapper.create(sosuobj.position,sosuobj.objectUID,sosuobj.objectGID,sosuobj.quantity,sosuobj.effects);
                  sosuni = true;
                  inventorySize = this._exchangeInventory.length;
                  for(i = 0; i < inventorySize; i++)
                  {
                     if(this._exchangeInventory[i].objectUID == sosuic.objectUID)
                     {
                        this._exchangeInventory.splice(i,1,sosuic);
                        sosuni = false;
                        break;
                     }
                  }
                  if(sosuni)
                  {
                     this._exchangeInventory.push(sosuic);
                  }
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageObjectUpdate,this._exchangeInventory);
               return false;
            case msg is StorageObjectsRemoveMessage:
               sosrmsg = msg as StorageObjectsRemoveMessage;
               newExchangeInventory = this._exchangeInventory.slice(0,this._exchangeInventory.length);
               for each(sosruid in sosrmsg.objectUIDList)
               {
                  soris = this._exchangeInventory.length;
                  for(i = 0; i < soris; i++)
                  {
                     if(this._exchangeInventory[i].objectUID == sosruid)
                     {
                        this._exchangeInventory.splice(i,1);
                        break;
                     }
                  }
               }
               this._kernelEventsManager.processCallback(InventoryHookList.StorageObjectRemove,this._exchangeInventory);
               return false;
            case msg is StorageKamasUpdateMessage:
               skumsg = msg as StorageKamasUpdateMessage;
               this._kernelEventsManager.processCallback(InventoryHookList.StorageKamasUpdate,skumsg.kamasTotal);
               return false;
            case msg is ExchangeAcceptAction:
               exchangeAcceptMessage = new ExchangeAcceptMessage();
               exchangeAcceptMessage.initExchangeAcceptMessage();
               this._serverConnection.send(exchangeAcceptMessage);
               return true;
            case msg is ExchangeRefuseAction:
               ldrmsg = new LeaveDialogRequestMessage();
               ldrmsg.initLeaveDialogRequestMessage();
               this._serverConnection.send(ldrmsg);
               return true;
            case msg is ExchangeReadyAction:
               era = msg as ExchangeReadyAction;
               ermsg = new ExchangeReadyMessage();
               ermsg.initExchangeReadyMessage(era.isReady);
               this._serverConnection.send(ermsg);
               return true;
            case msg is ExchangeIsReadyMessage:
               eirmsg = msg as ExchangeIsReadyMessage;
               playerName = (this._roleplayEntitiesFrame.getEntityInfos(eirmsg.id) as GameRolePlayNamedActorInformations).name;
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeIsReady,playerName,eirmsg.ready);
               return true;
            case msg is ExchangeObjectMoveAction:
               eoma = msg as ExchangeObjectMoveAction;
               eommsg = new ExchangeObjectMoveMessage();
               eommsg.initExchangeObjectMoveMessage(eoma.objectUID,eoma.quantity);
               this._serverConnection.send(eommsg);
               return true;
            case msg is ExchangeObjectMoveKamaAction:
               eomka = msg as ExchangeObjectMoveKamaAction;
               eomkmsg = new ExchangeObjectMoveKamaMessage();
               eomkmsg.initExchangeObjectMoveKamaMessage(eomka.kamas);
               this._serverConnection.send(eomkmsg);
               return true;
            case msg is ExchangeObjectTransfertAllToInvAction:
               eotatia = msg as ExchangeObjectTransfertAllToInvAction;
               eotatimsg = new ExchangeObjectTransfertAllToInvMessage();
               eotatimsg.initExchangeObjectTransfertAllToInvMessage();
               this._serverConnection.send(eotatimsg);
               return true;
            case msg is ExchangeObjectTransfertListToInvAction:
               eotltia = msg as ExchangeObjectTransfertListToInvAction;
               if(eotltia.ids.length != 0)
               {
                  eotltimsg = new ExchangeObjectTransfertListToInvMessage();
                  eotltimsg.initExchangeObjectTransfertListToInvMessage(eotltia.ids);
                  this._serverConnection.send(eotltimsg);
               }
               return true;
            case msg is ExchangeStartOkNpcShopMessage:
               esonmsg = msg as ExchangeStartOkNpcShopMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               merchant = this._roleplayContextFrame.entitiesFrame.getEntityInfos(esonmsg.npcSellerId);
               merchantLook = EntityLookAdapter.fromNetwork(merchant.look);
               NPCShopItems = new Array();
               for each(oimi in esonmsg.objectsInfos)
               {
                  itemwra = ItemWrapper.create(63,0,oimi.objectGID,0,oimi.effects,false);
                  NPCShopItems.push(itemwra);
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcShop,esonmsg.npcSellerId,NPCShopItems,merchantLook);
               this._kernelEventsManager.processCallback(InventoryHookList.StorageModChanged,StorageModList.SHOP_MOD);
               return true;
            default:
               return false;
         }
      }
      
      private function proceedExchange() : void
      {
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function get _kernelEventsManager() : KernelEventsManager
      {
         return KernelEventsManager.getInstance();
      }
      
      private function get _serverConnection() : IServerConnection
      {
         return ConnectionsHandler.getConnection();
      }
   }
}
