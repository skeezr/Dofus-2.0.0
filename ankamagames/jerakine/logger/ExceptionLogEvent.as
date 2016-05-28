package com.ankamagames.jerakine.logger
{
   public class ExceptionLogEvent extends LogEvent
   {
       
      public function ExceptionLogEvent(message:String)
      {
         super(null,message,1);
      }
   }
}
