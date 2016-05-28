package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameFightPlacementPossiblePositionsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 703;
       
      private var _isInitialized:Boolean = false;
      
      public var positionsForChallengers:Vector.<uint>;
      
      public var positionsForDefenders:Vector.<uint>;
      
      public var teamNumber:uint = 2;
      
      public function GameFightPlacementPossiblePositionsMessage()
      {
         this.positionsForChallengers = new Vector.<uint>();
         this.positionsForDefenders = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 703;
      }
      
      public function initGameFightPlacementPossiblePositionsMessage(positionsForChallengers:Vector.<uint> = null, positionsForDefenders:Vector.<uint> = null, teamNumber:uint = 2) : GameFightPlacementPossiblePositionsMessage
      {
         this.positionsForChallengers = positionsForChallengers;
         this.positionsForDefenders = positionsForDefenders;
         this.teamNumber = teamNumber;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.positionsForChallengers = new Vector.<uint>();
         this.positionsForDefenders = new Vector.<uint>();
         this.teamNumber = 2;
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
         this.serializeAs_GameFightPlacementPossiblePositionsMessage(output);
      }
      
      public function serializeAs_GameFightPlacementPossiblePositionsMessage(output:IDataOutput) : void
      {
         output.writeShort(this.positionsForChallengers.length);
         for(var _i1:uint = 0; _i1 < this.positionsForChallengers.length; _i1++)
         {
            if(this.positionsForChallengers[_i1] < 0 || this.positionsForChallengers[_i1] > 559)
            {
               throw new Error("Forbidden value (" + this.positionsForChallengers[_i1] + ") on element 1 (starting at 1) of positionsForChallengers.");
            }
            output.writeShort(this.positionsForChallengers[_i1]);
         }
         output.writeShort(this.positionsForDefenders.length);
         for(var _i2:uint = 0; _i2 < this.positionsForDefenders.length; _i2++)
         {
            if(this.positionsForDefenders[_i2] < 0 || this.positionsForDefenders[_i2] > 559)
            {
               throw new Error("Forbidden value (" + this.positionsForDefenders[_i2] + ") on element 2 (starting at 1) of positionsForDefenders.");
            }
            output.writeShort(this.positionsForDefenders[_i2]);
         }
         output.writeByte(this.teamNumber);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightPlacementPossiblePositionsMessage(input);
      }
      
      public function deserializeAs_GameFightPlacementPossiblePositionsMessage(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _val2:uint = 0;
         var _positionsForChallengersLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _positionsForChallengersLen; _i1++)
         {
            _val1 = input.readShort();
            if(_val1 < 0 || _val1 > 559)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of positionsForChallengers.");
            }
            this.positionsForChallengers.push(_val1);
         }
         var _positionsForDefendersLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _positionsForDefendersLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0 || _val2 > 559)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of positionsForDefenders.");
            }
            this.positionsForDefenders.push(_val2);
         }
         this.teamNumber = input.readByte();
         if(this.teamNumber < 0)
         {
            throw new Error("Forbidden value (" + this.teamNumber + ") on element of GameFightPlacementPossiblePositionsMessage.teamNumber.");
         }
      }
   }
}
