package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ObjectsAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6033;
       
      private var _isInitialized:Boolean = false;
      
      public var object:Vector.<ObjectItem>;
      
      public function ObjectsAddedMessage()
      {
         this.object = new Vector.<ObjectItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6033;
      }
      
      public function initObjectsAddedMessage(object:Vector.<ObjectItem> = null) : ObjectsAddedMessage
      {
         this.object = object;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.object = new Vector.<ObjectItem>();
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
         this.serializeAs_ObjectsAddedMessage(output);
      }
      
      public function serializeAs_ObjectsAddedMessage(output:IDataOutput) : void
      {
         output.writeShort(this.object.length);
         for(var _i1:uint = 0; _i1 < this.object.length; _i1++)
         {
            (this.object[_i1] as ObjectItem).serializeAs_ObjectItem(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectsAddedMessage(input);
      }
      
      public function deserializeAs_ObjectsAddedMessage(input:IDataInput) : void
      {
         var _item1:ObjectItem = null;
         var _objectLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _objectLen; _i1++)
         {
            _item1 = new ObjectItem();
            _item1.deserialize(input);
            this.object.push(_item1);
         }
      }
   }
}
