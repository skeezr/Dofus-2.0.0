package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.enums.PlayableBreedEnum;
   
   public class FriendOnlineInformations extends FriendInformations implements INetworkType
   {
      
      public static const protocolId:uint = 92;
       
      public var playerName:String = "";
      
      public var level:uint = 0;
      
      public var alignmentSide:int = 0;
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var guildName:String = "";
      
      public function FriendOnlineInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 92;
      }
      
      public function initFriendOnlineInformations(name:String = "", playerState:uint = 99, lastConnection:uint = 0, playerName:String = "", level:uint = 0, alignmentSide:int = 0, breed:int = 0, sex:Boolean = false, guildName:String = "") : FriendOnlineInformations
      {
         super.initFriendInformations(name,playerState,lastConnection);
         this.playerName = playerName;
         this.level = level;
         this.alignmentSide = alignmentSide;
         this.breed = breed;
         this.sex = sex;
         this.guildName = guildName;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.playerName = "";
         this.level = 0;
         this.alignmentSide = 0;
         this.breed = 0;
         this.sex = false;
         this.guildName = "";
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FriendOnlineInformations(output);
      }
      
      public function serializeAs_FriendOnlineInformations(output:IDataOutput) : void
      {
         super.serializeAs_FriendInformations(output);
         output.writeUTF(this.playerName);
         if(this.level < 0 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeShort(this.level);
         output.writeByte(this.alignmentSide);
         output.writeByte(this.breed);
         output.writeBoolean(this.sex);
         output.writeUTF(this.guildName);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendOnlineInformations(input);
      }
      
      public function deserializeAs_FriendOnlineInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.playerName = input.readUTF();
         this.level = input.readShort();
         if(this.level < 0 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of FriendOnlineInformations.level.");
         }
         this.alignmentSide = input.readByte();
         this.breed = input.readByte();
         if(this.breed < PlayableBreedEnum.Feca || this.breed > PlayableBreedEnum.Pandawa)
         {
            throw new Error("Forbidden value (" + this.breed + ") on element of FriendOnlineInformations.breed.");
         }
         this.sex = input.readBoolean();
         this.guildName = input.readUTF();
      }
   }
}
