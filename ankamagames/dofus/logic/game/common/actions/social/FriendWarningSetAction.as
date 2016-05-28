package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FriendWarningSetAction implements Action
   {
       
      private var _enable:Boolean;
      
      public function FriendWarningSetAction()
      {
         super();
      }
      
      public static function create(enable:Boolean) : FriendWarningSetAction
      {
         var a:FriendWarningSetAction = new FriendWarningSetAction();
         a._enable = enable;
         return a;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
