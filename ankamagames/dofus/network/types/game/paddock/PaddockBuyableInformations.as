package com.ankamagames.dofus.network.types.game.paddock
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PaddockBuyableInformations extends PaddockInformations implements INetworkType
   {
      
      public static const protocolId:uint = 130;
       
      public var price:uint = 0;
      
      public function PaddockBuyableInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 130;
      }
      
      public function initPaddockBuyableInformations(maxOutdoorMount:uint = 0, maxItems:uint = 0, price:uint = 0) : PaddockBuyableInformations
      {
         super.initPaddockInformations(maxOutdoorMount,maxItems);
         this.price = price;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.price = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PaddockBuyableInformations(output);
      }
      
      public function serializeAs_PaddockBuyableInformations(output:IDataOutput) : void
      {
         super.serializeAs_PaddockInformations(output);
         if(this.price < 0)
         {
            throw new Error("Forbidden value (" + this.price + ") on element price.");
         }
         output.writeInt(this.price);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PaddockBuyableInformations(input);
      }
      
      public function deserializeAs_PaddockBuyableInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.price = input.readInt();
         if(this.price < 0)
         {
            throw new Error("Forbidden value (" + this.price + ") on element of PaddockBuyableInformations.price.");
         }
      }
   }
}
