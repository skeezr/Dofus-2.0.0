package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyStopFollowingMemberAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyStopFollowingMemberAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyStopFollowingMemberAction
      {
         var a:PartyStopFollowingMemberAction = new PartyStopFollowingMemberAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
