package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyLeaveRequestAction implements Action
   {
       
      public function PartyLeaveRequestAction()
      {
         super();
      }
      
      public static function create() : PartyLeaveRequestAction
      {
         var a:PartyLeaveRequestAction = new PartyLeaveRequestAction();
         return a;
      }
   }
}
