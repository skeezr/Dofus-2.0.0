package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameActionFightPassNextTurnsMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5529;
       
      private var _isInitialized:Boolean = false;
      
      public var targetId:int = 0;
      
      public var turnCount:uint = 0;
      
      public function GameActionFightPassNextTurnsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5529;
      }
      
      public function initGameActionFightPassNextTurnsMessage(actionId:uint = 0, sourceId:int = 0, targetId:int = 0, turnCount:uint = 0) : GameActionFightPassNextTurnsMessage
      {
         super.initAbstractGameActionMessage(actionId,sourceId);
         this.targetId = targetId;
         this.turnCount = turnCount;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.targetId = 0;
         this.turnCount = 0;
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
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameActionFightPassNextTurnsMessage(output);
      }
      
      public function serializeAs_GameActionFightPassNextTurnsMessage(output:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(output);
         output.writeInt(this.targetId);
         if(this.turnCount < 0)
         {
            throw new Error("Forbidden value (" + this.turnCount + ") on element turnCount.");
         }
         output.writeByte(this.turnCount);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameActionFightPassNextTurnsMessage(input);
      }
      
      public function deserializeAs_GameActionFightPassNextTurnsMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.targetId = input.readInt();
         this.turnCount = input.readByte();
         if(this.turnCount < 0)
         {
            throw new Error("Forbidden value (" + this.turnCount + ") on element of GameActionFightPassNextTurnsMessage.turnCount.");
         }
      }
   }
}
