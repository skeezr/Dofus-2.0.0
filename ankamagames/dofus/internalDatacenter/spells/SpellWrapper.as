package com.ankamagames.dofus.internalDatacenter.spells
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.berilia.interfaces.IClonable;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.berilia.managers.SlotDataHolderManager;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public dynamic class SpellWrapper extends Proxy implements ISlotData, IClonable
   {
      
      private static var _cache:Array = new Array();
      
      private static var _playersCache:Array = new Array();
      
      private static var _errorIconUri:Uri;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellWrapper));
       
      private var _uri:Uri;
      
      private var _slotDataHolderManager:SlotDataHolderManager;
      
      private var _spellLevel:SpellLevel;
      
      public var position:uint;
      
      public var id:uint = 0;
      
      public var spellLevel:int;
      
      public var effects:Vector.<EffectInstance>;
      
      public var criticalEffect:Vector.<EffectInstance>;
      
      public var gfxId:int;
      
      public var playerId:int;
      
      private var _actualCooldown:uint = 0;
      
      public function SpellWrapper()
      {
         super();
      }
      
      public static function create(position:uint, spellID:uint, spellLevel:int, useCache:Boolean = true, playerId:int = 0) : SpellWrapper
      {
         var spell:SpellWrapper = null;
         var effectInstance:EffectInstance = null;
         if(useCache)
         {
            if(Boolean(_cache[spellID]) && !playerId)
            {
               spell = _cache[spellID];
            }
            else if(Boolean(_playersCache[playerId]) && Boolean(_playersCache[playerId][spellID]))
            {
               spell = _playersCache[playerId][spellID];
            }
         }
         if(!spell)
         {
            spell = new SpellWrapper();
            spell.id = spellID;
            if(useCache)
            {
               if(playerId)
               {
                  if(!_playersCache[playerId])
                  {
                     _playersCache[playerId] = new Array();
                  }
                  _playersCache[playerId][spellID] = spell;
               }
               else
               {
                  _cache[spellID] = spell;
               }
            }
            spell._slotDataHolderManager = new SlotDataHolderManager(spell);
         }
         spell.id = spellID;
         spell.gfxId = spellID;
         spell.position = position;
         spell.spellLevel = spellLevel;
         spell.playerId = playerId;
         spell.effects = new Vector.<EffectInstance>();
         spell.criticalEffect = new Vector.<EffectInstance>();
         spell._spellLevel = SpellLevel.getLevelById(Spell.getSpellById(spellID).spellLevels[spellLevel - 1]);
         for each(effectInstance in spell._spellLevel.effects)
         {
            effectInstance = effectInstance.clone();
            if(SpellsBoostsManager.getInstance().isBoostedHealingEffect(effectInstance.effectId))
            {
               effectInstance.modificator = SpellsBoostsManager.getInstance().getSpellModificator(SpellsBoostsManager.ACTION_BOOST_SPELL_HEAL,spellID);
            }
            else if(SpellsBoostsManager.getInstance().isBoostedDamagingEffect(effectInstance.effectId))
            {
               effectInstance.modificator = SpellsBoostsManager.getInstance().getSpellModificator(SpellsBoostsManager.ACTION_BOOST_SPELL_DMG,spellID);
            }
            spell.effects.push(effectInstance);
         }
         for each(effectInstance in spell._spellLevel.criticalEffect)
         {
            spell.criticalEffect.push(effectInstance.clone());
         }
         return spell;
      }
      
      public static function getSpellWrapperById(id:uint, playerID:int) : SpellWrapper
      {
         if(playerID != 0)
         {
            if(!_playersCache[playerID])
            {
               return null;
            }
            if(!_playersCache[playerID][id])
            {
               _playersCache[playerID][id] = _cache[id].clone();
            }
            return _playersCache[playerID][id];
         }
         return _cache[id];
      }
      
      restricted_namespace static function refreshAllPlayerSpellHolder(playerId:int) : void
      {
         var wrapper:SpellWrapper = null;
         for each(wrapper in _playersCache[playerId])
         {
            SpellWrapper(wrapper)._slotDataHolderManager.refreshAll();
         }
      }
      
      restricted_namespace static function resetAllCoolDown(playerId:int) : void
      {
         var wrapper:SpellWrapper = null;
         for each(wrapper in _playersCache[playerId])
         {
            SpellWrapper(wrapper).actualCooldown = 0;
         }
      }
      
      restricted_namespace static function removeAllSpellWrapperBut(playerId:int) : void
      {
         var id:* = null;
         for(id in _playersCache)
         {
            if(parseInt(id) != playerId)
            {
               delete _playersCache[id];
            }
         }
      }
      
      public function set actualCooldown(u:uint) : void
      {
         this._actualCooldown = u;
         this._slotDataHolderManager.refreshAll();
      }
      
      public function get actualCooldown() : uint
      {
         return !!PlayedCharacterManager.getInstance().isFighting?uint(this._actualCooldown):uint(0);
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/spells/all.swf|sort_").concat(this.id));
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/spells/all.swf|sort_").concat(this.id));
         }
         return this._uri;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat("error.png"));
         }
         return _errorIconUri;
      }
      
      public function get info1() : String
      {
         if(this.actualCooldown == 0 || !PlayedCharacterManager.getInstance().isFighting)
         {
            return null;
         }
         return this.actualCooldown.toString();
      }
      
      public function get active() : Boolean
      {
         if(!PlayedCharacterManager.getInstance().isFighting || this.playerId != PlayedCharacterManager.getInstance().id)
         {
            return true;
         }
         return PlayedCharacterManager.getInstance().canCastThisSpell(this.spellId,this.spellLevel);
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this.id);
      }
      
      public function get spellId() : uint
      {
         return this.spell.id;
      }
      
      public function get playerCriticalRate() : int
      {
         var characteristics:CharacterCharacteristicsInformations = null;
         var criticalHit:Object = null;
         var agility:Object = null;
         var criticalMiss:Object = null;
         var totalCriticalHit:int = 0;
         var totalAgility:int = 0;
         var totalCriticalMiss:int = 0;
         var baseCritik:int = 0;
         var critikPlusBonus:int = 0;
         var critikRate:int = 0;
         var currentCriticalHitProbability:Number = this.getCriticalHitProbability();
         if(Boolean(currentCriticalHitProbability) && PlayedCharacterApi.knowSpell(this.spell.id) >= 0)
         {
            characteristics = PlayedCharacterManager.getInstance().characteristics;
            if(characteristics)
            {
               criticalHit = characteristics.criticalHit;
               agility = characteristics.agility;
               criticalMiss = characteristics.criticalMiss;
               totalCriticalHit = criticalHit.alignGiftBonus + criticalHit.base + criticalHit.contextModif + criticalHit.objectsAndMountBonus;
               totalAgility = agility.alignGiftBonus + agility.base + agility.contextModif + agility.objectsAndMountBonus;
               totalCriticalMiss = criticalMiss.alignGiftBonus + criticalMiss.base + criticalMiss.contextModif + criticalMiss.objectsAndMountBonus;
               if(totalAgility < 0)
               {
                  totalAgility = 0;
               }
               baseCritik = currentCriticalHitProbability - totalCriticalHit;
               critikPlusBonus = int(baseCritik * Math.E * 1.1 / Math.log(totalAgility + 12));
               critikRate = Math.min(baseCritik,critikPlusBonus);
               if(critikRate < 2)
               {
                  critikRate = 2;
               }
               return critikRate;
            }
         }
         return 0;
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         return isAttribute(name);
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var modificator:int = 0;
         var nBaseValue:int = 0;
         var nValue:Number = NaN;
         if(isAttribute(name))
         {
            return this[name];
         }
         switch(name.toString())
         {
            case "id":
            case "nameId":
            case "descriptionId":
            case "typeId":
            case "scriptParams":
            case "scriptId":
            case "iconId":
            case "spellLevels":
            case "useParamCache":
            case "name":
            case "description":
               return Spell.getSpellById(this.id)[name];
            case "spellBreed":
            case "needFreeCell":
            case "criticalFailureEndsTurn":
            case "criticalFailureProbability":
            case "minPlayerLevel":
            case "minRange":
               return this._spellLevel[name.toString()];
            case "criticalHitProbability":
               return this.getCriticalHitProbability();
            case "maxCastPerTurn":
            case "range":
            case "maxCastPerTarget":
               modificator = SpellsBoostsManager.getInstance().getSpellModificatorByPropertyName(name.toString(),this.spellId);
               if(modificator > -1)
               {
                  return this._spellLevel[name.toString()] + modificator;
               }
               return this._spellLevel[name.toString()];
            case "castInLine":
            case "castTestLos":
               modificator = SpellsBoostsManager.getInstance().getSpellModificatorByPropertyName(name.toString(),this.spellId);
               if(modificator > 0)
               {
                  return false;
               }
               return this._spellLevel[name.toString()];
            case "rangeCanBeBoosted":
               modificator = SpellsBoostsManager.getInstance().getSpellModificatorByPropertyName(name.toString(),this.spellId);
               if(modificator > 0)
               {
                  return true;
               }
               return this._spellLevel[name.toString()];
            case "apCost":
               modificator = SpellsBoostsManager.getInstance().getSpellModificatorByPropertyName(name.toString(),this.spellId);
               if(modificator > -1)
               {
                  return this._spellLevel[name.toString()] - modificator;
               }
               return this._spellLevel[name.toString()];
            case "minCastInterval":
               modificator = SpellsBoostsManager.getInstance().getSpellModificator(SpellsBoostsManager.ACTION_BOOST_SPELL_CAST_INTVL,this.spellId);
               nBaseValue = SpellsBoostsManager.getInstance().getSpellModificator(SpellsBoostsManager.ACTION_BOOST_SPELL_SET_INTVL,this.spellId);
               nValue = nBaseValue > -1?Number(nBaseValue):Number(this._spellLevel.minCastInterval);
               if(modificator > -1)
               {
                  return nValue - modificator;
               }
               return nValue;
            case "isSpellWeapon":
               return this.id == 0;
            case "isDefaultSpellWeapon":
               return this.id == 0 && !PlayedCharacterManager.getInstance().currentWeapon;
            default:
               return;
         }
      }
      
      private function getCriticalHitProbability() : Number
      {
         var modificator:int = SpellsBoostsManager.getInstance().getSpellModificatorByPropertyName("criticalHitProbability",this.spellId);
         if(modificator > -1)
         {
            return this._spellLevel["criticalHitProbability"] > 0?Number(Math.max(this._spellLevel.criticalHitProbability - modificator,2)):Number(0);
         }
         return this._spellLevel["criticalHitProbability"];
      }
      
      public function clone() : *
      {
         var returnSpellWrapper:SpellWrapper = null;
         returnSpellWrapper = SpellWrapper.create(this.position,this.id,this.spellLevel);
         return returnSpellWrapper;
      }
      
      public function addHolder(h:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.addHolder(h);
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.removeHolder(h);
      }
   }
}
