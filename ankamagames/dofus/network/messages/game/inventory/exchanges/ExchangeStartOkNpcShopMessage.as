package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemMinimalInformation;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeStartOkNpcShopMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5761;
       
      private var _isInitialized:Boolean = false;
      
      public var npcSellerId:int = 0;
      
      public var objectsInfos:Vector.<ObjectItemMinimalInformation>;
      
      public function ExchangeStartOkNpcShopMessage()
      {
         this.objectsInfos = new Vector.<ObjectItemMinimalInformation>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5761;
      }
      
      public function initExchangeStartOkNpcShopMessage(npcSellerId:int = 0, objectsInfos:Vector.<ObjectItemMinimalInformation> = null) : ExchangeStartOkNpcShopMessage
      {
         this.npcSellerId = npcSellerId;
         this.objectsInfos = objectsInfos;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.npcSellerId = 0;
         this.objectsInfos = new Vector.<ObjectItemMinimalInformation>();
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
         this.serializeAs_ExchangeStartOkNpcShopMessage(output);
      }
      
      public function serializeAs_ExchangeStartOkNpcShopMessage(output:IDataOutput) : void
      {
         output.writeInt(this.npcSellerId);
         output.writeShort(this.objectsInfos.length);
         for(var _i2:uint = 0; _i2 < this.objectsInfos.length; _i2++)
         {
            (this.objectsInfos[_i2] as ObjectItemMinimalInformation).serializeAs_ObjectItemMinimalInformation(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkNpcShopMessage(input);
      }
      
      public function deserializeAs_ExchangeStartOkNpcShopMessage(input:IDataInput) : void
      {
         var _item2:ObjectItemMinimalInformation = null;
         this.npcSellerId = input.readInt();
         var _objectsInfosLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _objectsInfosLen; _i2++)
         {
            _item2 = new ObjectItemMinimalInformation();
            _item2.deserialize(input);
            this.objectsInfos.push(_item2);
         }
      }
   }
}
