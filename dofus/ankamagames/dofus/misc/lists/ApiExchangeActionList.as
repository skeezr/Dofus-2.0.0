package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeAcceptAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRefuseAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectMoveKamaAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertAllToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeObjectTransfertListToInvAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeReadyAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangePlayerRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeStartAsVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeRequestOnShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMovmentAddAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMovmentRemoveAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockModifyObjectAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeSellAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShowVendorTaxAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseSearchAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseListAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseTypeAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHouseBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.ExchangeBidHousePriceAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.LeaveBidHouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidHouseStringSearchAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToBuyerModeAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.BidSwitchToSellerModeAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeItemGoldAddAsPaymentAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeItemObjectAddAsPaymentAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.JobAllowMultiCraftRequestSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayStopAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeObjectUseInWorkshopAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRequestOnTaxCollectorAction;
   
   public class ApiExchangeActionList
   {
      
      public static const DoNothing:ApiAction = new ApiAction("DoNothing",null,true);
      
      public static const ExchangeAccept:ApiAction = new ApiAction("ExchangeAccept",ExchangeAcceptAction,true);
      
      public static const ExchangeRefuse:ApiAction = new ApiAction("ExchangeRefuse",ExchangeRefuseAction,true);
      
      public static const ExchangeObjectMove:ApiAction = new ApiAction("ExchangeObjectMove",ExchangeObjectMoveAction,true);
      
      public static const ExchangeObjectMoveKama:ApiAction = new ApiAction("ExchangeObjectMoveKama",ExchangeObjectMoveKamaAction,true);
      
      public static const ExchangeObjectTransfertAllToInv:ApiAction = new ApiAction("ExchangeObjectTransfertAllToInv",ExchangeObjectTransfertAllToInvAction,true);
      
      public static const ExchangeObjectTransfertListToInv:ApiAction = new ApiAction("ExchangeObjectTransfertListToInv",ExchangeObjectTransfertListToInvAction,true);
      
      public static const ExchangeReady:ApiAction = new ApiAction("ExchangeReady",ExchangeReadyAction,true);
      
      public static const ExchangePlayerRequest:ApiAction = new ApiAction("ExchangePlayerRequest",ExchangePlayerRequestAction,true);
      
      public static const ExchangeOnHumanVendorRequest:ApiAction = new ApiAction("ExchangeOnHumanVendorRequest",ExchangeOnHumanVendorRequestAction,true);
      
      public static const ExchangeStartAsVendorRequest:ApiAction = new ApiAction("ExchangeStartAsVendorRequest",ExchangeStartAsVendorRequestAction,true);
      
      public static const ExchangeRequestOnShopStock:ApiAction = new ApiAction("ExchangeRequestOnShopStock",ExchangeRequestOnShopStockAction,true);
      
      public static const LeaveShopStock:ApiAction = new ApiAction("LeaveShopStock",LeaveShopStockAction,true);
      
      public static const ExchangeShopStockMouvmentAdd:ApiAction = new ApiAction("ExchangeShopStockMouvmentAdd",ExchangeShopStockMovmentAddAction,true);
      
      public static const ExchangeShopStockMouvmentRemove:ApiAction = new ApiAction("ExchangeShopStockMouvmentRemove",ExchangeShopStockMovmentRemoveAction,true);
      
      public static const ExchangeShopStockModifyObject:ApiAction = new ApiAction("ExchangeShopStockModifyObject",ExchangeShopStockModifyObjectAction,true);
      
      public static const ExchangeBuy:ApiAction = new ApiAction("ExchangeBuy",ExchangeBuyAction,true);
      
      public static const ExchangeSell:ApiAction = new ApiAction("ExchangeSell",ExchangeSellAction,true);
      
      public static const ExchangeShowVendorTax:ApiAction = new ApiAction("ExchangeShowVendorTax",ExchangeShowVendorTaxAction,true);
      
      public static const ExchangeBidHouseSearch:ApiAction = new ApiAction("ExchangeBidHouseSearch",ExchangeBidHouseSearchAction,true);
      
      public static const ExchangeBidHouseList:ApiAction = new ApiAction("ExchangeBidHouseList",ExchangeBidHouseListAction,true);
      
      public static const ExchangeBidHouseType:ApiAction = new ApiAction("ExchangeBidHouseType",ExchangeBidHouseTypeAction,true);
      
      public static const ExchangeBidHouseBuy:ApiAction = new ApiAction("ExchangeBidHouseBuy",ExchangeBidHouseBuyAction,true);
      
      public static const ExchangeBidHousePrice:ApiAction = new ApiAction("ExchangeBidHousePrice",ExchangeBidHousePriceAction,true);
      
      public static const LeaveBidHouse:ApiAction = new ApiAction("LeaveBidHouse",LeaveBidHouseAction,true);
      
      public static const BidHouseStringSearch:ApiAction = new ApiAction("BidHouseStringSearch",BidHouseStringSearchAction,true);
      
      public static const BidSwitchToBuyerMode:ApiAction = new ApiAction("BidSwitchToBuyerMode",BidSwitchToBuyerModeAction,true);
      
      public static const BidSwitchToSellerMode:ApiAction = new ApiAction("BidSwitchToSellerMode",BidSwitchToSellerModeAction,true);
      
      public static const ExchangeItemGoldAddAsPayment:ApiAction = new ApiAction("ExchangeItemGoldAddAsPayment",ExchangeItemGoldAddAsPaymentAction,true);
      
      public static const ExchangeItemObjectAddAsPayment:ApiAction = new ApiAction("ExchangeItemObjectAddAsPayment",ExchangeItemObjectAddAsPaymentAction,true);
      
      public static const JobAllowMultiCraftRequestSet:ApiAction = new ApiAction("JobAllowMultiCraftRequestSet",JobAllowMultiCraftRequestSetAction,true);
      
      public static const ExchangePlayerMultiCraftRequest:ApiAction = new ApiAction("ExchangePlayerMultiCraftRequest",ExchangePlayerMultiCraftRequestAction,true);
      
      public static const ExchangeReplay:ApiAction = new ApiAction("ExchangeReplay",ExchangeReplayAction,true);
      
      public static const ExchangeReplayStop:ApiAction = new ApiAction("ExchangeReplayStop",ExchangeReplayStopAction,true);
      
      public static const ExchangeMultiCraftSetCrafterCanUseHisRessources:ApiAction = new ApiAction("ExchangeMultiCraftSetCrafterCanUseHisRessources",ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction,true);
      
      public static const ExchangeObjectUseInWorkshop:ApiAction = new ApiAction("ExchangeObjectUseInWorkshop",ExchangeObjectUseInWorkshopAction,true);
      
      public static const ExchangeRequestOnTaxCollector:ApiAction = new ApiAction("ExchangeRequestOnTaxCollector",ExchangeRequestOnTaxCollectorAction,true);
       
      public function ApiExchangeActionList()
      {
         super();
      }
   }
}
