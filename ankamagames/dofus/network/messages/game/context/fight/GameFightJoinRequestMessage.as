package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameFightJoinRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 701;
       
      private var _isInitialized:Boolean = false;
      
      public var fightId:int = 0;
      
      public var fighterId:int = 0;
      
      public function GameFightJoinRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 701;
      }
      
      public function initGameFightJoinRequestMessage(fightId:int = 0, fighterId:int = 0) : GameFightJoinRequestMessage
      {
         this.fightId = fightId;
         this.fighterId = fighterId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.fighterId = 0;
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
         this.serializeAs_GameFightJoinRequestMessage(output);
      }
      
      public function serializeAs_GameFightJoinRequestMessage(output:IDataOutput) : void
      {
         output.writeInt(this.fightId);
         output.writeInt(this.fighterId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightJoinRequestMessage(input);
      }
      
      public function deserializeAs_GameFightJoinRequestMessage(input:IDataInput) : void
      {
         this.fightId = input.readInt();
         this.fighterId = input.readInt();
      }
   }
}
