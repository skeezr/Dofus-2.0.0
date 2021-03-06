package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightInvisibleObstacleStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _spellLevelId:int;
      
      public function FightInvisibleObstacleStep(fighterId:int, spellLevelId:int)
      {
         super();
         this._fighterId = fighterId;
         this._spellLevelId = spellLevelId;
      }
      
      public function get stepType() : String
      {
         return "invisibleObstacle";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_INVISIBLE_OBSTACLE,[this._fighterId,this._spellLevelId]);
         executeCallbacks();
      }
   }
}
