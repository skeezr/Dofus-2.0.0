package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightSkipNextTurnStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _turnCount:uint;
      
      public function FightSkipNextTurnStep(fighterId:int, turnCount:uint)
      {
         super();
         this._fighterId = fighterId;
         this._turnCount = turnCount;
      }
      
      public function get stepType() : String
      {
         return "skipNextTurn";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SKIP_NEXT_TURN,[this._fighterId,this._turnCount]);
         executeCallbacks();
      }
   }
}
