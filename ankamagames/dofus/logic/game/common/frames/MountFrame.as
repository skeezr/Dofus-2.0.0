package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import flash.utils.Dictionary;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountToggleRidingRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountFeedRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectSetPositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountReleaseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSterilizeRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountRenameRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRenameRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSetXpRatioRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetXpRatioRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountInfoRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountInformationRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeRequestOnMountStockAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnMountStockMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.ExchangeHandleMountStableAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeHandleMountStableMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountInformationInPaddockRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountInformationInPaddockRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockSellRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockSellRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRenamedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountEquipedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMountStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeWeightMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountWithOutPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableBornAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountPaddockAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountPaddockRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockSellBuyDialogMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockBuyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSterilizedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountXpRatioMessage;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRidingMessage;
   import com.ankamagames.dofus.network.enums.MountEquipedErrorEnum;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.StorageModList;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountToggleRidingRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountReleaseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.MountSterilizeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.LeaveExchangeMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockBuyRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountUnSetMessage;
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   import com.ankamagames.jerakine.utils.misc.CopyObject;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.datacenter.mounts.MountBehavior;
   import com.ankamagames.dofus.misc.ObjectEffectAdapter;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   
   public class MountFrame implements Frame
   {
      
      public static const MAX_XP_RATIO:uint = 90;
      
      public static var _commonExchangeFrame:com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame = null;
      
      public static var _exchangeFrame:com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame = null;
       
      private var _mountXpRatio:uint;
      
      private var _inStable:Boolean = false;
      
      private var _dictionary_cache:Dictionary;
      
      private var _stableList:Array;
      
      private var _paddockList:Array;
      
      public function MountFrame()
      {
         this._dictionary_cache = new Dictionary();
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function get stableList() : Array
      {
         return this._stableList;
      }
      
      public function get paddockList() : Array
      {
         return this._paddockList;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function inventoryListUpdated(inventoryList:Array) : void
      {
         KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,null,inventoryList);
      }
      
      public function process(msg:Message) : Boolean
      {
         var mtrrmsg:MountToggleRidingRequestMessage = null;
         var mtfra:MountFeedRequestAction = null;
         var mfrmsg:ObjectSetPositionMessage = null;
         var mrrmsg:MountReleaseRequestMessage = null;
         var msrmsg:MountSterilizeRequestMessage = null;
         var mrra:MountRenameRequestAction = null;
         var mountRenameRequestMessage:MountRenameRequestMessage = null;
         var msxrra:MountSetXpRatioRequestAction = null;
         var msxrpmsg:MountSetXpRatioRequestMessage = null;
         var mira:MountInfoRequestAction = null;
         var mirmsg:MountInformationRequestMessage = null;
         var eromsa:ExchangeRequestOnMountStockAction = null;
         var eromsmsg:ExchangeRequestOnMountStockMessage = null;
         var ehmsa:ExchangeHandleMountStableAction = null;
         var ehmsmsg:ExchangeHandleMountStableMessage = null;
         var ldrmsg:LeaveDialogRequestMessage = null;
         var miipra:MountInformationInPaddockRequestAction = null;
         var miiprmsg:MountInformationInPaddockRequestMessage = null;
         var psra:PaddockSellRequestAction = null;
         var psrmsg:PaddockSellRequestMessage = null;
         var mount:Object = null;
         var mrmsg:MountRenamedMessage = null;
         var mountId:Number = NaN;
         var mountName:String = null;
         var mdmsg:MountDataMessage = null;
         var o:Object = null;
         var meemsg:MountEquipedErrorMessage = null;
         var typeError:String = null;
         var esmsmsg:ExchangeStartedMountStockMessage = null;
         var ewmsg:ExchangeWeightMessage = null;
         var esokmmsg:ExchangeStartOkMountMessage = null;
         var pmount:Object = null;
         var esomwopmsg:ExchangeStartOkMountWithOutPaddockMessage = null;
         var emsamsg:ExchangeMountStableAddMessage = null;
         var emsbamsg:ExchangeMountStableBornAddMessage = null;
         var newMount:Object = null;
         var emsrmsg:ExchangeMountStableRemoveMessage = null;
         var empamsg:ExchangeMountPaddockAddMessage = null;
         var emprmsg:ExchangeMountPaddockRemoveMessage = null;
         var emsemsg:ExchangeMountStableErrorMessage = null;
         var psbdmsg:PaddockSellBuyDialogMessage = null;
         var i:int = 0;
         switch(true)
         {
            case msg is MountToggleRidingRequestAction:
               mtrrmsg = new MountToggleRidingRequestMessage();
               mtrrmsg.initMountToggleRidingRequestMessage();
               ConnectionsHandler.getConnection().send(mtrrmsg);
               return true;
            case msg is MountFeedRequestAction:
               mtfra = msg as MountFeedRequestAction;
               mfrmsg = new ObjectSetPositionMessage();
               mfrmsg.initObjectSetPositionMessage(mtfra.objectUID,mtfra.position,mtfra.quantity);
               ConnectionsHandler.getConnection().send(mfrmsg);
               return true;
            case msg is MountReleaseRequestAction:
               mrrmsg = new MountReleaseRequestMessage();
               mrrmsg.initMountReleaseRequestMessage();
               ConnectionsHandler.getConnection().send(mrrmsg);
               return true;
            case msg is MountSterilizeRequestAction:
               msrmsg = new MountSterilizeRequestMessage();
               msrmsg.initMountSterilizeRequestMessage();
               ConnectionsHandler.getConnection().send(msrmsg);
               return true;
            case msg is MountRenameRequestAction:
               mrra = msg as MountRenameRequestAction;
               mountRenameRequestMessage = new MountRenameRequestMessage();
               mountRenameRequestMessage.initMountRenameRequestMessage(!!mrra.newName?mrra.newName:"",mrra.mountId);
               ConnectionsHandler.getConnection().send(mountRenameRequestMessage);
               return true;
            case msg is MountSetXpRatioRequestAction:
               msxrra = msg as MountSetXpRatioRequestAction;
               msxrpmsg = new MountSetXpRatioRequestMessage();
               msxrpmsg.initMountSetXpRatioRequestMessage(msxrra.xpRatio > MAX_XP_RATIO?uint(MAX_XP_RATIO):uint(msxrra.xpRatio));
               ConnectionsHandler.getConnection().send(msxrpmsg);
               return true;
            case msg is MountInfoRequestAction:
               mira = msg as MountInfoRequestAction;
               mirmsg = new MountInformationRequestMessage();
               mirmsg.initMountInformationRequestMessage(mira.mountId,mira.time);
               ConnectionsHandler.getConnection().send(mirmsg);
               return true;
            case msg is ExchangeRequestOnMountStockAction:
               this.addCommonExchangeFrame(ExchangeTypeEnum.MOUNT);
               eromsa = msg as ExchangeRequestOnMountStockAction;
               eromsmsg = new ExchangeRequestOnMountStockMessage();
               eromsmsg.initExchangeRequestOnMountStockMessage();
               ConnectionsHandler.getConnection().send(eromsmsg);
               return true;
            case msg is ExchangeHandleMountStableAction:
               ehmsa = msg as ExchangeHandleMountStableAction;
               ehmsmsg = new ExchangeHandleMountStableMessage();
               ehmsmsg.initExchangeHandleMountStableMessage(ehmsa.actionType,ehmsa.rideId);
               ConnectionsHandler.getConnection().send(ehmsmsg);
               return true;
            case msg is LeaveExchangeMountAction:
               ldrmsg = new LeaveDialogRequestMessage();
               ldrmsg.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(ldrmsg);
               return true;
            case msg is MountInformationInPaddockRequestAction:
               miipra = msg as MountInformationInPaddockRequestAction;
               miiprmsg = new MountInformationInPaddockRequestMessage();
               miiprmsg.initMountInformationInPaddockRequestMessage(miipra.mountId);
               ConnectionsHandler.getConnection().send(miiprmsg);
               return true;
            case msg is PaddockBuyRequestAction:
               ConnectionsHandler.getConnection().send(new PaddockBuyRequestMessage());
               return true;
            case msg is PaddockSellRequestAction:
               psra = msg as PaddockSellRequestAction;
               psrmsg = new PaddockSellRequestMessage();
               psrmsg.initPaddockSellRequestMessage(psra.price);
               ConnectionsHandler.getConnection().send(psrmsg);
               return true;
            case msg is MountSterilizedMessage:
               mountId = MountSterilizedMessage(msg).mountId;
               mount = this.getMountFromCache(mountId);
               if(mount)
               {
                  mount.reproductionCount = -1;
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountSterilized,mountId);
               return true;
            case msg is MountRenamedMessage:
               mrmsg = msg as MountRenamedMessage;
               mountId = mrmsg.mountId;
               mountName = mrmsg.name;
               mount = this.getMountFromCache(mountId);
               if(mount)
               {
                  mount.name = mountName;
               }
               if(this._inStable)
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountRenamed,mountId,mountName);
               return true;
            case msg is MountXpRatioMessage:
               this._mountXpRatio = MountXpRatioMessage(msg).ratio;
               mount = PlayedCharacterManager.getInstance().mount;
               if(mount)
               {
                  mount.xpRatio = this._mountXpRatio;
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountXpRatio,this._mountXpRatio);
               return true;
            case msg is MountDataMessage:
               mdmsg = msg as MountDataMessage;
               o = this.makeMountData(mdmsg.mountData);
               if(this._inStable)
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.CertificateMountData,this.makeMountData(mdmsg.mountData,false));
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(MountHookList.PaddockedMountData,this.makeMountData(mdmsg.mountData,false));
               }
               return true;
            case msg is MountSetMessage:
               PlayedCharacterManager.getInstance().mount = this.makeMountData(MountSetMessage(msg).mountData,false);
               KernelEventsManager.getInstance().processCallback(MountHookList.MountSet);
               return true;
            case msg is MountUnSetMessage:
               PlayedCharacterManager.getInstance().mount = null;
               KernelEventsManager.getInstance().processCallback(MountHookList.MountUnSet);
               return true;
            case msg is MountRidingMessage:
               PlayedCharacterManager.getInstance().isRidding = MountRidingMessage(msg).isRiding;
               KernelEventsManager.getInstance().processCallback(MountHookList.MountRiding,MountRidingMessage(msg).isRiding);
               return true;
            case msg is MountEquipedErrorMessage:
               meemsg = MountEquipedErrorMessage(msg);
               switch(meemsg.errorType)
               {
                  case MountEquipedErrorEnum.UNSET:
                     typeError = "UNSET";
                     break;
                  case MountEquipedErrorEnum.SET:
                     typeError = "SET";
                     break;
                  case MountEquipedErrorEnum.RIDING:
                     typeError = "RIDING";
                     KernelEventsManager.getInstance().processCallback(MountHookList.MountRiding,false);
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountEquipedError,typeError);
               return true;
            case msg is ExchangeStartedMountStockMessage:
               esmsmsg = ExchangeStartedMountStockMessage(msg);
               PlayedCharacterManager.getInstance().isInExchange = true;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeStartedType,ExchangeTypeEnum.MOUNT);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.MOUNT_STORAGE_MOD);
               _exchangeFrame.initMountStock(esmsmsg.objectsInfos);
               return true;
            case msg is ExchangeWeightMessage:
               ewmsg = msg as ExchangeWeightMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeWeight,ewmsg.currentWeight,ewmsg.maxWeight);
               return true;
            case msg is ExchangeStartOkMountMessage:
               esokmmsg = msg as ExchangeStartOkMountMessage;
               pmount = PlayedCharacterManager.getInstance().mount;
               this.sendStartOkMount(esokmmsg.stabledMountsDescription,esokmmsg.paddockedMountsDescription);
               return true;
            case msg is ExchangeStartOkMountWithOutPaddockMessage:
               esomwopmsg = msg as ExchangeStartOkMountWithOutPaddockMessage;
               this.sendStartOkMount(esomwopmsg.stabledMountsDescription,null);
               return true;
            case msg is ExchangeMountStableAddMessage:
               emsamsg = msg as ExchangeMountStableAddMessage;
               this._stableList.push(this.makeMountData(emsamsg.mountDescription));
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case msg is ExchangeMountStableBornAddMessage:
               emsbamsg = msg as ExchangeMountStableBornAddMessage;
               newMount = this.makeMountData(emsbamsg.mountDescription);
               newMount.borning = true;
               this._stableList.push(newMount);
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case msg is ExchangeMountStableRemoveMessage:
               emsrmsg = msg as ExchangeMountStableRemoveMessage;
               for(i = 0; i < this._stableList.length; i++)
               {
                  if(this._stableList[i].id == emsrmsg.mountId)
                  {
                     this._stableList.splice(i,1);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,this._stableList,null,null);
               return true;
            case msg is ExchangeMountPaddockAddMessage:
               empamsg = msg as ExchangeMountPaddockAddMessage;
               this._paddockList.push(this.makeMountData(empamsg.mountDescription));
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,this._paddockList,null);
               return true;
            case msg is ExchangeMountPaddockRemoveMessage:
               emprmsg = msg as ExchangeMountPaddockRemoveMessage;
               for(i = 0; i < this._paddockList.length; i++)
               {
                  if(this._paddockList[i].id == emprmsg.mountId)
                  {
                     this._paddockList.splice(i,1);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(MountHookList.MountStableUpdate,null,this._paddockList,null);
               return true;
            case msg is ExchangeMountStableErrorMessage:
               emsemsg = msg as ExchangeMountStableErrorMessage;
               return true;
            case msg is PaddockSellBuyDialogMessage:
               psbdmsg = msg as PaddockSellBuyDialogMessage;
               KernelEventsManager.getInstance().processCallback(MountHookList.PaddockSellBuyDialog,psbdmsg.bsell,psbdmsg.ownerId,psbdmsg.price);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function makeMountData(o:MountClientData, cache:Boolean = true) : Object
      {
         var mountData:Object = null;
         var ability:uint = 0;
         var nEffect:int = 0;
         var i:int = 0;
         if(Boolean(this._dictionary_cache[o.id]) && Boolean(cache))
         {
            mountData = this.getMountFromCache(o.id);
         }
         else
         {
            mountData = CopyObject.copyObject(o,["behaviors","ancestor"]);
            this._dictionary_cache[mountData.id] = mountData;
         }
         var mount:Mount = Mount.getMountById(o.model);
         if(!o.name)
         {
            mountData.name = I18n.getText(I18nProxy.getKeyId("ui.common.noName"));
         }
         mountData.id = o.id;
         mountData.description = mount.name;
         mountData.xpRatio = this._mountXpRatio;
         try
         {
            mountData.entityLook = TiphonEntityLook.fromString(mount.look);
         }
         catch(e:Error)
         {
         }
         var a:Vector.<uint> = o.ancestor.concat();
         a.unshift(o.model);
         mountData.ancestor = this.makeParent(a,0,1);
         mountData.ability = new Array();
         for each(ability in o.behaviors)
         {
            mountData.ability.push(MountBehavior.getMountBehaviorById(ability));
         }
         mountData.effectList = new Array();
         nEffect = o.effectList.length;
         for(i = 0; i < nEffect; i++)
         {
            mountData.effectList.push(ObjectEffectAdapter.fromNetwork(o.effectList[i]));
         }
         return mountData;
      }
      
      private function getMountFromCache(id:uint) : Object
      {
         return this._dictionary_cache[id];
      }
      
      private function makeParent(ancestor:Vector.<uint>, generation:uint, index:uint) : Object
      {
         var ancestorIndex:uint = generation * generation - 1 + index;
         if(ancestor.length <= ancestorIndex)
         {
            return null;
         }
         var mount:Mount = Mount.getMountById(ancestor[ancestorIndex]);
         if(!mount)
         {
            return null;
         }
         return {
            "mount":mount,
            "mother":this.makeParent(ancestor,generation + 1,index),
            "father":this.makeParent(ancestor,generation + 1,index + 1),
            "entityLook":TiphonEntityLook.fromString(mount.look)
         };
      }
      
      private function addCommonExchangeFrame(pExchangeType:uint) : void
      {
         var roleplayContextFrame:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         if(!Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame))
         {
            _commonExchangeFrame = new com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame(roleplayContextFrame,pExchangeType);
            Kernel.getWorker().addFrame(_commonExchangeFrame);
         }
         if(!Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame))
         {
            _exchangeFrame = new com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame(roleplayContextFrame,Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame) as com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame;
            Kernel.getWorker().addFrame(_exchangeFrame);
         }
      }
      
      private function sendStartOkMount(stableMountsDescription:Vector.<MountClientData>, paddockMountsDescription:Vector.<MountClientData>) : void
      {
         var mountData:MountClientData = null;
         this._paddockList = new Array();
         this._stableList = new Array();
         this._inStable = true;
         for each(mountData in stableMountsDescription)
         {
            this._stableList.push(this.makeMountData(mountData));
         }
         if(paddockMountsDescription)
         {
            for each(mountData in paddockMountsDescription)
            {
               this._paddockList.push(this.makeMountData(mountData));
            }
         }
         KernelEventsManager.getInstance().processCallback(MountHookList.ExchangeStartOkMount,this._stableList,this._paddockList);
      }
   }
}
