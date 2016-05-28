package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GuildInformations implements INetworkType
   {
      
      public static const protocolId:uint = 127;
       
      public var guildName:String = "";
      
      public var guildEmblem:GuildEmblem;
      
      public function GuildInformations()
      {
         this.guildEmblem = new GuildEmblem();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 127;
      }
      
      public function initGuildInformations(guildName:String = "", guildEmblem:GuildEmblem = null) : GuildInformations
      {
         this.guildName = guildName;
         this.guildEmblem = guildEmblem;
         return this;
      }
      
      public function reset() : void
      {
         this.guildName = "";
         this.guildEmblem = new GuildEmblem();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GuildInformations(output);
      }
      
      public function serializeAs_GuildInformations(output:IDataOutput) : void
      {
         output.writeUTF(this.guildName);
         this.guildEmblem.serializeAs_GuildEmblem(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildInformations(input);
      }
      
      public function deserializeAs_GuildInformations(input:IDataInput) : void
      {
         this.guildName = input.readUTF();
         this.guildEmblem = new GuildEmblem();
         this.guildEmblem.deserialize(input);
      }
   }
}
