package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyFollowThisMemberRequestMessage extends PartyFollowMemberRequestMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5588;
       
      private var _isInitialized:Boolean = false;
      
      public var enabled:Boolean = false;
      
      public function PartyFollowThisMemberRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5588;
      }
      
      public function initPartyFollowThisMemberRequestMessage(playerId:uint = 0, enabled:Boolean = false) : PartyFollowThisMemberRequestMessage
      {
         super.initPartyFollowMemberRequestMessage(playerId);
         this.enabled = enabled;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.enabled = false;
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
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PartyFollowThisMemberRequestMessage(output);
      }
      
      public function serializeAs_PartyFollowThisMemberRequestMessage(output:IDataOutput) : void
      {
         super.serializeAs_PartyFollowMemberRequestMessage(output);
         output.writeBoolean(this.enabled);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyFollowThisMemberRequestMessage(input);
      }
      
      public function deserializeAs_PartyFollowThisMemberRequestMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.enabled = input.readBoolean();
      }
   }
}
