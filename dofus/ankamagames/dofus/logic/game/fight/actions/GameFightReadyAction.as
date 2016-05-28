package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameFightReadyAction implements Action
   {
       
      private var _isReady:Boolean;
      
      public function GameFightReadyAction()
      {
         super();
      }
      
      public static function create(isReady:Boolean) : GameFightReadyAction
      {
         var a:GameFightReadyAction = new GameFightReadyAction();
         a._isReady = isReady;
         return a;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
   }
}
