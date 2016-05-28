package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class ExchangeBidHouseInListAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5949;
       
      private var _isInitialized:Boolean = false;
      
      public var itemUID:int = 0;
      
      public var objGenericId:int = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var prices:Vector.<uint>;
      
      public function ExchangeBidHouseInListAddedMessage()
      {
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5949;
      }
      
      public function initExchangeBidHouseInListAddedMessage(itemUID:int = 0, objGenericId:int = 0, effects:Vector.<ObjectEffect> = null, prices:Vector.<uint> = null) : ExchangeBidHouseInListAddedMessage
      {
         this.itemUID = itemUID;
         this.objGenericId = objGenericId;
         this.effects = effects;
         this.prices = prices;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.itemUID = 0;
         this.objGenericId = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
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
         this.serializeAs_ExchangeBidHouseInListAddedMessage(output);
      }
      
      public function serializeAs_ExchangeBidHouseInListAddedMessage(output:IDataOutput) : void
      {
         output.writeInt(this.itemUID);
         output.writeInt(this.objGenericId);
         output.writeShort(this.effects.length);
         for(var _i3:uint = 0; _i3 < this.effects.length; _i3++)
         {
            output.writeShort((this.effects[_i3] as ObjectEffect).getTypeId());
            (this.effects[_i3] as ObjectEffect).serialize(output);
         }
         output.writeShort(this.prices.length);
         for(var _i4:uint = 0; _i4 < this.prices.length; _i4++)
         {
            if(this.prices[_i4] < 0)
            {
               throw new Error("Forbidden value (" + this.prices[_i4] + ") on element 4 (starting at 1) of prices.");
            }
            output.writeInt(this.prices[_i4]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeBidHouseInListAddedMessage(input);
      }
      
      public function deserializeAs_ExchangeBidHouseInListAddedMessage(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:ObjectEffect = null;
         var _val4:uint = 0;
         this.itemUID = input.readInt();
         this.objGenericId = input.readInt();
         var _effectsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _effectsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(ObjectEffect,_id3);
            _item3.deserialize(input);
            this.effects.push(_item3);
         }
         var _pricesLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _pricesLen; _i4++)
         {
            _val4 = input.readInt();
            if(_val4 < 0)
            {
               throw new Error("Forbidden value (" + _val4 + ") on elements of prices.");
            }
            this.prices.push(_val4);
         }
      }
   }
}
