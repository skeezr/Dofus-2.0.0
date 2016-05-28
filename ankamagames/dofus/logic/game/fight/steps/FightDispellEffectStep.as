package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   
   public class FightDispellEffectStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _boostUID:int;
      
      public function FightDispellEffectStep(fighterId:int, boostUID:int)
      {
         super();
         this._fighterId = fighterId;
         this._boostUID = boostUID;
      }
      
      public function get stepType() : String
      {
         return "dispellEffect";
      }
      
      override public function start() : void
      {
         BuffManager.getInstance().dispellUniqueBuff(this._fighterId,this._boostUID,true,true);
         executeCallbacks();
      }
   }
}
