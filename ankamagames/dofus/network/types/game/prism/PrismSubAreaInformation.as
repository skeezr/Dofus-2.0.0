package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.IDataInput;
   
   public class PrismSubAreaInformation implements INetworkType
   {
      
      public static const protocolId:uint = 142;
       
      public var subId:uint = 0;
      
      public var alignment:uint = 0;
      
      public var mapId:uint = 0;
      
      public var isInFight:Boolean = false;
      
      public var isFightable:Boolean = false;
      
      public function PrismSubAreaInformation()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 142;
      }
      
      public function initPrismSubAreaInformation(subId:uint = 0, alignment:uint = 0, mapId:uint = 0, isInFight:Boolean = false, isFightable:Boolean = false) : PrismSubAreaInformation
      {
         this.subId = subId;
         this.alignment = alignment;
         this.mapId = mapId;
         this.isInFight = isInFight;
         this.isFightable = isFightable;
         return this;
      }
      
      public function reset() : void
      {
         this.subId = 0;
         this.alignment = 0;
         this.mapId = 0;
         this.isInFight = false;
         this.isFightable = false;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PrismSubAreaInformation(output);
      }
      
      public function serializeAs_PrismSubAreaInformation(output:IDataOutput) : void
      {
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.isInFight);
         BooleanByteWrapper.setFlag(_box0,1,this.isFightable);
         output.writeByte(_box0);
         if(this.subId < 0)
         {
            throw new Error("Forbidden value (" + this.subId + ") on element subId.");
         }
         output.writeInt(this.subId);
         if(this.alignment < 0)
         {
            throw new Error("Forbidden value (" + this.alignment + ") on element alignment.");
         }
         output.writeByte(this.alignment);
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PrismSubAreaInformation(input);
      }
      
      public function deserializeAs_PrismSubAreaInformation(input:IDataInput) : void
      {
         var _box0:uint = input.readByte();
         this.isInFight = BooleanByteWrapper.getFlag(_box0,0);
         this.isFightable = BooleanByteWrapper.getFlag(_box0,1);
         this.subId = input.readInt();
         if(this.subId < 0)
         {
            throw new Error("Forbidden value (" + this.subId + ") on element of PrismSubAreaInformation.subId.");
         }
         this.alignment = input.readByte();
         if(this.alignment < 0)
         {
            throw new Error("Forbidden value (" + this.alignment + ") on element of PrismSubAreaInformation.alignment.");
         }
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of PrismSubAreaInformation.mapId.");
         }
      }
   }
}
