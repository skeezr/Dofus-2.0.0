package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyCancelInvitationAction implements Action
   {
       
      public function PartyCancelInvitationAction()
      {
         super();
      }
      
      public static function create() : PartyCancelInvitationAction
      {
         var a:PartyCancelInvitationAction = new PartyCancelInvitationAction();
         return a;
      }
   }
}
