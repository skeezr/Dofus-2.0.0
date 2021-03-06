package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class StatedMapUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5716;
       
      private var _isInitialized:Boolean = false;
      
      public var statedElements:Vector.<StatedElement>;
      
      public function StatedMapUpdateMessage()
      {
         this.statedElements = new Vector.<StatedElement>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5716;
      }
      
      public function initStatedMapUpdateMessage(statedElements:Vector.<StatedElement> = null) : StatedMapUpdateMessage
      {
         this.statedElements = statedElements;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.statedElements = new Vector.<StatedElement>();
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
         this.serializeAs_StatedMapUpdateMessage(output);
      }
      
      public function serializeAs_StatedMapUpdateMessage(output:IDataOutput) : void
      {
         output.writeShort(this.statedElements.length);
         for(var _i1:uint = 0; _i1 < this.statedElements.length; _i1++)
         {
            (this.statedElements[_i1] as StatedElement).serializeAs_StatedElement(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_StatedMapUpdateMessage(input);
      }
      
      public function deserializeAs_StatedMapUpdateMessage(input:IDataInput) : void
      {
         var _item1:StatedElement = null;
         var _statedElementsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _statedElementsLen; _i1++)
         {
            _item1 = new StatedElement();
            _item1.deserialize(input);
            this.statedElements.push(_item1);
         }
      }
   }
}
