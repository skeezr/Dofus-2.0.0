package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class TaxCollectorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 167;
       
      public var uniqueId:int = 0;
      
      public var firtNameId:uint = 0;
      
      public var lastNameId:uint = 0;
      
      public var additonalInformation:com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations;
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var subAreaId:uint = 0;
      
      public var state:int = 0;
      
      public var look:EntityLook;
      
      public function TaxCollectorInformations()
      {
         this.additonalInformation = new com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations();
         this.look = new EntityLook();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 167;
      }
      
      public function initTaxCollectorInformations(uniqueId:int = 0, firtNameId:uint = 0, lastNameId:uint = 0, additonalInformation:com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations = null, worldX:int = 0, worldY:int = 0, subAreaId:uint = 0, state:int = 0, look:EntityLook = null) : TaxCollectorInformations
      {
         this.uniqueId = uniqueId;
         this.firtNameId = firtNameId;
         this.lastNameId = lastNameId;
         this.additonalInformation = additonalInformation;
         this.worldX = worldX;
         this.worldY = worldY;
         this.subAreaId = subAreaId;
         this.state = state;
         this.look = look;
         return this;
      }
      
      public function reset() : void
      {
         this.uniqueId = 0;
         this.firtNameId = 0;
         this.lastNameId = 0;
         this.additonalInformation = new com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations();
         this.worldY = 0;
         this.subAreaId = 0;
         this.state = 0;
         this.look = new EntityLook();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorInformations(output);
      }
      
      public function serializeAs_TaxCollectorInformations(output:IDataOutput) : void
      {
         output.writeInt(this.uniqueId);
         if(this.firtNameId < 0)
         {
            throw new Error("Forbidden value (" + this.firtNameId + ") on element firtNameId.");
         }
         output.writeShort(this.firtNameId);
         if(this.lastNameId < 0)
         {
            throw new Error("Forbidden value (" + this.lastNameId + ") on element lastNameId.");
         }
         output.writeShort(this.lastNameId);
         this.additonalInformation.serializeAs_AdditionalTaxCollectorInformations(output);
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         output.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         output.writeShort(this.worldY);
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         output.writeShort(this.subAreaId);
         output.writeByte(this.state);
         this.look.serializeAs_EntityLook(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorInformations(input);
      }
      
      public function deserializeAs_TaxCollectorInformations(input:IDataInput) : void
      {
         this.uniqueId = input.readInt();
         this.firtNameId = input.readShort();
         if(this.firtNameId < 0)
         {
            throw new Error("Forbidden value (" + this.firtNameId + ") on element of TaxCollectorInformations.firtNameId.");
         }
         this.lastNameId = input.readShort();
         if(this.lastNameId < 0)
         {
            throw new Error("Forbidden value (" + this.lastNameId + ") on element of TaxCollectorInformations.lastNameId.");
         }
         this.additonalInformation = new com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations();
         this.additonalInformation.deserialize(input);
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of TaxCollectorInformations.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of TaxCollectorInformations.worldY.");
         }
         this.subAreaId = input.readShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of TaxCollectorInformations.subAreaId.");
         }
         this.state = input.readByte();
         this.look = new EntityLook();
         this.look.deserialize(input);
      }
   }
}
