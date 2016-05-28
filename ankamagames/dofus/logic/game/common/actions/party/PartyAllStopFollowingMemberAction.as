package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyAllStopFollowingMemberAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyAllStopFollowingMemberAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyAllStopFollowingMemberAction
      {
         var a:PartyAllStopFollowingMemberAction = new PartyAllStopFollowingMemberAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
