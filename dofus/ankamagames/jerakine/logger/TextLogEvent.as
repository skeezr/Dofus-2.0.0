package com.ankamagames.jerakine.logger
{
   public class TextLogEvent extends LogEvent
   {
       
      public function TextLogEvent(category:String, message:String, logLevel:uint)
      {
         super(category,message,logLevel);
      }
   }
}
