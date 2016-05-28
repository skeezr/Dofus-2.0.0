package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatSmileyRequestAction implements Action
   {
       
      private var _smileyId:int;
      
      public function ChatSmileyRequestAction()
      {
         super();
      }
      
      public static function create(id:int) : ChatSmileyRequestAction
      {
         var a:ChatSmileyRequestAction = new ChatSmileyRequestAction();
         a._smileyId = id;
         return a;
      }
      
      public function get id() : int
      {
         return this._smileyId;
      }
   }
}
