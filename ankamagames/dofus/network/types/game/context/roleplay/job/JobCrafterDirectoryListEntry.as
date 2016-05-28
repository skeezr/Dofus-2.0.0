package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class JobCrafterDirectoryListEntry implements INetworkType
   {
      
      public static const protocolId:uint = 196;
       
      public var playerInfo:com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo;
      
      public var jobInfo:com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo;
      
      public function JobCrafterDirectoryListEntry()
      {
         this.playerInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo();
         this.jobInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 196;
      }
      
      public function initJobCrafterDirectoryListEntry(playerInfo:com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo = null, jobInfo:com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo = null) : JobCrafterDirectoryListEntry
      {
         this.playerInfo = playerInfo;
         this.jobInfo = jobInfo;
         return this;
      }
      
      public function reset() : void
      {
         this.playerInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectoryListEntry(output);
      }
      
      public function serializeAs_JobCrafterDirectoryListEntry(output:IDataOutput) : void
      {
         this.playerInfo.serializeAs_JobCrafterDirectoryEntryPlayerInfo(output);
         this.jobInfo.serializeAs_JobCrafterDirectoryEntryJobInfo(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryListEntry(input);
      }
      
      public function deserializeAs_JobCrafterDirectoryListEntry(input:IDataInput) : void
      {
         this.playerInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo();
         this.playerInfo.deserialize(input);
         this.jobInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo();
         this.jobInfo.deserialize(input);
      }
   }
}
