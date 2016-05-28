package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameContextKickAction implements Action
   {
       
      private var _targetId:uint;
      
      public function GameContextKickAction()
      {
         super();
      }
      
      public static function create(targetId:uint) : GameContextKickAction
      {
         var a:GameContextKickAction = new GameContextKickAction();
         a._targetId = targetId;
         return a;
      }
      
      public function get targetId() : uint
      {
         return this._targetId;
      }
   }
}
