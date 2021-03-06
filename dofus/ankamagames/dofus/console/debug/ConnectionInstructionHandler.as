package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   
   public class ConnectionInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function ConnectionInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         switch(cmd)
         {
            case "connectionstatus":
               console.output("" + (!!ConnectionsHandler.getConnection()?ConnectionsHandler.getConnection():"There is currently no connection."));
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "connectionstatus":
               return "Print the status of the current connection (if any).";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
