package com.ankamagames.dofus.network.messages.game.friend
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class FriendDeleteRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5603;
       
      private var _isInitialized:Boolean = false;
      
      public var name:String = "";
      
      public function FriendDeleteRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5603;
      }
      
      public function initFriendDeleteRequestMessage(name:String = "") : FriendDeleteRequestMessage
      {
         this.name = name;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.name = "";
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
         this.serializeAs_FriendDeleteRequestMessage(output);
      }
      
      public function serializeAs_FriendDeleteRequestMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.name);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendDeleteRequestMessage(input);
      }
      
      public function deserializeAs_FriendDeleteRequestMessage(input:IDataInput) : void
      {
         this.name = input.readUTF();
      }
   }
}
