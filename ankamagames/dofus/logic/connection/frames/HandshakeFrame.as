package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.handshake.ProtocolRequired;
   import com.ankamagames.dofus.network.Metadata;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.PanicMessages;
   
   public class HandshakeFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HandshakeFrame));
       
      public function HandshakeFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var prmsg:ProtocolRequired = null;
         switch(true)
         {
            case msg is ProtocolRequired:
               prmsg = msg as ProtocolRequired;
               if(prmsg.requiredVersion > Metadata.PROTOCOL_BUILD)
               {
                  _log.fatal("Current protocol build is " + Metadata.PROTOCOL_BUILD + ", required build is " + prmsg.requiredVersion + ".");
                  Kernel.panic(PanicMessages.PROTOCOL_TOO_OLD,[Metadata.PROTOCOL_BUILD,prmsg.requiredVersion]);
               }
               if(prmsg.currentVersion < Metadata.PROTOCOL_REQUIRED_BUILD)
               {
                  _log.fatal("Current protocol build is " + Metadata.PROTOCOL_BUILD + " is too new for the server version (" + prmsg.currentVersion + ").");
               }
               Kernel.getWorker().removeFrame(this);
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
