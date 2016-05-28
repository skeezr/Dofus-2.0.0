package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.steps.abstract.AbstractStatContextualStep;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.managers.OptionManager;
   
   public class FightMovementPointsVariationStep extends AbstractStatContextualStep implements IFightStep
   {
      
      private static const COLOR:uint = 26112;
      
      private static const BLOCKING:Boolean = false;
       
      private var _intValue:int;
      
      private var _voluntarlyUsed:Boolean;
      
      public function FightMovementPointsVariationStep(entityId:int, value:int, voluntarlyUsed:Boolean)
      {
         super(COLOR,value.toString(),entityId,BLOCKING);
         this._intValue = value;
         this._voluntarlyUsed = voluntarlyUsed;
         _virtual = Boolean(this._voluntarlyUsed) && this._intValue < 0 && !OptionManager.getOptionManager("dofus").showUsedPaPm;
      }
      
      public function get stepType() : String
      {
         return "movementPointsVariation";
      }
      
      public function get value() : int
      {
         return this._intValue;
      }
      
      override public function start() : void
      {
         super.start();
         var fighterInfos:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_targetId) as GameFightFighterInformations;
         var temp:int = fighterInfos.stats.movementPoints;
         if(temp + this._intValue < 0)
         {
            fighterInfos.stats.movementPoints = 0;
         }
         else
         {
            fighterInfos.stats.movementPoints = fighterInfos.stats.movementPoints + this._intValue;
         }
         if(PlayedCharacterManager.getInstance().infos.id == _targetId)
         {
            PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent = fighterInfos.stats.movementPoints;
         }
         if(fighterInfos.disposition.cellId == -1)
         {
            super.executeCallbacks();
            return;
         }
         if(this._intValue > 0)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_MP_GAINED,[_targetId,Math.abs(this._intValue)]);
         }
         else if(this._intValue < 0)
         {
            if(this._voluntarlyUsed)
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_MP_USED,[_targetId,Math.abs(this._intValue)]);
            }
            else
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_MP_LOST,[_targetId,Math.abs(this._intValue)]);
            }
         }
      }
   }
}
