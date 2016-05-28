package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   
   public class FightDispellStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      public function FightDispellStep(fighterId:int)
      {
         super();
         this._fighterId = fighterId;
      }
      
      public function get stepType() : String
      {
         return "dispell";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_GOT_DISPELLED,[this._fighterId]);
         BuffManager.getInstance().dispell(this._fighterId);
         executeCallbacks();
      }
   }
}
