package com.ankamagames.dofus.network.messages.game.context.roleplay.objects
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ObjectGroundListAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5925;
       
      private var _isInitialized:Boolean = false;
      
      public var cells:Vector.<uint>;
      
      public var referenceIds:Vector.<uint>;
      
      public function ObjectGroundListAddedMessage()
      {
         this.cells = new Vector.<uint>();
         this.referenceIds = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5925;
      }
      
      public function initObjectGroundListAddedMessage(cells:Vector.<uint> = null, referenceIds:Vector.<uint> = null) : ObjectGroundListAddedMessage
      {
         this.cells = cells;
         this.referenceIds = referenceIds;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cells = new Vector.<uint>();
         this.referenceIds = new Vector.<uint>();
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
         this.serializeAs_ObjectGroundListAddedMessage(output);
      }
      
      public function serializeAs_ObjectGroundListAddedMessage(output:IDataOutput) : void
      {
         output.writeShort(this.cells.length);
         for(var _i1:uint = 0; _i1 < this.cells.length; _i1++)
         {
            if(this.cells[_i1] < 0 || this.cells[_i1] > 559)
            {
               throw new Error("Forbidden value (" + this.cells[_i1] + ") on element 1 (starting at 1) of cells.");
            }
            output.writeShort(this.cells[_i1]);
         }
         output.writeShort(this.referenceIds.length);
         for(var _i2:uint = 0; _i2 < this.referenceIds.length; _i2++)
         {
            if(this.referenceIds[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.referenceIds[_i2] + ") on element 2 (starting at 1) of referenceIds.");
            }
            output.writeInt(this.referenceIds[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectGroundListAddedMessage(input);
      }
      
      public function deserializeAs_ObjectGroundListAddedMessage(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _val2:uint = 0;
         var _cellsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _cellsLen; _i1++)
         {
            _val1 = input.readShort();
            if(_val1 < 0 || _val1 > 559)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of cells.");
            }
            this.cells.push(_val1);
         }
         var _referenceIdsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _referenceIdsLen; _i2++)
         {
            _val2 = input.readInt();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of referenceIds.");
            }
            this.referenceIds.push(_val2);
         }
      }
   }
}
