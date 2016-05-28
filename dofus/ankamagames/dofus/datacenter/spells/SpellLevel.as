package com.ankamagames.dofus.datacenter.spells
{
   import com.ankamagames.dofus.datacenter.common.BasicActionInfo;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.utils.display.spellZone.IZoneShape;
   import com.ankamagames.jerakine.utils.display.spellZone.ZoneEffect;
   
   public class SpellLevel extends BasicActionInfo implements ICellZoneProvider
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellLevel));
      
      private static const MODULE:String = "SpellLevels";
       
      public var id:uint;
      
      public var spellId:uint;
      
      public var spellBreed:uint;
      
      public var needFreeCell:Boolean;
      
      public var rangeCanBeBoosted:Boolean;
      
      public var maxCastPerTurn:uint;
      
      public var maxCastPerTarget:uint;
      
      public var minCastInterval:uint;
      
      public var minPlayerLevel:uint;
      
      public var criticalFailureEndsTurn:Boolean;
      
      public var statesRequired:Vector.<int>;
      
      public var statesForbidden:Vector.<int>;
      
      public var effects:Vector.<EffectInstance>;
      
      public var criticalEffect:Vector.<EffectInstance>;
      
      public function SpellLevel()
      {
         super();
      }
      
      public static function getLevelById(id:int) : SpellLevel
      {
         return GameData.getObject(MODULE,id) as SpellLevel;
      }
      
      public static function create(id:uint, spellId:uint, spellBreed:uint, apCost:uint, minRange:uint, range:uint, castInLine:Boolean, castTestLos:Boolean, criticalHitProbability:uint, criticalFailureProbability:uint, needFreeCell:Boolean, rangeCanBeBoosted:Boolean, maxCastPerTurn:uint, maxCastPerTarget:uint, minCastInterval:uint, minPlayerLevel:uint, criticalFailureEndsTurn:Boolean, statesRequired:Vector.<int>, statesForbidden:Vector.<int>, effects:Vector.<EffectInstance>, criticalEffect:Vector.<EffectInstance>) : SpellLevel
      {
         var o:SpellLevel = new SpellLevel();
         o.id = id;
         o.spellId = spellId;
         o.spellBreed = spellBreed;
         o.apCost = apCost;
         o.minRange = minRange;
         o.range = range;
         o.castInLine = castInLine;
         o.castTestLos = castTestLos;
         o.criticalHitProbability = criticalHitProbability;
         o.criticalFailureProbability = criticalFailureProbability;
         o.needFreeCell = needFreeCell;
         o.rangeCanBeBoosted = rangeCanBeBoosted;
         o.maxCastPerTurn = maxCastPerTurn;
         o.maxCastPerTarget = maxCastPerTarget;
         o.minCastInterval = minCastInterval;
         o.minPlayerLevel = minPlayerLevel;
         o.criticalFailureEndsTurn = criticalFailureEndsTurn;
         o.effects = effects;
         o.criticalEffect = criticalEffect;
         o.statesRequired = statesRequired;
         o.statesForbidden = statesForbidden;
         return o;
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this.spellId);
      }
      
      public function get minimalRange() : uint
      {
         return minRange;
      }
      
      public function set minimalRange(pMinRange:uint) : void
      {
         minRange = pMinRange;
      }
      
      public function get maximalRange() : uint
      {
         return range;
      }
      
      public function set maximalRange(pRange:uint) : void
      {
         minRange = pRange;
      }
      
      public function get castZoneInLine() : Boolean
      {
         return castInLine;
      }
      
      public function set castZoneInLine(pCastInLine:Boolean) : void
      {
         castInLine = pCastInLine;
      }
      
      public function get spellZoneEffects() : Vector.<IZoneShape>
      {
         var i:EffectInstance = null;
         var zone:ZoneEffect = null;
         var spellEffects:Vector.<IZoneShape> = new Vector.<IZoneShape>();
         for each(i in this.effects)
         {
            zone = new ZoneEffect(i.zoneSize,i.zoneShape);
            spellEffects.push(zone);
         }
         return spellEffects;
      }
      
      public function get canSummon() : Boolean
      {
         if(this.effects.length == 1 && (this.effects[0].effectId == 181 || this.effects[0].effectId == 180))
         {
            return true;
         }
         return false;
      }
   }
}
