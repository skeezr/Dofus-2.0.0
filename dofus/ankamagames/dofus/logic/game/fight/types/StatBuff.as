package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   
   public class StatBuff extends BasicBuff
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StatBuff));
       
      private var _statName:String;
      
      private var _isABoost:Boolean;
      
      public function StatBuff(targetId:int, castingSpell:CastingSpell, actionId:uint, delta:int, duration:uint, statName:String, isABoost:Boolean)
      {
         super(targetId,castingSpell,actionId,delta,null,null,duration);
         this._statName = statName;
         this._isABoost = isABoost;
      }
      
      override public function get type() : String
      {
         return "StatBuff";
      }
      
      public function get statName() : String
      {
         return this._statName;
      }
      
      public function get delta() : int
      {
         return !!this._isABoost?int(_effect.param1):int(-_effect.param1);
      }
      
      override public function onApplyed() : void
      {
         var tempValue:int = 0;
         if(PlayedCharacterManager.getInstance().id == targetId)
         {
            if(PlayedCharacterManager.getInstance().characteristics.hasOwnProperty(this._statName))
            {
               CharacterBaseCharacteristic(PlayedCharacterManager.getInstance().characteristics[this._statName]).contextModif = CharacterBaseCharacteristic(PlayedCharacterManager.getInstance().characteristics[this._statName]).contextModif + this.delta;
               switch(this.statName)
               {
                  case "vitality":
                     tempValue = PlayedCharacterManager.getInstance().characteristics.maxLifePoints;
                     if(tempValue + this.delta < 0)
                     {
                        PlayedCharacterManager.getInstance().characteristics.maxLifePoints = 0;
                     }
                     else
                     {
                        PlayedCharacterManager.getInstance().characteristics.maxLifePoints = PlayedCharacterManager.getInstance().characteristics.maxLifePoints + this.delta;
                     }
                     tempValue = PlayedCharacterManager.getInstance().characteristics.lifePoints;
                     if(tempValue + this.delta < 0)
                     {
                        PlayedCharacterManager.getInstance().characteristics.lifePoints = 0;
                     }
                     else
                     {
                        PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.lifePoints + this.delta;
                     }
                     break;
                  case "lifePoints":
                     tempValue = PlayedCharacterManager.getInstance().characteristics.lifePoints;
                     if(tempValue + this.delta < 0)
                     {
                        PlayedCharacterManager.getInstance().characteristics.lifePoints = 0;
                     }
                     else
                     {
                        PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.lifePoints + this.delta;
                     }
                     break;
                  case "movementPoints":
                     tempValue = PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent;
                     if(tempValue + this.delta < 0)
                     {
                        PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent = 0;
                     }
                     else
                     {
                        PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent = PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent + this.delta;
                     }
                     break;
                  case "actionPoints":
                     tempValue = PlayedCharacterManager.getInstance().characteristics.actionPointsCurrent;
                     if(tempValue + this.delta < 0)
                     {
                        PlayedCharacterManager.getInstance().characteristics.actionPointsCurrent = 0;
                     }
                     else
                     {
                        PlayedCharacterManager.getInstance().characteristics.actionPointsCurrent = PlayedCharacterManager.getInstance().characteristics.actionPointsCurrent + this.delta;
                     }
               }
            }
            else
            {
               _log.warn(this._statName + " buff is not supported");
            }
         }
         switch(this.statName)
         {
            case "lifePoints":
            case "movementPoints":
            case "actionPoints":
               tempValue = BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName];
               if(tempValue + this.delta < 0)
               {
                  BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] = 0;
               }
               else
               {
                  BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] = BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] + this.delta;
               }
               break;
            default:
               if(BuffManager.getInstance().getFighterInfo(targetId).stats.hasOwnProperty(this._statName))
               {
                  BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] = BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] + this.delta;
               }
         }
      }
      
      override public function onRemoved() : void
      {
         if(PlayedCharacterManager.getInstance().id == targetId && Boolean(PlayedCharacterManager.getInstance().characteristics.hasOwnProperty(this._statName)))
         {
            CharacterBaseCharacteristic(PlayedCharacterManager.getInstance().characteristics[this._statName]).contextModif = CharacterBaseCharacteristic(PlayedCharacterManager.getInstance().characteristics[this._statName]).contextModif - this.delta;
         }
         if(BuffManager.getInstance().getFighterInfo(targetId).stats.hasOwnProperty(this._statName))
         {
            BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] = BuffManager.getInstance().getFighterInfo(targetId).stats[this._statName] - this.delta;
         }
      }
   }
}
