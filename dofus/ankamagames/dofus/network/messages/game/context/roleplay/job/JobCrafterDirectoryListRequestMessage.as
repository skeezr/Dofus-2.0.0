package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class JobCrafterDirectoryListRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6047;
       
      private var _isInitialized:Boolean = false;
      
      public var jobId:uint = 0;
      
      public function JobCrafterDirectoryListRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6047;
      }
      
      public function initJobCrafterDirectoryListRequestMessage(jobId:uint = 0) : JobCrafterDirectoryListRequestMessage
      {
         this.jobId = jobId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.jobId = 0;
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void
      {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void
      {
         this.deserialize(input);
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectoryListRequestMessage(output);
      }
      
      public function serializeAs_JobCrafterDirectoryListRequestMessage(output:IDataOutput) : void
      {
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         output.writeByte(this.jobId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryListRequestMessage(input);
      }
      
      public function deserializeAs_JobCrafterDirectoryListRequestMessage(input:IDataInput) : void
      {
         this.jobId = input.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobCrafterDirectoryListRequestMessage.jobId.");
         }
      }
   }
}
