package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import com.ankamagames.jerakine.data.I18n;
   
   public class MiscInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function MiscInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var log:Logger = null;
         var size:uint = 0;
         var emptySince:uint = 0;
         var i:uint = 0;
         var s:String = null;
         switch(cmd)
         {
            case "log":
               log = Log.getLogger(getQualifiedClassName(MiscInstructionHandler));
               log.enabled = args[0] == "true" || args[0] == "on";
               console.output("Log set to " + log.enabled);
               break;
            case "newdofus":
               NativeApplication.nativeApplication.dispatchEvent(new Event(InvokeEvent.INVOKE));
               break;
            case "i18nsize":
               size = 0;
               emptySince = 0;
               i = 1;
               s = "";
               do
               {
                  s = I18n.getText(i++);
                  if(s)
                  {
                     emptySince = 0;
                     size = size + s.length;
                  }
                  else
                  {
                     emptySince++;
                  }
               }
               while(emptySince < 20);
               
               console.output(size + " characters in " + (i - 1) + " entries.");
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "log":
               return "Switch on/off client log process.";
            case "i18nsize":
               return "Get the total size in characters of I18N datas.";
            case "newdofus":
               return "Try to launch a new dofus client.";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
