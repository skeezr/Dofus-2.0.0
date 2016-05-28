package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyCannotJoinErrorMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5583;
       
      private var _isInitialized:Boolean = false;
      
      public var reason:uint = 0;
      
      public function PartyCannotJoinErrorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5583;
      }
      
      public function initPartyCannotJoinErrorMessage(reason:uint = 0) : PartyCannotJoinErrorMessage
      {
         this.reason = reason;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.reason = 0;
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
         this.serializeAs_PartyCannotJoinErrorMessage(output);
      }
      
      public function serializeAs_PartyCannotJoinErrorMessage(output:IDataOutput) : void
      {
         output.writeByte(this.reason);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyCannotJoinErrorMessage(input);
      }
      
      public function deserializeAs_PartyCannotJoinErrorMessage(input:IDataInput) : void
      {
         this.reason = input.readByte();
         if(this.reason < 0)
         {
            throw new Error("Forbidden value (" + this.reason + ") on element of PartyCannotJoinErrorMessage.reason.");
         }
      }
   }
}
