package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemQuantity;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ExchangeGuildTaxCollectorGetMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5762;
       
      private var _isInitialized:Boolean = false;
      
      public var collectorName:String = "";
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var mapId:uint = 0;
      
      public var userName:String = "";
      
      public var experience:Number = 0;
      
      public var objectsInfos:Vector.<ObjectItemQuantity>;
      
      public function ExchangeGuildTaxCollectorGetMessage()
      {
         this.objectsInfos = new Vector.<ObjectItemQuantity>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5762;
      }
      
      public function initExchangeGuildTaxCollectorGetMessage(collectorName:String = "", worldX:int = 0, worldY:int = 0, mapId:uint = 0, userName:String = "", experience:Number = 0, objectsInfos:Vector.<ObjectItemQuantity> = null) : ExchangeGuildTaxCollectorGetMessage
      {
         this.collectorName = collectorName;
         this.worldX = worldX;
         this.worldY = worldY;
         this.mapId = mapId;
         this.userName = userName;
         this.experience = experience;
         this.objectsInfos = objectsInfos;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.collectorName = "";
         this.worldX = 0;
         this.worldY = 0;
         this.mapId = 0;
         this.userName = "";
         this.experience = 0;
         this.objectsInfos = new Vector.<ObjectItemQuantity>();
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
         this.serializeAs_ExchangeGuildTaxCollectorGetMessage(output);
      }
      
      public function serializeAs_ExchangeGuildTaxCollectorGetMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.collectorName);
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         output.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         output.writeShort(this.worldY);
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
         output.writeUTF(this.userName);
         output.writeDouble(this.experience);
         output.writeShort(this.objectsInfos.length);
         for(var _i7:uint = 0; _i7 < this.objectsInfos.length; _i7++)
         {
            (this.objectsInfos[_i7] as ObjectItemQuantity).serializeAs_ObjectItemQuantity(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ExchangeGuildTaxCollectorGetMessage(input);
      }
      
      public function deserializeAs_ExchangeGuildTaxCollectorGetMessage(input:IDataInput) : void
      {
         var _item7:ObjectItemQuantity = null;
         this.collectorName = input.readUTF();
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of ExchangeGuildTaxCollectorGetMessage.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of ExchangeGuildTaxCollectorGetMessage.worldY.");
         }
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of ExchangeGuildTaxCollectorGetMessage.mapId.");
         }
         this.userName = input.readUTF();
         this.experience = input.readDouble();
         var _objectsInfosLen:uint = input.readUnsignedShort();
         for(var _i7:uint = 0; _i7 < _objectsInfosLen; _i7++)
         {
            _item7 = new ObjectItemQuantity();
            _item7.deserialize(input);
            this.objectsInfos.push(_item7);
         }
      }
   }
}
