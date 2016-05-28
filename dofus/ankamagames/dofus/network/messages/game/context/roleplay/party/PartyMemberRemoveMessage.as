package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyMemberRemoveMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5579;
       
      private var _isInitialized:Boolean = false;
      
      public var leavingPlayerId:uint = 0;
      
      public function PartyMemberRemoveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5579;
      }
      
      public function initPartyMemberRemoveMessage(leavingPlayerId:uint = 0) : PartyMemberRemoveMessage
      {
         this.leavingPlayerId = leavingPlayerId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.leavingPlayerId = 0;
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
         this.serializeAs_PartyMemberRemoveMessage(output);
      }
      
      public function serializeAs_PartyMemberRemoveMessage(output:IDataOutput) : void
      {
         if(this.leavingPlayerId < 0)
         {
            throw new Error("Forbidden value (" + this.leavingPlayerId + ") on element leavingPlayerId.");
         }
         output.writeInt(this.leavingPlayerId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyMemberRemoveMessage(input);
      }
      
      public function deserializeAs_PartyMemberRemoveMessage(input:IDataInput) : void
      {
         this.leavingPlayerId = input.readInt();
         if(this.leavingPlayerId < 0)
         {
            throw new Error("Forbidden value (" + this.leavingPlayerId + ") on element of PartyMemberRemoveMessage.leavingPlayerId.");
         }
      }
   }
}
