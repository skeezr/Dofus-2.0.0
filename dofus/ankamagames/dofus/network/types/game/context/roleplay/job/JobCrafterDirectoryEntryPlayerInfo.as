package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.enums.PlayableBreedEnum;
   
   public class JobCrafterDirectoryEntryPlayerInfo implements INetworkType
   {
      
      public static const protocolId:uint = 194;
       
      public var playerId:uint = 0;
      
      public var playerName:String = "";
      
      public var alignmentSide:int = 0;
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var isInWorkshop:Boolean = false;
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var mapId:uint = 0;
      
      public var subareaId:uint = 0;
      
      public function JobCrafterDirectoryEntryPlayerInfo()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 194;
      }
      
      public function initJobCrafterDirectoryEntryPlayerInfo(playerId:uint = 0, playerName:String = "", alignmentSide:int = 0, breed:int = 0, sex:Boolean = false, isInWorkshop:Boolean = false, worldX:int = 0, worldY:int = 0, mapId:uint = 0, subareaId:uint = 0) : JobCrafterDirectoryEntryPlayerInfo
      {
         this.playerId = playerId;
         this.playerName = playerName;
         this.alignmentSide = alignmentSide;
         this.breed = breed;
         this.sex = sex;
         this.isInWorkshop = isInWorkshop;
         this.worldX = worldX;
         this.worldY = worldY;
         this.mapId = mapId;
         this.subareaId = subareaId;
         return this;
      }
      
      public function reset() : void
      {
         this.playerId = 0;
         this.playerName = "";
         this.alignmentSide = 0;
         this.breed = 0;
         this.sex = false;
         this.isInWorkshop = false;
         this.worldX = 0;
         this.worldY = 0;
         this.mapId = 0;
         this.subareaId = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectoryEntryPlayerInfo(output);
      }
      
      public function serializeAs_JobCrafterDirectoryEntryPlayerInfo(output:IDataOutput) : void
      {
         if(this.playerId < 0)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element playerId.");
         }
         output.writeInt(this.playerId);
         output.writeUTF(this.playerName);
         output.writeByte(this.alignmentSide);
         output.writeByte(this.breed);
         output.writeBoolean(this.sex);
         output.writeBoolean(this.isInWorkshop);
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
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
         if(this.subareaId < 0)
         {
            throw new Error("Forbidden value (" + this.subareaId + ") on element subareaId.");
         }
         output.writeShort(this.subareaId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryEntryPlayerInfo(input);
      }
      
      public function deserializeAs_JobCrafterDirectoryEntryPlayerInfo(input:IDataInput) : void
      {
         this.playerId = input.readInt();
         if(this.playerId < 0)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element of JobCrafterDirectoryEntryPlayerInfo.playerId.");
         }
         this.playerName = input.readUTF();
         this.alignmentSide = input.readByte();
         this.breed = input.readByte();
         if(this.breed < PlayableBreedEnum.Feca || this.breed > PlayableBreedEnum.Pandawa)
         {
            throw new Error("Forbidden value (" + this.breed + ") on element of JobCrafterDirectoryEntryPlayerInfo.breed.");
         }
         this.sex = input.readBoolean();
         this.isInWorkshop = input.readBoolean();
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of JobCrafterDirectoryEntryPlayerInfo.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of JobCrafterDirectoryEntryPlayerInfo.worldY.");
         }
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of JobCrafterDirectoryEntryPlayerInfo.mapId.");
         }
         this.subareaId = input.readShort();
         if(this.subareaId < 0)
         {
            throw new Error("Forbidden value (" + this.subareaId + ") on element of JobCrafterDirectoryEntryPlayerInfo.subareaId.");
         }
      }
   }
}
