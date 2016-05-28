package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class StatsUpgradeRequestAction implements Action
   {
       
      private var _statId:uint;
      
      private var _boostPoint:uint;
      
      public function StatsUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(statId:uint, boostPoint:uint) : StatsUpgradeRequestAction
      {
         var a:StatsUpgradeRequestAction = new StatsUpgradeRequestAction();
         a._statId = statId;
         a._boostPoint = boostPoint;
         return a;
      }
      
      public function get statId() : uint
      {
         return this._statId;
      }
      
      public function get boostPoint() : uint
      {
         return this._boostPoint;
      }
   }
}
