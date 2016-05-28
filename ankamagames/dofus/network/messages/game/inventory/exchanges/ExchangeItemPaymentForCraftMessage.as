package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemNotInContainer;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeItemPaymentForCraftMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5831;
       
      private var _isInitialized:Boolean = false;
      
      public var onlySuccess:Boolean = false;
      
      public var object:ObjectItemNotInContainer;
      
      public function ExchangeItemPaymentForCraftMessage()
      {
         this.object = new ObjectItemNotInContainer();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5831;
      }
      
      public function initExchangeItemPaymentForCraftMessage(onlySuccess:Boolean = false, object:ObjectItemNotInContainer = null) : ExchangeItemPaymentForCraftMessage
      {
         this.onlySuccess = onlySuccess;
         this.object = object;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.onlySuccess = false;
         this.object = new ObjectItemNotInContainer();
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
         this.serializeAs_ExchangeItemPaymentForCraftMessage(output);
      }
      
      public function serializeAs_ExchangeItemPaymentForCraftMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.onlySuccess);
         this.object.serializeAs_ObjectItemNotInContainer(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeItemPaymentForCraftMessage(input);
      }
      
      public function deserializeAs_ExchangeItemPaymentForCraftMessage(input:IDataInput) : void
      {
         this.onlySuccess = input.readBoolean();
         this.object = new ObjectItemNotInContainer();
         this.object.deserialize(input);
      }
   }
}
