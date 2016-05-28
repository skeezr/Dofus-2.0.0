package com.ankamagames.dofus.datacenter.effects
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.dofus.types.enums.LanguageEnum;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.documents.Document;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   
   public class EffectInstance
   {
      
      private static const UNKNOWN_NAME:String = "???";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EffectInstance));
       
      public var effectId:uint;
      
      public var targetId:int;
      
      public var duration:int;
      
      public var param1;
      
      public var param2;
      
      public var param3;
      
      public var param4:String;
      
      public var random:int;
      
      public var modificator:int;
      
      private var _zoneSize:uint;
      
      private var _zoneShape:uint;
      
      public function EffectInstance()
      {
         super();
      }
      
      public static function create(effectId:uint, duration:int, param1:*, param2:*, param3:*, random:uint, zoneSize:uint, zoneShape:uint, targetId:int) : EffectInstance
      {
         var o:EffectInstance = new EffectInstance();
         o.effectId = effectId;
         o.duration = duration;
         o.param1 = param1;
         o.param2 = param2;
         o.param3 = param3;
         o.random = random;
         o.zoneSize = zoneSize;
         o.zoneShape = zoneShape;
         o.targetId = targetId;
         return o;
      }
      
      public function get zoneSize() : uint
      {
         return this._zoneSize;
      }
      
      public function set zoneSize(pZoneSize:uint) : void
      {
         this._zoneSize = pZoneSize;
      }
      
      public function set zoneShape(pZoneShape:uint) : void
      {
         this._zoneShape = pZoneShape;
      }
      
      public function get zoneShape() : uint
      {
         return this._zoneShape;
      }
      
      public function get durationString() : String
      {
         return this.getTurnCountStr(false);
      }
      
      public function get category() : int
      {
         var e:Object = Effect.getEffectById(this.effectId);
         return !!e?int(e.category):-1;
      }
      
      public function clone() : EffectInstance
      {
         var o:EffectInstance = new EffectInstance();
         o._zoneShape = this._zoneShape;
         o._zoneSize = this._zoneSize;
         o.effectId = this.effectId;
         o.duration = this.duration;
         o.param1 = this.param1;
         o.param2 = this.param2;
         o.param3 = this.param3;
         o.param4 = this.param4;
         o.random = this.random;
         o.targetId = this.targetId;
         return o;
      }
      
      public function get description() : String
      {
         var nYear:String = null;
         var nMonth:String = null;
         var nDay:String = null;
         var nHours:String = null;
         var nMinutes:String = null;
         var lang:String = null;
         var effect:Effect = Effect.getEffectById(this.effectId);
         if(!effect)
         {
            return null;
         }
         var sSourceDesc:String = effect.description;
         var aTmp:Array = [this.param1,this.param2,this.param3,this.param4];
         switch(effect.id)
         {
            case 10:
               aTmp[2] = this.getEmoticonName(this.param3);
               break;
            case 165:
               aTmp[0] = this.getItemTypeName(this.param1);
               break;
            case 197:
               aTmp[0] = this.getMonsterName(this.param1);
               break;
            case 281:
            case 282:
            case 283:
            case 284:
            case 285:
            case 286:
            case 287:
            case 288:
            case 289:
            case 290:
            case 291:
            case 292:
            case 293:
            case 294:
               aTmp[0] = this.getSpellName(this.param1);
               break;
            case 603:
            case 615:
               aTmp[2] = this.getJobName(this.param1);
               break;
            case 614:
               aTmp[0] = this.param2;
               aTmp[1] = this.getJobName(this.param3);
               break;
            case 604:
            case 616:
            case 624:
               aTmp[2] = this.getSpellName(this.param1);
               break;
            case 620:
               aTmp[2] = this.getDocumentTitle(this.param3);
               break;
            case 621:
            case 623:
            case 628:
               aTmp[2] = this.getMonsterName(this.param3);
               break;
            case 649:
            case 960:
               aTmp[2] = this.getAlignmentSideName(this.param3);
               break;
            case 699:
               aTmp[0] = this.getJobName(this.param1);
               break;
            case 706:
               aTmp[0] = aTmp[2];
               break;
            case 715:
               aTmp[0] = this.getMonsterSuperRaceName(this.param1);
               break;
            case 716:
               aTmp[0] = this.getMonsterRaceName(this.param1);
               break;
            case 717:
               aTmp[0] = this.getMonsterName(this.param1);
               break;
            case 724:
               aTmp[2] = this.getTitleName(this.param3);
               break;
            case 787:
               aTmp[0] = this.getSpellName(this.param1);
               break;
            case 806:
               if(this.param2 > 6)
               {
                  aTmp[0] = I18n.getText(I18nProxy.getKeyId("ui.petWeight.fat"),null,"%");
               }
               else if(this.param3 > 6)
               {
                  aTmp[0] = I18n.getText(I18nProxy.getKeyId("ui.petWeight.lean"),null,"%");
               }
               else
               {
                  aTmp[0] = I18n.getText(I18nProxy.getKeyId("ui.petWeight.nominal"),null,"%");
               }
               break;
            case 807:
               if(this.param3)
               {
                  aTmp[0] = this.getItemName(this.param3);
               }
               else
               {
                  aTmp[0] = I18n.getText(I18nProxy.getKeyId("ui.common.none"),null,"%");
               }
               break;
            case 814:
               aTmp[0] = this.getItemName(this.param1);
               break;
            case 905:
               aTmp[1] = this.getMonsterName(this.param2);
               break;
            case 939:
            case 940:
               aTmp[2] = this.getItemName(this.param3);
               break;
            case 950:
            case 951:
               aTmp[2] = this.getSpellStateName(this.param1);
               break;
            case 961:
            case 962:
               aTmp[2] = aTmp[0];
               break;
            case 805:
            case 808:
            case 983:
               this.param3 = this.param3 == undefined?0:this.param3;
               nYear = this.param1;
               nMonth = this.param2.substr(0,2);
               nDay = this.param2.substr(2,2);
               nHours = this.param3.substr(0,2);
               nMinutes = this.param3.substr(2,2);
               lang = XmlConfig.getInstance().getEntry("config.lang.current");
               switch(lang)
               {
                  case LanguageEnum.LANG_FR:
                     aTmp[0] = nDay + "/" + nMonth + "/" + nYear + " " + nHours + ":" + nMinutes;
                     break;
                  case LanguageEnum.LANG_EN:
                     aTmp[0] = nMonth + "/" + nDay + "/" + nYear + " " + nHours + ":" + nMinutes;
                     break;
                  default:
                     aTmp[0] = nMonth + "/" + nDay + "/" + nYear + " " + nHours + ":" + nMinutes;
               }
         }
         var sEffect:String = "";
         if(sSourceDesc == null)
         {
            return new String();
         }
         var sDescription:String = PatternDecoder.getDescription(sSourceDesc,aTmp);
         if(sDescription == null || sDescription == "")
         {
            return new String();
         }
         sEffect = sEffect + sDescription;
         if(this.modificator > 0 && Boolean(SpellsBoostsManager.getInstance().isBoostedHealingOrDamagingEffect(this.effectId)))
         {
            sEffect = sEffect + (" " + I18n.getText(I18nProxy.getKeyId("ui.effect.boosted.spell.complement"),[this.modificator],"%"));
         }
         if(this.random > 0)
         {
            sEffect = sEffect + (" " + I18n.getText(I18nProxy.getKeyId("ui.effect.randomProbability"),[this.random],"%"));
         }
         return sEffect;
      }
      
      private function getTurnCountStr(bShowLast:Boolean) : String
      {
         var sTmp:String = new String();
         var d:int = this.duration;
         if(isNaN(d))
         {
            return "";
         }
         if(d > -2)
         {
            if(d > 1)
            {
               return PatternDecoder.combine(I18n.getText(I18nProxy.getKeyId("ui.common.turn"),[d]),"n",false);
            }
            if(d == 0)
            {
               return "";
            }
            if(bShowLast)
            {
               return I18n.getText(I18nProxy.getKeyId("ui.common.lastTurn"));
            }
            return PatternDecoder.combine(I18n.getText(I18nProxy.getKeyId("ui.common.turn"),[d]),"n",true);
         }
         return I18n.getText(I18nProxy.getKeyId("ui.common.infinit"));
      }
      
      private function getEmoticonName(id:int) : String
      {
         var o:Emoticon = Emoticon.getEmoticonById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getItemTypeName(id:int) : String
      {
         var o:ItemType = ItemType.getItemTypeById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getMonsterName(id:int) : String
      {
         var o:Monster = Monster.getMonsterById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getSpellName(id:int) : String
      {
         var o:Spell = Spell.getSpellById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getJobName(id:int) : String
      {
         var o:Job = Job.getJobById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getDocumentTitle(id:int) : String
      {
         var o:Document = Document.getDocumentById(id);
         return !!o?o.title:UNKNOWN_NAME;
      }
      
      private function getAlignmentSideName(id:int) : String
      {
         var o:AlignmentSide = AlignmentSide.getAlignmentSideById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getItemName(id:int) : String
      {
         var o:Item = Item.getItemById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getMonsterSuperRaceName(id:int) : String
      {
         var o:MonsterSuperRace = MonsterSuperRace.getMonsterSuperRaceById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getMonsterRaceName(id:int) : String
      {
         var o:MonsterRace = MonsterRace.getMonsterRaceById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
      
      private function getTitleName(id:int) : String
      {
         return UNKNOWN_NAME;
      }
      
      private function getSpellStateName(id:int) : String
      {
         var o:SpellState = SpellState.getSpellStateById(id);
         return !!o?o.name:UNKNOWN_NAME;
      }
   }
}
