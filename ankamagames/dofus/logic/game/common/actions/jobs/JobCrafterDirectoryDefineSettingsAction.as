package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJob;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.CrafterDirectoryParamBitEnum;
   
   public class JobCrafterDirectoryDefineSettingsAction implements Action
   {
       
      private var _jobId:uint;
      
      private var _minSlot:uint;
      
      private var _notFree:Boolean;
      
      private var _notFreeExceptOnFail:Boolean;
      
      private var _resourcesRequired:Boolean;
      
      public function JobCrafterDirectoryDefineSettingsAction()
      {
         super();
      }
      
      public static function create(jobId:uint, minSlot:uint, notFree:Boolean, notFreeExceptOnFail:Boolean, resourcesRequired:Boolean) : JobCrafterDirectoryDefineSettingsAction
      {
         var act:JobCrafterDirectoryDefineSettingsAction = new JobCrafterDirectoryDefineSettingsAction();
         act._jobId = jobId;
         act._minSlot = minSlot;
         act._notFree = notFree;
         act._notFreeExceptOnFail = notFreeExceptOnFail;
         act._resourcesRequired = resourcesRequired;
         return act;
      }
      
      public function get jobId() : uint
      {
         return this._jobId;
      }
      
      public function get minSlot() : uint
      {
         return this._minSlot;
      }
      
      public function get notFree() : Boolean
      {
         return this._notFree;
      }
      
      public function get notFreeExceptOnFail() : Boolean
      {
         return this._notFreeExceptOnFail;
      }
      
      public function get resourcesRequired() : Boolean
      {
         return this._resourcesRequired;
      }
      
      public function get settings() : JobCrafterDirectorySettings
      {
         var job:KnownJob = null;
         var entry:JobCrafterDirectorySettings = new JobCrafterDirectorySettings();
         var jobs:Array = PlayedCharacterManager.getInstance().jobs;
         for(var i:uint = 0; i < jobs.length; i++)
         {
            job = jobs[i];
            if(Boolean(job) && job.jobDescription.jobId == this.jobId)
            {
               entry.initJobCrafterDirectorySettings(i,this.minSlot,(!!this.notFree?CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE:CrafterDirectoryParamBitEnum.CRAFT_OPTION_NONE) + (!!this.notFreeExceptOnFail?CrafterDirectoryParamBitEnum.CRAFT_OPTION_NOT_FREE_EXCEPT_ON_FAIL:CrafterDirectoryParamBitEnum.CRAFT_OPTION_NONE) + (!!this.resourcesRequired?CrafterDirectoryParamBitEnum.CRAFT_OPTION_RESOURCES_REQUIRED:CrafterDirectoryParamBitEnum.CRAFT_OPTION_NONE));
               return entry;
            }
         }
         return null;
      }
   }
}
