package com.ankamagames.dofus.network.types.game.paddock
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PaddockPrivateInformations extends PaddockAbandonnedInformations implements INetworkType
   {
      
      public static const protocolId:uint = 131;
       
      public var guildName:String = "";
      
      public var guildEmblem:GuildEmblem;
      
      public function PaddockPrivateInformations()
      {
         this.guildEmblem = new GuildEmblem();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 131;
      }
      
      public function initPaddockPrivateInformations(maxOutdoorMount:uint = 0, maxItems:uint = 0, price:uint = 0, guildId:uint = 0, guildName:String = "", guildEmblem:GuildEmblem = null) : PaddockPrivateInformations
      {
         super.initPaddockAbandonnedInformations(maxOutdoorMount,maxItems,price,guildId);
         this.guildName = guildName;
         this.guildEmblem = guildEmblem;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guildName = "";
         this.guildEmblem = new GuildEmblem();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PaddockPrivateInformations(output);
      }
      
      public function serializeAs_PaddockPrivateInformations(output:IDataOutput) : void
      {
         super.serializeAs_PaddockAbandonnedInformations(output);
         output.writeUTF(this.guildName);
         this.guildEmblem.serializeAs_GuildEmblem(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PaddockPrivateInformations(input);
      }
      
      public function deserializeAs_PaddockPrivateInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.guildName = input.readUTF();
         this.guildEmblem = new GuildEmblem();
         this.guildEmblem.deserialize(input);
      }
   }
}
