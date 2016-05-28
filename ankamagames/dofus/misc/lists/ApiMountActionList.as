package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountToggleRidingRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountFeedRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountReleaseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSterilizeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountRenameRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSetXpRatioRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountInfoRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeRequestOnMountStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeHandleMountStableAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.LeaveExchangeMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockRemoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockMoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockBuyRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockSellRequestAction;
   
   public class ApiMountActionList
   {
      
      public static const MountToggleRidingRequest:ApiAction = new ApiAction("MountToggleRidingRequest",MountToggleRidingRequestAction,true);
      
      public static const MountFeedRequest:ApiAction = new ApiAction("MountFeedRequest",MountFeedRequestAction,true);
      
      public static const MountReleaseRequest:ApiAction = new ApiAction("MountReleaseRequest",MountReleaseRequestAction,true);
      
      public static const MountSterilizeRequest:ApiAction = new ApiAction("MountSterilizeRequest",MountSterilizeRequestAction,true);
      
      public static const MountRenameRequest:ApiAction = new ApiAction("MountRenameRequest",MountRenameRequestAction,true);
      
      public static const MountSetXpRatioRequest:ApiAction = new ApiAction("MountSetXpRatioRequest",MountSetXpRatioRequestAction,true);
      
      public static const MountInfoRequest:ApiAction = new ApiAction("MountInfoRequest",MountInfoRequestAction,true);
      
      public static const ExchangeRequestOnMountStock:ApiAction = new ApiAction("ExchangeRequestOnMountStock",ExchangeRequestOnMountStockAction,true);
      
      public static const ExchangeHandleMountStable:ApiAction = new ApiAction("ExchangeHandleMountStable",ExchangeHandleMountStableAction,true);
      
      public static const LeaveExchangeMount:ApiAction = new ApiAction("LeaveExchangeMount",LeaveExchangeMountAction,true);
      
      public static const PaddockRemoveItemRequest:ApiAction = new ApiAction("PaddockRemoveItemRequest",PaddockRemoveItemRequestAction,true);
      
      public static const PaddockMoveItemRequest:ApiAction = new ApiAction("PaddockMoveItemRequest",PaddockMoveItemRequestAction,true);
      
      public static const PaddockBuyRequest:ApiAction = new ApiAction("PaddockBuyRequest",PaddockBuyRequestAction,true);
      
      public static const PaddockSellRequest:ApiAction = new ApiAction("PaddockSellRequest",PaddockSellRequestAction,true);
       
      public function ApiMountActionList()
      {
         super();
      }
   }
}
