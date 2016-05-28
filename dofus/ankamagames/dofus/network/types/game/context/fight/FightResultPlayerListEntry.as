package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class FightResultPlayerListEntry extends FightResultFighterListEntry implements INetworkType
   {
      
      public static const protocolId:uint = 24;
       
      public var level:uint = 0;
      
      public var additional:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData>;
      
      public function FightResultPlayerListEntry()
      {
         this.additional = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 24;
      }
      
      public function initFightResultPlayerListEntry(outcome:uint = 0, rewards:FightLoot = null, id:int = 0, alive:Boolean = false, level:uint = 0, additional:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData> = null) : FightResultPlayerListEntry
      {
         super.initFightResultFighterListEntry(outcome,rewards,id,alive);
         this.level = level;
         this.additional = additional;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.level = 0;
         this.additional = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData>();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightResultPlayerListEntry(output);
      }
      
      public function serializeAs_FightResultPlayerListEntry(output:IDataOutput) : void
      {
         super.serializeAs_FightResultFighterListEntry(output);
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeByte(this.level);
         output.writeShort(this.additional.length);
         for(var _i2:uint = 0; _i2 < this.additional.length; _i2++)
         {
            output.writeShort((this.additional[_i2] as com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData).getTypeId());
            (this.additional[_i2] as com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData).serialize(output);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightResultPlayerListEntry(input);
      }
      
      public function deserializeAs_FightResultPlayerListEntry(input:IDataInput) : void
      {
         var _id2:uint = 0;
         var _item2:com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData = null;
         super.deserialize(input);
         this.level = input.readUnsignedByte();
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of FightResultPlayerListEntry.level.");
         }
         var _additionalLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _additionalLen; _i2++)
         {
            _id2 = input.readUnsignedShort();
            _item2 = ProtocolTypeManager.getInstance(com.ankamagames.dofus.network.types.game.context.fight.FightResultAdditionalData,_id2);
            _item2.deserialize(input);
            this.additional.push(_item2);
         }
      }
   }
}
