package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5575;
       
      private var _isInitialized:Boolean = false;
      
      public var memberInformations:PartyMemberInformations;
      
      public function PartyUpdateMessage()
      {
         this.memberInformations = new PartyMemberInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5575;
      }
      
      public function initPartyUpdateMessage(memberInformations:PartyMemberInformations = null) : PartyUpdateMessage
      {
         this.memberInformations = memberInformations;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.memberInformations = new PartyMemberInformations();
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
         this.serializeAs_PartyUpdateMessage(output);
      }
      
      public function serializeAs_PartyUpdateMessage(output:IDataOutput) : void
      {
         this.memberInformations.serializeAs_PartyMemberInformations(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyUpdateMessage(input);
      }
      
      public function deserializeAs_PartyUpdateMessage(input:IDataInput) : void
      {
         this.memberInformations = new PartyMemberInformations();
         this.memberInformations.deserialize(input);
      }
   }
}
