package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class TaxCollectorBasicInformations implements INetworkType
   {
      
      public static const protocolId:uint = 96;
       
      public var firstNameId:uint = 0;
      
      public var lastNameId:uint = 0;
      
      public var mapId:int = 0;
      
      public function TaxCollectorBasicInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 96;
      }
      
      public function initTaxCollectorBasicInformations(firstNameId:uint = 0, lastNameId:uint = 0, mapId:int = 0) : TaxCollectorBasicInformations
      {
         this.firstNameId = firstNameId;
         this.lastNameId = lastNameId;
         this.mapId = mapId;
         return this;
      }
      
      public function reset() : void
      {
         this.firstNameId = 0;
         this.lastNameId = 0;
         this.mapId = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorBasicInformations(output);
      }
      
      public function serializeAs_TaxCollectorBasicInformations(output:IDataOutput) : void
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
         output.writeInt(this.mapId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorBasicInformations(input);
      }
      
      public function deserializeAs_TaxCollectorBasicInformations(input:IDataInput) : void
      {
         this.firstNameId = input.readShort();
         if(this.firstNameId < 0)
         {
            throw new Error("Forbidden value (" + this.firstNameId + ") on element of TaxCollectorBasicInformations.firstNameId.");
         }
         this.lastNameId = input.readShort();
         if(this.lastNameId < 0)
         {
            throw new Error("Forbidden value (" + this.lastNameId + ") on element of TaxCollectorBasicInformations.lastNameId.");
         }
         this.mapId = input.readInt();
      }
   }
}
