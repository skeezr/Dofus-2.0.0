package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListMessage;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepNoInfoMessage;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestStartRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestObjectiveValidationAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeReturnRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeQuitRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationListMessage;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationUpdateFlagAction;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationUpdateFlagMessage;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationResetAction;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationResetMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeReturnRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   
   public class QuestFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestFrame));
      
      public static var notificationList:Array;
       
      private var _activeQuests:Vector.<uint>;
      
      private var _completedQuests:Vector.<uint>;
      
      private var _questsInformations:Dictionary;
      
      public function QuestFrame()
      {
         this._questsInformations = new Dictionary();
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
         var qlrmsg:QuestListRequestMessage = null;
         var qlmsg:QuestListMessage = null;
         var qira:QuestInfosRequestAction = null;
         var qsirmsg:QuestStepInfoRequestMessage = null;
         var qsimsg:QuestStepInfoMessage = null;
         var qsnimsg:QuestStepNoInfoMessage = null;
         var qsra:QuestStartRequestAction = null;
         var qsrmsg:QuestStartRequestMessage = null;
         var qova:QuestObjectiveValidationAction = null;
         var qovmsg:QuestObjectiveValidationMessage = null;
         var gmrrmsg:GuidedModeReturnRequestMessage = null;
         var gmqrmsg:GuidedModeQuitRequestMessage = null;
         var qsmsg:QuestStartedMessage = null;
         var qvmsg:QuestValidatedMessage = null;
         var qovmsg2:QuestObjectiveValidatedMessage = null;
         var qsvmsg:QuestStepValidatedMessage = null;
         var qssmsg:QuestStepStartedMessage = null;
         var nlmsg:NotificationListMessage = null;
         var num:int = 0;
         var nufa:NotificationUpdateFlagAction = null;
         var nufmsg:NotificationUpdateFlagMessage = null;
         var nra:NotificationResetAction = null;
         var nrmsg:NotificationResetMessage = null;
         var i:uint = 0;
         var c:int = 0;
         var val:* = 0;
         var bit:int = 0;
         switch(true)
         {
            case msg is QuestListRequestAction:
               qlrmsg = new QuestListRequestMessage();
               qlrmsg.initQuestListRequestMessage();
               ConnectionsHandler.getConnection().send(qlrmsg);
               return true;
            case msg is QuestListMessage:
               qlmsg = msg as QuestListMessage;
               this._activeQuests = qlmsg.activeQuestsIds;
               this._completedQuests = qlmsg.finishedQuestsIds;
               _log.debug("quetes actives : " + this._activeQuests);
               _log.debug("quetes finies : " + this._completedQuests);
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestListUpdated);
               return true;
            case msg is QuestInfosRequestAction:
               qira = msg as QuestInfosRequestAction;
               qsirmsg = new QuestStepInfoRequestMessage();
               qsirmsg.initQuestStepInfoRequestMessage(qira.questId);
               ConnectionsHandler.getConnection().send(qsirmsg);
               return true;
            case msg is QuestStepInfoMessage:
               qsimsg = msg as QuestStepInfoMessage;
               this._questsInformations[qsimsg.questId] = {
                  "questId":qsimsg.questId,
                  "stepId":qsimsg.stepId
               };
               this._questsInformations[qsimsg.questId].objectives = new Array();
               for(i = 0; i < qsimsg.objectivesIds.length; i++)
               {
                  this._questsInformations[qsimsg.questId].objectives[qsimsg.objectivesIds[i]] = qsimsg.objectivesStatus[i];
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,qsimsg.questId,true);
               return true;
            case msg is QuestStepNoInfoMessage:
               qsnimsg = msg as QuestStepNoInfoMessage;
               delete this._questsInformations[qsnimsg.questId];
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,qsnimsg.questId,false);
               return true;
            case msg is QuestStartRequestAction:
               qsra = msg as QuestStartRequestAction;
               qsrmsg = new QuestStartRequestMessage();
               qsrmsg.initQuestStartRequestMessage(qsra.questId);
               ConnectionsHandler.getConnection().send(qsrmsg);
               return true;
            case msg is QuestObjectiveValidationAction:
               qova = msg as QuestObjectiveValidationAction;
               qovmsg = new QuestObjectiveValidationMessage();
               qovmsg.initQuestObjectiveValidationMessage(qova.questId,qova.objectiveId);
               ConnectionsHandler.getConnection().send(qovmsg);
               return true;
            case msg is GuidedModeReturnRequestAction:
               gmrrmsg = new GuidedModeReturnRequestMessage();
               gmrrmsg.initGuidedModeReturnRequestMessage();
               ConnectionsHandler.getConnection().send(gmrrmsg);
               return true;
            case msg is GuidedModeQuitRequestAction:
               gmqrmsg = new GuidedModeQuitRequestMessage();
               gmqrmsg.initGuidedModeQuitRequestMessage();
               ConnectionsHandler.getConnection().send(gmqrmsg);
               return true;
            case msg is QuestStartedMessage:
               qsmsg = msg as QuestStartedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStarted,qsmsg.questId);
               return true;
            case msg is QuestValidatedMessage:
               qvmsg = msg as QuestValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestValidated,qvmsg.questId);
               return true;
            case msg is QuestObjectiveValidatedMessage:
               qovmsg2 = msg as QuestObjectiveValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestObjectiveValidated,qovmsg2.questId,qovmsg2.objectiveId);
               return true;
            case msg is QuestStepValidatedMessage:
               qsvmsg = msg as QuestStepValidatedMessage;
               if(this._questsInformations[qsvmsg.questId])
               {
                  this._questsInformations[qsvmsg.questId].stepId = qsvmsg.stepId;
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepValidated,qsvmsg.questId,qsvmsg.stepId);
               return true;
            case msg is QuestStepStartedMessage:
               qssmsg = msg as QuestStepStartedMessage;
               if(this._questsInformations[qssmsg.questId])
               {
                  this._questsInformations[qssmsg.questId].stepId = qssmsg.stepId;
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepStarted,qssmsg.questId,qssmsg.stepId);
               return true;
            case msg is NotificationListMessage:
               nlmsg = msg as NotificationListMessage;
               notificationList = new Array();
               num = nlmsg.flags.length;
               for(c = 0; c < num; c++)
               {
                  val = int(nlmsg.flags[c]);
                  for(bit = 0; bit < 32; bit++)
                  {
                     notificationList[bit + c * 32] = Boolean(val & 1);
                     val = val >> 1;
                  }
               }
               return true;
            case msg is NotificationUpdateFlagAction:
               nufa = msg as NotificationUpdateFlagAction;
               nufmsg = new NotificationUpdateFlagMessage();
               nufmsg.initNotificationUpdateFlagMessage(nufa.index);
               ConnectionsHandler.getConnection().send(nufmsg);
               return true;
            case msg is NotificationResetAction:
               nra = msg as NotificationResetAction;
               notificationList = new Array();
               nrmsg = new NotificationResetMessage();
               nrmsg.initNotificationResetMessage();
               ConnectionsHandler.getConnection().send(nrmsg);
               KernelEventsManager.getInstance().processCallback(HookList.NotificationReset);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function getActiveQuests() : Vector.<uint>
      {
         return this._activeQuests;
      }
      
      public function getCompletedQuests() : Vector.<uint>
      {
         return this._completedQuests;
      }
      
      public function getQuestInformations(questId:uint) : Object
      {
         return this._questsInformations[questId];
      }
   }
}
