package com.ankamagames.dofus.network.messages.game.context.roleplay.lockable
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class LockableCodeResultMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5672;
       
      private var _isInitialized:Boolean = false;
      
      public var success:Boolean = false;
      
      public function LockableCodeResultMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5672;
      }
      
      public function initLockableCodeResultMessage(success:Boolean = false) : LockableCodeResultMessage
      {
         this.success = success;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.success = false;
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
         this.serializeAs_LockableCodeResultMessage(output);
      }
      
      public function serializeAs_LockableCodeResultMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.success);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_LockableCodeResultMessage(input);
      }
      
      public function deserializeAs_LockableCodeResultMessage(input:IDataInput) : void
      {
         this.success = input.readBoolean();
      }
   }
}
