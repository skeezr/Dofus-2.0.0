package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeOnHumanVendorRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5772;
       
      private var _isInitialized:Boolean = false;
      
      public var humanVendorId:uint = 0;
      
      public var humanVendorCell:uint = 0;
      
      public function ExchangeOnHumanVendorRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5772;
      }
      
      public function initExchangeOnHumanVendorRequestMessage(humanVendorId:uint = 0, humanVendorCell:uint = 0) : ExchangeOnHumanVendorRequestMessage
      {
         this.humanVendorId = humanVendorId;
         this.humanVendorCell = humanVendorCell;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.humanVendorId = 0;
         this.humanVendorCell = 0;
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
         this.serializeAs_ExchangeOnHumanVendorRequestMessage(output);
      }
      
      public function serializeAs_ExchangeOnHumanVendorRequestMessage(output:IDataOutput) : void
      {
         if(this.humanVendorId < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorId + ") on element humanVendorId.");
         }
         output.writeInt(this.humanVendorId);
         if(this.humanVendorCell < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorCell + ") on element humanVendorCell.");
         }
         output.writeInt(this.humanVendorCell);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeOnHumanVendorRequestMessage(input);
      }
      
      public function deserializeAs_ExchangeOnHumanVendorRequestMessage(input:IDataInput) : void
      {
         this.humanVendorId = input.readInt();
         if(this.humanVendorId < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorId + ") on element of ExchangeOnHumanVendorRequestMessage.humanVendorId.");
         }
         this.humanVendorCell = input.readInt();
         if(this.humanVendorCell < 0)
         {
            throw new Error("Forbidden value (" + this.humanVendorCell + ") on element of ExchangeOnHumanVendorRequestMessage.humanVendorCell.");
         }
      }
   }
}
