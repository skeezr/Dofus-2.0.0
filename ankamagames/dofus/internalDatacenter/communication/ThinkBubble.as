package com.ankamagames.dofus.internalDatacenter.communication
{
   public class ThinkBubble
   {
       
      private var _text:String;
      
      public function ThinkBubble(text:String)
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
