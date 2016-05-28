package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class InteractiveMapUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5002;
       
      private var _isInitialized:Boolean = false;
      
      public var interactiveElements:Vector.<InteractiveElement>;
      
      public function InteractiveMapUpdateMessage()
      {
         this.interactiveElements = new Vector.<InteractiveElement>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5002;
      }
      
      public function initInteractiveMapUpdateMessage(interactiveElements:Vector.<InteractiveElement> = null) : InteractiveMapUpdateMessage
      {
         this.interactiveElements = interactiveElements;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.interactiveElements = new Vector.<InteractiveElement>();
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
         this.serializeAs_InteractiveMapUpdateMessage(output);
      }
      
      public function serializeAs_InteractiveMapUpdateMessage(output:IDataOutput) : void
      {
         output.writeShort(this.interactiveElements.length);
         for(var _i1:uint = 0; _i1 < this.interactiveElements.length; _i1++)
         {
            (this.interactiveElements[_i1] as InteractiveElement).serializeAs_InteractiveElement(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_InteractiveMapUpdateMessage(input);
      }
      
      public function deserializeAs_InteractiveMapUpdateMessage(input:IDataInput) : void
      {
         var _item1:InteractiveElement = null;
         var _interactiveElementsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _interactiveElementsLen; _i1++)
         {
            _item1 = new InteractiveElement();
            _item1.deserialize(input);
            this.interactiveElements.push(_item1);
         }
      }
   }
}
