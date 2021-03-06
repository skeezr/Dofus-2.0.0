package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobDescriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceMultiUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobUnlearntMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectorySettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobListedUpdateMessage;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryListRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryDefineSettingsAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryDefineSettingsMessage;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryEntryRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterContactLookRequestAction;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByIdMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkJobIndexMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectJobAddedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJob;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryListEntry;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.enums.SocialContactCategoryEnum;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo;
   import com.ankamagames.dofus.network.enums.CrafterDirectoryParamBitEnum;
   
   public class JobsFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(JobsFrame));
       
      private var _crafterList:Array = null;
      
      private var _settings:Array = null;
      
      private var _equipedJobId:int;
      
      public function JobsFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get settings() : Array
      {
         return this._settings;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var jdmsg:JobDescriptionMessage = null;
         var n:int = 0;
         var jeumsg:JobExperienceUpdateMessage = null;
         var jemumsg:JobExperienceMultiUpdateMessage = null;
         var julmsg:JobUnlearntMessage = null;
         var jlumsg:JobLevelUpMessage = null;
         var jobName:String = null;
         var levelUpTexteMessage:String = null;
         var commonMod:Object = null;
         var jcdsmsg:JobCrafterDirectorySettingsMessage = null;
         var jldumsg:JobListedUpdateMessage = null;
         var text:String = null;
         var job:Job = null;
         var jcdlra:JobCrafterDirectoryListRequestAction = null;
         var jcdlrmsg:JobCrafterDirectoryListRequestMessage = null;
         var jcddsa:JobCrafterDirectoryDefineSettingsAction = null;
         var jcddsmsg:JobCrafterDirectoryDefineSettingsMessage = null;
         var jcdera:JobCrafterDirectoryEntryRequestAction = null;
         var jcdermsg:JobCrafterDirectoryEntryRequestMessage = null;
         var jcclra:JobCrafterContactLookRequestAction = null;
         var clrbimsg:ContactLookRequestByIdMessage = null;
         var jcdlmsg:JobCrafterDirectoryListMessage = null;
         var jcdrmsg:JobCrafterDirectoryRemoveMessage = null;
         var jcdamsg:JobCrafterDirectoryAddMessage = null;
         var esokimsg:ExchangeStartOkJobIndexMessage = null;
         var array:Array = null;
         var ojamsg:ObjectJobAddedMessage = null;
         var rpContextFrame:RoleplayContextFrame = null;
         var ies:Vector.<InteractiveElement> = null;
         var jd:JobDescription = null;
         var kj:KnownJob = null;
         var je:JobExperience = null;
         var setting:JobCrafterDirectorySettings = null;
         var entry:JobCrafterDirectoryListEntry = null;
         var i:uint = 0;
         var jobInfo:Object = null;
         var esojijob:uint = 0;
         var knj:KnownJob = null;
         var skills:Vector.<SkillActionDescription> = null;
         var sad:SkillActionDescription = null;
         var ie:InteractiveElement = null;
         var id:uint = 0;
         switch(true)
         {
            case msg is JobDescriptionMessage:
               jdmsg = msg as JobDescriptionMessage;
               PlayedCharacterManager.getInstance().jobs = [];
               n = 0;
               for each(jd in jdmsg.jobsDescription)
               {
                  kj = PlayedCharacterManager.getInstance().jobs[jd.jobId];
                  if(!kj)
                  {
                     kj = new KnownJob();
                     PlayedCharacterManager.getInstance().jobs[jd.jobId] = kj;
                  }
                  kj.jobDescription = jd;
                  kj.jobPosition = n;
                  n++;
               }
               KernelEventsManager.getInstance().processCallback(HookList.JobsListUpdated);
               return true;
            case msg is JobExperienceUpdateMessage:
               jeumsg = msg as JobExperienceUpdateMessage;
               this.updateJobExperience(jeumsg.experiencesUpdate);
               KernelEventsManager.getInstance().processCallback(HookList.JobsExpUpdated);
               return true;
            case msg is JobExperienceMultiUpdateMessage:
               jemumsg = msg as JobExperienceMultiUpdateMessage;
               for each(je in jemumsg.experiencesUpdate)
               {
                  this.updateJobExperience(je);
               }
               KernelEventsManager.getInstance().processCallback(HookList.JobsExpUpdated);
               return true;
            case msg is JobUnlearntMessage:
               julmsg = msg as JobUnlearntMessage;
               delete PlayedCharacterManager.getInstance().jobs[julmsg.jobId];
               return true;
            case msg is JobLevelUpMessage:
               jlumsg = msg as JobLevelUpMessage;
               jobName = Job.getJobById(jlumsg.jobsDescription.jobId).name;
               levelUpTexteMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.newJobLevel"),[jobName,jlumsg.newLevel]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,levelUpTexteMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.information")),levelUpTexteMessage,[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               this.updateJob(jlumsg.jobsDescription.jobId,jlumsg.jobsDescription);
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobLevelUp,jlumsg.newLevel);
               return true;
            case msg is JobCrafterDirectorySettingsMessage:
               jcdsmsg = msg as JobCrafterDirectorySettingsMessage;
               this._settings = new Array();
               for each(setting in jcdsmsg.craftersSettings)
               {
                  this._settings.push(this.createCrafterDirectorySettings(setting));
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectorySettings,this._settings);
               return true;
            case msg is JobListedUpdateMessage:
               jldumsg = msg as JobListedUpdateMessage;
               job = Job.getJobById(jldumsg.jobId);
               if(jldumsg.addedOrDeleted)
               {
                  text = I18n.getText(I18nProxy.getKeyId("ui.craft.referenceAdd"),[job.name]);
               }
               else
               {
                  text = I18n.getText(I18nProxy.getKeyId("ui.craft.referenceRemove"),[job.name]);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
            case msg is JobCrafterDirectoryListRequestAction:
               jcdlra = msg as JobCrafterDirectoryListRequestAction;
               jcdlrmsg = new JobCrafterDirectoryListRequestMessage();
               jcdlrmsg.initJobCrafterDirectoryListRequestMessage(jcdlra.jobId);
               ConnectionsHandler.getConnection().send(jcdlrmsg);
               return true;
            case msg is JobCrafterDirectoryDefineSettingsAction:
               jcddsa = msg as JobCrafterDirectoryDefineSettingsAction;
               jcddsmsg = new JobCrafterDirectoryDefineSettingsMessage();
               jcddsmsg.initJobCrafterDirectoryDefineSettingsMessage(jcddsa.settings);
               ConnectionsHandler.getConnection().send(jcddsmsg);
               return true;
            case msg is JobCrafterDirectoryEntryRequestAction:
               jcdera = msg as JobCrafterDirectoryEntryRequestAction;
               jcdermsg = new JobCrafterDirectoryEntryRequestMessage();
               jcdermsg.initJobCrafterDirectoryEntryRequestMessage(jcdera.playerId);
               ConnectionsHandler.getConnection().send(jcddsmsg);
               return true;
            case msg is JobCrafterContactLookRequestAction:
               jcclra = msg as JobCrafterContactLookRequestAction;
               clrbimsg = new ContactLookRequestByIdMessage();
               clrbimsg.initContactLookRequestByIdMessage(0,SocialContactCategoryEnum.SOCIAL_CONTACT_CRAFTER,jcclra.crafterId);
               ConnectionsHandler.getConnection().send(clrbimsg);
               return true;
            case msg is JobCrafterDirectoryListMessage:
               jcdlmsg = msg as JobCrafterDirectoryListMessage;
               this._crafterList = new Array();
               for each(entry in jcdlmsg.listEntries)
               {
                  this._crafterList.push(this.createCrafterDirectoryListEntry(entry));
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectoryListUpdate,this._crafterList);
               return true;
            case msg is JobCrafterDirectoryRemoveMessage:
               jcdrmsg = msg as JobCrafterDirectoryRemoveMessage;
               for(i = 0; i < this._crafterList.length; i++)
               {
                  jobInfo = this._crafterList[i];
                  if(jobInfo.jobInfo.jobId == jcdrmsg.jobId && jobInfo.playerInfo.playerId == jcdrmsg.playerId)
                  {
                     this._crafterList.splice(i,1);
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectoryListUpdate,this._crafterList);
               return true;
            case msg is JobCrafterDirectoryAddMessage:
               jcdamsg = msg as JobCrafterDirectoryAddMessage;
               this._crafterList.push(this.createCrafterDirectoryListEntry(jcdamsg.listEntry));
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectoryListUpdate,this._crafterList);
               return true;
            case msg is JobCrafterDirectoryEntryMessage:
               return false;
            case msg is ExchangeStartOkJobIndexMessage:
               esokimsg = msg as ExchangeStartOkJobIndexMessage;
               array = new Array();
               for each(esojijob in esokimsg.jobs)
               {
                  array.push(esojijob);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkJobIndex,array);
               return true;
            case msg is ObjectJobAddedMessage:
               ojamsg = ObjectJobAddedMessage(msg);
               rpContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               ies = rpContextFrame.entitiesFrame.interactiveElements;
               if(ojamsg.jobId != 0)
               {
                  this._equipedJobId = ojamsg.jobId;
                  knj = PlayedCharacterManager.getInstance().jobs[this._equipedJobId] as KnownJob;
                  if(!knj)
                  {
                     return true;
                  }
                  skills = knj.jobDescription.skills;
                  for each(sad in skills)
                  {
                     for each(ie in ies)
                     {
                        for each(id in ie.disabledSkillIds)
                        {
                           if(id == sad.skillId)
                           {
                              ie.disabledSkillIds.splice(ie.disabledSkillIds.indexOf(id),1);
                              ie.enabledSkillIds.push(id);
                           }
                        }
                     }
                  }
                  return true;
               }
               knj = PlayedCharacterManager.getInstance().jobs[this._equipedJobId] as KnownJob;
               if(!knj)
               {
                  return true;
               }
               skills = knj.jobDescription.skills;
               for each(sad in skills)
               {
                  for each(ie in ies)
                  {
                     for each(id in ie.enabledSkillIds)
                     {
                        if(id == sad.skillId)
                        {
                           ie.enabledSkillIds.splice(ie.enabledSkillIds.indexOf(id),1);
                           ie.disabledSkillIds.push(id);
                        }
                     }
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function updateJobExperience(je:JobExperience) : void
      {
         var kj:KnownJob = PlayedCharacterManager.getInstance().jobs[je.jobId];
         if(!kj)
         {
            kj = new KnownJob();
            PlayedCharacterManager.getInstance().jobs[je.jobId] = kj;
         }
         kj.jobExperience = je;
      }
      
      private function updateJob(pJobId:uint, pJobDescription:JobDescription) : void
      {
         var kj:KnownJob = PlayedCharacterManager.getInstance().jobs[pJobId];
         kj.jobDescription = pJobDescription;
      }
      
      private function createCrafterDirectoryListEntry(entry:JobCrafterDirectoryListEntry) : Object
      {
         var obj:Object = new Object();
         obj.playerInfo = entry.playerInfo;
         obj.jobInfo = this.createCrafterDirectoryJobInfo(entry.jobInfo);
         return obj;
      }
      
      private function createCrafterDirectoryJobInfo(settings:JobCrafterDirectoryEntryJobInfo) : Object
      {
         var obj:Object = new Object();
         obj.jobId = settings.jobId;
         obj.jobLevel = settings.jobLevel;
         obj.minSlots = settings.minSlots;
         obj.notFree = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE) != 0;
         obj.notFreeExceptOnFail = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE_EXCEPT_ON_FAIL) != 0;
         obj.resourcesRequired = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_RESOURCES_REQUIRED) != 0;
         return obj;
      }
      
      private function createCrafterDirectorySettings(settings:JobCrafterDirectorySettings) : Object
      {
         var obj:Object = new Object();
         obj.jobId = settings.jobId;
         obj.minSlots = settings.minSlot;
         obj.notFree = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE) != 0;
         obj.notFreeExceptOnFail = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE_EXCEPT_ON_FAIL) != 0;
         obj.resourcesRequired = (settings.userDefinedParams & CrafterDirectoryParamBitEnum.CRAFT_OPTION_RESOURCES_REQUIRED) != 0;
         return obj;
      }
   }
}
