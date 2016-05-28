package com.ankamagames.dofus.network.types.game.data.items.effects
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class ObjectEffectLadder extends ObjectEffectCreature implements INetworkType
   {
      
      public static const protocolId:uint = 81;
       
      public var monsterCount:uint = 0;
      
      public function ObjectEffectLadder()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 81;
      }
      
      public function initObjectEffectLadder(actionId:uint = 0, monsterFamilyId:uint = 0, monsterCount:uint = 0) : ObjectEffectLadder
      {
         super.initObjectEffectCreature(actionId,monsterFamilyId);
         this.monsterCount = monsterCount;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.monsterCount = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ObjectEffectLadder(output);
      }
      
      public function serializeAs_ObjectEffectLadder(output:IDataOutput) : void
      {
         super.serializeAs_ObjectEffectCreature(output);
         if(this.monsterCount < 0)
         {
            throw new Error("Forbidden value (" + this.monsterCount + ") on element monsterCount.");
         }
         output.writeInt(this.monsterCount);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectEffectLadder(input);
      }
      
      public function deserializeAs_ObjectEffectLadder(input:IDataInput) : void
      {
         super.deserialize(input);
         this.monsterCount = input.readInt();
         if(this.monsterCount < 0)
         {
            throw new Error("Forbidden value (" + this.monsterCount + ") on element of ObjectEffectLadder.monsterCount.");
         }
      }
   }
}
