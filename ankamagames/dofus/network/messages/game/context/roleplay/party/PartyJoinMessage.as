package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyJoinMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5576;
       
      private var _isInitialized:Boolean = false;
      
      public var partyLeaderId:uint = 0;
      
      public var members:Vector.<PartyMemberInformations>;
      
      public function PartyJoinMessage()
      {
         this.members = new Vector.<PartyMemberInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5576;
      }
      
      public function initPartyJoinMessage(partyLeaderId:uint = 0, members:Vector.<PartyMemberInformations> = null) : PartyJoinMessage
      {
         this.partyLeaderId = partyLeaderId;
         this.members = members;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.partyLeaderId = 0;
         this.members = new Vector.<PartyMemberInformations>();
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
         this.serializeAs_PartyJoinMessage(output);
      }
      
      public function serializeAs_PartyJoinMessage(output:IDataOutput) : void
      {
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element partyLeaderId.");
         }
         output.writeInt(this.partyLeaderId);
         output.writeShort(this.members.length);
         for(var _i2:uint = 0; _i2 < this.members.length; _i2++)
         {
            (this.members[_i2] as PartyMemberInformations).serializeAs_PartyMemberInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyJoinMessage(input);
      }
      
      public function deserializeAs_PartyJoinMessage(input:IDataInput) : void
      {
         var _item2:PartyMemberInformations = null;
         this.partyLeaderId = input.readInt();
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element of PartyJoinMessage.partyLeaderId.");
         }
         var _membersLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _membersLen; _i2++)
         {
            _item2 = new PartyMemberInformations();
            _item2.deserialize(input);
            this.members.push(_item2);
         }
      }
   }
}
