package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyAcceptInvitationAction implements Action
   {
       
      public function PartyAcceptInvitationAction()
      {
         super();
      }
      
      public static function create() : PartyAcceptInvitationAction
      {
         var a:PartyAcceptInvitationAction = new PartyAcceptInvitationAction();
         return a;
      }
   }
}
