package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyInvitationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5586;
       
      private var _isInitialized:Boolean = false;
      
      public var fromId:uint = 0;
      
      public var fromName:String = "";
      
      public var toId:uint = 0;
      
      public var toName:String = "";
      
      public function PartyInvitationMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5586;
      }
      
      public function initPartyInvitationMessage(fromId:uint = 0, fromName:String = "", toId:uint = 0, toName:String = "") : PartyInvitationMessage
      {
         this.fromId = fromId;
         this.fromName = fromName;
         this.toId = toId;
         this.toName = toName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fromId = 0;
         this.fromName = "";
         this.toId = 0;
         this.toName = "";
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
         this.serializeAs_PartyInvitationMessage(output);
      }
      
      public function serializeAs_PartyInvitationMessage(output:IDataOutput) : void
      {
         if(this.fromId < 0)
         {
            throw new Error("Forbidden value (" + this.fromId + ") on element fromId.");
         }
         output.writeInt(this.fromId);
         output.writeUTF(this.fromName);
         if(this.toId < 0)
         {
            throw new Error("Forbidden value (" + this.toId + ") on element toId.");
         }
         output.writeInt(this.toId);
         output.writeUTF(this.toName);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyInvitationMessage(input);
      }
      
      public function deserializeAs_PartyInvitationMessage(input:IDataInput) : void
      {
         this.fromId = input.readInt();
         if(this.fromId < 0)
         {
            throw new Error("Forbidden value (" + this.fromId + ") on element of PartyInvitationMessage.fromId.");
         }
         this.fromName = input.readUTF();
         this.toId = input.readInt();
         if(this.toId < 0)
         {
            throw new Error("Forbidden value (" + this.toId + ") on element of PartyInvitationMessage.toId.");
         }
         this.toName = input.readUTF();
      }
   }
}
