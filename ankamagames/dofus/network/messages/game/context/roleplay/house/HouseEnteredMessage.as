package com.ankamagames.dofus.network.messages.game.context.roleplay.house
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HouseEnteredMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5860;
       
      private var _isInitialized:Boolean = false;
      
      public var ownerId:int = 0;
      
      public var ownerName:String = "";
      
      public var price:uint = 0;
      
      public var isLocked:Boolean = false;
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var modelId:uint = 0;
      
      public function HouseEnteredMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5860;
      }
      
      public function initHouseEnteredMessage(ownerId:int = 0, ownerName:String = "", price:uint = 0, isLocked:Boolean = false, worldX:int = 0, worldY:int = 0, modelId:uint = 0) : HouseEnteredMessage
      {
         this.ownerId = ownerId;
         this.ownerName = ownerName;
         this.price = price;
         this.isLocked = isLocked;
         this.worldX = worldX;
         this.worldY = worldY;
         this.modelId = modelId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.ownerId = 0;
         this.ownerName = "";
         this.price = 0;
         this.isLocked = false;
         this.worldX = 0;
         this.worldY = 0;
         this.modelId = 0;
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
         this.serializeAs_HouseEnteredMessage(output);
      }
      
      public function serializeAs_HouseEnteredMessage(output:IDataOutput) : void
      {
         output.writeInt(this.ownerId);
         output.writeUTF(this.ownerName);
         if(this.price < 0 || this.price > 4294967295)
         {
            throw new Error("Forbidden value (" + this.price + ") on element price.");
         }
         output.writeUnsignedInt(this.price);
         output.writeBoolean(this.isLocked);
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
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element modelId.");
         }
         output.writeShort(this.modelId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseEnteredMessage(input);
      }
      
      public function deserializeAs_HouseEnteredMessage(input:IDataInput) : void
      {
         this.ownerId = input.readInt();
         this.ownerName = input.readUTF();
         this.price = input.readUnsignedInt();
         if(this.price < 0 || this.price > 4294967295)
         {
            throw new Error("Forbidden value (" + this.price + ") on element of HouseEnteredMessage.price.");
         }
         this.isLocked = input.readBoolean();
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of HouseEnteredMessage.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of HouseEnteredMessage.worldY.");
         }
         this.modelId = input.readShort();
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element of HouseEnteredMessage.modelId.");
         }
      }
   }
}
