package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildJoinedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5564;
       
      private var _isInitialized:Boolean = false;
      
      public var guildName:String = "";
      
      public var guildEmblem:GuildEmblem;
      
      public var memberRights:uint = 0;
      
      public function GuildJoinedMessage()
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
         return 5564;
      }
      
      public function initGuildJoinedMessage(guildName:String = "", guildEmblem:GuildEmblem = null, memberRights:uint = 0) : GuildJoinedMessage
      {
         this.guildName = guildName;
         this.guildEmblem = guildEmblem;
         this.memberRights = memberRights;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
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
         this.serializeAs_GuildJoinedMessage(output);
      }
      
      public function serializeAs_GuildJoinedMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.guildName);
         this.guildEmblem.serializeAs_GuildEmblem(output);
         if(this.memberRights < 0 || this.memberRights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.memberRights + ") on element memberRights.");
         }
         output.writeUnsignedInt(this.memberRights);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildJoinedMessage(input);
      }
      
      public function deserializeAs_GuildJoinedMessage(input:IDataInput) : void
      {
         this.guildName = input.readUTF();
         this.guildEmblem = new GuildEmblem();
         this.guildEmblem.deserialize(input);
         this.memberRights = input.readUnsignedInt();
         if(this.memberRights < 0 || this.memberRights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.memberRights + ") on element of GuildJoinedMessage.memberRights.");
         }
      }
   }
}
