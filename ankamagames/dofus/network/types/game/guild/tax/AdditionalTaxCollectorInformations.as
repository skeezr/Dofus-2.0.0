package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class AdditionalTaxCollectorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 165;
       
      public var CollectorCallerName:String = "";
      
      public var date:uint = 0;
      
      public function AdditionalTaxCollectorInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 165;
      }
      
      public function initAdditionalTaxCollectorInformations(CollectorCallerName:String = "", date:uint = 0) : AdditionalTaxCollectorInformations
      {
         this.CollectorCallerName = CollectorCallerName;
         this.date = date;
         return this;
      }
      
      public function reset() : void
      {
         this.CollectorCallerName = "";
         this.date = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_AdditionalTaxCollectorInformations(output);
      }
      
      public function serializeAs_AdditionalTaxCollectorInformations(output:IDataOutput) : void
      {
         output.writeUTF(this.CollectorCallerName);
         if(this.date < 0)
         {
            throw new Error("Forbidden value (" + this.date + ") on element date.");
         }
         output.writeInt(this.date);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AdditionalTaxCollectorInformations(input);
      }
      
      public function deserializeAs_AdditionalTaxCollectorInformations(input:IDataInput) : void
      {
         this.CollectorCallerName = input.readUTF();
         this.date = input.readInt();
         if(this.date < 0)
         {
            throw new Error("Forbidden value (" + this.date + ") on element of AdditionalTaxCollectorInformations.date.");
         }
      }
   }
}
