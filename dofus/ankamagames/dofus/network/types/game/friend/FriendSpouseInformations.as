package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FriendSpouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 77;
       
      public var spouseId:uint = 0;
      
      public var spouseName:String = "";
      
      public var spouseLevel:uint = 0;
      
      public var breed:int = 0;
      
      public var sex:int = 0;
      
      public var spouseEntityLook:EntityLook;
      
      public function FriendSpouseInformations()
      {
         this.spouseEntityLook = new EntityLook();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 77;
      }
      
      public function initFriendSpouseInformations(spouseId:uint = 0, spouseName:String = "", spouseLevel:uint = 0, breed:int = 0, sex:int = 0, spouseEntityLook:EntityLook = null) : FriendSpouseInformations
      {
         this.spouseId = spouseId;
         this.spouseName = spouseName;
         this.spouseLevel = spouseLevel;
         this.breed = breed;
         this.sex = sex;
         this.spouseEntityLook = spouseEntityLook;
         return this;
      }
      
      public function reset() : void
      {
         this.spouseId = 0;
         this.spouseName = "";
         this.spouseLevel = 0;
         this.breed = 0;
         this.sex = 0;
         this.spouseEntityLook = new EntityLook();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FriendSpouseInformations(output);
      }
      
      public function serializeAs_FriendSpouseInformations(output:IDataOutput) : void
      {
         if(this.spouseId < 0)
         {
            throw new Error("Forbidden value (" + this.spouseId + ") on element spouseId.");
         }
         output.writeInt(this.spouseId);
         output.writeUTF(this.spouseName);
         if(this.spouseLevel < 1 || this.spouseLevel > 200)
         {
            throw new Error("Forbidden value (" + this.spouseLevel + ") on element spouseLevel.");
         }
         output.writeByte(this.spouseLevel);
         output.writeByte(this.breed);
         output.writeByte(this.sex);
         this.spouseEntityLook.serializeAs_EntityLook(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendSpouseInformations(input);
      }
      
      public function deserializeAs_FriendSpouseInformations(input:IDataInput) : void
      {
         this.spouseId = input.readInt();
         if(this.spouseId < 0)
         {
            throw new Error("Forbidden value (" + this.spouseId + ") on element of FriendSpouseInformations.spouseId.");
         }
         this.spouseName = input.readUTF();
         this.spouseLevel = input.readUnsignedByte();
         if(this.spouseLevel < 1 || this.spouseLevel > 200)
         {
            throw new Error("Forbidden value (" + this.spouseLevel + ") on element of FriendSpouseInformations.spouseLevel.");
         }
         this.breed = input.readByte();
         this.sex = input.readByte();
         this.spouseEntityLook = new EntityLook();
         this.spouseEntityLook.deserialize(input);
      }
   }
}
