package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FriendOrGuildMemberWarningSetAction implements Action
   {
       
      private var _enable:Boolean;
      
      public function FriendOrGuildMemberWarningSetAction()
      {
         super();
      }
      
      public static function create(enable:Boolean) : FriendOrGuildMemberWarningSetAction
      {
         var a:FriendOrGuildMemberWarningSetAction = new FriendOrGuildMemberWarningSetAction();
         a._enable = enable;
         return a;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
