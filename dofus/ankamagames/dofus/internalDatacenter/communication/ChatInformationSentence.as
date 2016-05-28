package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.jerakine.data.I18n;
   
   public class ChatInformationSentence extends BasicChatSentence
   {
       
      private var _textKey:uint;
      
      private var _params:Array;
      
      public function ChatInformationSentence(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "", textKey:uint = 0, params:Array = null)
      {
         super(id,msg,channel,time,finger);
         this._textKey = textKey;
         this._params = params;
      }
      
      public function get textKey() : uint
      {
         return this._textKey;
      }
      
      public function get params() : Array
      {
         return this._params;
      }
      
      override public function get msg() : String
      {
         var text:String = I18n.getText(this._textKey,this._params);
         return text;
      }
   }
}
