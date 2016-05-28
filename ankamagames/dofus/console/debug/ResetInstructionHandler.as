package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   
   public class ResetInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function ResetInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         switch(cmd)
         {
            case "reset":
               Kernel.getWorker().process(new ResetGameAction());
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "reset":
               return "Resets the Kernel and restart the game.";
            default:
               return "Unknown command \'" + cmd + "\'.";
         }
      }
   }
}
