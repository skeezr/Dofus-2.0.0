package com.ankamagames.dofus.network.types.game.interactive
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class InteractiveElement implements INetworkType
   {
      
      public static const protocolId:uint = 80;
       
      public var elementId:uint = 0;
      
      public var enabledSkillIds:Vector.<uint>;
      
      public var disabledSkillIds:Vector.<uint>;
      
      public function InteractiveElement()
      {
         this.enabledSkillIds = new Vector.<uint>();
         this.disabledSkillIds = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 80;
      }
      
      public function initInteractiveElement(elementId:uint = 0, enabledSkillIds:Vector.<uint> = null, disabledSkillIds:Vector.<uint> = null) : InteractiveElement
      {
         this.elementId = elementId;
         this.enabledSkillIds = enabledSkillIds;
         this.disabledSkillIds = disabledSkillIds;
         return this;
      }
      
      public function reset() : void
      {
         this.elementId = 0;
         this.enabledSkillIds = new Vector.<uint>();
         this.disabledSkillIds = new Vector.<uint>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_InteractiveElement(output);
      }
      
      public function serializeAs_InteractiveElement(output:IDataOutput) : void
      {
         if(this.elementId < 0)
         {
            throw new Error("Forbidden value (" + this.elementId + ") on element elementId.");
         }
         output.writeInt(this.elementId);
         output.writeShort(this.enabledSkillIds.length);
         for(var _i2:uint = 0; _i2 < this.enabledSkillIds.length; _i2++)
         {
            if(this.enabledSkillIds[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.enabledSkillIds[_i2] + ") on element 2 (starting at 1) of enabledSkillIds.");
            }
            output.writeShort(this.enabledSkillIds[_i2]);
         }
         output.writeShort(this.disabledSkillIds.length);
         for(var _i3:uint = 0; _i3 < this.disabledSkillIds.length; _i3++)
         {
            if(this.disabledSkillIds[_i3] < 0)
            {
               throw new Error("Forbidden value (" + this.disabledSkillIds[_i3] + ") on element 3 (starting at 1) of disabledSkillIds.");
            }
            output.writeShort(this.disabledSkillIds[_i3]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_InteractiveElement(input);
      }
      
      public function deserializeAs_InteractiveElement(input:IDataInput) : void
      {
         var _val2:uint = 0;
         var _val3:uint = 0;
         this.elementId = input.readInt();
         if(this.elementId < 0)
         {
            throw new Error("Forbidden value (" + this.elementId + ") on element of InteractiveElement.elementId.");
         }
         var _enabledSkillIdsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _enabledSkillIdsLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of enabledSkillIds.");
            }
            this.enabledSkillIds.push(_val2);
         }
         var _disabledSkillIdsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _disabledSkillIdsLen; _i3++)
         {
            _val3 = input.readShort();
            if(_val3 < 0)
            {
               throw new Error("Forbidden value (" + _val3 + ") on elements of disabledSkillIds.");
            }
            this.disabledSkillIds.push(_val3);
         }
      }
   }
}
