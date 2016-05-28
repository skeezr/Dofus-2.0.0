package com.ankamagames.dofus.network.types.game.interactive.skill
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class SkillActionDescriptionCraft extends SkillActionDescription implements INetworkType
   {
      
      public static const protocolId:uint = 100;
       
      public var maxSlots:uint = 0;
      
      public var probability:uint = 0;
      
      public function SkillActionDescriptionCraft()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 100;
      }
      
      public function initSkillActionDescriptionCraft(skillId:uint = 0, maxSlots:uint = 0, probability:uint = 0) : SkillActionDescriptionCraft
      {
         super.initSkillActionDescription(skillId);
         this.maxSlots = maxSlots;
         this.probability = probability;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.maxSlots = 0;
         this.probability = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_SkillActionDescriptionCraft(output);
      }
      
      public function serializeAs_SkillActionDescriptionCraft(output:IDataOutput) : void
      {
         super.serializeAs_SkillActionDescription(output);
         if(this.maxSlots < 0)
         {
            throw new Error("Forbidden value (" + this.maxSlots + ") on element maxSlots.");
         }
         output.writeByte(this.maxSlots);
         if(this.probability < 0)
         {
            throw new Error("Forbidden value (" + this.probability + ") on element probability.");
         }
         output.writeByte(this.probability);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SkillActionDescriptionCraft(input);
      }
      
      public function deserializeAs_SkillActionDescriptionCraft(input:IDataInput) : void
      {
         super.deserialize(input);
         this.maxSlots = input.readByte();
         if(this.maxSlots < 0)
         {
            throw new Error("Forbidden value (" + this.maxSlots + ") on element of SkillActionDescriptionCraft.maxSlots.");
         }
         this.probability = input.readByte();
         if(this.probability < 0)
         {
            throw new Error("Forbidden value (" + this.probability + ") on element of SkillActionDescriptionCraft.probability.");
         }
      }
   }
}
