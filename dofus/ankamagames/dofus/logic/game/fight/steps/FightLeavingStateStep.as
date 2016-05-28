package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightLeavingStateStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _stateId:int;
      
      public function FightLeavingStateStep(fighterId:int, stateId:int)
      {
         super();
         this._fighterId = fighterId;
         this._stateId = stateId;
      }
      
      public function get stepType() : String
      {
         return "leavingState";
      }
      
      override public function start() : void
      {
         var iState:* = undefined;
         if(PlayedCharacterManager.getInstance().infos.id == this._fighterId)
         {
            for(iState in PlayedCharacterManager.getInstance().fightStates)
            {
               if(PlayedCharacterManager.getInstance().fightStates[iState] == this._stateId)
               {
                  PlayedCharacterManager.getInstance().fightStates.splice(iState,1);
               }
            }
         }
         SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(this._fighterId);
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LEAVING_STATE,[this._fighterId,this._stateId]);
         executeCallbacks();
      }
   }
}
