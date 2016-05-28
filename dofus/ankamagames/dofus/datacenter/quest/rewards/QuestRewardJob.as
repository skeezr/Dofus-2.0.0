package com.ankamagames.dofus.datacenter.quest.rewards
{
   import com.ankamagames.dofus.datacenter.jobs.Job;
   
   public class QuestRewardJob extends QuestReward
   {
       
      private var _jobId:uint;
      
      public function QuestRewardJob(jobId:uint)
      {
         super(QuestRewardType.JOB);
         this._jobId = jobId;
      }
      
      public function get jobId() : uint
      {
         return this._jobId;
      }
      
      public function get job() : Job
      {
         return Job.getJobById(this._jobId);
      }
   }
}
