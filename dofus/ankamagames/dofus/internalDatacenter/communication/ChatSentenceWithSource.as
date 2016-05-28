package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class ChatSentenceWithSource extends BasicChatSentence
   {
       
      private var _senderId:uint;
      
      private var _senderName:String;
      
      private var _objects:Vector.<ItemWrapper>;
      
      public function ChatSentenceWithSource(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "", senderId:uint = 0, senderName:String = "", objects:Vector.<ItemWrapper> = null)
      {
         super(id,msg,channel,time,finger);
         this._senderId = senderId;
         this._senderName = senderName;
         this._objects = objects;
      }
      
      public function get senderId() : uint
      {
         return this._senderId;
      }
      
      public function get senderName() : String
      {
         return this._senderName;
      }
      
      public function get objects() : Vector.<ItemWrapper>
      {
         return this._objects;
      }
   }
}
