package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameActionFightTackledMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1004;
       
      private var _isInitialized:Boolean = false;
      
      public function GameActionFightTackledMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 1004;
      }
      
      public function initGameActionFightTackledMessage(actionId:uint = 0, sourceId:int = 0) : GameActionFightTackledMessage
      {
         super.initAbstractGameActionMessage(actionId,sourceId);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
         this.serializeAs_GameActionFightTackledMessage(output);
      }
      
      public function serializeAs_GameActionFightTackledMessage(output:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameActionFightTackledMessage(input);
      }
      
      public function deserializeAs_GameActionFightTackledMessage(input:IDataInput) : void
      {
         super.deserialize(input);
      }
   }
}
