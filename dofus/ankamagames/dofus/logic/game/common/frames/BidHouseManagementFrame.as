package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInBid;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseSearchAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseSearchMessage;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseListAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseListMessage;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseTypeAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseTypeMessage;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseBuyAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseBuyMessage;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHousePriceAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHousePriceMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidPriceMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemAddOkMessage;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemRemoveOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesItemsExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidSearchOkMessage;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidHouseStringSearchAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.network.types.game.data.items.BidExchangerObjectInfo;
   import flash.utils.getTimer;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToBuyerModeAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToSellerModeAction;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.jerakine.network.IServerConnection;
   
   public class BidHouseManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(BidHouseManagementFrame));
       
      private var _bidHouseObjects:Array;
      
      private var _vendorObjects:Array;
      
      private var _typeAsk:uint;
      
      private var _GIDAsk:uint;
      
      private var _NPCId:uint;
      
      private var _listItemsSearchMode:Array;
      
      private var _itemsTypesAllowed:Vector.<uint>;
      
      private var _switching:Boolean = false;
      
      public function BidHouseManagementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get switching() : Boolean
      {
         return this._switching;
      }
      
      public function processExchangeStartedBidSellerMessage(msg:ExchangeStartedBidSellerMessage) : void
      {
         var objectInfo:ObjectItemToSellInBid = null;
         var iw:ItemWrapper = null;
         var price:uint = 0;
         var unsoldDelay:uint = 0;
         this._switching = false;
         var esbsmsg:ExchangeStartedBidSellerMessage = msg as ExchangeStartedBidSellerMessage;
         this._NPCId = esbsmsg.sellerDescriptor.npcContextualId;
         this.initSearchMode(esbsmsg.sellerDescriptor.types);
         this._vendorObjects = new Array();
         for each(objectInfo in esbsmsg.objectsInfos)
         {
            iw = ItemWrapper.create(63,objectInfo.objectUID,objectInfo.objectGID,objectInfo.quantity,objectInfo.effects);
            price = objectInfo.objectPrice;
            unsoldDelay = objectInfo.unsoldDelay;
            this._vendorObjects.push(new ItemSellByPlayer(iw,price,unsoldDelay));
         }
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedBidSeller,esbsmsg.sellerDescriptor,esbsmsg.objectsInfos);
         this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
      }
      
      public function processExchangeStartedBidBuyerMessage(msg:ExchangeStartedBidBuyerMessage) : void
      {
         var typeObject:uint = 0;
         this._switching = false;
         var esbbmsg:ExchangeStartedBidBuyerMessage = msg as ExchangeStartedBidBuyerMessage;
         this._NPCId = esbbmsg.buyerDescriptor.npcContextualId;
         this.initSearchMode(esbbmsg.buyerDescriptor.types);
         this._bidHouseObjects = new Array();
         for each(typeObject in esbbmsg.buyerDescriptor.types)
         {
            this._bidHouseObjects.push(new TypeObjectData(typeObject,null));
         }
         this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedBidBuyer,esbbmsg.buyerDescriptor);
      }
      
      public function process(msg:Message) : Boolean
      {
         var ebhsa:ExchangeBidHouseSearchAction = null;
         var ebhsmsg:ExchangeBidHouseSearchMessage = null;
         var ebhla:ExchangeBidHouseListAction = null;
         var ebhlmsg:ExchangeBidHouseListMessage = null;
         var ebhta:ExchangeBidHouseTypeAction = null;
         var ebhtmsg:ExchangeBidHouseTypeMessage = null;
         var ebhba:ExchangeBidHouseBuyAction = null;
         var ebhbmsg:ExchangeBidHouseBuyMessage = null;
         var ebhpa:ExchangeBidHousePriceAction = null;
         var ebhpmsg:ExchangeBidHousePriceMessage = null;
         var ebpmsg:ExchangeBidPriceMessage = null;
         var ebhiaomsg:ExchangeBidHouseItemAddOkMessage = null;
         var item:Item = null;
         var iwrapper:ItemWrapper = null;
         var priceObject:uint = 0;
         var unsoldDelay:uint = 0;
         var ebhiromsg:ExchangeBidHouseItemRemoveOkMessage = null;
         var comptSellItem:uint = 0;
         var ebhgiamsg:ExchangeBidHouseGenericItemAddedMessage = null;
         var typeObjectDt:TypeObjectData = null;
         var ebhgirmsg:ExchangeBidHouseGenericItemRemovedMessage = null;
         var typeObjectD:TypeObjectData = null;
         var ebhilamsg:ExchangeBidHouseInListAddedMessage = null;
         var typeObjects:TypeObjectData = null;
         var godat:GIDObjectData = null;
         var ebhilrmsg:ExchangeBidHouseInListRemovedMessage = null;
         var GID:uint = 0;
         var GIDobj:GIDObjectData = null;
         var comptGID:uint = 0;
         var etedfumsg:ExchangeTypesExchangerDescriptionForUserMessage = null;
         var tod:* = undefined;
         var etiedfumsg:ExchangeTypesItemsExchangerDescriptionForUserMessage = null;
         var goData:GIDObjectData = null;
         var ebsomsg:ExchangeBidSearchOkMessage = null;
         var bhssa:BidHouseStringSearchAction = null;
         var searchText:String = null;
         var i:int = 0;
         var nItems:int = 0;
         var time:int = 0;
         var itemsMatch:Vector.<uint> = null;
         var Buyngarmsg:NpcGenericActionRequestMessage = null;
         var Sellngarmsg:NpcGenericActionRequestMessage = null;
         var objectToSell:ItemSellByPlayer = null;
         var goda:GIDObjectData = null;
         var itemwra:ItemWrapper = null;
         var objectsPrice:Vector.<int> = null;
         var pric:uint = 0;
         var isbbid:ItemSellByBid = null;
         var objectGID:uint = 0;
         var objectInfo:BidExchangerObjectInfo = null;
         var itemW:ItemWrapper = null;
         var objectsPrices:Vector.<int> = null;
         var pri:uint = 0;
         var lsItems:Array = null;
         var currentItem:Object = null;
         var currentName:String = null;
         switch(true)
         {
            case msg is ExchangeBidHouseSearchAction:
               ebhsa = msg as ExchangeBidHouseSearchAction;
               ebhsmsg = new ExchangeBidHouseSearchMessage();
               ebhsmsg.initExchangeBidHouseSearchMessage(ebhsa.type,ebhsa.genId);
               this._typeAsk = ebhsa.type;
               this._GIDAsk = ebhsa.genId;
               this._serverConection.send(ebhsmsg);
               return false;
            case msg is ExchangeBidHouseListAction:
               ebhla = msg as ExchangeBidHouseListAction;
               this._GIDAsk = ebhla.id;
               ebhlmsg = new ExchangeBidHouseListMessage();
               ebhlmsg.initExchangeBidHouseListMessage(ebhla.id);
               this._serverConection.send(ebhlmsg);
               return true;
            case msg is ExchangeBidHouseTypeAction:
               ebhta = msg as ExchangeBidHouseTypeAction;
               this._typeAsk = ebhta.type;
               ebhtmsg = new ExchangeBidHouseTypeMessage();
               ebhtmsg.initExchangeBidHouseTypeMessage(ebhta.type);
               this._serverConection.send(ebhtmsg);
               return true;
            case msg is ExchangeBidHouseBuyAction:
               ebhba = msg as ExchangeBidHouseBuyAction;
               ebhbmsg = new ExchangeBidHouseBuyMessage();
               ebhbmsg.initExchangeBidHouseBuyMessage(ebhba.uid,ebhba.qty,ebhba.price);
               this._serverConection.send(ebhbmsg);
               return true;
            case msg is ExchangeBidHousePriceAction:
               ebhpa = msg as ExchangeBidHousePriceAction;
               ebhpmsg = new ExchangeBidHousePriceMessage();
               ebhpmsg.initExchangeBidHousePriceMessage(ebhpa.genId);
               this._serverConection.send(ebhpmsg);
               return true;
            case msg is ExchangeBidPriceMessage:
               ebpmsg = msg as ExchangeBidPriceMessage;
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBidPrice,ebpmsg.genericId,ebpmsg.averagePrice);
               return true;
            case msg is ExchangeBidHouseItemAddOkMessage:
               ebhiaomsg = msg as ExchangeBidHouseItemAddOkMessage;
               item = Item.getItemById(ebhiaomsg.itemInfo.objectGID);
               iwrapper = ItemWrapper.create(63,ebhiaomsg.itemInfo.objectUID,ebhiaomsg.itemInfo.objectGID,ebhiaomsg.itemInfo.quantity,ebhiaomsg.itemInfo.effects);
               priceObject = ebhiaomsg.itemInfo.objectPrice;
               unsoldDelay = ebhiaomsg.itemInfo.unsoldDelay;
               this._vendorObjects.push(new ItemSellByPlayer(iwrapper,priceObject,unsoldDelay));
               this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
               return true;
            case msg is ExchangeBidHouseItemRemoveOkMessage:
               ebhiromsg = msg as ExchangeBidHouseItemRemoveOkMessage;
               comptSellItem = 0;
               for each(objectToSell in this._vendorObjects)
               {
                  if(objectToSell.itemWrapper.objectUID == ebhiromsg.sellerId)
                  {
                     this._vendorObjects.splice(comptSellItem,1);
                  }
                  comptSellItem++;
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.SellerObjectListUpdate,this._vendorObjects);
               return true;
            case msg is ExchangeBidHouseGenericItemAddedMessage:
               ebhgiamsg = msg as ExchangeBidHouseGenericItemAddedMessage;
               typeObjectDt = this.getTypeObject(this._typeAsk);
               typeObjectDt.objects.push(new GIDObjectData(ebhgiamsg.objGenericId,new Array()));
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,typeObjectDt.objects);
               return true;
            case msg is ExchangeBidHouseGenericItemRemovedMessage:
               ebhgirmsg = msg as ExchangeBidHouseGenericItemRemovedMessage;
               typeObjectD = this.getTypeObject(this._typeAsk);
               typeObjectD.objects.splice(this.getGIDObjectIndex(this._typeAsk,ebhgirmsg.objGenericId),1);
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,typeObjectD.objects);
               return true;
            case msg is ExchangeBidHouseInListAddedMessage:
               ebhilamsg = msg as ExchangeBidHouseInListAddedMessage;
               typeObjects = this.getTypeObject(this._typeAsk);
               for each(goda in typeObjects.objects)
               {
                  if(goda.GIDObject == ebhilamsg.objGenericId)
                  {
                     godat = goda;
                     if(goda.objects == null)
                     {
                        goda.objects = new Array();
                     }
                     itemwra = ItemWrapper.create(63,ebhilamsg.itemUID,ebhilamsg.objGenericId,1,ebhilamsg.effects);
                     objectsPrice = new Vector.<int>();
                     for each(pric in ebhilamsg.prices)
                     {
                        objectsPrice.push(pric as int);
                     }
                     goda.objects.push(new ItemSellByBid(itemwra,objectsPrice));
                  }
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,godat.objects);
               return true;
            case msg is ExchangeBidHouseInListRemovedMessage:
               ebhilrmsg = msg as ExchangeBidHouseInListRemovedMessage;
               GID = 0;
               GIDobj = this.getGIDObject(this._typeAsk,this._GIDAsk);
               comptGID = 0;
               for each(isbbid in GIDobj.objects)
               {
                  if(ebhilrmsg.itemUID == isbbid.itemWrapper.objectUID)
                  {
                     GIDobj.objects.splice(comptGID,1);
                  }
                  comptGID++;
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,GIDobj.objects);
               return true;
            case msg is ExchangeTypesExchangerDescriptionForUserMessage:
               etedfumsg = msg as ExchangeTypesExchangerDescriptionForUserMessage;
               tod = this.getTypeObject(this._typeAsk);
               tod.objects = new Array();
               for each(objectGID in etedfumsg.typeDescription)
               {
                  tod.objects.push(new GIDObjectData(objectGID,new Array()));
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,tod.objects);
               return true;
            case msg is ExchangeTypesItemsExchangerDescriptionForUserMessage:
               etiedfumsg = msg as ExchangeTypesItemsExchangerDescriptionForUserMessage;
               goData = this.getGIDObject(this._typeAsk,this._GIDAsk);
               if(goData)
               {
                  goData.objects = new Array();
                  for each(objectInfo in etiedfumsg.itemTypeDescriptions)
                  {
                     itemW = ItemWrapper.create(63,objectInfo.objectUID,this._GIDAsk,1,objectInfo.effects);
                     objectsPrices = new Vector.<int>();
                     for each(pri in objectInfo.prices)
                     {
                        objectsPrices.push(pri as int);
                     }
                     goData.objects.push(new ItemSellByBid(itemW,objectsPrices));
                  }
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,goData.objects);
               }
               else
               {
                  this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectListUpdate,null);
               }
               return true;
            case msg is ExchangeBidSearchOkMessage:
               ebsomsg = msg as ExchangeBidSearchOkMessage;
               this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBidSearchOk);
               return true;
            case msg is BidHouseStringSearchAction:
               bhssa = msg as BidHouseStringSearchAction;
               searchText = bhssa.searchString;
               time = getTimer();
               itemsMatch = new Vector.<uint>();
               if(this._listItemsSearchMode == null)
               {
                  this._listItemsSearchMode = new Array();
                  lsItems = Item.getItems();
                  nItems = lsItems.length;
                  for(i = 0; i < nItems; i++)
                  {
                     currentItem = lsItems[i];
                     if(Boolean(currentItem) && this._itemsTypesAllowed.indexOf(currentItem.typeId) != -1)
                     {
                        this._listItemsSearchMode.push(currentItem.name.toLowerCase(),currentItem.id);
                     }
                  }
                  _log.debug("Initialisation recherche HDV en " + (getTimer() - time) + " ms.");
               }
               nItems = this._listItemsSearchMode.length;
               for(i = 0; i < nItems; i = i + 2)
               {
                  currentName = this._listItemsSearchMode[i];
                  if(currentName.indexOf(searchText) != -1)
                  {
                     itemsMatch.push(this._listItemsSearchMode[i + 1]);
                  }
               }
               this._kernelEventsManager.processCallback(ExchangeHookList.BidObjectTypeListUpdate,itemsMatch,true);
               return true;
            case msg is BidSwitchToBuyerModeAction:
               this._switching = true;
               Buyngarmsg = new NpcGenericActionRequestMessage();
               Buyngarmsg.initNpcGenericActionRequestMessage(this._NPCId,6);
               ConnectionsHandler.getConnection().send(Buyngarmsg);
               return true;
            case msg is BidSwitchToSellerModeAction:
               this._switching = true;
               Sellngarmsg = new NpcGenericActionRequestMessage();
               Sellngarmsg.initNpcGenericActionRequestMessage(this._NPCId,5);
               ConnectionsHandler.getConnection().send(Sellngarmsg);
               return true;
            default:
               return false;
         }
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
      
      private function get _serverConection() : IServerConnection
      {
         return ConnectionsHandler.getConnection();
      }
      
      private function getTypeObject(pType:uint) : TypeObjectData
      {
         var tod:TypeObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return null;
         }
         for each(tod in this._bidHouseObjects)
         {
            if(tod.typeObject == pType)
            {
               return tod;
            }
         }
         return null;
      }
      
      private function getGIDObject(pType:uint, pGID:uint) : GIDObjectData
      {
         var god:GIDObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return null;
         }
         var typeObjectData:TypeObjectData = this.getTypeObject(pType);
         if(typeObjectData == null)
         {
            return null;
         }
         for each(god in typeObjectData.objects)
         {
            if(god.GIDObject == pGID)
            {
               return god;
            }
         }
         return null;
      }
      
      private function getGIDObjectIndex(pType:uint, pGID:uint) : uint
      {
         var god:GIDObjectData = null;
         if(this._bidHouseObjects == null)
         {
            return null;
         }
         var typeObjectData:TypeObjectData = this.getTypeObject(pType);
         if(typeObjectData == null)
         {
            return null;
         }
         var index:uint = 0;
         for each(god in typeObjectData.objects)
         {
            if(god.GIDObject == pGID)
            {
               return index;
            }
            index++;
         }
         return null;
      }
      
      private function initSearchMode(types:Vector.<uint>) : void
      {
         var nTypes:int = 0;
         var reset:Boolean = false;
         var i:int = 0;
         if(this._itemsTypesAllowed)
         {
            nTypes = types.length;
            if(nTypes == this._itemsTypesAllowed.length)
            {
               reset = false;
               for(i = 0; i < nTypes; i++)
               {
                  if(types[i] != this._itemsTypesAllowed[i])
                  {
                     reset = true;
                     break;
                  }
               }
               if(reset)
               {
                  this._listItemsSearchMode = null;
               }
            }
            else
            {
               this._listItemsSearchMode = null;
            }
         }
         else
         {
            this._listItemsSearchMode = null;
         }
         this._itemsTypesAllowed = types;
      }
   }
}

