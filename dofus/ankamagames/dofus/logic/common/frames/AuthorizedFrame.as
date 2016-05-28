package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.console.DebugConsoleInstructionRegistar;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.common.actions.AuthorizedCommandAction;
   import com.ankamagames.dofus.network.messages.authorized.ConsoleMessage;
   import com.ankamagames.jerakine.console.ConsoleOutputMessage;
   import com.ankamagames.dofus.network.messages.authorized.AdminCommandMessage;
   import com.ankamagames.jerakine.console.UnhandledConsoleInstructionError;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.ConnectionType;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class AuthorizedFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthorizedFrame));
       
      public function AuthorizedFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.LOW;
      }
      
      public function pushed() : Boolean
      {
         ConsolesManager.registerConsole("debug",new ConsoleHandler(Kernel.getWorker()),new DebugConsoleInstructionRegistar());
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var aca:AuthorizedCommandAction = null;
         var cmsg:ConsoleMessage = null;
         var comsg:ConsoleOutputMessage = null;
         var acmsg:AdminCommandMessage = null;
         switch(true)
         {
            case msg is AuthorizedCommandAction:
               aca = msg as AuthorizedCommandAction;
               if(aca.command.substr(0,1) == "/")
               {
                  try
                  {
                     ConsolesManager.getConsole("debug").process(ConsolesManager.getMessage(aca.command));
                  }
                  catch(ucie:UnhandledConsoleInstructionError)
                  {
                     ConsolesManager.getConsole("debug").output("Unknown command: " + aca.command + "\n");
                  }
               }
               else if(ConnectionsHandler.connectionType != ConnectionType.DISCONNECTED)
               {
                  acmsg = new AdminCommandMessage();
                  acmsg.initAdminCommandMessage(aca.command);
                  ConnectionsHandler.getConnection().send(acmsg);
               }
               else
               {
                  ConsolesManager.getConsole("debug").output("You are disconnected.");
               }
               return true;
            case msg is ConsoleMessage:
               cmsg = msg as ConsoleMessage;
               ConsolesManager.getConsole("debug").output(cmsg.content);
               return true;
            case msg is ConsoleOutputMessage:
               comsg = msg as ConsoleOutputMessage;
               if(comsg.consoleId != "debug")
               {
                  return false;
               }
               KernelEventsManager.getInstance().processCallback(HookList.ConsoleOutput,comsg.text);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
