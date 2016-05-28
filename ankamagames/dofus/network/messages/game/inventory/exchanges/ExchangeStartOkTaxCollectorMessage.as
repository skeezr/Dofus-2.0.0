package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeStartOkTaxCollectorMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5780;
       
      private var _isInitialized:Boolean = false;
      
      public var collectorId:int = 0;
      
      public var objectsInfos:Vector.<ObjectItem>;
      
      public var goldInfo:uint = 0;
      
      public function ExchangeStartOkTaxCollectorMessage()
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
         return 5780;
      }
      
      public function initExchangeStartOkTaxCollectorMessage(collectorId:int = 0, objectsInfos:Vector.<ObjectItem> = null, goldInfo:uint = 0) : ExchangeStartOkTaxCollectorMessage
      {
         this.collectorId = collectorId;
         this.objectsInfos = objectsInfos;
         this.goldInfo = goldInfo;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.collectorId = 0;
         this.objectsInfos = new Vector.<ObjectItem>();
         this.goldInfo = 0;
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
         this.serializeAs_ExchangeStartOkTaxCollectorMessage(output);
      }
      
      public function serializeAs_ExchangeStartOkTaxCollectorMessage(output:IDataOutput) : void
      {
         output.writeInt(this.collectorId);
         output.writeShort(this.objectsInfos.length);
         for(var _i2:uint = 0; _i2 < this.objectsInfos.length; _i2++)
         {
            (this.objectsInfos[_i2] as ObjectItem).serializeAs_ObjectItem(output);
         }
         if(this.goldInfo < 0)
         {
            throw new Error("Forbidden value (" + this.goldInfo + ") on element goldInfo.");
         }
         output.writeInt(this.goldInfo);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkTaxCollectorMessage(input);
      }
      
      public function deserializeAs_ExchangeStartOkTaxCollectorMessage(input:IDataInput) : void
      {
         var _item2:ObjectItem = null;
         this.collectorId = input.readInt();
         var _objectsInfosLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _objectsInfosLen; _i2++)
         {
            _item2 = new ObjectItem();
            _item2.deserialize(input);
            this.objectsInfos.push(_item2);
         }
         this.goldInfo = input.readInt();
         if(this.goldInfo < 0)
         {
            throw new Error("Forbidden value (" + this.goldInfo + ") on element of ExchangeStartOkTaxCollectorMessage.goldInfo.");
         }
      }
   }
}
