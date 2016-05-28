package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyAbdicateThroneAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyAbdicateThroneAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyAbdicateThroneAction
      {
         var a:PartyAbdicateThroneAction = new PartyAbdicateThroneAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
