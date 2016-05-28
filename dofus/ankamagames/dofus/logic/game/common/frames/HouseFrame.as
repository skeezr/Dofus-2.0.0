package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.house.HouseEnteredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildRightsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.purchasable.PurchasableDialogMessage;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.logic.game.common.actions.LeaveDialogAction;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseBuyAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseBuyRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseSellAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseSellRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseSellFromInsideAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseSellFromInsideRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseSoldMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseBuyResultMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildRightsViewAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildRightsViewMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildRightsChangeAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildRightsChangeRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildShareAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildShareRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseKickAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseKickRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseKickIndoorMerchantAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseKickIndoorMerchantRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableStateUpdateHouseDoorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableShowCodeDialogMessage;
   import com.ankamagames.dofus.logic.game.common.actions.LockableChangeCodeAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableChangeCodeMessage;
   import com.ankamagames.dofus.logic.game.common.actions.HouseLockFromInsideAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseLockFromInsideRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableCodeResultMessage;
   import com.ankamagames.dofus.logic.game.common.actions.LockableUseCodeAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableUseCodeMessage;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import flash.geom.Point;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.house.HouseExitedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildNoneMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import flash.utils.Dictionary;
   
   public class HouseFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(JobsFrame));
       
      public function HouseFrame()
      {
         super();
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
         var i:int = 0;
         var housesListSize:int = 0;
         var hmsg:HouseEnteredMessage = null;
         var playerHouse:* = false;
         var hgrm:HouseGuildRightsMessage = null;
         var pdmsg:PurchasableDialogMessage = null;
         var houseType:int = 0;
         var ownerName:String = null;
         var houseID:uint = 0;
         var houseWrapper:HouseWrapper = null;
         var lda:LeaveDialogAction = null;
         var lsrmsg:LeaveDialogRequestMessage = null;
         var hba:HouseBuyAction = null;
         var hbrm:HouseBuyRequestMessage = null;
         var hsa:HouseSellAction = null;
         var hsrm:HouseSellRequestMessage = null;
         var hsfia:HouseSellFromInsideAction = null;
         var hsfirmag:HouseSellFromInsideRequestMessage = null;
         var hsm:HouseSoldMessage = null;
         var nhbrm:HouseBuyResultMessage = null;
         var hgrva:HouseGuildRightsViewAction = null;
         var hgrvm:HouseGuildRightsViewMessage = null;
         var hgrca:HouseGuildRightsChangeAction = null;
         var hgrcrmsg:HouseGuildRightsChangeRequestMessage = null;
         var hsga:HouseGuildShareAction = null;
         var hgsrm:HouseGuildShareRequestMessage = null;
         var hka:HouseKickAction = null;
         var hkrm:HouseKickRequestMessage = null;
         var hkima:HouseKickIndoorMerchantAction = null;
         var hkimrm:HouseKickIndoorMerchantRequestMessage = null;
         var lsuhdmsg:LockableStateUpdateHouseDoorMessage = null;
         var lscdmsg:LockableShowCodeDialogMessage = null;
         var lcca:LockableChangeCodeAction = null;
         var lccmsg:LockableChangeCodeMessage = null;
         var hlfia:HouseLockFromInsideAction = null;
         var hlfimsg:HouseLockFromInsideRequestMessage = null;
         var lcrmsg:LockableCodeResultMessage = null;
         var luca:LockableUseCodeAction = null;
         var lucmsg:LockableUseCodeMessage = null;
         switch(true)
         {
            case msg is HouseEnteredMessage:
               hmsg = msg as HouseEnteredMessage;
               playerHouse = PlayerManager.getInstance().nickname == hmsg.ownerName;
               PlayedCharacterManager.getInstance().isInHouse = true;
               PlayedCharacterManager.getInstance().lastCoord = new Point(hmsg.worldX,hmsg.worldY);
               if(playerHouse)
               {
                  PlayedCharacterManager.getInstance().isInHisHouse = true;
               }
               KernelEventsManager.getInstance().processCallback(HookList.HouseEntered,playerHouse,hmsg.ownerId,hmsg.ownerName,hmsg.price,hmsg.isLocked,hmsg.worldX,hmsg.worldY,HouseWrapper.manualCreate(hmsg.modelId,-1,hmsg.ownerName,hmsg.price != 0));
               return true;
            case msg is HouseExitedMessage:
               PlayedCharacterManager.getInstance().isInHouse = false;
               PlayedCharacterManager.getInstance().isInHisHouse = false;
               KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
               return true;
            case msg is HouseGuildNoneMessage:
               KernelEventsManager.getInstance().processCallback(HookList.HouseGuildNone);
               return true;
            case msg is HouseGuildRightsMessage:
               hgrm = msg as HouseGuildRightsMessage;
               KernelEventsManager.getInstance().processCallback(HookList.HouseGuildRights,hgrm.houseId,hgrm.guildName,hgrm.guildEmblem,hgrm.rights);
               return true;
            case msg is PurchasableDialogMessage:
               pdmsg = msg as PurchasableDialogMessage;
               houseType = 0;
               ownerName = "";
               houseID = pdmsg.purchasableId;
               houseWrapper = this.getHouseInformations(pdmsg.purchasableId);
               if(houseWrapper)
               {
                  houseType = houseWrapper.houseId;
                  ownerName = houseWrapper.ownerName;
               }
               KernelEventsManager.getInstance().processCallback(HookList.PurchasableDialog,pdmsg.buyOrSell,pdmsg.price,houseWrapper);
               return true;
            case msg is LeaveDialogAction:
               lda = msg as LeaveDialogAction;
               lsrmsg = new LeaveDialogRequestMessage();
               lsrmsg.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(lsrmsg);
               return true;
            case msg is HouseBuyAction:
               hba = msg as HouseBuyAction;
               hbrm = new HouseBuyRequestMessage();
               hbrm.initHouseBuyRequestMessage(hba.proposedPrice);
               ConnectionsHandler.getConnection().send(hbrm);
               return true;
            case msg is HouseSellAction:
               hsa = msg as HouseSellAction;
               hsrm = new HouseSellRequestMessage();
               hsrm.initHouseSellRequestMessage(hsa.amount);
               ConnectionsHandler.getConnection().send(hsrm);
               return true;
            case msg is HouseSellFromInsideAction:
               hsfia = msg as HouseSellFromInsideAction;
               hsfirmag = new HouseSellFromInsideRequestMessage();
               hsfirmag.initHouseSellFromInsideRequestMessage(hsfia.amount);
               ConnectionsHandler.getConnection().send(hsfirmag);
               return true;
            case msg is HouseSoldMessage:
               hsm = msg as HouseSoldMessage;
               KernelEventsManager.getInstance().processCallback(HookList.HouseSold,hsm.houseId,hsm.realPrice,hsm.buyerName);
               return true;
            case msg is HouseBuyResultMessage:
               nhbrm = msg as HouseBuyResultMessage;
               KernelEventsManager.getInstance().processCallback(HookList.HouseBuyResult,nhbrm.houseId,nhbrm.bought,nhbrm.realPrice,this.getHouseInformations(nhbrm.houseId).ownerName);
               return true;
            case msg is HouseGuildRightsViewAction:
               hgrva = msg as HouseGuildRightsViewAction;
               hgrvm = new HouseGuildRightsViewMessage();
               ConnectionsHandler.getConnection().send(hgrvm);
               return true;
            case msg is HouseGuildRightsChangeAction:
               hgrca = msg as HouseGuildRightsChangeAction;
               hgrcrmsg = new HouseGuildRightsChangeRequestMessage();
               hgrcrmsg.initHouseGuildRightsChangeRequestMessage(hgrca.rights);
               ConnectionsHandler.getConnection().send(hgrcrmsg);
               return true;
            case msg is HouseGuildShareAction:
               hsga = msg as HouseGuildShareAction;
               hgsrm = new HouseGuildShareRequestMessage();
               hgsrm.initHouseGuildShareRequestMessage(hsga.enabled);
               ConnectionsHandler.getConnection().send(hgsrm);
               return true;
            case msg is HouseKickAction:
               hka = msg as HouseKickAction;
               hkrm = new HouseKickRequestMessage();
               hkrm.initHouseKickRequestMessage(hka.id);
               ConnectionsHandler.getConnection().send(hkrm);
               return true;
            case msg is HouseKickIndoorMerchantAction:
               hkima = msg as HouseKickIndoorMerchantAction;
               hkimrm = new HouseKickIndoorMerchantRequestMessage();
               hkimrm.initHouseKickIndoorMerchantRequestMessage(hkima.cellId);
               ConnectionsHandler.getConnection().send(hkimrm);
               return true;
            case msg is LockableStateUpdateHouseDoorMessage:
               lsuhdmsg = msg as LockableStateUpdateHouseDoorMessage;
               KernelEventsManager.getInstance().processCallback(HookList.LockableStateUpdateHouseDoor,lsuhdmsg.houseId,lsuhdmsg.locked);
               return true;
            case msg is LockableShowCodeDialogMessage:
               lscdmsg = msg as LockableShowCodeDialogMessage;
               KernelEventsManager.getInstance().processCallback(HookList.LockableShowCode,lscdmsg.changeOrUse,lscdmsg.codeSize);
               return true;
            case msg is LockableChangeCodeAction:
               lcca = msg as LockableChangeCodeAction;
               lccmsg = new LockableChangeCodeMessage();
               lccmsg.initLockableChangeCodeMessage(lcca.code);
               ConnectionsHandler.getConnection().send(lccmsg);
               return true;
            case msg is HouseLockFromInsideAction:
               hlfia = msg as HouseLockFromInsideAction;
               hlfimsg = new HouseLockFromInsideRequestMessage();
               hlfimsg.initHouseLockFromInsideRequestMessage(hlfia.code);
               ConnectionsHandler.getConnection().send(hlfimsg);
               return true;
            case msg is LockableCodeResultMessage:
               lcrmsg = msg as LockableCodeResultMessage;
               KernelEventsManager.getInstance().processCallback(HookList.LockableCodeResult,lcrmsg.success);
               return true;
            case msg is LockableUseCodeAction:
               luca = msg as LockableUseCodeAction;
               lucmsg = new LockableUseCodeMessage();
               lucmsg.initLockableUseCodeMessage(luca.code);
               ConnectionsHandler.getConnection().send(lucmsg);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function getHouseInformations(houseID:uint) : HouseWrapper
      {
         var hi:HouseWrapper = null;
         var houseList:Dictionary = (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).housesInformations;
         for each(hi in houseList)
         {
            if(hi.houseId == houseID)
            {
               return hi;
            }
         }
         return null;
      }
   }
}
