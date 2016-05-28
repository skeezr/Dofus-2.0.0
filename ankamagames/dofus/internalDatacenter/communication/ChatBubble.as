package com.ankamagames.dofus.internalDatacenter.communication
{
   public class ChatBubble
   {
       
      private var _text:String;
      
      public function ChatBubble(text:String)
      {
         super();
         this._text = text;
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
