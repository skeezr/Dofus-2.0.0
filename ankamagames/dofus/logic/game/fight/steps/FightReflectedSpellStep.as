package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightReflectedSpellStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      public function FightReflectedSpellStep(fighterId:int)
      {
         super();
         this._fighterId = fighterId;
      }
      
      public function get stepType() : String
      {
         return "reflectedSpell";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_REFLECTED_SPELL,[this._fighterId]);
         executeCallbacks();
      }
   }
}
