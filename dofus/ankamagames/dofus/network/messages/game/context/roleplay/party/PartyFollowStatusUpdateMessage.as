package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyFollowStatusUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5581;
       
      private var _isInitialized:Boolean = false;
      
      public var success:Boolean = false;
      
      public var followedId:uint = 0;
      
      public function PartyFollowStatusUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5581;
      }
      
      public function initPartyFollowStatusUpdateMessage(success:Boolean = false, followedId:uint = 0) : PartyFollowStatusUpdateMessage
      {
         this.success = success;
         this.followedId = followedId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.success = false;
         this.followedId = 0;
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
         this.serializeAs_PartyFollowStatusUpdateMessage(output);
      }
      
      public function serializeAs_PartyFollowStatusUpdateMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.success);
         if(this.followedId < 0)
         {
            throw new Error("Forbidden value (" + this.followedId + ") on element followedId.");
         }
         output.writeInt(this.followedId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyFollowStatusUpdateMessage(input);
      }
      
      public function deserializeAs_PartyFollowStatusUpdateMessage(input:IDataInput) : void
      {
         this.success = input.readBoolean();
         this.followedId = input.readInt();
         if(this.followedId < 0)
         {
            throw new Error("Forbidden value (" + this.followedId + ") on element of PartyFollowStatusUpdateMessage.followedId.");
         }
      }
   }
}
