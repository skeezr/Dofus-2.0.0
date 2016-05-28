package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyLeaderUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5578;
       
      private var _isInitialized:Boolean = false;
      
      public var partyLeaderId:uint = 0;
      
      public function PartyLeaderUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5578;
      }
      
      public function initPartyLeaderUpdateMessage(partyLeaderId:uint = 0) : PartyLeaderUpdateMessage
      {
         this.partyLeaderId = partyLeaderId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.partyLeaderId = 0;
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
         this.serializeAs_PartyLeaderUpdateMessage(output);
      }
      
      public function serializeAs_PartyLeaderUpdateMessage(output:IDataOutput) : void
      {
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element partyLeaderId.");
         }
         output.writeInt(this.partyLeaderId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyLeaderUpdateMessage(input);
      }
      
      public function deserializeAs_PartyLeaderUpdateMessage(input:IDataInput) : void
      {
         this.partyLeaderId = input.readInt();
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element of PartyLeaderUpdateMessage.partyLeaderId.");
         }
      }
   }
}
