package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyKickRequestAction implements Action
   {
       
      private var _playerId:uint;
      
      public function PartyKickRequestAction()
      {
         super();
      }
      
      public static function create(playerId:uint) : PartyKickRequestAction
      {
         var a:PartyKickRequestAction = new PartyKickRequestAction();
         a._playerId = playerId;
         return a;
      }
      
      public function get playerId() : uint
      {
         return this._playerId;
      }
   }
}
