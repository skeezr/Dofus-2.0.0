package com.ankamagames.dofus.logic.game.common.actions.taxCollector
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameRolePlayTaxCollectorFightRequestAction implements Action
   {
       
      private var _taxCollectorId:uint;
      
      public function GameRolePlayTaxCollectorFightRequestAction()
      {
         super();
      }
      
      public static function create(pTaxCollectorId:uint) : GameRolePlayTaxCollectorFightRequestAction
      {
         var action:GameRolePlayTaxCollectorFightRequestAction = new GameRolePlayTaxCollectorFightRequestAction();
         action._taxCollectorId = pTaxCollectorId;
         return action;
      }
      
      public function get taxCollectorId() : uint
      {
         return this._taxCollectorId;
      }
   }
}
