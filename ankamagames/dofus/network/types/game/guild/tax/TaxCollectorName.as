package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class TaxCollectorName implements INetworkType
   {
      
      public static const protocolId:uint = 187;
       
      public var firstNameId:uint = 0;
      
      public var lastNameId:uint = 0;
      
      public function TaxCollectorName()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 187;
      }
      
      public function initTaxCollectorName(firstNameId:uint = 0, lastNameId:uint = 0) : TaxCollectorName
      {
         this.firstNameId = firstNameId;
         this.lastNameId = lastNameId;
         return this;
      }
      
      public function reset() : void
      {
         this.firstNameId = 0;
         this.lastNameId = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorName(output);
      }
      
      public function serializeAs_TaxCollectorName(output:IDataOutput) : void
      {
         if(this.firstNameId < 0)
         {
            throw new Error("Forbidden value (" + this.firstNameId + ") on element firstNameId.");
         }
         output.writeShort(this.firstNameId);
         if(this.lastNameId < 0)
         {
            throw new Error("Forbidden value (" + this.lastNameId + ") on element lastNameId.");
         }
         output.writeShort(this.lastNameId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorName(input);
      }
      
      public function deserializeAs_TaxCollectorName(input:IDataInput) : void
      {
         this.firstNameId = input.readShort();
         if(this.firstNameId < 0)
         {
            throw new Error("Forbidden value (" + this.firstNameId + ") on element of TaxCollectorName.firstNameId.");
         }
         this.lastNameId = input.readShort();
         if(this.lastNameId < 0)
         {
            throw new Error("Forbidden value (" + this.lastNameId + ") on element of TaxCollectorName.lastNameId.");
         }
      }
   }
}
