package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildMembershipMessage extends GuildJoinedMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5835;
       
      private var _isInitialized:Boolean = false;
      
      public function GuildMembershipMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5835;
      }
      
      public function initGuildMembershipMessage(guildName:String = "", guildEmblem:GuildEmblem = null, memberRights:uint = 0) : GuildMembershipMessage
      {
         super.initGuildJoinedMessage(guildName,guildEmblem,memberRights);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
         this.serializeAs_GuildMembershipMessage(output);
      }
      
      public function serializeAs_GuildMembershipMessage(output:IDataOutput) : void
      {
         super.serializeAs_GuildJoinedMessage(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildMembershipMessage(input);
      }
      
      public function deserializeAs_GuildMembershipMessage(input:IDataInput) : void
      {
         super.deserialize(input);
      }
   }
}