import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;

class ItemSellByPlayer
{
    
   public var itemWrapper:ItemWrapper;
   
   public var price:int;
   
   public var unsoldDelay:uint;
   
   function ItemSellByPlayer(pItemWrapper:ItemWrapper, pPrice:int, pUnsoldDelay:uint)
   {
      super();
      this.itemWrapper = pItemWrapper;
      this.price = pPrice;
      this.unsoldDelay = pUnsoldDelay;
   }
}

import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;

class ItemSellByBid
{
    
   public var itemWrapper:ItemWrapper;
   
   public var prices:Vector.<int>;
   
   function ItemSellByBid(pItemWrapper:ItemWrapper, pPrices:Vector.<int>)
   {
      super();
      this.itemWrapper = pItemWrapper;
      this.prices = pPrices;
   }
}

class TypeObjectData
{
    
   public var objects:Array;
   
   public var typeObject:uint;
   
   function TypeObjectData(pTypeObject:uint, pObjects:Array)
   {
      super();
      this.objects = pObjects;
      this.typeObject = pTypeObject;
   }
}

class GIDObjectData
{
    
   public var objects:Array;
   
   public var GIDObject:uint;
   
   function GIDObjectData(pGIDObject:uint, pObjects:Array)
   {
      super();
      this.objects = pObjects;
      this.GIDObject = pGIDObject;
   }
}
