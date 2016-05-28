package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.kernel.net.DisconnectionReason;
   import com.ankamagames.jerakine.network.messages.WrongSocketClosureReasonMessage;
   import com.ankamagames.jerakine.network.messages.UnexpectedSocketClosureMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.network.messages.ServerConnectionClosedMessage;
   
   public class DisconnectionHandlerFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DisconnectionHandlerFrame));
      
      public static var messagesAfterReset:Array = new Array();
       
      public function DisconnectionHandlerFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.LOWEST;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var reason:DisconnectionReason = null;
         var wscrmsg:WrongSocketClosureReasonMessage = null;
         var uscmsg:UnexpectedSocketClosureMessage = null;
         switch(true)
         {
            case msg is ServerConnectionClosedMessage:
               _log.trace("The connection was closed. Checking reasons.");
               reason = ConnectionsHandler.handleDisconnection();
               if(!reason.expected)
               {
                  _log.warn("The connection was closed unexpectedly. Reseting.");
                  if(messagesAfterReset.length == 0)
                  {
                     messagesAfterReset.unshift(new UnexpectedSocketClosureMessage());
                  }
                  Kernel.getInstance().reset();
               }
               else
               {
                  _log.trace("The connection closure was expected (reason: " + reason.reason + "). Dispatching the message.");
                  Kernel.getWorker().process(new ExpectedSocketClosureMessage(reason.reason));
               }
               return true;
            case msg is WrongSocketClosureReasonMessage:
               wscrmsg = msg as WrongSocketClosureReasonMessage;
               _log.error("Expecting socket closure for reason " + wscrmsg.expectedReason + ", got reason " + wscrmsg.gotReason + "! Reseting.");
               Kernel.getInstance().reset([new UnexpectedSocketClosureMessage()]);
               return true;
            case msg is UnexpectedSocketClosureMessage:
               uscmsg = msg as UnexpectedSocketClosureMessage;
               _log.debug("go hook UnexpectedSocketClosure");
               KernelEventsManager.getInstance().processCallback(HookList.UnexpectedSocketClosure);
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
