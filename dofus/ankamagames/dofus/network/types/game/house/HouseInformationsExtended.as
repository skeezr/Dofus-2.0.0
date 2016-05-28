package com.ankamagames.dofus.network.types.game.house
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class HouseInformationsExtended extends HouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 112;
       
      public var guildName:String = "";
      
      public var guildEmblem:GuildEmblem;
      
      public function HouseInformationsExtended()
      {
         this.guildEmblem = new GuildEmblem();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 112;
      }
      
      public function initHouseInformationsExtended(houseId:uint = 0, doorsOnMap:Vector.<uint> = null, ownerName:String = "", isOnSale:Boolean = false, modelId:uint = 0, guildName:String = "", guildEmblem:GuildEmblem = null) : HouseInformationsExtended
      {
         super.initHouseInformations(houseId,doorsOnMap,ownerName,isOnSale,modelId);
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
         this.serializeAs_HouseInformationsExtended(output);
      }
      
      public function serializeAs_HouseInformationsExtended(output:IDataOutput) : void
      {
         super.serializeAs_HouseInformations(output);
         output.writeUTF(this.guildName);
         this.guildEmblem.serializeAs_GuildEmblem(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseInformationsExtended(input);
      }
      
      public function deserializeAs_HouseInformationsExtended(input:IDataInput) : void
      {
         super.deserialize(input);
         this.guildName = input.readUTF();
         this.guildEmblem = new GuildEmblem();
         this.guildEmblem.deserialize(input);
      }
   }
}
