package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FriendSpouseFollowAction implements Action
   {
       
      private var _enable:Boolean;
      
      public function FriendSpouseFollowAction()
      {
         super();
      }
      
      public static function create(enable:Boolean) : FriendSpouseFollowAction
      {
         var a:FriendSpouseFollowAction = new FriendSpouseFollowAction();
         a._enable = enable;
         return a;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
