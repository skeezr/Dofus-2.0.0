package com.ankamagames.dofus.datacenter.breeds
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Breed
   {
      
      private static const MODULE:String = "Breeds";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Breed));
       
      private var _breedSpells:Vector.<Spell> = null;
      
      public var id:int;
      
      public var shortNameId:uint;
      
      public var longNameId:uint;
      
      public var descriptionId:uint;
      
      public var gameplayDescriptionId:uint;
      
      public var maleLook:String;
      
      public var femaleLook:String;
      
      public var creatureBonesId:uint;
      
      public var maleArtwork:int;
      
      public var femaleArtwork:int;
      
      public var statsPointsForStrength:Array;
      
      public var statsPointsForIntelligence:Array;
      
      public var statsPointsForChance:Array;
      
      public var statsPointsForAgility:Array;
      
      public var statsPointsForVitality:Array;
      
      public var statsPointsForWisdom:Array;
      
      public var breedSpellsId:Vector.<uint>;
      
      public function Breed()
      {
         super();
      }
      
      public static function getBreedById(id:int) : Breed
      {
         return GameData.getObject(MODULE,id) as Breed;
      }
      
      public static function getBreeds() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, shortNameId:uint, longNameId:uint, descriptionId:uint, gameplayDescriptionId:uint, maleLook:String, femaleLook:String, creatureBonesId:uint, maleArtwork:int, femaleArtwork:int, statsPointsForStrength:String, statsPointsForIntelligence:String, statsPointsForChance:String, statsPointsForAgility:String, statsPointsForVitality:String, statsPointsForWisdom:String, breedSpellsId:Vector.<uint>) : Breed
      {
         var ia:* = undefined;
         var ic:* = undefined;
         var ii:* = undefined;
         var i:* = undefined;
         var iv:* = undefined;
         var iw:* = undefined;
         var o:Breed = new Breed();
         o.id = id;
         o.shortNameId = shortNameId;
         o.longNameId = longNameId;
         o.descriptionId = descriptionId;
         o.gameplayDescriptionId = gameplayDescriptionId;
         o.maleLook = maleLook;
         o.femaleLook = femaleLook;
         o.creatureBonesId = creatureBonesId;
         o.maleArtwork = maleArtwork;
         o.femaleArtwork = femaleArtwork;
         o.breedSpellsId = breedSpellsId;
         o.statsPointsForAgility = statsPointsForAgility.split("|");
         o.statsPointsForChance = statsPointsForChance.split("|");
         o.statsPointsForIntelligence = statsPointsForIntelligence.split("|");
         o.statsPointsForStrength = statsPointsForStrength.split("|");
         o.statsPointsForVitality = statsPointsForVitality.split("|");
         o.statsPointsForWisdom = statsPointsForWisdom.split("|");
         for(ia in o.statsPointsForAgility)
         {
            o.statsPointsForAgility[ia] = o.statsPointsForAgility[ia].toString().split(";");
         }
         for(ic in o.statsPointsForChance)
         {
            o.statsPointsForChance[ic] = o.statsPointsForChance[ic].toString().split(";");
         }
         for(ii in o.statsPointsForIntelligence)
         {
            o.statsPointsForIntelligence[ii] = o.statsPointsForIntelligence[ii].toString().split(";");
         }
         for(i in o.statsPointsForStrength)
         {
            o.statsPointsForStrength[i] = o.statsPointsForStrength[i].toString().split(";");
         }
         for(iv in o.statsPointsForVitality)
         {
            o.statsPointsForVitality[iv] = o.statsPointsForVitality[iv].toString().split(";");
         }
         for(iw in o.statsPointsForWisdom)
         {
            o.statsPointsForWisdom[iw] = o.statsPointsForWisdom[iw].toString().split(";");
         }
         return o;
      }
      
      public function get shortName() : String
      {
         return I18n.getText(this.shortNameId);
      }
      
      public function get longName() : String
      {
         return I18n.getText(this.longNameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
      
      public function get gameplayDescription() : String
      {
         return I18n.getText(this.gameplayDescriptionId);
      }
      
      public function get breedSpells() : Vector.<Spell>
      {
         var spellId:uint = 0;
         if(!this._breedSpells)
         {
            this._breedSpells = new Vector.<Spell>();
            for each(spellId in this.breedSpellsId)
            {
               this._breedSpells.push(Spell.getSpellById(spellId));
            }
         }
         return this._breedSpells;
      }
      
      public function getStatsPointsNeededForStrength(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForStrength)
         {
            if(stat < this.statsPointsForStrength[i][0])
            {
               return this.statsPointsForStrength[i - 1][1];
            }
         }
         return this.statsPointsForStrength[i][1];
      }
      
      public function getStatsPointsNeededForIntelligence(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForIntelligence)
         {
            if(stat < this.statsPointsForIntelligence[i][0])
            {
               return this.statsPointsForIntelligence[i - 1][1];
            }
         }
         return this.statsPointsForIntelligence[i][1];
      }
      
      public function getStatsPointsNeededForChance(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForChance)
         {
            if(stat < this.statsPointsForChance[i][0])
            {
               return this.statsPointsForChance[i - 1][1];
            }
         }
         return this.statsPointsForChance[i][1];
      }
      
      public function getStatsPointsNeededForAgility(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForAgility)
         {
            if(stat < this.statsPointsForAgility[i][0])
            {
               return this.statsPointsForAgility[i - 1][1];
            }
         }
         return this.statsPointsForAgility[i][1];
      }
      
      public function getStatsPointsNeededForVitality(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForVitality)
         {
            if(stat < this.statsPointsForVitality[i][0])
            {
               return this.statsPointsForVitality[i - 1][1];
            }
         }
         return this.statsPointsForVitality[i][1];
      }
      
      public function getStatsPointsNeededForWisdom(stat:uint) : uint
      {
         var i:* = undefined;
         for(i in this.statsPointsForWisdom)
         {
            if(stat < this.statsPointsForWisdom[i][0])
            {
               return this.statsPointsForWisdom[i - 1][1];
            }
         }
         return this.statsPointsForWisdom[i][1];
      }
   }
}
