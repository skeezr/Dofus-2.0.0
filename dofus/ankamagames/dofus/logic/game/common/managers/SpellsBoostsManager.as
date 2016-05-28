package com.ankamagames.dofus.logic.game.common.managers
{
   public class SpellsBoostsManager
   {
      
      public static var ACTION_BOOST_SPELL_RANGE:uint = 281;
      
      public static var ACTION_BOOST_SPELL_RANGEABLE:uint = 282;
      
      public static var ACTION_BOOST_SPELL_DMG:uint = 283;
      
      public static var ACTION_BOOST_SPELL_HEAL:uint = 284;
      
      public static var ACTION_BOOST_SPELL_AP_COST:uint = 285;
      
      public static var ACTION_BOOST_SPELL_CAST_INTVL:uint = 286;
      
      public static var ACTION_BOOST_SPELL_CC:uint = 287;
      
      public static var ACTION_BOOST_SPELL_CASTOUTLINE:uint = 288;
      
      public static var ACTION_BOOST_SPELL_NOLINEOFSIGHT:uint = 289;
      
      public static var ACTION_BOOST_SPELL_MAXPERTURN:uint = 290;
      
      public static var ACTION_BOOST_SPELL_MAXPERTARGET:uint = 291;
      
      public static var ACTION_BOOST_SPELL_SET_INTVL:uint = 292;
      
      private static var _sSelf:com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager = null;
      
      private static var _aDamagingEffects:Array;
      
      private static var _aHealingEffects:Array;
      
      private static var _aBoostedEffects:Array;
       
      private var _oSpellsModificators:Object;
      
      private var _propertiesAssoc:Array;
      
      private var _actionsAssoc:Array;
      
      public function SpellsBoostsManager()
      {
         var id:* = null;
         var i:Number = NaN;
         this._propertiesAssoc = [];
         this._actionsAssoc = [];
         super();
         _sSelf = this;
         this.clear();
         this._actionsAssoc = new Array();
         this._actionsAssoc[ACTION_BOOST_SPELL_MAXPERTURN] = "maxCastPerTurn";
         this._actionsAssoc[ACTION_BOOST_SPELL_MAXPERTARGET] = "maxCastPerTarget";
         this._actionsAssoc[ACTION_BOOST_SPELL_CAST_INTVL] = "minCastInterval";
         this._actionsAssoc[ACTION_BOOST_SPELL_AP_COST] = "apCost";
         this._actionsAssoc[ACTION_BOOST_SPELL_RANGEABLE] = "rangeCanBeBoosted";
         this._actionsAssoc[ACTION_BOOST_SPELL_RANGE] = "range";
         this._actionsAssoc[ACTION_BOOST_SPELL_CASTOUTLINE] = "castInLine";
         this._actionsAssoc[ACTION_BOOST_SPELL_NOLINEOFSIGHT] = "castTestLos";
         this._actionsAssoc[ACTION_BOOST_SPELL_CC] = "criticalHitProbability";
         for(id in this._actionsAssoc)
         {
            this._propertiesAssoc[this._actionsAssoc[id]] = parseInt(id,10);
         }
         _aBoostedEffects = new Array();
         _aDamagingEffects = [100,95,97,92,98,93,96,91,99,94,80];
         _aHealingEffects = [108,81];
         for(i = 0; i < _aDamagingEffects.length; i++)
         {
            _aBoostedEffects.push(_aDamagingEffects[i]);
         }
         for(var j:Number = 0; j < _aHealingEffects.length; j++)
         {
            _aBoostedEffects.push(_aHealingEffects[j]);
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager
      {
         if(!_sSelf)
         {
            _sSelf = new com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager();
         }
         return _sSelf;
      }
      
      public function clear() : void
      {
         this._oSpellsModificators = new Object();
         _aBoostedEffects = [];
         _aDamagingEffects = [];
         _aHealingEffects = [];
      }
      
      public function getSpellModificatorByPropertyName(name:String, spellId:Number) : Number
      {
         return this.getSpellModificator(this.getTargetedActionIdByPropertyName(name),spellId);
      }
      
      public function getSpellModificator(actionId:Number, spellId:Number) : Number
      {
         if(!this._oSpellsModificators[actionId] || !this._oSpellsModificators[actionId][spellId])
         {
            return -1;
         }
         return Number(this._oSpellsModificators[actionId][spellId]);
      }
      
      public function getTargetedPropertyNameByActionId(actionId:uint) : String
      {
         return this._actionsAssoc[actionId];
      }
      
      public function getTargetedActionIdByPropertyName(name:String) : uint
      {
         return this._propertiesAssoc[name];
      }
      
      public function setSpellModificator(actionId:Number, spellId:Number, modificator:Number) : void
      {
         if(typeof this._oSpellsModificators[actionId] != "object" && this._oSpellsModificators[actionId] == undefined)
         {
            this._oSpellsModificators[actionId] = new Object();
         }
         this._oSpellsModificators[actionId][spellId] = modificator;
      }
      
      public function isBoostedDamagingEffect(effectId:Number) : Boolean
      {
         for(var i:Number = 0; i < _aDamagingEffects.length; i++)
         {
            if(_aDamagingEffects[i] == effectId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBoostedHealingEffect(effectId:Number) : Boolean
      {
         for(var i:Number = 0; i < _aHealingEffects.length; i++)
         {
            if(_aHealingEffects[i] == effectId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBoostedHealingOrDamagingEffect(effectId:Number) : Boolean
      {
         for(var i:Number = 0; i < _aBoostedEffects.length; i++)
         {
            if(_aBoostedEffects[i] == effectId)
            {
               return true;
            }
         }
         return false;
      }
   }
}
