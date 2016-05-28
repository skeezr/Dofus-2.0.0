package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.logic.game.roleplay.types.FighterTooltipInformation;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.network.enums.FightTypeEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class FightApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function FightApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(FightApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getFighterInformations(fighterId:int) : Object
      {
         var fighterInfos:GameFightFighterInformations = this.getFighterInfos(fighterId);
         if(!fighterInfos)
         {
            return null;
         }
         var r:Object = new Object();
         r.fighterId = fighterId;
         r.look = EntityLookAdapter.fromNetwork(fighterInfos.look);
         r.isAlive = fighterInfos.alive;
         r.currentCell = fighterInfos.disposition.cellId;
         r.currentOrientation = fighterInfos.disposition.direction;
         r.team = this.getFighterTeam(fighterInfos);
         r.actionPoints = fighterInfos.stats.actionPoints;
         r.paDodge = fighterInfos.stats.dodgePALostProbability;
         r.pmDodge = fighterInfos.stats.dodgePMLostProbability;
         r.lifePoints = fighterInfos.stats.lifePoints;
         r.maxLifePoints = fighterInfos.stats.maxLifePoints;
         r.movementPoints = fighterInfos.stats.movementPoints;
         r.summoner = fighterInfos.stats.summoner;
         r.airResist = fighterInfos.stats.airElementResistPercent;
         r.earthResist = fighterInfos.stats.earthElementResistPercent;
         r.fireResist = fighterInfos.stats.fireElementResistPercent;
         r.neutralResist = fighterInfos.stats.neutralElementResistPercent;
         r.waterResist = fighterInfos.stats.waterElementResistPercent;
         return r;
      }
      
      [Untrusted]
      public function getFighterTooltipInfos(fighterId:int) : Object
      {
         var fighterInfos:GameFightFighterInformations = this.getFighterInfos(fighterId);
         if(!fighterInfos)
         {
            return null;
         }
         var fighterTooltipInfos:FighterTooltipInformation = new FighterTooltipInformation(fighterInfos);
         return fighterTooltipInfos;
      }
      
      [Untrusted]
      public function getFighterName(fighterId:int) : String
      {
         return this.getFightFrame().getFighterName(fighterId);
      }
      
      [Untrusted]
      public function getFighterLevel(fighterId:int) : uint
      {
         return this.getFightFrame().getFighterLevel(fighterId);
      }
      
      [Untrusted]
      public function getFighters() : Vector.<int>
      {
         return this.getFightFrame().battleFrame.fightersList;
      }
      
      [Untrusted]
      public function getDeadFighters() : Vector.<int>
      {
         return this.getFightFrame().battleFrame.deadFightersList;
      }
      
      [Untrusted]
      public function getBuffList(targetId:int) : Array
      {
         var buffItem:BasicBuff = null;
         var res:Array = new Array();
         var buffs:Array = BuffManager.getInstance().getAllBuff(targetId);
         for each(buffItem in buffs)
         {
            if(!res[BasicBuff(buffItem).castingSpell.castingSpellId])
            {
               res[BasicBuff(buffItem).castingSpell.castingSpellId] = new Array();
            }
            res[BasicBuff(buffItem).castingSpell.castingSpellId].push(buffItem);
         }
         res.sortOn("duration",Array.NUMERIC);
         return res;
      }
      
      [Untrusted]
      public function getBuffById(buffId:uint) : BasicBuff
      {
         return BuffManager.getInstance().getBuff(buffId);
      }
      
      [Untrusted]
      public function getCastingSpellBuffEffects(targetId:int, castingSpellId:uint) : EffectsWrapper
      {
         var spell:Spell = null;
         var buffItem:BasicBuff = null;
         var effects:EffectsWrapper = null;
         var res:Vector.<EffectInstance> = new Vector.<EffectInstance>();
         var buffs:Array = BuffManager.getInstance().getAllBuff(targetId);
         for each(buffItem in buffs)
         {
            if(buffItem.castingSpell.castingSpellId == castingSpellId)
            {
               res.push(buffItem.effects);
               if(!spell)
               {
                  spell = buffItem.castingSpell.spell;
               }
            }
         }
         effects = new EffectsWrapper(res,spell);
         return effects;
      }
      
      [Untrusted]
      public function getAllBuffEffects(targetId:int) : EffectsListWrapper
      {
         var buffItem:BasicBuff = null;
         var effectsList:EffectsListWrapper = null;
         var res:Vector.<EffectInstance> = new Vector.<EffectInstance>();
         var buffs:Array = BuffManager.getInstance().getAllBuff(targetId);
         if(!buffs || buffs.length == 0)
         {
            return null;
         }
         for each(buffItem in buffs)
         {
            res.push(buffItem.effects);
         }
         res.sort(function(x:EffectInstance, y:EffectInstance):Number
         {
            if(x.duration == y.duration)
            {
               return 0;
            }
            if(x.duration > y.duration)
            {
               return 1;
            }
            return -1;
         });
         effectsList = new EffectsListWrapper(res);
         return effectsList;
      }
      
      [Untrusted]
      public function isCastingSpell() : Boolean
      {
         return Kernel.getWorker().contains(FightSpellCastFrame);
      }
      
      [Untrusted]
      public function cancelSpell() : void
      {
         var frame:FightSpellCastFrame = null;
         if(Kernel.getWorker().contains(FightSpellCastFrame))
         {
            frame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
            Kernel.getWorker().removeFrame(frame);
         }
      }
      
      [Untrusted]
      public function getChallengeList() : Array
      {
         return this.getFightFrame().challengesList;
      }
      
      [Untrusted]
      public function preFightIsActive() : Boolean
      {
         return FightContextFrame.preFightIsActive;
      }
      
      [Untrusted]
      public function isWaitingBeforeFight() : Boolean
      {
         if(this.getFightFrame().fightType == FightTypeEnum.FIGHT_TYPE_PvMA || this.getFightFrame().fightType == FightTypeEnum.FIGHT_TYPE_PvT)
         {
            return true;
         }
         return false;
      }
      
      [Untrusted]
      public function isFightLeader() : Boolean
      {
         return this.getFightFrame().isFightLeader;
      }
      
      private function getFighterInfos(fighterId:int) : GameFightFighterInformations
      {
         return this.getFightFrame().entitiesFrame.getEntityInfos(fighterId) as GameFightFighterInformations;
      }
      
      private function getFightFrame() : FightContextFrame
      {
         return FightContextFrame.getInstance();
      }
      
      private function getFighterTeam(fighterInfos:GameFightFighterInformations) : String
      {
         switch(fighterInfos.teamId)
         {
            case TeamEnum.TEAM_CHALLENGER:
               return "challenger";
            case TeamEnum.TEAM_DEFENDER:
               return "defender";
            case TeamEnum.TEAM_SPECTATOR:
               return "spectator";
            default:
               this._log.warn("Unknown teamId " + fighterInfos.teamId + " ?!");
               return "unknown";
         }
      }
   }
}
