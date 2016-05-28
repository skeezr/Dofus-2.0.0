package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyShowMenuAction implements Action
   {
       
      public var playerId:uint;
      
      public function PartyShowMenuAction()
      {
         super();
      }
      
      public static function create(pPlayerId:uint) : PartyShowMenuAction
      {
         var a:PartyShowMenuAction = new PartyShowMenuAction();
         a.playerId = pPlayerId;
         return a;
      }
   }
}
