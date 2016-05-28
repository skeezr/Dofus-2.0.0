package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountToggleRidingRequestAction implements Action
   {
       
      public function MountToggleRidingRequestAction()
      {
         super();
      }
      
      public static function create() : MountToggleRidingRequestAction
      {
         return new MountToggleRidingRequestAction();
      }
   }
}
