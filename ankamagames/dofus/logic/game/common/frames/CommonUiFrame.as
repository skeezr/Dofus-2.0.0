package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValueMessage;
   import com.ankamagames.dofus.network.messages.game.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.EntityTalkMessage;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionLimitationMessage;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionZoneMessage;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.NumericalValueTypeEnum;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import flash.text.TextFormat;
   import com.ankamagames.dofus.logic.common.frames.DisconnectionHandlerFrame;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.network.enums.TextInformationTypeEnum;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.dofus.network.enums.SubscriptionRequiredEnum;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSmileysAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenBookAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMapAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.CloseInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMainMenuAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenStatsAction;
   
   public class CommonUiFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CommonUiFrame));
       
      public function CommonUiFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function process(msg:Message) : Boolean
      {
         var dnvmsg:DisplayNumericalValueMessage = null;
         var color:uint = 0;
         var smdmsg:SystemMessageDisplayMessage = null;
         var commonMod:Object = null;
         var a:Array = null;
         var etmsg:EntityTalkMessage = null;
         var speakerEntity:IDisplayable = null;
         var msgContent:String = null;
         var textId:uint = 0;
         var params:Array = null;
         var type:uint = 0;
         var param:Array = null;
         var bubble:ChatBubble = null;
         var slmsg:SubscriptionLimitationMessage = null;
         var text:String = null;
         var szmsg:SubscriptionZoneMessage = null;
         var i:* = undefined;
         var prm:* = undefined;
         switch(true)
         {
            case msg is OpenSmileysAction:
               KernelEventsManager.getInstance().processCallback(HookList.SmileysStart);
               return true;
            case msg is OpenBookAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenBook);
               return true;
            case msg is OpenMapAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMap);
               return true;
            case msg is OpenInventoryAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenInventory,PlayedCharacterManager.getInstance().inventory,PlayedCharacterManager.getInstance().characteristics.kamas,PlayedCharacterManager.getInstance().inventoryWeight,PlayedCharacterManager.getInstance().inventoryWeightMax);
               return true;
            case msg is CloseInventoryAction:
               KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               return true;
            case msg is OpenMountAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMount);
               return true;
            case msg is OpenMainMenuAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenMainMenu);
               return true;
            case msg is OpenStatsAction:
               KernelEventsManager.getInstance().processCallback(HookList.OpenStats,PlayedCharacterManager.getInstance().inventory);
               return true;
            case msg is DisplayNumericalValueMessage:
               dnvmsg = msg as DisplayNumericalValueMessage;
               color = 0;
               switch(dnvmsg.type)
               {
                  case NumericalValueTypeEnum.NUMERICAL_VALUE_COLLECT:
                     color = 7615756;
                     CharacteristicContextualManager.getInstance().addStatContextual("" + dnvmsg.value,DofusEntities.getEntity(dnvmsg.entityId),new TextFormat("VerdanaBold",24,color,true),1);
                     return true;
                  default:
                     _log.warn("DisplayNumericalValueMessage with unsupported type : " + dnvmsg.type);
                     return false;
               }
            case msg is SystemMessageDisplayMessage:
               smdmsg = msg as SystemMessageDisplayMessage;
               if(smdmsg.hangUp)
               {
                  DisconnectionHandlerFrame.messagesAfterReset.push(msg);
               }
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               a = new Array();
               for each(i in smdmsg.parameters)
               {
                  a.push(i);
               }
               commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.warning")),I18n.getText(InfoMessage.getInfoMessageById(40000 + smdmsg.msgId).textId,a),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               return true;
            case msg is EntityTalkMessage:
               etmsg = msg as EntityTalkMessage;
               speakerEntity = DofusEntities.getEntity(etmsg.entityId) as IDisplayable;
               params = new Array();
               type = TextInformationTypeEnum.TEXT_ENTITY_TALK;
               if(speakerEntity == null)
               {
                  return true;
               }
               param = new Array();
               for each(prm in etmsg.parameters)
               {
                  param.push(prm);
               }
               if(InfoMessage.getInfoMessageById(type * 10000 + etmsg.textId))
               {
                  textId = InfoMessage.getInfoMessageById(type * 10000 + etmsg.textId).textId;
                  if(param != null)
                  {
                     if(Boolean(param[0]) && param[0].indexOf("~") != -1)
                     {
                        params = param[0].split("~");
                     }
                     else
                     {
                        params = param;
                     }
                  }
               }
               else
               {
                  _log.error("Texte " + (type * 10000 + etmsg.textId) + " not found.");
                  msgContent = "" + etmsg.textId;
               }
               if(!msgContent)
               {
                  msgContent = I18n.getText(textId,params);
               }
               bubble = new ChatBubble(msgContent);
               TooltipManager.show(bubble,speakerEntity.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"entityMsg" + etmsg.entityId,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               return true;
            case msg is SubscriptionLimitationMessage:
               slmsg = msg as SubscriptionLimitationMessage;
               _log.error("SubscriptionLimitationMessage reason " + slmsg.reason);
               text = "";
               switch(slmsg.reason)
               {
                  case SubscriptionRequiredEnum.LIMIT_ON_JOB_XP:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limitJobXp"));
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_JOB_USE:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limitJobXp"));
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_MAP:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limit"));
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_ITEM:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limitItem"));
                     break;
                  case SubscriptionRequiredEnum.LIMIT_ON_VENDOR:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limitVendor"));
                     break;
                  case SubscriptionRequiredEnum.LIMITED_TO_SUBSCRIBER:
                  default:
                     text = I18n.getText(I18nProxy.getKeyId("ui.payzone.limit"));
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               KernelEventsManager.getInstance().processCallback(HookList.NonSubscriberPopup);
               return true;
            case msg is SubscriptionZoneMessage:
               szmsg = msg as SubscriptionZoneMessage;
               _log.error("SubscriptionZoneMessage active " + szmsg.active);
               KernelEventsManager.getInstance().processCallback(HookList.SubscriptionZone,szmsg.active);
               return true;
            default:
               return false;
         }
      }
      
      public function pushed() : Boolean
      {
         _log.error("common ui frame ajoutée");
         return true;
      }
      
      public function pulled() : Boolean
      {
         _log.error("common ui frame enlevée");
         return true;
      }
   }
}
