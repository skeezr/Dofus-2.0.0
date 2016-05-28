package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   
   public class KnownJob
   {
       
      public var jobDescription:JobDescription;
      
      public var jobExperience:JobExperience;
      
      public var jobPosition:int;
      
      public function KnownJob()
      {
         super();
      }
   }
}
