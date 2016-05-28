package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FightResultTaxCollectorListEntry extends FightResultFighterListEntry implements INetworkType
   {
      
      public static const protocolId:uint = 84;
       
      public var level:uint = 0;
      
      public var guildName:String = "";
      
      public var experienceForGuild:int = 0;
      
      public function FightResultTaxCollectorListEntry()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 84;
      }
      
      public function initFightResultTaxCollectorListEntry(outcome:uint = 0, rewards:FightLoot = null, id:int = 0, alive:Boolean = false, level:uint = 0, guildName:String = "", experienceForGuild:int = 0) : FightResultTaxCollectorListEntry
      {
         super.initFightResultFighterListEntry(outcome,rewards,id,alive);
         this.level = level;
         this.guildName = guildName;
         this.experienceForGuild = experienceForGuild;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.level = 0;
         this.guildName = "";
         this.experienceForGuild = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightResultTaxCollectorListEntry(output);
      }
      
      public function serializeAs_FightResultTaxCollectorListEntry(output:IDataOutput) : void
      {
         super.serializeAs_FightResultFighterListEntry(output);
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeByte(this.level);
         output.writeUTF(this.guildName);
         output.writeInt(this.experienceForGuild);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightResultTaxCollectorListEntry(input);
      }
      
      public function deserializeAs_FightResultTaxCollectorListEntry(input:IDataInput) : void
      {
         super.deserialize(input);
         this.level = input.readUnsignedByte();
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of FightResultTaxCollectorListEntry.level.");
         }
         this.guildName = input.readUTF();
         this.experienceForGuild = input.readInt();
      }
   }
}
