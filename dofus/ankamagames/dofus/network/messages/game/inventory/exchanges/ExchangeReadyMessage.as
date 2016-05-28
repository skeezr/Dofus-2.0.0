package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeReadyMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5511;
       
      private var _isInitialized:Boolean = false;
      
      public var ready:Boolean = false;
      
      public function ExchangeReadyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5511;
      }
      
      public function initExchangeReadyMessage(ready:Boolean = false) : ExchangeReadyMessage
      {
         this.ready = ready;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.ready = false;
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
         this.serializeAs_ExchangeReadyMessage(output);
      }
      
      public function serializeAs_ExchangeReadyMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.ready);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeReadyMessage(input);
      }
      
      public function deserializeAs_ExchangeReadyMessage(input:IDataInput) : void
      {
         this.ready = input.readBoolean();
      }
   }
}
