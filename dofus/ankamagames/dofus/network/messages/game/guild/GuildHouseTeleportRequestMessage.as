package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildHouseTeleportRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5712;
       
      private var _isInitialized:Boolean = false;
      
      public var houseId:uint = 0;
      
      public function GuildHouseTeleportRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5712;
      }
      
      public function initGuildHouseTeleportRequestMessage(houseId:uint = 0) : GuildHouseTeleportRequestMessage
      {
         this.houseId = houseId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.houseId = 0;
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
         this.serializeAs_GuildHouseTeleportRequestMessage(output);
      }
      
      public function serializeAs_GuildHouseTeleportRequestMessage(output:IDataOutput) : void
      {
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         output.writeInt(this.houseId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildHouseTeleportRequestMessage(input);
      }
      
      public function deserializeAs_GuildHouseTeleportRequestMessage(input:IDataInput) : void
      {
         this.houseId = input.readInt();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of GuildHouseTeleportRequestMessage.houseId.");
         }
      }
   }
}
