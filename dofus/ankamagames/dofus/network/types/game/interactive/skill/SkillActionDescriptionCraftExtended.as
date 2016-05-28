package com.ankamagames.dofus.network.types.game.interactive.skill
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class SkillActionDescriptionCraftExtended extends SkillActionDescriptionCraft implements INetworkType
   {
      
      public static const protocolId:uint = 104;
       
      public var thresholdSlots:uint = 0;
      
      public var optimumProbability:uint = 0;
      
      public function SkillActionDescriptionCraftExtended()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 104;
      }
      
      public function initSkillActionDescriptionCraftExtended(skillId:uint = 0, maxSlots:uint = 0, probability:uint = 0, thresholdSlots:uint = 0, optimumProbability:uint = 0) : SkillActionDescriptionCraftExtended
      {
         super.initSkillActionDescriptionCraft(skillId,maxSlots,probability);
         this.thresholdSlots = thresholdSlots;
         this.optimumProbability = optimumProbability;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.thresholdSlots = 0;
         this.optimumProbability = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_SkillActionDescriptionCraftExtended(output);
      }
      
      public function serializeAs_SkillActionDescriptionCraftExtended(output:IDataOutput) : void
      {
         super.serializeAs_SkillActionDescriptionCraft(output);
         if(this.thresholdSlots < 0)
         {
            throw new Error("Forbidden value (" + this.thresholdSlots + ") on element thresholdSlots.");
         }
         output.writeByte(this.thresholdSlots);
         if(this.optimumProbability < 0)
         {
            throw new Error("Forbidden value (" + this.optimumProbability + ") on element optimumProbability.");
         }
         output.writeByte(this.optimumProbability);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SkillActionDescriptionCraftExtended(input);
      }
      
      public function deserializeAs_SkillActionDescriptionCraftExtended(input:IDataInput) : void
      {
         super.deserialize(input);
         this.thresholdSlots = input.readByte();
         if(this.thresholdSlots < 0)
         {
            throw new Error("Forbidden value (" + this.thresholdSlots + ") on element of SkillActionDescriptionCraftExtended.thresholdSlots.");
         }
         this.optimumProbability = input.readByte();
         if(this.optimumProbability < 0)
         {
            throw new Error("Forbidden value (" + this.optimumProbability + ") on element of SkillActionDescriptionCraftExtended.optimumProbability.");
         }
      }
   }
}
