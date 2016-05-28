package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeStartedMountStockMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5984;
       
      private var _isInitialized:Boolean = false;
      
      public var objectsInfos:Vector.<ObjectItem>;
      
      public function ExchangeStartedMountStockMessage()
      {
         this.objectsInfos = new Vector.<ObjectItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5984;
      }
      
      public function initExchangeStartedMountStockMessage(objectsInfos:Vector.<ObjectItem> = null) : ExchangeStartedMountStockMessage
      {
         this.objectsInfos = objectsInfos;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectsInfos = new Vector.<ObjectItem>();
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
         this.serializeAs_ExchangeStartedMountStockMessage(output);
      }
      
      public function serializeAs_ExchangeStartedMountStockMessage(output:IDataOutput) : void
      {
         output.writeShort(this.objectsInfos.length);
         for(var _i1:uint = 0; _i1 < this.objectsInfos.length; _i1++)
         {
            (this.objectsInfos[_i1] as ObjectItem).serializeAs_ObjectItem(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeStartedMountStockMessage(input);
      }
      
      public function deserializeAs_ExchangeStartedMountStockMessage(input:IDataInput) : void
      {
         var _item1:ObjectItem = null;
         var _objectsInfosLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _objectsInfosLen; _i1++)
         {
            _item1 = new ObjectItem();
            _item1.deserialize(input);
            this.objectsInfos.push(_item1);
         }
      }
   }
}
