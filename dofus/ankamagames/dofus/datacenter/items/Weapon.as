package com.ankamagames.dofus.datacenter.items
{
   public class Weapon extends Item
   {
       
      public var apCost:int;
      
      public var minRange:int;
      
      public var range:int;
      
      public var castInLine:Boolean;
      
      public var castTestLos:Boolean;
      
      public var criticalHitProbability:int;
      
      public var criticalHitBonus:int;
      
      public var criticalFailureProbability:int;
      
      public function Weapon()
      {
         super();
      }
      
      public static function createWeapon(id:int, nameId:uint, typeId:uint, descriptionId:uint, iconId:uint, level:uint, weight:uint, cursed:Boolean, useAnimationId:int, usable:Boolean, targetable:Boolean, price:uint, twoHanded:Boolean, etheral:Boolean, itemSetId:int, criteria:String, appearanceId:uint, recipeIds:Vector.<uint>, apCost:int, minRange:int, range:int, castInLine:Boolean, castTestLos:Boolean, criticalHitProbability:int, criticalHitBonus:int, criticalFailureProbability:int) : Weapon
      {
         var o:Weapon = new Weapon();
         o.id = id;
         o.nameId = nameId;
         o.typeId = typeId;
         o.descriptionId = descriptionId;
         o.iconId = iconId;
         o.level = level;
         o.weight = weight;
         o.cursed = cursed;
         o.useAnimationId = useAnimationId;
         o.usable = usable;
         o.targetable = targetable;
         o.price = price;
         o.twoHanded = twoHanded;
         o.etheral = etheral;
         o.itemSetId = itemSetId;
         o.criteria = criteria;
         o.appearanceId = appearanceId;
         o.recipeIds = recipeIds;
         o.apCost = apCost;
         o.minRange = minRange;
         o.range = range;
         o.castInLine = castInLine;
         o.castTestLos = castTestLos;
         o.criticalHitProbability = criticalHitProbability;
         o.criticalHitBonus = criticalHitBonus;
         o.criticalFailureProbability = criticalFailureProbability;
         o.isWeapon = true;
         return o;
      }
   }
}
