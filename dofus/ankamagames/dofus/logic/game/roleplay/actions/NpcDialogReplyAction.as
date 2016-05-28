package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NpcDialogReplyAction implements Action
   {
       
      private var _replyId:uint;
      
      public function NpcDialogReplyAction()
      {
         super();
      }
      
      public static function create(replyId:int) : NpcDialogReplyAction
      {
         var a:NpcDialogReplyAction = new NpcDialogReplyAction();
         a._replyId = replyId;
         return a;
      }
      
      public function get replyId() : uint
      {
         return this._replyId;
      }
   }
}
