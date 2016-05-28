package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryDefineSettingsAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryEntryRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterContactLookRequestAction;
   
   public class ApiCraftActionList
   {
      
      public static const JobCrafterDirectoryDefineSettings:ApiAction = new ApiAction("JobCrafterDirectoryDefineSettings",JobCrafterDirectoryDefineSettingsAction,true);
      
      public static const JobCrafterDirectoryEntryRequest:ApiAction = new ApiAction("JobCrafterDirectoryEntryRequest",JobCrafterDirectoryEntryRequestAction,true);
      
      public static const JobCrafterDirectoryListRequest:ApiAction = new ApiAction("JobCrafterDirectoryListRequest",JobCrafterDirectoryListRequestAction,true);
      
      public static const JobCrafterContactLookRequest:ApiAction = new ApiAction("JobCrafterContactLookRequest",JobCrafterContactLookRequestAction,true);
       
      public function ApiCraftActionList()
      {
         super();
      }
   }
}
