package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyAllFollowMemberAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyAllFollowMemberAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyAllFollowMemberAction
      {
         var a:PartyAllFollowMemberAction = new PartyAllFollowMemberAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
