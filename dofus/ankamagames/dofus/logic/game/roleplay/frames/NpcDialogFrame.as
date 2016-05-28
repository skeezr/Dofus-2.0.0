package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogQuestionMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcDialogReplyAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogReplyMessage;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   
   public class NpcDialogFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(NpcDialogFrame));
       
      public function NpcDialogFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var ndcmsg:NpcDialogQuestionMessage = null;
         var ndra:NpcDialogReplyAction = null;
         var ndrmsg:NpcDialogReplyMessage = null;
         switch(true)
         {
            case msg is NpcDialogQuestionMessage:
               ndcmsg = msg as NpcDialogQuestionMessage;
               KernelEventsManager.getInstance().processCallback(HookList.NpcDialogQuestion,ndcmsg.messageId,ndcmsg.dialogParams,ndcmsg.visibleReplies);
               return true;
            case msg is NpcDialogReplyAction:
               ndra = msg as NpcDialogReplyAction;
               ndrmsg = new NpcDialogReplyMessage();
               ndrmsg.initNpcDialogReplyMessage(ndra.replyId);
               ConnectionsHandler.getConnection().send(ndrmsg);
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
