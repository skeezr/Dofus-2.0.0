package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class EntityMovementInformations implements INetworkType
   {
      
      public static const protocolId:uint = 63;
       
      public var id:int = 0;
      
      public var steps:Vector.<int>;
      
      public function EntityMovementInformations()
      {
         this.steps = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 63;
      }
      
      public function initEntityMovementInformations(id:int = 0, steps:Vector.<int> = null) : EntityMovementInformations
      {
         this.id = id;
         this.steps = steps;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.steps = new Vector.<int>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_EntityMovementInformations(output);
      }
      
      public function serializeAs_EntityMovementInformations(output:IDataOutput) : void
      {
         output.writeInt(this.id);
         output.writeShort(this.steps.length);
         for(var _i2:uint = 0; _i2 < this.steps.length; _i2++)
         {
            output.writeByte(this.steps[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_EntityMovementInformations(input);
      }
      
      public function deserializeAs_EntityMovementInformations(input:IDataInput) : void
      {
         var _val2:int = 0;
         this.id = input.readInt();
         var _stepsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _stepsLen; _i2++)
         {
            _val2 = input.readByte();
            this.steps.push(_val2);
         }
      }
   }
}
