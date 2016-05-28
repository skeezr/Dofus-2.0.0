package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PlayerFightRequestAction implements Action
   {
       
      private var _targetedPlayerId:uint;
      
      private var _firendly:Boolean;
      
      public function PlayerFightRequestAction()
      {
         super();
      }
      
      public static function create(targetedPlayerId:uint, friendly:Boolean = true) : PlayerFightRequestAction
      {
         var o:PlayerFightRequestAction = new PlayerFightRequestAction();
         o._firendly = friendly;
         o._targetedPlayerId = targetedPlayerId;
         return o;
      }
      
      public function get targetedPlayerId() : uint
      {
         return this._targetedPlayerId;
      }
      
      public function get firendly() : Boolean
      {
         return this._firendly;
      }
   }
}
