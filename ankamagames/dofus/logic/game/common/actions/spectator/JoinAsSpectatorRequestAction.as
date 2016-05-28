package com.ankamagames.dofus.logic.game.common.actions.spectator
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JoinAsSpectatorRequestAction implements Action
   {
       
      private var _fightId:uint;
      
      public function JoinAsSpectatorRequestAction()
      {
         super();
      }
      
      public static function create(fightId:uint) : JoinAsSpectatorRequestAction
      {
         var a:JoinAsSpectatorRequestAction = new JoinAsSpectatorRequestAction();
         a._fightId = fightId;
         return a;
      }
      
      public function get fightId() : uint
      {
         return this._fightId;
      }
   }
}
