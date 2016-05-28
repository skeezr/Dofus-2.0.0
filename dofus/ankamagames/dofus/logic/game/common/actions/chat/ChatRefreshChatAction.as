package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatRefreshChatAction implements Action
   {
       
      private var _currentTab:uint;
      
      public function ChatRefreshChatAction()
      {
         super();
      }
      
      public static function create(currentTab:uint) : ChatRefreshChatAction
      {
         var a:ChatRefreshChatAction = new ChatRefreshChatAction();
         a._currentTab = currentTab;
         return a;
      }
      
      public function get currentTab() : uint
      {
         return this._currentTab;
      }
   }
}
