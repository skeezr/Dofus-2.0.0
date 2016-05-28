package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryListRequestAction implements Action
   {
       
      private var _jobId:uint;
      
      public function JobCrafterDirectoryListRequestAction()
      {
         super();
      }
      
      public static function create(jobId:uint) : JobCrafterDirectoryListRequestAction
      {
         var act:JobCrafterDirectoryListRequestAction = new JobCrafterDirectoryListRequestAction();
         act._jobId = jobId;
         return act;
      }
      
      public function get jobId() : uint
      {
         return this._jobId;
      }
   }
}
