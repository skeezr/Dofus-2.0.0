package com.ankamagames.dofus.network.types.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PartyUpdateCommonsInformations implements INetworkType
   {
      
      public static const protocolId:uint = 213;
       
      public var lifePoints:uint = 0;
      
      public var maxLifePoints:uint = 0;
      
      public var prospecting:uint = 0;
      
      public var regenRate:uint = 0;
      
      public function PartyUpdateCommonsInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 213;
      }
      
      public function initPartyUpdateCommonsInformations(lifePoints:uint = 0, maxLifePoints:uint = 0, prospecting:uint = 0, regenRate:uint = 0) : PartyUpdateCommonsInformations
      {
         this.lifePoints = lifePoints;
         this.maxLifePoints = maxLifePoints;
         this.prospecting = prospecting;
         this.regenRate = regenRate;
         return this;
      }
      
      public function reset() : void
      {
         this.lifePoints = 0;
         this.maxLifePoints = 0;
         this.prospecting = 0;
         this.regenRate = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PartyUpdateCommonsInformations(output);
      }
      
      public function serializeAs_PartyUpdateCommonsInformations(output:IDataOutput) : void
      {
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element lifePoints.");
         }
         output.writeInt(this.lifePoints);
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element maxLifePoints.");
         }
         output.writeInt(this.maxLifePoints);
         if(this.prospecting < 0)
         {
            throw new Error("Forbidden value (" + this.prospecting + ") on element prospecting.");
         }
         output.writeShort(this.prospecting);
         if(this.regenRate < 0 || this.regenRate > 255)
         {
            throw new Error("Forbidden value (" + this.regenRate + ") on element regenRate.");
         }
         output.writeByte(this.regenRate);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyUpdateCommonsInformations(input);
      }
      
      public function deserializeAs_PartyUpdateCommonsInformations(input:IDataInput) : void
      {
         this.lifePoints = input.readInt();
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element of PartyUpdateCommonsInformations.lifePoints.");
         }
         this.maxLifePoints = input.readInt();
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element of PartyUpdateCommonsInformations.maxLifePoints.");
         }
         this.prospecting = input.readShort();
         if(this.prospecting < 0)
         {
            throw new Error("Forbidden value (" + this.prospecting + ") on element of PartyUpdateCommonsInformations.prospecting.");
         }
         this.regenRate = input.readUnsignedByte();
         if(this.regenRate < 0 || this.regenRate > 255)
         {
            throw new Error("Forbidden value (" + this.regenRate + ") on element of PartyUpdateCommonsInformations.regenRate.");
         }
      }
   }
}
