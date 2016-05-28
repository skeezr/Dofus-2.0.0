package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.prism.PrismSubAreaInformation;
   import com.ankamagames.dofus.network.types.game.prism.PrismConquestInformation;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PrismWorldInformationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5854;
       
      private var _isInitialized:Boolean = false;
      
      public var nbSubOwned:uint = 0;
      
      public var subTotal:uint = 0;
      
      public var maxSub:uint = 0;
      
      public var subAreasInformation:Vector.<PrismSubAreaInformation>;
      
      public var nbConqsOwned:uint = 0;
      
      public var conqsTotal:uint = 0;
      
      public var conquetesInformation:Vector.<PrismConquestInformation>;
      
      public function PrismWorldInformationMessage()
      {
         this.subAreasInformation = new Vector.<PrismSubAreaInformation>();
         this.conquetesInformation = new Vector.<PrismConquestInformation>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5854;
      }
      
      public function initPrismWorldInformationMessage(nbSubOwned:uint = 0, subTotal:uint = 0, maxSub:uint = 0, subAreasInformation:Vector.<PrismSubAreaInformation> = null, nbConqsOwned:uint = 0, conqsTotal:uint = 0, conquetesInformation:Vector.<PrismConquestInformation> = null) : PrismWorldInformationMessage
      {
         this.nbSubOwned = nbSubOwned;
         this.subTotal = subTotal;
         this.maxSub = maxSub;
         this.subAreasInformation = subAreasInformation;
         this.nbConqsOwned = nbConqsOwned;
         this.conqsTotal = conqsTotal;
         this.conquetesInformation = conquetesInformation;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.nbSubOwned = 0;
         this.subTotal = 0;
         this.maxSub = 0;
         this.subAreasInformation = new Vector.<PrismSubAreaInformation>();
         this.nbConqsOwned = 0;
         this.conqsTotal = 0;
         this.conquetesInformation = new Vector.<PrismConquestInformation>();
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
         this.serializeAs_PrismWorldInformationMessage(output);
      }
      
      public function serializeAs_PrismWorldInformationMessage(output:IDataOutput) : void
      {
         if(this.nbSubOwned < 0)
         {
            throw new Error("Forbidden value (" + this.nbSubOwned + ") on element nbSubOwned.");
         }
         output.writeInt(this.nbSubOwned);
         if(this.subTotal < 0)
         {
            throw new Error("Forbidden value (" + this.subTotal + ") on element subTotal.");
         }
         output.writeInt(this.subTotal);
         if(this.maxSub < 0)
         {
            throw new Error("Forbidden value (" + this.maxSub + ") on element maxSub.");
         }
         output.writeInt(this.maxSub);
         output.writeShort(this.subAreasInformation.length);
         for(var _i4:uint = 0; _i4 < this.subAreasInformation.length; _i4++)
         {
            (this.subAreasInformation[_i4] as PrismSubAreaInformation).serializeAs_PrismSubAreaInformation(output);
         }
         if(this.nbConqsOwned < 0)
         {
            throw new Error("Forbidden value (" + this.nbConqsOwned + ") on element nbConqsOwned.");
         }
         output.writeInt(this.nbConqsOwned);
         if(this.conqsTotal < 0)
         {
            throw new Error("Forbidden value (" + this.conqsTotal + ") on element conqsTotal.");
         }
         output.writeInt(this.conqsTotal);
         output.writeShort(this.conquetesInformation.length);
         for(var _i7:uint = 0; _i7 < this.conquetesInformation.length; _i7++)
         {
            (this.conquetesInformation[_i7] as PrismConquestInformation).serializeAs_PrismConquestInformation(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PrismWorldInformationMessage(input);
      }
      
      public function deserializeAs_PrismWorldInformationMessage(input:IDataInput) : void
      {
         var _item4:PrismSubAreaInformation = null;
         var _item7:PrismConquestInformation = null;
         this.nbSubOwned = input.readInt();
         if(this.nbSubOwned < 0)
         {
            throw new Error("Forbidden value (" + this.nbSubOwned + ") on element of PrismWorldInformationMessage.nbSubOwned.");
         }
         this.subTotal = input.readInt();
         if(this.subTotal < 0)
         {
            throw new Error("Forbidden value (" + this.subTotal + ") on element of PrismWorldInformationMessage.subTotal.");
         }
         this.maxSub = input.readInt();
         if(this.maxSub < 0)
         {
            throw new Error("Forbidden value (" + this.maxSub + ") on element of PrismWorldInformationMessage.maxSub.");
         }
         var _subAreasInformationLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _subAreasInformationLen; _i4++)
         {
            _item4 = new PrismSubAreaInformation();
            _item4.deserialize(input);
            this.subAreasInformation.push(_item4);
         }
         this.nbConqsOwned = input.readInt();
         if(this.nbConqsOwned < 0)
         {
            throw new Error("Forbidden value (" + this.nbConqsOwned + ") on element of PrismWorldInformationMessage.nbConqsOwned.");
         }
         this.conqsTotal = input.readInt();
         if(this.conqsTotal < 0)
         {
            throw new Error("Forbidden value (" + this.conqsTotal + ") on element of PrismWorldInformationMessage.conqsTotal.");
         }
         var _conquetesInformationLen:uint = input.readUnsignedShort();
         for(var _i7:uint = 0; _i7 < _conquetesInformationLen; _i7++)
         {
            _item7 = new PrismConquestInformation();
            _item7.deserialize(input);
            this.conquetesInformation.push(_item7);
         }
      }
   }
}
