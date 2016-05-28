package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemMinimalInformation;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeCraftResultWithObjectDescMessage extends ExchangeCraftResultMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5999;
       
      private var _isInitialized:Boolean = false;
      
      public var objectInfo:ObjectItemMinimalInformation;
      
      public function ExchangeCraftResultWithObjectDescMessage()
      {
         this.objectInfo = new ObjectItemMinimalInformation();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5999;
      }
      
      public function initExchangeCraftResultWithObjectDescMessage(craftResult:uint = 0, objectInfo:ObjectItemMinimalInformation = null) : ExchangeCraftResultWithObjectDescMessage
      {
         super.initExchangeCraftResultMessage(craftResult);
         this.objectInfo = objectInfo;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.objectInfo = new ObjectItemMinimalInformation();
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
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ExchangeCraftResultWithObjectDescMessage(output);
      }
      
      public function serializeAs_ExchangeCraftResultWithObjectDescMessage(output:IDataOutput) : void
      {
         super.serializeAs_ExchangeCraftResultMessage(output);
         this.objectInfo.serializeAs_ObjectItemMinimalInformation(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeCraftResultWithObjectDescMessage(input);
      }
      
      public function deserializeAs_ExchangeCraftResultWithObjectDescMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.objectInfo = new ObjectItemMinimalInformation();
         this.objectInfo.deserialize(input);
      }
   }
}
