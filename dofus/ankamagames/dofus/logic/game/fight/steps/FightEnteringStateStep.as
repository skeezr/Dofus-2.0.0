package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightEnteringStateStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _stateId:int;
      
      public function FightEnteringStateStep(fighterId:int, stateId:int)
      {
         super();
         this._fighterId = fighterId;
         this._stateId = stateId;
      }
      
      public function get stepType() : String
      {
         return "enteringState";
      }
      
      override public function start() : void
      {
         if(PlayedCharacterManager.getInstance().infos.id == this._fighterId)
         {
            if(!PlayedCharacterManager.getInstance().fightStates)
            {
               PlayedCharacterManager.getInstance().fightStates = new Array();
            }
            PlayedCharacterManager.getInstance().fightStates.push(this._stateId);
         }
         SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(this._fighterId);
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_ENTERING_STATE,[this._fighterId,this._stateId]);
         executeCallbacks();
      }
   }
}
