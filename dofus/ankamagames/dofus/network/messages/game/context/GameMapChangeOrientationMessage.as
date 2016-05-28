package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameMapChangeOrientationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 946;
       
      private var _isInitialized:Boolean = false;
      
      public var id:int = 0;
      
      public var direction:uint = 1;
      
      public function GameMapChangeOrientationMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 946;
      }
      
      public function initGameMapChangeOrientationMessage(id:int = 0, direction:uint = 1) : GameMapChangeOrientationMessage
      {
         this.id = id;
         this.direction = direction;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.id = 0;
         this.direction = 1;
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
         this.serializeAs_GameMapChangeOrientationMessage(output);
      }
      
      public function serializeAs_GameMapChangeOrientationMessage(output:IDataOutput) : void
      {
         output.writeInt(this.id);
         output.writeByte(this.direction);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameMapChangeOrientationMessage(input);
      }
      
      public function deserializeAs_GameMapChangeOrientationMessage(input:IDataInput) : void
      {
         this.id = input.readInt();
         this.direction = input.readByte();
         if(this.direction < 0)
         {
            throw new Error("Forbidden value (" + this.direction + ") on element of GameMapChangeOrientationMessage.direction.");
         }
      }
   }
}
