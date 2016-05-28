package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameMapMovementRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 950;
       
      private var _isInitialized:Boolean = false;
      
      public var mapId:uint = 0;
      
      public var keyMovements:Vector.<uint>;
      
      public function GameMapMovementRequestMessage()
      {
         this.keyMovements = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 950;
      }
      
      public function initGameMapMovementRequestMessage(mapId:uint = 0, keyMovements:Vector.<uint> = null) : GameMapMovementRequestMessage
      {
         this.mapId = mapId;
         this.keyMovements = keyMovements;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mapId = 0;
         this.keyMovements = new Vector.<uint>();
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
         this.serializeAs_GameMapMovementRequestMessage(output);
      }
      
      public function serializeAs_GameMapMovementRequestMessage(output:IDataOutput) : void
      {
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
         output.writeShort(this.keyMovements.length);
         for(var _i2:uint = 0; _i2 < this.keyMovements.length; _i2++)
         {
            if(this.keyMovements[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.keyMovements[_i2] + ") on element 2 (starting at 1) of keyMovements.");
            }
            output.writeShort(this.keyMovements[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameMapMovementRequestMessage(input);
      }
      
      public function deserializeAs_GameMapMovementRequestMessage(input:IDataInput) : void
      {
         var _val2:uint = 0;
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of GameMapMovementRequestMessage.mapId.");
         }
         var _keyMovementsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _keyMovementsLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of keyMovements.");
            }
            this.keyMovements.push(_val2);
         }
      }
   }
}
