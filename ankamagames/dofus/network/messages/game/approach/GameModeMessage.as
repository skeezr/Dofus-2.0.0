package com.ankamagames.dofus.network.messages.game.approach
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameModeMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6003;
       
      private var _isInitialized:Boolean = false;
      
      public var mode:uint = 1;
      
      public function GameModeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6003;
      }
      
      public function initGameModeMessage(mode:uint = 1) : GameModeMessage
      {
         this.mode = mode;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mode = 1;
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
         this.serializeAs_GameModeMessage(output);
      }
      
      public function serializeAs_GameModeMessage(output:IDataOutput) : void
      {
         output.writeByte(this.mode);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameModeMessage(input);
      }
      
      public function deserializeAs_GameModeMessage(input:IDataInput) : void
      {
         this.mode = input.readByte();
         if(this.mode < 0)
         {
            throw new Error("Forbidden value (" + this.mode + ") on element of GameModeMessage.mode.");
         }
      }
   }
}
