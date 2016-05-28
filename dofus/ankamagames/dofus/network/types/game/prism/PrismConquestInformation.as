package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.IDataInput;
   
   public class PrismConquestInformation implements INetworkType
   {
      
      public static const protocolId:uint = 152;
       
      public var subId:uint = 0;
      
      public var alignment:uint = 0;
      
      public var isEntered:Boolean = false;
      
      public var isInRoom:Boolean = false;
      
      public function PrismConquestInformation()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 152;
      }
      
      public function initPrismConquestInformation(subId:uint = 0, alignment:uint = 0, isEntered:Boolean = false, isInRoom:Boolean = false) : PrismConquestInformation
      {
         this.subId = subId;
         this.alignment = alignment;
         this.isEntered = isEntered;
         this.isInRoom = isInRoom;
         return this;
      }
      
      public function reset() : void
      {
         this.subId = 0;
         this.alignment = 0;
         this.isEntered = false;
         this.isInRoom = false;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PrismConquestInformation(output);
      }
      
      public function serializeAs_PrismConquestInformation(output:IDataOutput) : void
      {
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.isEntered);
         BooleanByteWrapper.setFlag(_box0,1,this.isInRoom);
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
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PrismConquestInformation(input);
      }
      
      public function deserializeAs_PrismConquestInformation(input:IDataInput) : void
      {
         var _box0:uint = input.readByte();
         this.isEntered = BooleanByteWrapper.getFlag(_box0,0);
         this.isInRoom = BooleanByteWrapper.getFlag(_box0,1);
         this.subId = input.readInt();
         if(this.subId < 0)
         {
            throw new Error("Forbidden value (" + this.subId + ") on element of PrismConquestInformation.subId.");
         }
         this.alignment = input.readByte();
         if(this.alignment < 0)
         {
            throw new Error("Forbidden value (" + this.alignment + ") on element of PrismConquestInformation.alignment.");
         }
      }
   }
}
