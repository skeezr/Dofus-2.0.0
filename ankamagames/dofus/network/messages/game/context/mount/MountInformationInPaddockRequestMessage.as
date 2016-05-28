package com.ankamagames.dofus.network.messages.game.context.mount
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MountInformationInPaddockRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5975;
       
      private var _isInitialized:Boolean = false;
      
      public var mapRideId:uint = 0;
      
      public function MountInformationInPaddockRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5975;
      }
      
      public function initMountInformationInPaddockRequestMessage(mapRideId:uint = 0) : MountInformationInPaddockRequestMessage
      {
         this.mapRideId = mapRideId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mapRideId = 0;
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
         this.serializeAs_MountInformationInPaddockRequestMessage(output);
      }
      
      public function serializeAs_MountInformationInPaddockRequestMessage(output:IDataOutput) : void
      {
         if(this.mapRideId < 0)
         {
            throw new Error("Forbidden value (" + this.mapRideId + ") on element mapRideId.");
         }
         output.writeInt(this.mapRideId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MountInformationInPaddockRequestMessage(input);
      }
      
      public function deserializeAs_MountInformationInPaddockRequestMessage(input:IDataInput) : void
      {
         this.mapRideId = input.readInt();
         if(this.mapRideId < 0)
         {
            throw new Error("Forbidden value (" + this.mapRideId + ") on element of MountInformationInPaddockRequestMessage.mapRideId.");
         }
      }
   }
}
