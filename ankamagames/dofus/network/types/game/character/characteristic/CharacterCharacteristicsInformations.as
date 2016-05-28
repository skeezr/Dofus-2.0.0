package com.ankamagames.dofus.network.types.game.character.characteristic
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorExtendedAlignmentInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class CharacterCharacteristicsInformations implements INetworkType
   {
      
      public static const protocolId:uint = 8;
       
      public var experience:Number = 0;
      
      public var experienceLevelFloor:Number = 0;
      
      public var experienceNextLevelFloor:Number = 0;
      
      public var kamas:uint = 0;
      
      public var statsPoints:uint = 0;
      
      public var spellsPoints:uint = 0;
      
      public var alignmentInfos:ActorExtendedAlignmentInformations;
      
      public var lifePoints:uint = 0;
      
      public var maxLifePoints:uint = 0;
      
      public var energyPoints:uint = 0;
      
      public var maxEnergyPoints:uint = 0;
      
      public var actionPointsCurrent:uint = 0;
      
      public var movementPointsCurrent:uint = 0;
      
      public var initiative:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var prospecting:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var actionPoints:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var movementPoints:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var strength:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var vitality:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var wisdom:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var chance:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var agility:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var intelligence:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var range:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var summonableCreaturesBoost:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var reflect:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var criticalHit:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var criticalHitWeapon:uint = 0;
      
      public var criticalMiss:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var healBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var allDamagesBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var weaponDamagesBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var damagesBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var trapBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var trapBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var permanentDamagePercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var dodgePALostProbability:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var dodgePMLostProbability:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var neutralElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var earthElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var waterElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var airElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var fireElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var neutralElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var earthElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var waterElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var airElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var fireElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpNeutralElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpEarthElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpWaterElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpAirElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpFireElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpNeutralElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpEarthElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpWaterElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpAirElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var pvpFireElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
      
      public var spellModifications:Vector.<com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification>;
      
      public function CharacterCharacteristicsInformations()
      {
         this.alignmentInfos = new ActorExtendedAlignmentInformations();
         this.initiative = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.prospecting = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.actionPoints = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.movementPoints = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.strength = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.vitality = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.wisdom = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.chance = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.agility = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.intelligence = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.range = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.summonableCreaturesBoost = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.reflect = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.criticalHit = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.criticalMiss = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.healBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.allDamagesBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.weaponDamagesBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.damagesBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.trapBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.trapBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.permanentDamagePercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.dodgePALostProbability = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.dodgePMLostProbability = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.neutralElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.earthElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.waterElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.airElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.fireElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.neutralElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.earthElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.waterElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.airElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.fireElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpNeutralElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpEarthElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpWaterElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpAirElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpFireElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpNeutralElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpEarthElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpWaterElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpAirElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpFireElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.spellModifications = new Vector.<com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 8;
      }
      
      public function initCharacterCharacteristicsInformations(experience:Number = 0, experienceLevelFloor:Number = 0, experienceNextLevelFloor:Number = 0, kamas:uint = 0, statsPoints:uint = 0, spellsPoints:uint = 0, alignmentInfos:ActorExtendedAlignmentInformations = null, lifePoints:uint = 0, maxLifePoints:uint = 0, energyPoints:uint = 0, maxEnergyPoints:uint = 0, actionPointsCurrent:uint = 0, movementPointsCurrent:uint = 0, initiative:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, prospecting:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, actionPoints:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, movementPoints:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, strength:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, vitality:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, wisdom:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, chance:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, agility:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, intelligence:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, range:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, summonableCreaturesBoost:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, reflect:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, criticalHit:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, criticalHitWeapon:uint = 0, criticalMiss:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, healBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, allDamagesBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, weaponDamagesBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, damagesBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, trapBonus:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, trapBonusPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, permanentDamagePercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, dodgePALostProbability:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, dodgePMLostProbability:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, neutralElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, earthElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, waterElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, airElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, fireElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, neutralElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, earthElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, waterElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, airElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, fireElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpNeutralElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpEarthElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpWaterElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpAirElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpFireElementResistPercent:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpNeutralElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpEarthElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpWaterElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpAirElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, pvpFireElementReduction:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic = null, spellModifications:Vector.<com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification> = null) : CharacterCharacteristicsInformations
      {
         this.experience = experience;
         this.experienceLevelFloor = experienceLevelFloor;
         this.experienceNextLevelFloor = experienceNextLevelFloor;
         this.kamas = kamas;
         this.statsPoints = statsPoints;
         this.spellsPoints = spellsPoints;
         this.alignmentInfos = alignmentInfos;
         this.lifePoints = lifePoints;
         this.maxLifePoints = maxLifePoints;
         this.energyPoints = energyPoints;
         this.maxEnergyPoints = maxEnergyPoints;
         this.actionPointsCurrent = actionPointsCurrent;
         this.movementPointsCurrent = movementPointsCurrent;
         this.initiative = initiative;
         this.prospecting = prospecting;
         this.actionPoints = actionPoints;
         this.movementPoints = movementPoints;
         this.strength = strength;
         this.vitality = vitality;
         this.wisdom = wisdom;
         this.chance = chance;
         this.agility = agility;
         this.intelligence = intelligence;
         this.range = range;
         this.summonableCreaturesBoost = summonableCreaturesBoost;
         this.reflect = reflect;
         this.criticalHit = criticalHit;
         this.criticalHitWeapon = criticalHitWeapon;
         this.criticalMiss = criticalMiss;
         this.healBonus = healBonus;
         this.allDamagesBonus = allDamagesBonus;
         this.weaponDamagesBonusPercent = weaponDamagesBonusPercent;
         this.damagesBonusPercent = damagesBonusPercent;
         this.trapBonus = trapBonus;
         this.trapBonusPercent = trapBonusPercent;
         this.permanentDamagePercent = permanentDamagePercent;
         this.dodgePALostProbability = dodgePALostProbability;
         this.dodgePMLostProbability = dodgePMLostProbability;
         this.neutralElementResistPercent = neutralElementResistPercent;
         this.earthElementResistPercent = earthElementResistPercent;
         this.waterElementResistPercent = waterElementResistPercent;
         this.airElementResistPercent = airElementResistPercent;
         this.fireElementResistPercent = fireElementResistPercent;
         this.neutralElementReduction = neutralElementReduction;
         this.earthElementReduction = earthElementReduction;
         this.waterElementReduction = waterElementReduction;
         this.airElementReduction = airElementReduction;
         this.fireElementReduction = fireElementReduction;
         this.pvpNeutralElementResistPercent = pvpNeutralElementResistPercent;
         this.pvpEarthElementResistPercent = pvpEarthElementResistPercent;
         this.pvpWaterElementResistPercent = pvpWaterElementResistPercent;
         this.pvpAirElementResistPercent = pvpAirElementResistPercent;
         this.pvpFireElementResistPercent = pvpFireElementResistPercent;
         this.pvpNeutralElementReduction = pvpNeutralElementReduction;
         this.pvpEarthElementReduction = pvpEarthElementReduction;
         this.pvpWaterElementReduction = pvpWaterElementReduction;
         this.pvpAirElementReduction = pvpAirElementReduction;
         this.pvpFireElementReduction = pvpFireElementReduction;
         this.spellModifications = spellModifications;
         return this;
      }
      
      public function reset() : void
      {
         this.experience = 0;
         this.experienceLevelFloor = 0;
         this.experienceNextLevelFloor = 0;
         this.kamas = 0;
         this.statsPoints = 0;
         this.spellsPoints = 0;
         this.alignmentInfos = new ActorExtendedAlignmentInformations();
         this.maxLifePoints = 0;
         this.energyPoints = 0;
         this.maxEnergyPoints = 0;
         this.actionPointsCurrent = 0;
         this.movementPointsCurrent = 0;
         this.initiative = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.criticalMiss = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_CharacterCharacteristicsInformations(output);
      }
      
      public function serializeAs_CharacterCharacteristicsInformations(output:IDataOutput) : void
      {
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element experience.");
         }
         output.writeDouble(this.experience);
         if(this.experienceLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceLevelFloor + ") on element experienceLevelFloor.");
         }
         output.writeDouble(this.experienceLevelFloor);
         if(this.experienceNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceNextLevelFloor + ") on element experienceNextLevelFloor.");
         }
         output.writeDouble(this.experienceNextLevelFloor);
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element kamas.");
         }
         output.writeInt(this.kamas);
         if(this.statsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.statsPoints + ") on element statsPoints.");
         }
         output.writeInt(this.statsPoints);
         if(this.spellsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.spellsPoints + ") on element spellsPoints.");
         }
         output.writeInt(this.spellsPoints);
         this.alignmentInfos.serializeAs_ActorExtendedAlignmentInformations(output);
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element lifePoints.");
         }
         output.writeInt(this.lifePoints);
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element maxLifePoints.");
         }
         output.writeInt(this.maxLifePoints);
         if(this.energyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.energyPoints + ") on element energyPoints.");
         }
         output.writeShort(this.energyPoints);
         if(this.maxEnergyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxEnergyPoints + ") on element maxEnergyPoints.");
         }
         output.writeShort(this.maxEnergyPoints);
         if(this.actionPointsCurrent < 0)
         {
            throw new Error("Forbidden value (" + this.actionPointsCurrent + ") on element actionPointsCurrent.");
         }
         output.writeShort(this.actionPointsCurrent);
         if(this.movementPointsCurrent < 0)
         {
            throw new Error("Forbidden value (" + this.movementPointsCurrent + ") on element movementPointsCurrent.");
         }
         output.writeShort(this.movementPointsCurrent);
         this.initiative.serializeAs_CharacterBaseCharacteristic(output);
         this.prospecting.serializeAs_CharacterBaseCharacteristic(output);
         this.actionPoints.serializeAs_CharacterBaseCharacteristic(output);
         this.movementPoints.serializeAs_CharacterBaseCharacteristic(output);
         this.strength.serializeAs_CharacterBaseCharacteristic(output);
         this.vitality.serializeAs_CharacterBaseCharacteristic(output);
         this.wisdom.serializeAs_CharacterBaseCharacteristic(output);
         this.chance.serializeAs_CharacterBaseCharacteristic(output);
         this.agility.serializeAs_CharacterBaseCharacteristic(output);
         this.intelligence.serializeAs_CharacterBaseCharacteristic(output);
         this.range.serializeAs_CharacterBaseCharacteristic(output);
         this.summonableCreaturesBoost.serializeAs_CharacterBaseCharacteristic(output);
         this.reflect.serializeAs_CharacterBaseCharacteristic(output);
         this.criticalHit.serializeAs_CharacterBaseCharacteristic(output);
         if(this.criticalHitWeapon < 0)
         {
            throw new Error("Forbidden value (" + this.criticalHitWeapon + ") on element criticalHitWeapon.");
         }
         output.writeShort(this.criticalHitWeapon);
         this.criticalMiss.serializeAs_CharacterBaseCharacteristic(output);
         this.healBonus.serializeAs_CharacterBaseCharacteristic(output);
         this.allDamagesBonus.serializeAs_CharacterBaseCharacteristic(output);
         this.weaponDamagesBonusPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.damagesBonusPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.trapBonus.serializeAs_CharacterBaseCharacteristic(output);
         this.trapBonusPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.permanentDamagePercent.serializeAs_CharacterBaseCharacteristic(output);
         this.dodgePALostProbability.serializeAs_CharacterBaseCharacteristic(output);
         this.dodgePMLostProbability.serializeAs_CharacterBaseCharacteristic(output);
         this.neutralElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.earthElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.waterElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.airElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.fireElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.neutralElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.earthElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.waterElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.airElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.fireElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpNeutralElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpEarthElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpWaterElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpAirElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpFireElementResistPercent.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpNeutralElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpEarthElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpWaterElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpAirElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         this.pvpFireElementReduction.serializeAs_CharacterBaseCharacteristic(output);
         output.writeShort(this.spellModifications.length);
         for(var _i59:uint = 0; _i59 < this.spellModifications.length; _i59++)
         {
            (this.spellModifications[_i59] as com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification).serializeAs_CharacterSpellModification(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CharacterCharacteristicsInformations(input);
      }
      
      public function deserializeAs_CharacterCharacteristicsInformations(input:IDataInput) : void
      {
         var _item59:com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification = null;
         this.experience = input.readDouble();
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element of CharacterCharacteristicsInformations.experience.");
         }
         this.experienceLevelFloor = input.readDouble();
         if(this.experienceLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceLevelFloor + ") on element of CharacterCharacteristicsInformations.experienceLevelFloor.");
         }
         this.experienceNextLevelFloor = input.readDouble();
         if(this.experienceNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.experienceNextLevelFloor + ") on element of CharacterCharacteristicsInformations.experienceNextLevelFloor.");
         }
         this.kamas = input.readInt();
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element of CharacterCharacteristicsInformations.kamas.");
         }
         this.statsPoints = input.readInt();
         if(this.statsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.statsPoints + ") on element of CharacterCharacteristicsInformations.statsPoints.");
         }
         this.spellsPoints = input.readInt();
         if(this.spellsPoints < 0)
         {
            throw new Error("Forbidden value (" + this.spellsPoints + ") on element of CharacterCharacteristicsInformations.spellsPoints.");
         }
         this.alignmentInfos = new ActorExtendedAlignmentInformations();
         this.alignmentInfos.deserialize(input);
         this.lifePoints = input.readInt();
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element of CharacterCharacteristicsInformations.lifePoints.");
         }
         this.maxLifePoints = input.readInt();
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element of CharacterCharacteristicsInformations.maxLifePoints.");
         }
         this.energyPoints = input.readShort();
         if(this.energyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.energyPoints + ") on element of CharacterCharacteristicsInformations.energyPoints.");
         }
         this.maxEnergyPoints = input.readShort();
         if(this.maxEnergyPoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxEnergyPoints + ") on element of CharacterCharacteristicsInformations.maxEnergyPoints.");
         }
         this.actionPointsCurrent = input.readShort();
         if(this.actionPointsCurrent < 0)
         {
            throw new Error("Forbidden value (" + this.actionPointsCurrent + ") on element of CharacterCharacteristicsInformations.actionPointsCurrent.");
         }
         this.movementPointsCurrent = input.readShort();
         if(this.movementPointsCurrent < 0)
         {
            throw new Error("Forbidden value (" + this.movementPointsCurrent + ") on element of CharacterCharacteristicsInformations.movementPointsCurrent.");
         }
         this.initiative = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.initiative.deserialize(input);
         this.prospecting = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.prospecting.deserialize(input);
         this.actionPoints = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.actionPoints.deserialize(input);
         this.movementPoints = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.movementPoints.deserialize(input);
         this.strength = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.strength.deserialize(input);
         this.vitality = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.vitality.deserialize(input);
         this.wisdom = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.wisdom.deserialize(input);
         this.chance = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.chance.deserialize(input);
         this.agility = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.agility.deserialize(input);
         this.intelligence = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.intelligence.deserialize(input);
         this.range = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.range.deserialize(input);
         this.summonableCreaturesBoost = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.summonableCreaturesBoost.deserialize(input);
         this.reflect = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.reflect.deserialize(input);
         this.criticalHit = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.criticalHit.deserialize(input);
         this.criticalHitWeapon = input.readShort();
         if(this.criticalHitWeapon < 0)
         {
            throw new Error("Forbidden value (" + this.criticalHitWeapon + ") on element of CharacterCharacteristicsInformations.criticalHitWeapon.");
         }
         this.criticalMiss = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.criticalMiss.deserialize(input);
         this.healBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.healBonus.deserialize(input);
         this.allDamagesBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.allDamagesBonus.deserialize(input);
         this.weaponDamagesBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.weaponDamagesBonusPercent.deserialize(input);
         this.damagesBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.damagesBonusPercent.deserialize(input);
         this.trapBonus = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.trapBonus.deserialize(input);
         this.trapBonusPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.trapBonusPercent.deserialize(input);
         this.permanentDamagePercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.permanentDamagePercent.deserialize(input);
         this.dodgePALostProbability = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.dodgePALostProbability.deserialize(input);
         this.dodgePMLostProbability = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.dodgePMLostProbability.deserialize(input);
         this.neutralElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.neutralElementResistPercent.deserialize(input);
         this.earthElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.earthElementResistPercent.deserialize(input);
         this.waterElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.waterElementResistPercent.deserialize(input);
         this.airElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.airElementResistPercent.deserialize(input);
         this.fireElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.fireElementResistPercent.deserialize(input);
         this.neutralElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.neutralElementReduction.deserialize(input);
         this.earthElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.earthElementReduction.deserialize(input);
         this.waterElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.waterElementReduction.deserialize(input);
         this.airElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.airElementReduction.deserialize(input);
         this.fireElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.fireElementReduction.deserialize(input);
         this.pvpNeutralElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpNeutralElementResistPercent.deserialize(input);
         this.pvpEarthElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpEarthElementResistPercent.deserialize(input);
         this.pvpWaterElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpWaterElementResistPercent.deserialize(input);
         this.pvpAirElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpAirElementResistPercent.deserialize(input);
         this.pvpFireElementResistPercent = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpFireElementResistPercent.deserialize(input);
         this.pvpNeutralElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpNeutralElementReduction.deserialize(input);
         this.pvpEarthElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpEarthElementReduction.deserialize(input);
         this.pvpWaterElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpWaterElementReduction.deserialize(input);
         this.pvpAirElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpAirElementReduction.deserialize(input);
         this.pvpFireElementReduction = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic();
         this.pvpFireElementReduction.deserialize(input);
         var _spellModificationsLen:uint = input.readUnsignedShort();
         for(var _i59:uint = 0; _i59 < _spellModificationsLen; _i59++)
         {
            _item59 = new com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification();
            _item59.deserialize(input);
            this.spellModifications.push(_item59);
         }
      }
   }
}
