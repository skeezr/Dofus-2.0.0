package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyKickedByMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5590;
       
      private var _isInitialized:Boolean = false;
      
      public var kickerId:uint = 0;
      
      public function PartyKickedByMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5590;
      }
      
      public function initPartyKickedByMessage(kickerId:uint = 0) : PartyKickedByMessage
      {
         this.kickerId = kickerId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.kickerId = 0;
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
         this.serializeAs_PartyKickedByMessage(output);
      }
      
      public function serializeAs_PartyKickedByMessage(output:IDataOutput) : void
      {
         if(this.kickerId < 0)
         {
            throw new Error("Forbidden value (" + this.kickerId + ") on element kickerId.");
         }
         output.writeInt(this.kickerId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyKickedByMessage(input);
      }
      
      public function deserializeAs_PartyKickedByMessage(input:IDataInput) : void
      {
         this.kickerId = input.readInt();
         if(this.kickerId < 0)
         {
            throw new Error("Forbidden value (" + this.kickerId + ") on element of PartyKickedByMessage.kickerId.");
         }
      }
   }
}
