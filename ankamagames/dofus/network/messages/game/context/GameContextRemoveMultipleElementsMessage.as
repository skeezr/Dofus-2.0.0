package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameContextRemoveMultipleElementsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 252;
       
      private var _isInitialized:Boolean = false;
      
      public var id:Vector.<int>;
      
      public function GameContextRemoveMultipleElementsMessage()
      {
         this.id = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 252;
      }
      
      public function initGameContextRemoveMultipleElementsMessage(id:Vector.<int> = null) : GameContextRemoveMultipleElementsMessage
      {
         this.id = id;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.id = new Vector.<int>();
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
         this.serializeAs_GameContextRemoveMultipleElementsMessage(output);
      }
      
      public function serializeAs_GameContextRemoveMultipleElementsMessage(output:IDataOutput) : void
      {
         output.writeShort(this.id.length);
         for(var _i1:uint = 0; _i1 < this.id.length; _i1++)
         {
            output.writeInt(this.id[_i1]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameContextRemoveMultipleElementsMessage(input);
      }
      
      public function deserializeAs_GameContextRemoveMultipleElementsMessage(input:IDataInput) : void
      {
         var _val1:int = 0;
         var _idLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _idLen; _i1++)
         {
            _val1 = input.readInt();
            this.id.push(_val1);
         }
      }
   }
}
