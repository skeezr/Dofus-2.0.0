package com.ankamagames.dofus.network.types.game.paddock
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PaddockAbandonnedInformations extends PaddockBuyableInformations implements INetworkType
   {
      
      public static const protocolId:uint = 133;
       
      public var guildId:uint = 0;
      
      public function PaddockAbandonnedInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 133;
      }
      
      public function initPaddockAbandonnedInformations(maxOutdoorMount:uint = 0, maxItems:uint = 0, price:uint = 0, guildId:uint = 0) : PaddockAbandonnedInformations
      {
         super.initPaddockBuyableInformations(maxOutdoorMount,maxItems,price);
         this.guildId = guildId;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guildId = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PaddockAbandonnedInformations(output);
      }
      
      public function serializeAs_PaddockAbandonnedInformations(output:IDataOutput) : void
      {
         super.serializeAs_PaddockBuyableInformations(output);
         if(this.guildId < 0)
         {
            throw new Error("Forbidden value (" + this.guildId + ") on element guildId.");
         }
         output.writeInt(this.guildId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PaddockAbandonnedInformations(input);
      }
      
      public function deserializeAs_PaddockAbandonnedInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.guildId = input.readInt();
         if(this.guildId < 0)
         {
            throw new Error("Forbidden value (" + this.guildId + ") on element of PaddockAbandonnedInformations.guildId.");
         }
      }
   }
}
