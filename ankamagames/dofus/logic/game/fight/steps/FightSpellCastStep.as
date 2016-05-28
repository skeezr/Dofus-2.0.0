package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
   
   public class FightSpellCastStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _spellId:int;
      
      private var _spellRank:uint;
      
      private var _critical:uint;
      
      public function FightSpellCastStep(fighterId:int, spellId:int, spellRank:uint, critical:uint)
      {
         super();
         this._fighterId = fighterId;
         this._spellId = spellId;
         this._spellRank = spellRank;
         this._critical = critical;
      }
      
      public function get stepType() : String
      {
         return "spellCast";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_CASTED_SPELL,[this._fighterId,this._spellId,this._spellRank]);
         if(this._critical == FightSpellCastCriticalEnum.CRITICAL_HIT)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_DID_CRITICAL_HIT,[]);
         }
         else if(this._critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_DID_CRITICAL_MISS,[]);
         }
         executeCallbacks();
      }
   }
}
