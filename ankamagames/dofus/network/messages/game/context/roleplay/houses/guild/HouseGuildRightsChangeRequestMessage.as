package com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HouseGuildRightsChangeRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5702;
       
      private var _isInitialized:Boolean = false;
      
      public var rights:uint = 0;
      
      public function HouseGuildRightsChangeRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5702;
      }
      
      public function initHouseGuildRightsChangeRequestMessage(rights:uint = 0) : HouseGuildRightsChangeRequestMessage
      {
         this.rights = rights;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.rights = 0;
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
         this.serializeAs_HouseGuildRightsChangeRequestMessage(output);
      }
      
      public function serializeAs_HouseGuildRightsChangeRequestMessage(output:IDataOutput) : void
      {
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element rights.");
         }
         output.writeUnsignedInt(this.rights);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseGuildRightsChangeRequestMessage(input);
      }
      
      public function deserializeAs_HouseGuildRightsChangeRequestMessage(input:IDataInput) : void
      {
         this.rights = input.readUnsignedInt();
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element of HouseGuildRightsChangeRequestMessage.rights.");
         }
      }
   }
}
