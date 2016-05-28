package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyFollowMemberRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5577;
       
      private var _isInitialized:Boolean = false;
      
      public var playerId:uint = 0;
      
      public function PartyFollowMemberRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5577;
      }
      
      public function initPartyFollowMemberRequestMessage(playerId:uint = 0) : PartyFollowMemberRequestMessage
      {
         this.playerId = playerId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.playerId = 0;
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
         this.serializeAs_PartyFollowMemberRequestMessage(output);
      }
      
      public function serializeAs_PartyFollowMemberRequestMessage(output:IDataOutput) : void
      {
         if(this.playerId < 0)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element playerId.");
         }
         output.writeInt(this.playerId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyFollowMemberRequestMessage(input);
      }
      
      public function deserializeAs_PartyFollowMemberRequestMessage(input:IDataInput) : void
      {
         this.playerId = input.readInt();
         if(this.playerId < 0)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element of PartyFollowMemberRequestMessage.playerId.");
         }
      }
   }
}
