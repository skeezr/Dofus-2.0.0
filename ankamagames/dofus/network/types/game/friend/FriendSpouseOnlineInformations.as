package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.IDataInput;
   
   public class FriendSpouseOnlineInformations extends FriendSpouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 93;
       
      public var mapId:uint = 0;
      
      public var subAreaId:uint = 0;
      
      public var inFight:Boolean = false;
      
      public var followSpouse:Boolean = false;
      
      public var guildName:String = "";
      
      public var alignmentSide:int = 0;
      
      public var pvpEnabled:Boolean = false;
      
      public function FriendSpouseOnlineInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 93;
      }
      
      public function initFriendSpouseOnlineInformations(spouseId:uint = 0, spouseName:String = "", spouseLevel:uint = 0, breed:int = 0, sex:int = 0, spouseEntityLook:EntityLook = null, mapId:uint = 0, subAreaId:uint = 0, inFight:Boolean = false, followSpouse:Boolean = false, guildName:String = "", alignmentSide:int = 0, pvpEnabled:Boolean = false) : FriendSpouseOnlineInformations
      {
         super.initFriendSpouseInformations(spouseId,spouseName,spouseLevel,breed,sex,spouseEntityLook);
         this.mapId = mapId;
         this.subAreaId = subAreaId;
         this.inFight = inFight;
         this.followSpouse = followSpouse;
         this.guildName = guildName;
         this.alignmentSide = alignmentSide;
         this.pvpEnabled = pvpEnabled;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mapId = 0;
         this.subAreaId = 0;
         this.inFight = false;
         this.followSpouse = false;
         this.guildName = "";
         this.alignmentSide = 0;
         this.pvpEnabled = false;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FriendSpouseOnlineInformations(output);
      }
      
      public function serializeAs_FriendSpouseOnlineInformations(output:IDataOutput) : void
      {
         super.serializeAs_FriendSpouseInformations(output);
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.inFight);
         BooleanByteWrapper.setFlag(_box0,1,this.followSpouse);
         BooleanByteWrapper.setFlag(_box0,2,this.pvpEnabled);
         output.writeByte(_box0);
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         output.writeShort(this.subAreaId);
         output.writeUTF(this.guildName);
         output.writeByte(this.alignmentSide);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendSpouseOnlineInformations(input);
      }
      
      public function deserializeAs_FriendSpouseOnlineInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         var _box0:uint = input.readByte();
         this.inFight = BooleanByteWrapper.getFlag(_box0,0);
         this.followSpouse = BooleanByteWrapper.getFlag(_box0,1);
         this.pvpEnabled = BooleanByteWrapper.getFlag(_box0,2);
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of FriendSpouseOnlineInformations.mapId.");
         }
         this.subAreaId = input.readShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of FriendSpouseOnlineInformations.subAreaId.");
         }
         this.guildName = input.readUTF();
         this.alignmentSide = input.readByte();
      }
   }
}
