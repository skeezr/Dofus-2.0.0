package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.steps.abstract.AbstractStatContextualStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightLifeVariationStep extends AbstractStatContextualStep implements IFightStep
   {
      
      private static const COLOR:uint = 16711680;
      
      private static const BLOCKING:Boolean = false;
       
      private var _intValue:int;
      
      public function FightLifeVariationStep(entityId:int, value:int)
      {
         super(COLOR,value.toString(),entityId,BLOCKING);
         this._intValue = value;
      }
      
      public function get stepType() : String
      {
         return "lifeVariation";
      }
      
      public function get value() : int
      {
         return this._intValue;
      }
      
      public function get target() : IEntity
      {
         return DofusEntities.getEntity(_targetId);
      }
      
      override public function start() : void
      {
         var permanentLifeLoss:int = 0;
         var pdp:CharacterBaseCharacteristic = null;
         var fighterInfos:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_targetId) as GameFightFighterInformations;
         if(!fighterInfos)
         {
            super.executeCallbacks();
            return;
         }
         var res:int = fighterInfos.stats.lifePoints + this._intValue;
         fighterInfos.stats.lifePoints = Math.max(0,res);
         if(this._intValue < 0)
         {
            pdp = PlayedCharacterManager.getInstance().characteristics.permanentDamagePercent;
            permanentLifeLoss = Math.ceil((pdp.alignGiftBonus + pdp.base + pdp.contextModif + pdp.objectsAndMountBonus) * this._intValue / 100);
            fighterInfos.stats.maxLifePoints = fighterInfos.stats.maxLifePoints + permanentLifeLoss;
         }
         if(PlayedCharacterManager.getInstance().infos.id == _targetId)
         {
            PlayedCharacterManager.getInstance().characteristics.lifePoints = fighterInfos.stats.lifePoints;
            if(this._intValue < 0)
            {
               PlayedCharacterManager.getInstance().characteristics.maxLifePoints = PlayedCharacterManager.getInstance().characteristics.maxLifePoints + permanentLifeLoss;
            }
         }
         if(this._intValue < 0)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LIFE_LOSS,[_targetId,Math.abs(this._intValue)]);
         }
         else if(this._intValue > 0)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LIFE_GAIN,[_targetId,Math.abs(this._intValue)]);
         }
         else
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_NO_CHANGE,[_targetId]);
         }
         super.start();
      }
   }
}
