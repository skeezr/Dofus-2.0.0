package com.ankamagames.jerakine.console
{
   public interface ConsoleInstructionHandler
   {
       
      function handle(param1:ConsoleHandler, param2:String, param3:Array) : void;
      
      function getHelp(param1:String) : String;
   }
}
