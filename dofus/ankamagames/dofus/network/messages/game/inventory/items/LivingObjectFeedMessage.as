package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class LivingObjectFeedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5724;
       
      private var _isInitialized:Boolean = false;
      
      public var livingUID:uint = 0;
      
      public var livingPosition:uint = 0;
      
      public var foodUID:uint = 0;
      
      public function LivingObjectFeedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5724;
      }
      
      public function initLivingObjectFeedMessage(livingUID:uint = 0, livingPosition:uint = 0, foodUID:uint = 0) : LivingObjectFeedMessage
      {
         this.livingUID = livingUID;
         this.livingPosition = livingPosition;
         this.foodUID = foodUID;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.livingUID = 0;
         this.livingPosition = 0;
         this.foodUID = 0;
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
         this.serializeAs_LivingObjectFeedMessage(output);
      }
      
      public function serializeAs_LivingObjectFeedMessage(output:IDataOutput) : void
      {
         if(this.livingUID < 0)
         {
            throw new Error("Forbidden value (" + this.livingUID + ") on element livingUID.");
         }
         output.writeInt(this.livingUID);
         if(this.livingPosition < 0 || this.livingPosition > 255)
         {
            throw new Error("Forbidden value (" + this.livingPosition + ") on element livingPosition.");
         }
         output.writeByte(this.livingPosition);
         if(this.foodUID < 0)
         {
            throw new Error("Forbidden value (" + this.foodUID + ") on element foodUID.");
         }
         output.writeInt(this.foodUID);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_LivingObjectFeedMessage(input);
      }
      
      public function deserializeAs_LivingObjectFeedMessage(input:IDataInput) : void
      {
         this.livingUID = input.readInt();
         if(this.livingUID < 0)
         {
            throw new Error("Forbidden value (" + this.livingUID + ") on element of LivingObjectFeedMessage.livingUID.");
         }
         this.livingPosition = input.readUnsignedByte();
         if(this.livingPosition < 0 || this.livingPosition > 255)
         {
            throw new Error("Forbidden value (" + this.livingPosition + ") on element of LivingObjectFeedMessage.livingPosition.");
         }
         this.foodUID = input.readInt();
         if(this.foodUID < 0)
         {
            throw new Error("Forbidden value (" + this.foodUID + ") on element of LivingObjectFeedMessage.foodUID.");
         }
      }
   }
}
