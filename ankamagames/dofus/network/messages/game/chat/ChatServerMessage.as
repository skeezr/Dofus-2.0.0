package com.ankamagames.dofus.network.messages.game.chat
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ChatServerMessage extends ChatAbstractServerMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 881;
       
      private var _isInitialized:Boolean = false;
      
      public var senderId:int = 0;
      
      public var senderName:String = "";
      
      public function ChatServerMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 881;
      }
      
      public function initChatServerMessage(channel:uint = 0, content:String = "", timestamp:uint = 0, fingerprint:String = "", senderId:int = 0, senderName:String = "") : ChatServerMessage
      {
         super.initChatAbstractServerMessage(channel,content,timestamp,fingerprint);
         this.senderId = senderId;
         this.senderName = senderName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.senderId = 0;
         this.senderName = "";
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
         this.serializeAs_ChatServerMessage(output);
      }
      
      public function serializeAs_ChatServerMessage(output:IDataOutput) : void
      {
         super.serializeAs_ChatAbstractServerMessage(output);
         output.writeInt(this.senderId);
         output.writeUTF(this.senderName);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ChatServerMessage(input);
      }
      
      public function deserializeAs_ChatServerMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.senderId = input.readInt();
         this.senderName = input.readUTF();
      }
   }
}
