package com.ankamagames.dofus.network.messages.game.pvp
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class AlignmentAreaUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6060;
       
      private var _isInitialized:Boolean = false;
      
      public var areaId:uint = 0;
      
      public var side:int = 0;
      
      public function AlignmentAreaUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6060;
      }
      
      public function initAlignmentAreaUpdateMessage(areaId:uint = 0, side:int = 0) : AlignmentAreaUpdateMessage
      {
         this.areaId = areaId;
         this.side = side;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.areaId = 0;
         this.side = 0;
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
         this.serializeAs_AlignmentAreaUpdateMessage(output);
      }
      
      public function serializeAs_AlignmentAreaUpdateMessage(output:IDataOutput) : void
      {
         if(this.areaId < 0)
         {
            throw new Error("Forbidden value (" + this.areaId + ") on element areaId.");
         }
         output.writeShort(this.areaId);
         output.writeByte(this.side);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AlignmentAreaUpdateMessage(input);
      }
      
      public function deserializeAs_AlignmentAreaUpdateMessage(input:IDataInput) : void
      {
         this.areaId = input.readShort();
         if(this.areaId < 0)
         {
            throw new Error("Forbidden value (" + this.areaId + ") on element of AlignmentAreaUpdateMessage.areaId.");
         }
         this.side = input.readByte();
      }
   }
}
