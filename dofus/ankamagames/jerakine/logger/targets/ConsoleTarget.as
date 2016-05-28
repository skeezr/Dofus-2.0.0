package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogLevel;
   import flash.utils.getTimer;
   import com.ankamagames.jerakine.console.ConsolesManager;
   
   public class ConsoleTarget extends AbstractTarget implements ConfigurableLoggingTarget
   {
      
      private static const CONSOLE_INIT_DELAY:uint = 200;
       
      private var _console:ConsoleHandler;
      
      private var _msgBuffer:Array;
      
      private var _delayingForConsole:Boolean;
      
      private var _consoleAvailableSince:uint;
      
      public var consoleId:String = "defaultConsole";
      
      public function ConsoleTarget()
      {
         super();
      }
      
      override public function logEvent(event:LogEvent) : void
      {
         var bufferedMsg:String = null;
         var text:String = "[" + LogLevel.getString(event.level) + "] " + event.message;
         if(this._consoleAvailableSince != 0 && this._consoleAvailableSince < getTimer())
         {
            if(this._msgBuffer != null && this._msgBuffer.length > 0)
            {
               for each(bufferedMsg in this._msgBuffer)
               {
                  this._console.output(bufferedMsg);
               }
               this._msgBuffer = null;
            }
            this._delayingForConsole = false;
            this._consoleAvailableSince = 0;
         }
         if(this._console == null || Boolean(this._delayingForConsole))
         {
            this._console = ConsolesManager.getConsole(this.consoleId);
            if(this._console != null && this._console.outputHandler != null && this._consoleAvailableSince == 0 && !this._delayingForConsole)
            {
               this._consoleAvailableSince = getTimer() + CONSOLE_INIT_DELAY;
               this._delayingForConsole = true;
            }
            if(this._msgBuffer == null)
            {
               this._msgBuffer = new Array();
            }
            this._msgBuffer.push(text);
            return;
         }
         this._console.output(text);
      }
      
      public function configure(config:XML) : void
      {
         if(config..console.@id != undefined)
         {
            this.consoleId = String(config..console.@id);
         }
      }
   }
}
