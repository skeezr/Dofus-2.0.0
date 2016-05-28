package com.ankamagames.dofus.network.messages.game.friend
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class FriendWarnOnConnectionStateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5630;
       
      private var _isInitialized:Boolean = false;
      
      public var enable:Boolean = false;
      
      public function FriendWarnOnConnectionStateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5630;
      }
      
      public function initFriendWarnOnConnectionStateMessage(enable:Boolean = false) : FriendWarnOnConnectionStateMessage
      {
         this.enable = enable;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.enable = false;
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
         this.serializeAs_FriendWarnOnConnectionStateMessage(output);
      }
      
      public function serializeAs_FriendWarnOnConnectionStateMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.enable);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendWarnOnConnectionStateMessage(input);
      }
      
      public function deserializeAs_FriendWarnOnConnectionStateMessage(input:IDataInput) : void
      {
         this.enable = input.readBoolean();
      }
   }
}
