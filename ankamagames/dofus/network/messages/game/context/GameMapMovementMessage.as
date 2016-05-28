package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameMapMovementMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 951;
       
      private var _isInitialized:Boolean = false;
      
      public var actorId:int = 0;
      
      public var keyMovements:Vector.<uint>;
      
      public function GameMapMovementMessage()
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
         return 951;
      }
      
      public function initGameMapMovementMessage(actorId:int = 0, keyMovements:Vector.<uint> = null) : GameMapMovementMessage
      {
         this.actorId = actorId;
         this.keyMovements = keyMovements;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.actorId = 0;
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
         this.serializeAs_GameMapMovementMessage(output);
      }
      
      public function serializeAs_GameMapMovementMessage(output:IDataOutput) : void
      {
         output.writeInt(this.actorId);
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
         this.deserializeAs_GameMapMovementMessage(input);
      }
      
      public function deserializeAs_GameMapMovementMessage(input:IDataInput) : void
      {
         var _val2:uint = 0;
         this.actorId = input.readInt();
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
