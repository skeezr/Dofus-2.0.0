package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogLevel;
   
   public class TraceTarget extends AbstractTarget
   {
       
      public function TraceTarget()
      {
         super();
      }
      
      override public function logEvent(event:LogEvent) : void
      {
         trace("[" + LogLevel.getString(event.level) + "] " + event.message);
      }
   }
}
