package com.ankamagames.dofus.network.types.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PartyMemberInformations extends CharacterMinimalPlusLookInformations implements INetworkType
   {
      
      public static const protocolId:uint = 90;
       
      public var lifePoints:uint = 0;
      
      public var maxLifePoints:uint = 0;
      
      public var prospecting:uint = 0;
      
      public var regenRate:uint = 0;
      
      public var initiative:uint = 0;
      
      public var pvpEnabled:Boolean = false;
      
      public var alignmentSide:int = 0;
      
      public function PartyMemberInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 90;
      }
      
      public function initPartyMemberInformations(id:uint = 0, name:String = "", level:uint = 0, entityLook:EntityLook = null, lifePoints:uint = 0, maxLifePoints:uint = 0, prospecting:uint = 0, regenRate:uint = 0, initiative:uint = 0, pvpEnabled:Boolean = false, alignmentSide:int = 0) : PartyMemberInformations
      {
         super.initCharacterMinimalPlusLookInformations(id,name,level,entityLook);
         this.lifePoints = lifePoints;
         this.maxLifePoints = maxLifePoints;
         this.prospecting = prospecting;
         this.regenRate = regenRate;
         this.initiative = initiative;
         this.pvpEnabled = pvpEnabled;
         this.alignmentSide = alignmentSide;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.lifePoints = 0;
         this.maxLifePoints = 0;
         this.prospecting = 0;
         this.regenRate = 0;
         this.initiative = 0;
         this.pvpEnabled = false;
         this.alignmentSide = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PartyMemberInformations(output);
      }
      
      public function serializeAs_PartyMemberInformations(output:IDataOutput) : void
      {
         super.serializeAs_CharacterMinimalPlusLookInformations(output);
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
         if(this.initiative < 0)
         {
            throw new Error("Forbidden value (" + this.initiative + ") on element initiative.");
         }
         output.writeShort(this.initiative);
         output.writeBoolean(this.pvpEnabled);
         output.writeByte(this.alignmentSide);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyMemberInformations(input);
      }
      
      public function deserializeAs_PartyMemberInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.lifePoints = input.readInt();
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element of PartyMemberInformations.lifePoints.");
         }
         this.maxLifePoints = input.readInt();
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element of PartyMemberInformations.maxLifePoints.");
         }
         this.prospecting = input.readShort();
         if(this.prospecting < 0)
         {
            throw new Error("Forbidden value (" + this.prospecting + ") on element of PartyMemberInformations.prospecting.");
         }
         this.regenRate = input.readUnsignedByte();
         if(this.regenRate < 0 || this.regenRate > 255)
         {
            throw new Error("Forbidden value (" + this.regenRate + ") on element of PartyMemberInformations.regenRate.");
         }
         this.initiative = input.readShort();
         if(this.initiative < 0)
         {
            throw new Error("Forbidden value (" + this.initiative + ") on element of PartyMemberInformations.initiative.");
         }
         this.pvpEnabled = input.readBoolean();
         this.alignmentSide = input.readByte();
      }
   }
}
