package com.ankamagames.dofus.network.types.game.actions.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FightTriggeredEffect extends AbstractFightDispellableEffect implements INetworkType
   {
      
      public static const protocolId:uint = 210;
       
      public var trigger:uint = 0;
      
      public var param1:int = 0;
      
      public var param2:int = 0;
      
      public var param3:int = 0;
      
      public function FightTriggeredEffect()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 210;
      }
      
      public function initFightTriggeredEffect(uid:uint = 0, targetId:int = 0, turnDuration:int = 0, dispelable:uint = 1, spellId:uint = 0, trigger:uint = 0, param1:int = 0, param2:int = 0, param3:int = 0) : FightTriggeredEffect
      {
         super.initAbstractFightDispellableEffect(uid,targetId,turnDuration,dispelable,spellId);
         this.trigger = trigger;
         this.param1 = param1;
         this.param2 = param2;
         this.param3 = param3;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.trigger = 0;
         this.param1 = 0;
         this.param2 = 0;
         this.param3 = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightTriggeredEffect(output);
      }
      
      public function serializeAs_FightTriggeredEffect(output:IDataOutput) : void
      {
         super.serializeAs_AbstractFightDispellableEffect(output);
         output.writeByte(this.trigger);
         output.writeInt(this.param1);
         output.writeInt(this.param2);
         output.writeInt(this.param3);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightTriggeredEffect(input);
      }
      
      public function deserializeAs_FightTriggeredEffect(input:IDataInput) : void
      {
         super.deserialize(input);
         this.trigger = input.readByte();
         if(this.trigger < 0)
         {
            throw new Error("Forbidden value (" + this.trigger + ") on element of FightTriggeredEffect.trigger.");
         }
         this.param1 = input.readInt();
         this.param2 = input.readInt();
         this.param3 = input.readInt();
      }
   }
}
