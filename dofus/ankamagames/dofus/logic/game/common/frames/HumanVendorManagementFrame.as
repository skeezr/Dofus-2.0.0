package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnShopStockMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMovmentAddAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMovePricedMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMovmentRemoveAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockModifyObjectAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementUpdatedMessage;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartAsVendorMessage;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeBuyAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeSellAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyOkMessage;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShowVendorTaxMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplyTaxVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkHumanVendorMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSell;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.StorageModList;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeRequestOnShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeStartAsVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShowVendorTaxAction;
   
   public class HumanVendorManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HumanVendorManagementFrame));
       
      private var _rpContextFrame:RoleplayContextFrame;
      
      private var _movFrame:RoleplayMovementFrame;
      
      private var _commonExchangeFrame:com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame;
      
      private var _shopStock:Array;
      
      public function HumanVendorManagementFrame(parentFrame:RoleplayContextFrame, movementFrame:RoleplayMovementFrame)
      {
         super();
         this._rpContextFrame = parentFrame;
         this._movFrame = movementFrame;
         this._shopStock = new Array();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var ldrmsg:LeaveDialogRequestMessage = null;
         var erossa:ExchangeOnHumanVendorRequestAction = null;
         var ospmsg:ExchangeRequestOnShopStockMessage = null;
         var essmaa:ExchangeShopStockMovmentAddAction = null;
         var eompmsg:ExchangeObjectMovePricedMessage = null;
         var essmra:ExchangeShopStockMovmentRemoveAction = null;
         var eommsg:ExchangeObjectMoveMessage = null;
         var essmoa:ExchangeShopStockModifyObjectAction = null;
         var esostmsg:ExchangeShopStockStartedMessage = null;
         var essmamsg:ExchangeShopStockMovementUpdatedMessage = null;
         var itemWrapper:ItemWrapper = null;
         var newPrice:uint = 0;
         var newItem:Boolean = false;
         var essmrmsg:ExchangeShopStockMovementRemovedMessage = null;
         var essmmumsg:ExchangeShopStockMultiMovementUpdatedMessage = null;
         var essmmrmsg:ExchangeShopStockMultiMovementRemovedMessage = null;
         var esavmsg:ExchangeStartAsVendorMessage = null;
         var eohvra:ExchangeOnHumanVendorRequestAction = null;
         var playerEntity:IEntity = null;
         var eohvrmsg:ExchangeOnHumanVendorRequestMessage = null;
         var eba:ExchangeBuyAction = null;
         var ebmsg:ExchangeBuyMessage = null;
         var esa:ExchangeSellAction = null;
         var esmsg:ExchangeSellMessage = null;
         var ebomsg:ExchangeBuyOkMessage = null;
         var eslmsg:ExpectedSocketClosureMessage = null;
         var esvtmsg:ExchangeShowVendorTaxMessage = null;
         var ertvmsg:ExchangeReplyTaxVendorMessage = null;
         var esohvmsg:ExchangeStartOkHumanVendorMessage = null;
         var player:GameContextActorInformations = null;
         var playerName:String = null;
         var object:ObjectItemToSell = null;
         var iw:ItemWrapper = null;
         var cat:Object = null;
         var i:int = 0;
         var cate:Object = null;
         var objectInfo:ObjectItemToSell = null;
         var newItem2:Boolean = false;
         var objectId:uint = 0;
         var objectToSell:ObjectItemToSell = null;
         var iwrapper:ItemWrapper = null;
         switch(true)
         {
            case msg is LeaveShopStockAction:
               ldrmsg = new LeaveDialogRequestMessage();
               ldrmsg.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(ldrmsg);
               return true;
            case msg is ExchangeRequestOnShopStockAction:
               erossa = msg as ExchangeOnHumanVendorRequestAction;
               ospmsg = new ExchangeRequestOnShopStockMessage();
               ospmsg.initExchangeRequestOnShopStockMessage();
               ConnectionsHandler.getConnection().send(ospmsg);
               return true;
            case msg is ExchangeShopStockMovmentAddAction:
               essmaa = msg as ExchangeShopStockMovmentAddAction;
               eompmsg = new ExchangeObjectMovePricedMessage();
               eompmsg.initExchangeObjectMovePricedMessage(essmaa.objectUID,essmaa.quantity,essmaa.price);
               ConnectionsHandler.getConnection().send(eompmsg);
               return true;
            case msg is ExchangeShopStockMovmentRemoveAction:
               essmra = msg as ExchangeShopStockMovmentRemoveAction;
               eommsg = new ExchangeObjectMoveMessage();
               eommsg.initExchangeObjectMoveMessage(essmra.objectUID,essmra.quantity);
               ConnectionsHandler.getConnection().send(eommsg);
               return true;
            case msg is ExchangeShopStockModifyObjectAction:
               essmoa = msg as ExchangeShopStockModifyObjectAction;
               eompmsg = new ExchangeObjectMovePricedMessage();
               eompmsg.initExchangeObjectMovePricedMessage(essmoa.objectUID,essmoa.quantity,essmoa.price);
               ConnectionsHandler.getConnection().send(eompmsg);
               return true;
            case msg is ExchangeShopStockStartedMessage:
               esostmsg = msg as ExchangeShopStockStartedMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               this._shopStock = new Array();
               for each(object in esostmsg.objectsInfos)
               {
                  iw = ItemWrapper.create(0,object.objectUID,object.objectGID,object.quantity,object.effects,false);
                  cat = Item.getItemById(iw.objectGID).category;
                  this._shopStock.push({
                     "itemWrapper":iw,
                     "price":object.objectPrice,
                     "category":cat
                  });
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockStarted,this._shopStock);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.HUMAN_VENDOR_MOD);
               return true;
            case msg is ExchangeShopStockMovementUpdatedMessage:
               essmamsg = msg as ExchangeShopStockMovementUpdatedMessage;
               itemWrapper = ItemWrapper.create(0,essmamsg.objectInfo.objectUID,essmamsg.objectInfo.objectGID,essmamsg.objectInfo.quantity,essmamsg.objectInfo.effects,false);
               newPrice = essmamsg.objectInfo.objectPrice;
               newItem = true;
               for(i = 0; i < this._shopStock.length; i++)
               {
                  if(this._shopStock[i].itemWrapper.objectUID == itemWrapper.objectUID)
                  {
                     if(itemWrapper.quantity > this._shopStock[i].itemWrapper.quantity)
                     {
                        KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockAddQuantity);
                     }
                     else
                     {
                        KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockRemoveQuantity);
                     }
                     cate = Item.getItemById(itemWrapper.objectGID).category;
                     this._shopStock.splice(i,1,{
                        "itemWrapper":itemWrapper,
                        "price":newPrice,
                        "category":cate
                     });
                     newItem = false;
                     break;
                  }
               }
               if(newItem)
               {
                  cat = Item.getItemById(itemWrapper.objectGID).category;
                  this._shopStock.push({
                     "itemWrapper":itemWrapper,
                     "price":essmamsg.objectInfo.objectPrice,
                     "category":cat
                  });
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock,itemWrapper);
               return true;
            case msg is ExchangeShopStockMovementRemovedMessage:
               essmrmsg = msg as ExchangeShopStockMovementRemovedMessage;
               for(i = 0; i < this._shopStock.length; i++)
               {
                  if(this._shopStock[i].itemWrapper.objectUID == essmrmsg.objectId)
                  {
                     this._shopStock.splice(i,1);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock,null);
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockMovementRemoved,essmrmsg.objectId);
               return true;
            case msg is ExchangeShopStockMultiMovementUpdatedMessage:
               essmmumsg = msg as ExchangeShopStockMultiMovementUpdatedMessage;
               for each(objectInfo in essmmumsg.objectInfoList)
               {
                  itemWrapper = ItemWrapper.create(0,objectInfo.objectUID,essmamsg.objectInfo.objectGID,objectInfo.quantity,objectInfo.effects,false);
                  newItem2 = true;
                  for(i = 0; i < this._shopStock.length; i++)
                  {
                     if(this._shopStock[i].itemWrapper.objectUID == itemWrapper.objectUID)
                     {
                        cat = Item.getItemById(itemWrapper.objectGID).category;
                        this._shopStock.splice(i,1,{
                           "itemWrapper":itemWrapper,
                           "price":essmamsg.objectInfo.objectPrice,
                           "category":cat
                        });
                        newItem2 = false;
                        break;
                     }
                  }
                  if(newItem2)
                  {
                     this._shopStock.push({
                        "itemWrapper":itemWrapper,
                        "price":essmamsg.objectInfo.objectPrice
                     });
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockUpdate,this._shopStock);
               return true;
            case msg is ExchangeShopStockMultiMovementRemovedMessage:
               essmmrmsg = msg as ExchangeShopStockMultiMovementRemovedMessage;
               for each(objectId in essmmrmsg.objectIdList)
               {
                  for(i = 0; i < this._shopStock.length; i++)
                  {
                     if(this._shopStock[i].itemWrapper.objectUID == objectId)
                     {
                        this._shopStock.splice(i,1);
                        break;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeShopStockMouvmentRemoveOk,essmrmsg.objectId);
               return true;
            case msg is ExchangeStartAsVendorRequestAction:
               ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR);
               esavmsg = new ExchangeStartAsVendorMessage();
               esavmsg.initExchangeStartAsVendorMessage();
               ConnectionsHandler.getConnection().send(esavmsg);
               return true;
            case msg is ExchangeOnHumanVendorRequestAction:
               eohvra = msg as ExchangeOnHumanVendorRequestAction;
               playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               eohvrmsg = new ExchangeOnHumanVendorRequestMessage();
               eohvrmsg.initExchangeOnHumanVendorRequestMessage(eohvra.humanVendorId,eohvra.humanVendorCell);
               if((playerEntity as IMovable).isMoving)
               {
                  this._movFrame.setFollowingMessage(eohvrmsg);
                  (playerEntity as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(eohvrmsg);
               }
               return true;
            case msg is ExchangeBuyAction:
               eba = msg as ExchangeBuyAction;
               ebmsg = new ExchangeBuyMessage();
               ebmsg.initExchangeBuyMessage(eba.objectUID,eba.quantity);
               ConnectionsHandler.getConnection().send(ebmsg);
               return true;
            case msg is ExchangeSellAction:
               esa = msg as ExchangeSellAction;
               esmsg = new ExchangeSellMessage();
               esmsg.initExchangeSellMessage(esa.objectUID,esa.quantity);
               ConnectionsHandler.getConnection().send(esmsg);
               return true;
            case msg is ExchangeBuyOkMessage:
               ebomsg = msg as ExchangeBuyOkMessage;
               return true;
            case msg is ExpectedSocketClosureMessage:
               eslmsg = msg as ExpectedSocketClosureMessage;
               if(eslmsg.reason == DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR)
               {
                  Kernel.getWorker().process(new ResetGameAction());
                  return true;
               }
               return false;
            case msg is ExchangeShowVendorTaxAction:
               esvtmsg = new ExchangeShowVendorTaxMessage();
               esvtmsg.initExchangeShowVendorTaxMessage();
               ConnectionsHandler.getConnection().send(esvtmsg);
               return true;
            case msg is ExchangeReplyTaxVendorMessage:
               ertvmsg = msg as ExchangeReplyTaxVendorMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeReplyTaxVendor,ertvmsg.totalTaxValue);
               return true;
            case msg is ExchangeStartOkHumanVendorMessage:
               esohvmsg = msg as ExchangeStartOkHumanVendorMessage;
               player = this._rpContextFrame.entitiesFrame.getEntityInfos(esohvmsg.sellerId);
               if(player == null)
               {
                  _log.error("Impossible de trouver le personnage vendeur dans l\'entitiesFrame");
                  return true;
               }
               playerName = (player as GameRolePlayMerchantInformations).name;
               this._shopStock = new Array();
               for each(objectToSell in esohvmsg.objectsInfos)
               {
                  iwrapper = ItemWrapper.create(0,objectToSell.objectUID,objectToSell.objectGID,objectToSell.quantity,objectToSell.effects);
                  this._shopStock.push({
                     "itemWrapper":iwrapper,
                     "price":objectToSell.objectPrice
                  });
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeStartOkHumanVendor,playerName,this._shopStock);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         this._shopStock = null;
         return true;
      }
   }
}
