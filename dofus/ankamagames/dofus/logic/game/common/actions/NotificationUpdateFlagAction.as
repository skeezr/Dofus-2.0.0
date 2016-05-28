package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NotificationUpdateFlagAction implements Action
   {
       
      private var _index:uint;
      
      public function NotificationUpdateFlagAction()
      {
         super();
      }
      
      public static function create(index:uint) : NotificationUpdateFlagAction
      {
         var action:NotificationUpdateFlagAction = new NotificationUpdateFlagAction();
         action._index = index;
         return action;
      }
      
      public function get index() : uint
      {
         return this._index;
      }
   }
}
