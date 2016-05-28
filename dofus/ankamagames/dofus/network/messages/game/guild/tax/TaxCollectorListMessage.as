package com.ankamagames.dofus.network.messages.game.guild.tax
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorFightersInformation;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class TaxCollectorListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5930;
       
      private var _isInitialized:Boolean = false;
      
      public var nbcollectorMax:uint = 0;
      
      public var taxCollectorHireCost:uint = 0;
      
      public var informations:Vector.<TaxCollectorInformations>;
      
      public var fightersInformations:Vector.<TaxCollectorFightersInformation>;
      
      public function TaxCollectorListMessage()
      {
         this.informations = new Vector.<TaxCollectorInformations>();
         this.fightersInformations = new Vector.<TaxCollectorFightersInformation>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5930;
      }
      
      public function initTaxCollectorListMessage(nbcollectorMax:uint = 0, taxCollectorHireCost:uint = 0, informations:Vector.<TaxCollectorInformations> = null, fightersInformations:Vector.<TaxCollectorFightersInformation> = null) : TaxCollectorListMessage
      {
         this.nbcollectorMax = nbcollectorMax;
         this.taxCollectorHireCost = taxCollectorHireCost;
         this.informations = informations;
         this.fightersInformations = fightersInformations;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.nbcollectorMax = 0;
         this.taxCollectorHireCost = 0;
         this.informations = new Vector.<TaxCollectorInformations>();
         this.fightersInformations = new Vector.<TaxCollectorFightersInformation>();
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void
      {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void
      {
         this.deserialize(input);
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorListMessage(output);
      }
      
      public function serializeAs_TaxCollectorListMessage(output:IDataOutput) : void
      {
         if(this.nbcollectorMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbcollectorMax + ") on element nbcollectorMax.");
         }
         output.writeByte(this.nbcollectorMax);
         if(this.taxCollectorHireCost < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorHireCost + ") on element taxCollectorHireCost.");
         }
         output.writeShort(this.taxCollectorHireCost);
         output.writeShort(this.informations.length);
         for(var _i3:uint = 0; _i3 < this.informations.length; _i3++)
         {
            output.writeShort((this.informations[_i3] as TaxCollectorInformations).getTypeId());
            (this.informations[_i3] as TaxCollectorInformations).serialize(output);
         }
         output.writeShort(this.fightersInformations.length);
         for(var _i4:uint = 0; _i4 < this.fightersInformations.length; _i4++)
         {
            (this.fightersInformations[_i4] as TaxCollectorFightersInformation).serializeAs_TaxCollectorFightersInformation(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorListMessage(input);
      }
      
      public function deserializeAs_TaxCollectorListMessage(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:TaxCollectorInformations = null;
         var _item4:TaxCollectorFightersInformation = null;
         this.nbcollectorMax = input.readByte();
         if(this.nbcollectorMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbcollectorMax + ") on element of TaxCollectorListMessage.nbcollectorMax.");
         }
         this.taxCollectorHireCost = input.readShort();
         if(this.taxCollectorHireCost < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorHireCost + ") on element of TaxCollectorListMessage.taxCollectorHireCost.");
         }
         var _informationsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _informationsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(TaxCollectorInformations,_id3);
            _item3.deserialize(input);
            this.informations.push(_item3);
         }
         var _fightersInformationsLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _fightersInformationsLen; _i4++)
         {
            _item4 = new TaxCollectorFightersInformation();
            _item4.deserialize(input);
            this.fightersInformations.push(_item4);
         }
      }
   }
}
