package com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HouseGuildRightsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5703;
       
      private var _isInitialized:Boolean = false;
      
      public var houseId:uint = 0;
      
      public var guildName:String = "";
      
      public var guildEmblem:GuildEmblem;
      
      public var rights:uint = 0;
      
      public function HouseGuildRightsMessage()
      {
         this.guildEmblem = new GuildEmblem();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5703;
      }
      
      public function initHouseGuildRightsMessage(houseId:uint = 0, guildName:String = "", guildEmblem:GuildEmblem = null, rights:uint = 0) : HouseGuildRightsMessage
      {
         this.houseId = houseId;
         this.guildName = guildName;
         this.guildEmblem = guildEmblem;
         this.rights = rights;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.houseId = 0;
         this.guildName = "";
         this.guildEmblem = new GuildEmblem();
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
         this.serializeAs_HouseGuildRightsMessage(output);
      }
      
      public function serializeAs_HouseGuildRightsMessage(output:IDataOutput) : void
      {
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         output.writeShort(this.houseId);
         output.writeUTF(this.guildName);
         this.guildEmblem.serializeAs_GuildEmblem(output);
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element rights.");
         }
         output.writeUnsignedInt(this.rights);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseGuildRightsMessage(input);
      }
      
      public function deserializeAs_HouseGuildRightsMessage(input:IDataInput) : void
      {
         this.houseId = input.readShort();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of HouseGuildRightsMessage.houseId.");
         }
         this.guildName = input.readUTF();
         this.guildEmblem = new GuildEmblem();
         this.guildEmblem.deserialize(input);
         this.rights = input.readUnsignedInt();
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element of HouseGuildRightsMessage.rights.");
         }
      }
   }
}
