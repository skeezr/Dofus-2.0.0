package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.dofus.kernel.Kernel;
   
   public class WorkerStatusInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function WorkerStatusInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var i:uint = 0;
         var frame:Frame = null;
         switch(cmd)
         {
            case "workerstatus":
               console.output("Current worker status (" + Kernel.getWorker().framesList.length + " frames) :");
               i = 1;
               for each(frame in Kernel.getWorker().framesList)
               {
                  console.output("    " + i++ + ") " + frame + " (priority: " + frame.priority + ")");
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "workerstatus":
               return "Print the status of the Worker.";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
