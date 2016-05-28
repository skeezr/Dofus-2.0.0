package com.ankamagames.dofus.network.types.game.guild
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GuildMember extends CharacterMinimalInformations implements INetworkType
   {
      
      public static const protocolId:uint = 88;
       
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var rank:uint = 0;
      
      public var givenExperience:Number = 0;
      
      public var experienceGivenPercent:uint = 0;
      
      public var rights:uint = 0;
      
      public var connected:uint = 99;
      
      public var alignmentSide:int = 0;
      
      public var hoursSinceLastConnection:uint = 0;
      
      public function GuildMember()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 88;
      }
      
      public function initGuildMember(id:uint = 0, name:String = "", level:uint = 0, breed:int = 0, sex:Boolean = false, rank:uint = 0, givenExperience:Number = 0, experienceGivenPercent:uint = 0, rights:uint = 0, connected:uint = 99, alignmentSide:int = 0, hoursSinceLastConnection:uint = 0) : GuildMember
      {
         super.initCharacterMinimalInformations(id,name,level);
         this.breed = breed;
         this.sex = sex;
         this.rank = rank;
         this.givenExperience = givenExperience;
         this.experienceGivenPercent = experienceGivenPercent;
         this.rights = rights;
         this.connected = connected;
         this.alignmentSide = alignmentSide;
         this.hoursSinceLastConnection = hoursSinceLastConnection;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.breed = 0;
         this.sex = false;
         this.rank = 0;
         this.givenExperience = 0;
         this.experienceGivenPercent = 0;
         this.rights = 0;
         this.connected = 99;
         this.alignmentSide = 0;
         this.hoursSinceLastConnection = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GuildMember(output);
      }
      
      public function serializeAs_GuildMember(output:IDataOutput) : void
      {
         super.serializeAs_CharacterMinimalInformations(output);
         output.writeByte(this.breed);
         output.writeBoolean(this.sex);
         if(this.rank < 0)
         {
            throw new Error("Forbidden value (" + this.rank + ") on element rank.");
         }
         output.writeShort(this.rank);
         if(this.givenExperience < 0)
         {
            throw new Error("Forbidden value (" + this.givenExperience + ") on element givenExperience.");
         }
         output.writeDouble(this.givenExperience);
         if(this.experienceGivenPercent < 0 || this.experienceGivenPercent > 100)
         {
            throw new Error("Forbidden value (" + this.experienceGivenPercent + ") on element experienceGivenPercent.");
         }
         output.writeByte(this.experienceGivenPercent);
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element rights.");
         }
         output.writeUnsignedInt(this.rights);
         output.writeByte(this.connected);
         output.writeByte(this.alignmentSide);
         if(this.hoursSinceLastConnection < 0 || this.hoursSinceLastConnection > 65535)
         {
            throw new Error("Forbidden value (" + this.hoursSinceLastConnection + ") on element hoursSinceLastConnection.");
         }
         output.writeShort(this.hoursSinceLastConnection);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildMember(input);
      }
      
      public function deserializeAs_GuildMember(input:IDataInput) : void
      {
         super.deserialize(input);
         this.breed = input.readByte();
         this.sex = input.readBoolean();
         this.rank = input.readShort();
         if(this.rank < 0)
         {
            throw new Error("Forbidden value (" + this.rank + ") on element of GuildMember.rank.");
         }
         this.givenExperience = input.readDouble();
         if(this.givenExperience < 0)
         {
            throw new Error("Forbidden value (" + this.givenExperience + ") on element of GuildMember.givenExperience.");
         }
         this.experienceGivenPercent = input.readByte();
         if(this.experienceGivenPercent < 0 || this.experienceGivenPercent > 100)
         {
            throw new Error("Forbidden value (" + this.experienceGivenPercent + ") on element of GuildMember.experienceGivenPercent.");
         }
         this.rights = input.readUnsignedInt();
         if(this.rights < 0 || this.rights > 4294967295)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element of GuildMember.rights.");
         }
         this.connected = input.readByte();
         if(this.connected < 0)
         {
            throw new Error("Forbidden value (" + this.connected + ") on element of GuildMember.connected.");
         }
         this.alignmentSide = input.readByte();
         this.hoursSinceLastConnection = input.readUnsignedShort();
         if(this.hoursSinceLastConnection < 0 || this.hoursSinceLastConnection > 65535)
         {
            throw new Error("Forbidden value (" + this.hoursSinceLastConnection + ") on element of GuildMember.hoursSinceLastConnection.");
         }
      }
   }
}
