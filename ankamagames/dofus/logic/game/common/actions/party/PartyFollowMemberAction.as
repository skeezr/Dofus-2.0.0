package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyFollowMemberAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyFollowMemberAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyFollowMemberAction
      {
         var a:PartyFollowMemberAction = new PartyFollowMemberAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
