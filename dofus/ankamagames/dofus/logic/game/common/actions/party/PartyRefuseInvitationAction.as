package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyRefuseInvitationAction implements Action
   {
       
      public function PartyRefuseInvitationAction()
      {
         super();
      }
      
      public static function create() : PartyRefuseInvitationAction
      {
         var a:PartyRefuseInvitationAction = new PartyRefuseInvitationAction();
         return a;
      }
   }
}
