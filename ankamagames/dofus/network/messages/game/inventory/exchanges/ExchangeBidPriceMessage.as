package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeBidPriceMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5755;
       
      private var _isInitialized:Boolean = false;
      
      public var genericId:uint = 0;
      
      public var averagePrice:uint = 0;
      
      public function ExchangeBidPriceMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5755;
      }
      
      public function initExchangeBidPriceMessage(genericId:uint = 0, averagePrice:uint = 0) : ExchangeBidPriceMessage
      {
         this.genericId = genericId;
         this.averagePrice = averagePrice;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.genericId = 0;
         this.averagePrice = 0;
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
         this.serializeAs_ExchangeBidPriceMessage(output);
      }
      
      public function serializeAs_ExchangeBidPriceMessage(output:IDataOutput) : void
      {
         if(this.genericId < 0)
         {
            throw new Error("Forbidden value (" + this.genericId + ") on element genericId.");
         }
         output.writeInt(this.genericId);
         if(this.averagePrice < 0)
         {
            throw new Error("Forbidden value (" + this.averagePrice + ") on element averagePrice.");
         }
         output.writeInt(this.averagePrice);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeBidPriceMessage(input);
      }
      
      public function deserializeAs_ExchangeBidPriceMessage(input:IDataInput) : void
      {
         this.genericId = input.readInt();
         if(this.genericId < 0)
         {
            throw new Error("Forbidden value (" + this.genericId + ") on element of ExchangeBidPriceMessage.genericId.");
         }
         this.averagePrice = input.readInt();
         if(this.averagePrice < 0)
         {
            throw new Error("Forbidden value (" + this.averagePrice + ") on element of ExchangeBidPriceMessage.averagePrice.");
         }
      }
   }
}
