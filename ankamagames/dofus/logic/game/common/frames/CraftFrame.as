package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.StorageModList;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerMultiCraftRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeItemGoldAddAsPaymentAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemGoldAddAsPaymentMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeItemObjectAddAsPaymentAction;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemObjectAddAsPaymentMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayStopAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplayStopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemAutoCraftStopedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeGoldPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRemovedPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeModifiedPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedInBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectPutInBagMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedFromBagMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeObjectUseInWorkshopAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectUseInWorkshopMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeMultiCraftCrafterCanUseHisRessourcesMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCrafterMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCustomerMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangeReplayAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplayMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplayCountModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemAutoCraftRemainingMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectIdMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectDescMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.enums.PaymentTypeEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.ExchangeReplayStopReasonEnum;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.internalDatacenter.jobs.RecipeWithSkill;
   
   public class CraftFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CraftFrame));
       
      public var playerList:PlayerExchangeCraftList;
      
      public var otherPlayerList:PlayerExchangeCraftList;
      
      public var paymentCraftList:PaymentCraftList;
      
      private var _crafterInfos:PlayerInfo;
      
      private var _customerInfos:PlayerInfo;
      
      public var bagList:Array;
      
      private var _roleplayContextFrame:RoleplayContextFrame;
      
      private var _isCrafter:Boolean;
      
      private var _recipes:Array;
      
      public function CraftFrame(parentFrame:RoleplayContextFrame)
      {
         this.playerList = new PlayerExchangeCraftList();
         this.otherPlayerList = new PlayerExchangeCraftList();
         this.paymentCraftList = new PaymentCraftList();
         this._crafterInfos = new PlayerInfo();
         this._customerInfos = new PlayerInfo();
         this.bagList = new Array();
         super();
         this._roleplayContextFrame = parentFrame;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get crafterInfos() : PlayerInfo
      {
         return this._crafterInfos;
      }
      
      public function get customerInfos() : PlayerInfo
      {
         return this._customerInfos;
      }
      
      public function processExchangeOkMultiCraftMessage(msg:ExchangeOkMultiCraftMessage) : void
      {
         PlayedCharacterManager.getInstance().isInExchange = true;
         var eomcmsg:ExchangeOkMultiCraftMessage = msg as ExchangeOkMultiCraftMessage;
         if(eomcmsg.role == ExchangeTypeEnum.MULTICRAFT_CRAFTER)
         {
            this.playerList.isCrafter = true;
            this.otherPlayerList.isCrafter = false;
            this._crafterInfos.id = PlayedCharacterManager.getInstance().infos.id;
            if(this.crafterInfos.id == eomcmsg.initiatorId)
            {
               this._customerInfos.id = eomcmsg.otherId;
            }
            else
            {
               this._customerInfos.id = eomcmsg.initiatorId;
            }
         }
         else
         {
            this.playerList.isCrafter = false;
            this.otherPlayerList.isCrafter = true;
            this._customerInfos.id = PlayedCharacterManager.getInstance().infos.id;
            if(this.customerInfos.id == eomcmsg.initiatorId)
            {
               this._crafterInfos.id = eomcmsg.otherId;
            }
            else
            {
               this._crafterInfos.id = eomcmsg.initiatorId;
            }
         }
         this._crafterInfos.look = EntityLookAdapter.fromNetwork(this._roleplayContextFrame.entitiesFrame.getEntityInfos(this.crafterInfos.id).look);
         this._crafterInfos.name = (this._roleplayContextFrame.entitiesFrame.getEntityInfos(this.crafterInfos.id) as GameRolePlayNamedActorInformations).name;
         this._customerInfos.look = EntityLookAdapter.fromNetwork(this._roleplayContextFrame.entitiesFrame.getEntityInfos(this.customerInfos.id).look);
         this._customerInfos.name = (this._roleplayContextFrame.entitiesFrame.getEntityInfos(this.customerInfos.id) as GameRolePlayNamedActorInformations).name;
         var otherName:String = "";
         var askerId:uint = eomcmsg.initiatorId;
         if(eomcmsg.initiatorId == PlayedCharacterManager.getInstance().infos.id)
         {
            if(eomcmsg.initiatorId == this.crafterInfos.id)
            {
               this._isCrafter = true;
               otherName = this.customerInfos.name;
            }
            else
            {
               otherName = this.crafterInfos.name;
            }
         }
         else if(eomcmsg.otherId == this.crafterInfos.id)
         {
            otherName = this.crafterInfos.name;
         }
         else
         {
            this._isCrafter = true;
            otherName = this.customerInfos.name;
         }
         KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeMultiCraftRequest,eomcmsg.role,otherName,askerId);
      }
      
      public function processExchangeStartOkCraftWithInformationMessage(msg:ExchangeStartOkCraftWithInformationMessage) : void
      {
         PlayedCharacterManager.getInstance().isInExchange = true;
         var esocwimsg:ExchangeStartOkCraftWithInformationMessage = msg as ExchangeStartOkCraftWithInformationMessage;
         var recipes:Array = this.getAllRecipesForSkillId(esocwimsg.skillId,esocwimsg.nbCase);
         this._roleplayContextFrame.commonExchangeFrame.synchronizeDisplayedInventory();
         this._isCrafter = true;
         var skill:Skill = Skill.getSkillById(esocwimsg.skillId);
         if(Boolean(skill.isForgemagus) || skill.modifiableItemType != -1)
         {
            KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.SMITH_MAGIC_MOD);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.CRAFT_MOD);
         }
         KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkCraft,recipes,esocwimsg.skillId,esocwimsg.nbCase);
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         this.playerList = new PlayerExchangeCraftList();
         this.otherPlayerList = new PlayerExchangeCraftList();
         this.bagList = new Array();
         this._crafterInfos = new PlayerInfo();
         this._customerInfos = new PlayerInfo();
         this.paymentCraftList = new PaymentCraftList();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var epmcra:ExchangePlayerMultiCraftRequestAction = null;
         var epmcrmsg:ExchangePlayerMultiCraftRequestMessage = null;
         var eigaapa:ExchangeItemGoldAddAsPaymentAction = null;
         var paymentType:uint = 0;
         var eigaapmsg:ExchangeItemGoldAddAsPaymentMessage = null;
         var eioaapa:ExchangeItemObjectAddAsPaymentAction = null;
         var paymentTypeObject:uint = 0;
         var objectlist:Array = null;
         var itemWr:ItemWrapper = null;
         var eioaapmsg:ExchangeItemObjectAddAsPaymentMessage = null;
         var ersa:ExchangeReplayStopAction = null;
         var rsmsg:ExchangeReplayStopMessage = null;
         var ecrmsg:ExchangeCraftResultMessage = null;
         var messageId:uint = 0;
         var objectName:String = null;
         var craftResultMessage:String = null;
         var itemW:ItemWrapper = null;
         var success:* = false;
         var eiacsmsg:ExchangeItemAutoCraftStopedMessage = null;
         var autoCraftStopedMessage:String = null;
         var commonMod:Object = null;
         var esocmsg:ExchangeStartOkCraftMessage = null;
         var msgId:uint = 0;
         var egpfcmsg:ExchangeGoldPaymentForCraftMessage = null;
         var eipfcmsg:ExchangeItemPaymentForCraftMessage = null;
         var itemWrapper:ItemWrapper = null;
         var erpfcmsg:ExchangeRemovedPaymentForCraftMessage = null;
         var empfcmsg:ExchangeModifiedPaymentForCraftMessage = null;
         var itTemp:ItemWrapper = null;
         var newItemWra:ItemWrapper = null;
         var objectLis:Array = null;
         var eomiwmsg:ExchangeObjectModifiedInBagMessage = null;
         var eopiwmsg:ExchangeObjectPutInBagMessage = null;
         var obj:ObjectItem = null;
         var obAdded:ItemWrapper = null;
         var eorfwmsg:ExchangeObjectRemovedFromBagMessage = null;
         var compt:uint = 0;
         var eosiwa:ExchangeObjectUseInWorkshopAction = null;
         var eouiwmsg:ExchangeObjectUseInWorkshopMessage = null;
         var emcsccuhra:ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction = null;
         var emcsccuhrmsg:ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage = null;
         var emcccuhrmsg:ExchangeMultiCraftCrafterCanUseHisRessourcesMessage = null;
         var esomcmsg:ExchangeStartOkMulticraftCrafterMessage = null;
         var recipes:Array = null;
         var skill:Skill = null;
         var esomcustomermsg:ExchangeStartOkMulticraftCustomerMessage = null;
         var recipesCrafter:Array = null;
         var era:ExchangeReplayAction = null;
         var ermsg:ExchangeReplayMessage = null;
         var ercmmsg:ExchangeReplayCountModifiedMessage = null;
         var eiacrmsg:ExchangeItemAutoCraftRemainingMessage = null;
         var ecrwoimsg:ExchangeCraftResultWithObjectIdMessage = null;
         var ecrwodmsg:ExchangeCraftResultWithObjectDescMessage = null;
         var iwrapper:ItemWrapper = null;
         var newItemWr:ItemWrapper = null;
         var iw:ItemWrapper = null;
         switch(true)
         {
            case msg is ExchangePlayerMultiCraftRequestAction:
               epmcra = msg as ExchangePlayerMultiCraftRequestAction;
               epmcrmsg = new ExchangePlayerMultiCraftRequestMessage();
               epmcrmsg.initExchangePlayerMultiCraftRequestMessage(epmcra.exchangeType,epmcra.target,epmcra.skillId);
               ConnectionsHandler.getConnection().send(epmcrmsg);
               return true;
            case msg is ExchangeOkMultiCraftMessage:
               this.processExchangeOkMultiCraftMessage(msg as ExchangeOkMultiCraftMessage);
               return true;
            case msg is ExchangeItemGoldAddAsPaymentAction:
               eigaapa = msg as ExchangeItemGoldAddAsPaymentAction;
               if(eigaapa.onlySuccess)
               {
                  paymentType = PaymentTypeEnum.PAYMENT_ON_SUCCESS_ONLY;
               }
               else
               {
                  paymentType = PaymentTypeEnum.PAYMENT_IN_ANY_CASE;
               }
               eigaapmsg = new ExchangeItemGoldAddAsPaymentMessage();
               eigaapmsg.initExchangeItemGoldAddAsPaymentMessage(paymentType,eigaapa.kamas);
               ConnectionsHandler.getConnection().send(eigaapmsg);
               return true;
            case msg is ExchangeItemObjectAddAsPaymentAction:
               eioaapa = msg as ExchangeItemObjectAddAsPaymentAction;
               if(eioaapa.onlySuccess)
               {
                  paymentTypeObject = PaymentTypeEnum.PAYMENT_ON_SUCCESS_ONLY;
                  objectlist = this.paymentCraftList.objectsPaymentOnlySuccess;
               }
               else
               {
                  paymentTypeObject = PaymentTypeEnum.PAYMENT_IN_ANY_CASE;
                  objectlist = this.paymentCraftList.objectsPaymentOnlySuccess;
               }
               eioaapmsg = new ExchangeItemObjectAddAsPaymentMessage();
               eioaapmsg.initExchangeItemObjectAddAsPaymentMessage(paymentTypeObject,eioaapa.isAdd,eioaapa.objectUID,eioaapa.quantity);
               ConnectionsHandler.getConnection().send(eioaapmsg);
               return true;
            case msg is ExchangeReplayStopAction:
               ersa = msg as ExchangeReplayStopAction;
               rsmsg = new ExchangeReplayStopMessage();
               rsmsg.initExchangeReplayStopMessage();
               ConnectionsHandler.getConnection().send(rsmsg);
               return true;
            case msg is ExchangeCraftResultMessage:
               ecrmsg = msg as ExchangeCraftResultMessage;
               messageId = ecrmsg.getMessageId();
               itemW = null;
               success = false;
               switch(messageId)
               {
                  case ExchangeCraftResultMessage.protocolId:
                     craftResultMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.noCraftResult"));
                     break;
                  case ExchangeCraftResultWithObjectIdMessage.protocolId:
                     ecrwoimsg = msg as ExchangeCraftResultWithObjectIdMessage;
                     itemW = ItemWrapper.create(63,0,ecrwoimsg.objectGenericId,1,null,false);
                     objectName = Item.getItemById(ecrwoimsg.objectGenericId).name;
                     craftResultMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.failed"));
                     success = ecrwoimsg.craftResult == 2;
                     break;
                  case ExchangeCraftResultWithObjectDescMessage.protocolId:
                     ecrwodmsg = msg as ExchangeCraftResultWithObjectDescMessage;
                     itemW = ItemWrapper.create(63,0,ecrwodmsg.objectInfo.objectGID,1,ecrwodmsg.objectInfo.effects,false);
                     if(ecrwodmsg.objectInfo.objectGID == 0)
                     {
                        break;
                     }
                     objectName = Item.getItemById(ecrwodmsg.objectInfo.objectGID).name;
                     switch(true)
                     {
                        case this._crafterInfos.id == PlayedCharacterManager.getInstance().id:
                           craftResultMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.successTarget"),[objectName,this._customerInfos.name]);
                           break;
                        case this._customerInfos.id == PlayedCharacterManager.getInstance().id:
                           craftResultMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.successOther"),[this._crafterInfos.name,objectName]);
                           break;
                        default:
                           craftResultMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.craftSuccessSelf"),[objectName]);
                     }
                     success = ecrwodmsg.craftResult == 2;
                     break;
               }
               this.resetLists();
               if(success)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CRAFT_OK);
               }
               else
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CRAFT_KO);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,craftResultMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeCraftResult,ecrmsg.craftResult,itemW);
               return true;
            case msg is ExchangeItemAutoCraftStopedMessage:
               eiacsmsg = msg as ExchangeItemAutoCraftStopedMessage;
               autoCraftStopedMessage = "";
               switch(eiacsmsg.reason)
               {
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_IMPOSSIBLE_CRAFT:
                     autoCraftStopedMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.autoCraftStopedInvalidRecipe"));
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_MISSING_RESSOURCE:
                     autoCraftStopedMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.autoCraftStopedNoRessource"));
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_OK:
                     autoCraftStopedMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.autoCraftStopedOk"));
                     break;
                  case ExchangeReplayStopReasonEnum.STOPPED_REASON_USER:
                     autoCraftStopedMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.autoCraftStoped"));
               }
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.information")),autoCraftStopedMessage,[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,autoCraftStopedMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeItemAutoCraftStoped,eiacsmsg.reason);
               return true;
            case msg is ExchangeStartOkCraftMessage:
               esocmsg = msg as ExchangeStartOkCraftMessage;
               PlayedCharacterManager.getInstance().isInExchange = true;
               msgId = esocmsg.getMessageId();
               switch(msgId)
               {
                  case ExchangeStartOkCraftMessage.protocolId:
                     KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.CRAFT_MOD);
                     KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkCraft);
                     break;
                  case ExchangeStartOkCraftWithInformationMessage.protocolId:
                     skill = Skill.getSkillById((esocmsg as ExchangeStartOkCraftWithInformationMessage).skillId);
                     if(Boolean(skill.isForgemagus) || skill.modifiableItemType != -1)
                     {
                        KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.SMITH_MAGIC_MOD);
                     }
                     else
                     {
                        KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.CRAFT_MOD);
                     }
                     this.processExchangeStartOkCraftWithInformationMessage(msg as ExchangeStartOkCraftWithInformationMessage);
               }
               return true;
            case msg is ExchangeGoldPaymentForCraftMessage:
               egpfcmsg = msg as ExchangeGoldPaymentForCraftMessage;
               if(egpfcmsg.onlySuccess)
               {
                  this.paymentCraftList.kamaPaymentOnlySuccess = egpfcmsg.goldSum;
               }
               else
               {
                  this.paymentCraftList.kamaPayment = egpfcmsg.goldSum;
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList);
               return true;
            case msg is ExchangeItemPaymentForCraftMessage:
               eipfcmsg = msg as ExchangeItemPaymentForCraftMessage;
               itemWrapper = ItemWrapper.create(63,eipfcmsg.object.objectUID,eipfcmsg.object.objectGID,eipfcmsg.object.quantity,eipfcmsg.object.effects,false);
               this.addObjetPayment(eipfcmsg.onlySuccess,itemWrapper);
               KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList);
               return true;
            case msg is ExchangeRemovedPaymentForCraftMessage:
               erpfcmsg = msg as ExchangeRemovedPaymentForCraftMessage;
               this.removeObjetPayment(erpfcmsg.objectUID,erpfcmsg.onlySuccess);
               KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList);
               return true;
            case msg is ExchangeModifiedPaymentForCraftMessage:
               empfcmsg = msg as ExchangeModifiedPaymentForCraftMessage;
               itTemp = ItemWrapper.getItemFromUId(empfcmsg.object.objectUID);
               newItemWra = ItemWrapper.create(63,empfcmsg.object.objectUID,empfcmsg.object.objectGID,empfcmsg.object.quantity,empfcmsg.object.effects,false);
               if(empfcmsg.onlySuccess)
               {
                  objectLis = this.paymentCraftList.objectsPaymentOnlySuccess;
               }
               else
               {
                  objectLis = this.paymentCraftList.objectsPayment;
               }
               objectLis.splice(objectLis.indexOf(itTemp),1,newItemWra);
               KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList);
               return true;
            case msg is ExchangeObjectModifiedInBagMessage:
               eomiwmsg = msg as ExchangeObjectModifiedInBagMessage;
               for each(iwrapper in this.bagList)
               {
                  if(iwrapper.objectUID == eomiwmsg.object.objectUID)
                  {
                     newItemWr = ItemWrapper.create(63,eomiwmsg.object.objectUID,eomiwmsg.object.objectGID,eomiwmsg.object.quantity,eomiwmsg.object.effects,false);
                     this.bagList.splice(this.bagList.indexOf(iwrapper),1,newItemWr);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagListUpdate,this.bagList);
               return true;
            case msg is ExchangeObjectPutInBagMessage:
               eopiwmsg = msg as ExchangeObjectPutInBagMessage;
               obj = eopiwmsg.object;
               obAdded = ItemWrapper.create(63,obj.objectUID,obj.objectGID,obj.quantity,obj.effects,false);
               if(!eopiwmsg.remote && !this._isCrafter)
               {
                  this._roleplayContextFrame.commonExchangeFrame.updateDisplayedInventoryObject(obAdded,false,-obAdded.quantity);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this._roleplayContextFrame.commonExchangeFrame.displayedInventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               }
               this.bagList.push(obAdded);
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagListUpdate,this.bagList);
               return true;
            case msg is ExchangeObjectRemovedFromBagMessage:
               eorfwmsg = msg as ExchangeObjectRemovedFromBagMessage;
               compt = 0;
               for each(iw in this.bagList)
               {
                  if(iw.objectUID == eorfwmsg.objectUID)
                  {
                     this.bagList.splice(compt,1);
                     break;
                  }
                  compt++;
               }
               if(!eorfwmsg.remote && !this._isCrafter)
               {
                  this._roleplayContextFrame.commonExchangeFrame.updateDisplayedInventoryObject(iw,false,iw.quantity);
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.InventoryContent,this._roleplayContextFrame.commonExchangeFrame.displayedInventory,PlayedCharacterManager.getInstance().characteristics.kamas);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.BagListUpdate,this.bagList);
               return true;
            case msg is ExchangeObjectUseInWorkshopAction:
               eosiwa = msg as ExchangeObjectUseInWorkshopAction;
               eouiwmsg = new ExchangeObjectUseInWorkshopMessage();
               eouiwmsg.initExchangeObjectUseInWorkshopMessage(eosiwa.objectUID,eosiwa.quantity);
               ConnectionsHandler.getConnection().send(eouiwmsg);
               return true;
            case msg is ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction:
               emcsccuhra = msg as ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction;
               emcsccuhrmsg = new ExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage();
               emcsccuhrmsg.initExchangeMultiCraftSetCrafterCanUseHisRessourcesMessage(emcsccuhra.allow);
               ConnectionsHandler.getConnection().send(emcsccuhrmsg);
               return true;
            case msg is ExchangeMultiCraftCrafterCanUseHisRessourcesMessage:
               emcccuhrmsg = msg as ExchangeMultiCraftCrafterCanUseHisRessourcesMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeMultiCraftCrafterCanUseHisRessources,emcccuhrmsg.allowed);
               return true;
            case msg is ExchangeStartOkMulticraftCrafterMessage:
               esomcmsg = msg as ExchangeStartOkMulticraftCrafterMessage;
               recipes = this.getAllRecipesForSkillId(esomcmsg.skillId,esomcmsg.maxCase);
               this._roleplayContextFrame.commonExchangeFrame.synchronizeDisplayedInventory();
               skill = Skill.getSkillById(esomcmsg.skillId);
               if(Boolean(skill.isForgemagus) || skill.modifiableItemType != -1)
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.SMITH_MAGIC_MOD);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.CRAFT_MOD);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkMultiCraft,esomcmsg.skillId,recipes,esomcmsg.maxCase,this.crafterInfos,this.customerInfos);
               return true;
            case msg is ExchangeStartOkMulticraftCustomerMessage:
               esomcustomermsg = msg as ExchangeStartOkMulticraftCustomerMessage;
               recipesCrafter = this.getAllRecipesForSkillId(esomcustomermsg.skillId,esomcustomermsg.maxCase);
               this.crafterInfos.skillLevel = esomcustomermsg.crafterJobLevel;
               this._roleplayContextFrame.commonExchangeFrame.synchronizeDisplayedInventory();
               skill = Skill.getSkillById(esomcustomermsg.skillId);
               if(Boolean(skill.isForgemagus) || skill.modifiableItemType != -1)
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.SMITH_MAGIC_MOD);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.CRAFT_MOD);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkMultiCraft,esomcustomermsg.skillId,recipesCrafter,esomcustomermsg.maxCase,this.crafterInfos,this.customerInfos);
               return true;
            case msg is ExchangeReplayAction:
               era = msg as ExchangeReplayAction;
               ermsg = new ExchangeReplayMessage();
               ermsg.initExchangeReplayMessage(era.count);
               ConnectionsHandler.getConnection().send(ermsg);
               return true;
            case msg is ExchangeReplayCountModifiedMessage:
               ercmmsg = msg as ExchangeReplayCountModifiedMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeReplayCountModified,ercmmsg.count);
               return true;
            case msg is ExchangeItemAutoCraftRemainingMessage:
               eiacrmsg = msg as ExchangeItemAutoCraftRemainingMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeItemAutoCraftRemaining,eiacrmsg.count);
               return true;
            default:
               return false;
         }
      }
      
      private function resetLists() : void
      {
         this.playerList.componentList = new Array();
         this.otherPlayerList.componentList = new Array();
         this.paymentCraftList.kamaPayment = 0;
         this.paymentCraftList.kamaPaymentOnlySuccess = 0;
         this.paymentCraftList.objectsPayment = new Array();
         this.paymentCraftList.objectsPaymentOnlySuccess = new Array();
      }
      
      public function addCraftComponent(pRemote:Boolean, pItemWrapper:ItemWrapper) : void
      {
         var playerExchangeCraftList:PlayerExchangeCraftList = null;
         if(pRemote)
         {
            playerExchangeCraftList = this.otherPlayerList;
         }
         else
         {
            playerExchangeCraftList = this.playerList;
         }
         playerExchangeCraftList.componentList.push(pItemWrapper);
         this.sendUpdateHook(playerExchangeCraftList);
      }
      
      public function modifyCraftComponent(pRemote:Boolean, pItemWrapper:ItemWrapper) : void
      {
         var playerExchangeCraftList:PlayerExchangeCraftList = null;
         if(pRemote)
         {
            playerExchangeCraftList = this.otherPlayerList;
         }
         else
         {
            playerExchangeCraftList = this.playerList;
         }
         for(var index:int = 0; index < playerExchangeCraftList.componentList.length; index++)
         {
            if(playerExchangeCraftList.componentList[index].objectGID == pItemWrapper.objectGID)
            {
               playerExchangeCraftList.componentList.splice(index,1,pItemWrapper);
            }
         }
         this.sendUpdateHook(playerExchangeCraftList);
      }
      
      public function removeCraftComponent(pRemote:Boolean, pUID:uint) : void
      {
         var playerExchangeCraftList:PlayerExchangeCraftList = null;
         var itemW:ItemWrapper = null;
         var compt:uint = 0;
         if(pRemote)
         {
            playerExchangeCraftList = this.otherPlayerList;
         }
         else
         {
            playerExchangeCraftList = this.playerList;
         }
         for each(itemW in playerExchangeCraftList.componentList)
         {
            if(itemW.objectUID == pUID)
            {
               playerExchangeCraftList.componentList.splice(compt,1);
            }
            compt++;
         }
         this.sendUpdateHook(playerExchangeCraftList);
      }
      
      public function addObjetPayment(pOnlySuccess:Boolean, pItemWrapper:ItemWrapper) : void
      {
         if(pOnlySuccess)
         {
            this.paymentCraftList.objectsPaymentOnlySuccess.push(pItemWrapper);
         }
         else
         {
            this.paymentCraftList.objectsPayment.push(pItemWrapper);
         }
      }
      
      public function removeObjetPayment(pUID:uint, pOnlySuccess:Boolean) : void
      {
         var objects:Array = null;
         var itemW:ItemWrapper = null;
         var compt:uint = 0;
         if(pOnlySuccess)
         {
            objects = this.paymentCraftList.objectsPaymentOnlySuccess;
         }
         else
         {
            objects = this.paymentCraftList.objectsPayment;
         }
         for each(itemW in objects)
         {
            if(itemW.objectUID == pUID)
            {
               objects.splice(compt,1);
            }
            compt++;
         }
         KernelEventsManager.getInstance().processCallback(CraftHookList.PaymentCraftList,this.paymentCraftList);
      }
      
      private function sendUpdateHook(pPlayerExchangeCraftList:PlayerExchangeCraftList) : void
      {
         switch(pPlayerExchangeCraftList)
         {
            case this.otherPlayerList:
               KernelEventsManager.getInstance().processCallback(CraftHookList.OtherPlayerListUpdate,pPlayerExchangeCraftList);
               break;
            case this.playerList:
               KernelEventsManager.getInstance().processCallback(CraftHookList.PlayerListUpdate,pPlayerExchangeCraftList);
         }
      }
      
      private function getAllRecipesForSkillId(pSkillId:uint, pMaxCase:uint) : Array
      {
         var result:int = 0;
         var recipe:Recipe = null;
         var recipeSlots:uint = 0;
         var recipes:Array = new Array();
         var craftables:Vector.<int> = Skill.getSkillById(pSkillId).craftableItemIds;
         for each(result in craftables)
         {
            recipe = Recipe.getRecipeByResultId(result);
            recipeSlots = recipe.ingredientIds.length;
            if(recipeSlots <= pMaxCase)
            {
               recipes.push(new RecipeWithSkill(recipe,Skill.getSkillById(pSkillId)));
            }
         }
         recipes = recipes.sort(this.skillSortFunction);
         return recipes;
      }
      
      private function skillSortFunction(a:RecipeWithSkill, b:RecipeWithSkill) : Number
      {
         if(a.recipe.quantities.length > b.recipe.quantities.length)
         {
            return -1;
         }
         if(a.recipe.quantities.length == b.recipe.quantities.length)
         {
            return 0;
         }
         return 1;
      }
   }
}

class PaymentCraftList
{
    
   public var kamaPaymentOnlySuccess:uint;
   
   public var objectsPaymentOnlySuccess:Array;
   
   public var kamaPayment:uint;
   
   public var objectsPayment:Array;
   
   function PaymentCraftList()
   {
      super();
      this.kamaPaymentOnlySuccess = 0;
      this.objectsPaymentOnlySuccess = new Array();
      this.kamaPayment = 0;
      this.objectsPayment = new Array();
   }
}

class PlayerExchangeCraftList
{
    
   public var componentList:Array;
   
   public var isCrafter:Boolean;
   
   function PlayerExchangeCraftList()
   {
      super();
      this.componentList = new Array();
      this.isCrafter = false;
   }
}

import com.ankamagames.tiphon.types.look.TiphonEntityLook;

class PlayerInfo
{
    
   public var id:uint;
   
   public var name:String;
   
   public var look:TiphonEntityLook;
   
   public var skillLevel:int;
   
   function PlayerInfo()
   {
      super();
   }
}
