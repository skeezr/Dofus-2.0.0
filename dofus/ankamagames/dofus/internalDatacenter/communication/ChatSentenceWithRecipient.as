package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class ChatSentenceWithRecipient extends ChatSentenceWithSource
   {
       
      private var _receiverName:String;
      
      private var _receiverId:uint;
      
      public function ChatSentenceWithRecipient(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "", senderId:uint = 0, senderName:String = "", receiverName:String = "", receiverId:uint = 0, objects:Vector.<ItemWrapper> = null)
      {
         super(id,msg,channel,time,finger,senderId,senderName,objects);
         this._receiverName = receiverName;
         this._receiverId = receiverId;
      }
      
      public function get receiverName() : String
      {
         return this._receiverName;
      }
      
      public function get receiverId() : uint
      {
         return this._receiverId;
      }
   }
}
