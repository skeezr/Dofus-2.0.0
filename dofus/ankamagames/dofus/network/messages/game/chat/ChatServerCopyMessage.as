package com.ankamagames.dofus.network.messages.game.chat
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ChatServerCopyMessage extends ChatAbstractServerMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 882;
       
      private var _isInitialized:Boolean = false;
      
      public var receiverId:uint = 0;
      
      public var receiverName:String = "";
      
      public function ChatServerCopyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 882;
      }
      
      public function initChatServerCopyMessage(channel:uint = 0, content:String = "", timestamp:uint = 0, fingerprint:String = "", receiverId:uint = 0, receiverName:String = "") : ChatServerCopyMessage
      {
         super.initChatAbstractServerMessage(channel,content,timestamp,fingerprint);
         this.receiverId = receiverId;
         this.receiverName = receiverName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.receiverId = 0;
         this.receiverName = "";
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
         this.serializeAs_ChatServerCopyMessage(output);
      }
      
      public function serializeAs_ChatServerCopyMessage(output:IDataOutput) : void
      {
         super.serializeAs_ChatAbstractServerMessage(output);
         if(this.receiverId < 0)
         {
            throw new Error("Forbidden value (" + this.receiverId + ") on element receiverId.");
         }
         output.writeInt(this.receiverId);
         output.writeUTF(this.receiverName);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ChatServerCopyMessage(input);
      }
      
      public function deserializeAs_ChatServerCopyMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.receiverId = input.readInt();
         if(this.receiverId < 0)
         {
            throw new Error("Forbidden value (" + this.receiverId + ") on element of ChatServerCopyMessage.receiverId.");
         }
         this.receiverName = input.readUTF();
      }
   }
}
