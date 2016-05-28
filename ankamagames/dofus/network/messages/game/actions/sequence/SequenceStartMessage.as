package com.ankamagames.dofus.network.messages.game.actions.sequence
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class SequenceStartMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 955;
       
      private var _isInitialized:Boolean = false;
      
      public var authorId:int = 0;
      
      public var sequenceType:int = 0;
      
      public function SequenceStartMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 955;
      }
      
      public function initSequenceStartMessage(authorId:int = 0, sequenceType:int = 0) : SequenceStartMessage
      {
         this.authorId = authorId;
         this.sequenceType = sequenceType;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.authorId = 0;
         this.sequenceType = 0;
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
         this.serializeAs_SequenceStartMessage(output);
      }
      
      public function serializeAs_SequenceStartMessage(output:IDataOutput) : void
      {
         output.writeInt(this.authorId);
         output.writeByte(this.sequenceType);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SequenceStartMessage(input);
      }
      
      public function deserializeAs_SequenceStartMessage(input:IDataInput) : void
      {
         this.authorId = input.readInt();
         this.sequenceType = input.readByte();
      }
   }
}
