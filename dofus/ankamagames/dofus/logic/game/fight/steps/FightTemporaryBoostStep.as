package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightTemporaryBoostStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _statName:String;
      
      private var _duration:String;
      
      public function FightTemporaryBoostStep(fighterId:int, statName:String, duration:String)
      {
         super();
         this._fighterId = fighterId;
         this._statName = statName;
         this._duration = duration;
      }
      
      public function get stepType() : String
      {
         return "temporaryBoost";
      }
      
      override public function start() : void
      {
         var text:* = "";
         text = text + this._statName;
         text = text + " (";
         text = text + this._duration;
         text = text + ")";
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_TEMPORARY_BOOSTED,[this._fighterId,text]);
         executeCallbacks();
      }
   }
}
