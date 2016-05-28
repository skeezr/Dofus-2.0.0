package com.ankamagames.dofus.network.types.game.house
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class HouseInformationsForGuild implements INetworkType
   {
      
      public static const protocolId:uint = 170;
       
      public var houseId:uint = 0;
      
      public var ownerName:String = "";
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var skillListIds:Vector.<int>;
      
      public var guildshareParams:uint = 0;
      
      public function HouseInformationsForGuild()
      {
         this.skillListIds = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 170;
      }
      
      public function initHouseInformationsForGuild(houseId:uint = 0, ownerName:String = "", worldX:int = 0, worldY:int = 0, skillListIds:Vector.<int> = null, guildshareParams:uint = 0) : HouseInformationsForGuild
      {
         this.houseId = houseId;
         this.ownerName = ownerName;
         this.worldX = worldX;
         this.worldY = worldY;
         this.skillListIds = skillListIds;
         this.guildshareParams = guildshareParams;
         return this;
      }
      
      public function reset() : void
      {
         this.houseId = 0;
         this.ownerName = "";
         this.worldX = 0;
         this.worldY = 0;
         this.skillListIds = new Vector.<int>();
         this.guildshareParams = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_HouseInformationsForGuild(output);
      }
      
      public function serializeAs_HouseInformationsForGuild(output:IDataOutput) : void
      {
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         output.writeInt(this.houseId);
         output.writeUTF(this.ownerName);
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         output.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         output.writeShort(this.worldY);
         output.writeShort(this.skillListIds.length);
         for(var _i5:uint = 0; _i5 < this.skillListIds.length; _i5++)
         {
            output.writeInt(this.skillListIds[_i5]);
         }
         if(this.guildshareParams < 0 || this.guildshareParams > 4294967295)
         {
            throw new Error("Forbidden value (" + this.guildshareParams + ") on element guildshareParams.");
         }
         output.writeUnsignedInt(this.guildshareParams);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseInformationsForGuild(input);
      }
      
      public function deserializeAs_HouseInformationsForGuild(input:IDataInput) : void
      {
         var _val5:int = 0;
         this.houseId = input.readInt();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of HouseInformationsForGuild.houseId.");
         }
         this.ownerName = input.readUTF();
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of HouseInformationsForGuild.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of HouseInformationsForGuild.worldY.");
         }
         var _skillListIdsLen:uint = input.readUnsignedShort();
         for(var _i5:uint = 0; _i5 < _skillListIdsLen; _i5++)
         {
            _val5 = input.readInt();
            this.skillListIds.push(_val5);
         }
         this.guildshareParams = input.readUnsignedInt();
         if(this.guildshareParams < 0 || this.guildshareParams > 4294967295)
         {
            throw new Error("Forbidden value (" + this.guildshareParams + ") on element of HouseInformationsForGuild.guildshareParams.");
         }
      }
   }
}
