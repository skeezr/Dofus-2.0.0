package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.datacenter.misc.Appearance;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   
   public class Item
   {
      
      private static const MODULE:String = "Items";
      
      private static const SUPERTYPE_NOT_EQUIPABLE:Array = [9,14,15,16,17,18,6,19,21,20,8,22];
      
      private static const FILTER_EQUIPEMENT:Array = [false,true,true,true,true,true,false,true,true,false,true,true,true,true,false,false,false,false,false,false,false,false,true];
      
      private static const FILTER_CONSUMABLES:Array = [false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
      
      private static const FILTER_RESSOURCES:Array = [false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false];
      
      private static const FILTER_QUEST:Array = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false];
      
      public static const EQUIPEMENT_CATEGORY:uint = 0;
      
      public static const CONSUMABLES_CATEGORY:uint = 1;
      
      public static const RESSOURCES_CATEGORY:uint = 2;
      
      public static const QUEST_CATEGORY:uint = 3;
      
      public static const OTHER_CATEGORY:uint = 4;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Item));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var typeId:uint;
      
      public var descriptionId:uint;
      
      public var iconId:uint;
      
      public var level:uint;
      
      public var weight:uint;
      
      public var cursed:Boolean;
      
      public var useAnimationId:int;
      
      public var usable:Boolean;
      
      public var targetable:Boolean;
      
      public var price:uint;
      
      public var twoHanded:Boolean;
      
      public var etheral:Boolean;
      
      public var itemSetId:int;
      
      public var criteria:String;
      
      public var isWeapon:Boolean = false;
      
      public var appearanceId:uint;
      
      public var recipeIds:Vector.<uint>;
      
      private var _recipes:Array;
      
      private var _conditions:Array;
      
      public function Item()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, typeId:uint, descriptionId:uint, iconId:uint, level:uint, weight:uint, cursed:Boolean, useAnimationId:int, usable:Boolean, targetable:Boolean, price:uint, twoHanded:Boolean, etheral:Boolean, itemSetId:int, criteria:String, appearanceId:uint, recipeIds:Vector.<uint>) : Item
      {
         var o:Item = new Item();
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
         return o;
      }
      
      public static function getItemById(id:uint) : Item
      {
         return GameData.getObject(MODULE,id) as Item;
      }
      
      public static function getItems() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
      
      public function get type() : ItemType
      {
         return ItemType.getItemTypeById(this.typeId);
      }
      
      public function get itemSet() : ItemSet
      {
         return ItemSet.getItemSetById(this.itemSetId);
      }
      
      public function get appearance() : TiphonEntityLook
      {
         var appearance:Appearance = Appearance.getAppearanceById(this.appearanceId);
         if(appearance)
         {
            return TiphonEntityLook.fromString(appearance.data);
         }
         return null;
      }
      
      public function get recipes() : Array
      {
         var numRecipes:int = 0;
         var i:int = 0;
         var recipe:Recipe = null;
         if(!this._recipes)
         {
            numRecipes = this.recipeIds.length;
            this._recipes = new Array();
            for(i = 0; i < numRecipes; i++)
            {
               recipe = Recipe.getRecipeByResultId(this.recipeIds[i]);
               if(recipe)
               {
                  this._recipes.push(recipe);
               }
            }
         }
         return this._recipes;
      }
      
      public function get category() : uint
      {
         switch(true)
         {
            case FILTER_EQUIPEMENT[this.type.superTypeId]:
               return EQUIPEMENT_CATEGORY;
            case FILTER_CONSUMABLES[this.type.superTypeId]:
               return CONSUMABLES_CATEGORY;
            case FILTER_RESSOURCES[this.type.superTypeId]:
               return RESSOURCES_CATEGORY;
            case FILTER_QUEST[this.type.superTypeId]:
               return QUEST_CATEGORY;
            default:
               return OTHER_CATEGORY;
         }
      }
      
      public function get isEquipable() : Boolean
      {
         return SUPERTYPE_NOT_EQUIPABLE[this.type.superTypeId];
      }
      
      public function get conditions() : Array
      {
         var aTmp4:Array = null;
         var k:uint = 0;
         var aTmp2:Array = null;
         var sOperator:String = null;
         var j:uint = 0;
         var sProperty:String = null;
         var bPropertyOvewritten:Boolean = false;
         var sValue:String = null;
         var bIsNot:* = false;
         var o:AlignmentSide = null;
         var aTmp5:Array = null;
         if(this._conditions)
         {
            return this._conditions;
         }
         var aOperators:Array = [">","<","=","!"];
         var sConditions:String = this.criteria;
         _log.debug("Conditions : \'" + sConditions + "\'");
         if(!sConditions || sConditions.length == 0)
         {
            return [];
         }
         var aTmp:Array = sConditions.split("&");
         var aTmp3:Array = new Array();
         for(var i:uint = 0; i < aTmp.length; i++)
         {
            aTmp[i] = aTmp[i].replace(["(",")"],["",""]);
            aTmp4 = aTmp[i].split("|");
            for(k = 0; k < aTmp4.length; k++)
            {
               for(j = 0; j < aOperators.length; j++)
               {
                  sOperator = aOperators[j];
                  aTmp2 = aTmp4[k].split(sOperator);
                  if(aTmp2.length > 1)
                  {
                     break;
                  }
                  aTmp2 = null;
                  sOperator = null;
               }
               if(aTmp2)
               {
                  sProperty = String(aTmp2[0]);
                  bPropertyOvewritten = false;
                  sValue = aTmp2[1];
                  if(sProperty == "PZ")
                  {
                     break;
                  }
                  switch(sProperty)
                  {
                     case "Ps":
                        o = AlignmentSide.getAlignmentSideById(int(sValue));
                        sValue = !!o?o.name:"???";
                        break;
                     case "PS":
                        break;
                     case "Pr":
                        break;
                     case "Pg":
                        break;
                     case "PG":
                        sValue = Breed.getBreedById(Number(sValue)).shortName;
                        break;
                     case "PJ":
                     case "Pj":
                        aTmp5 = sValue.split(",");
                        if(aTmp5.length == 2)
                        {
                           bPropertyOvewritten = true;
                           sProperty = Job.getJobById(aTmp5[0]).name;
                           sValue = !aTmp5[1]?"???":I18nProxy.getKey("ui.common.short.level") + " " + aTmp5[1];
                        }
                        else
                        {
                           sValue = Job.getJobById(aTmp5[0]).name;
                        }
                        break;
                     case "PM":
                        continue;
                     case "Sc":
                        continue;
                     case "PO":
                  }
                  if(!bPropertyOvewritten)
                  {
                     sProperty = StringUtils.replace(sProperty,["CS","Cs","CV","Cv","CA","Ca","CI","Ci","CW","Cw","CC","Cc","CA","PG","PJ","Pj","PM","PA","PN","PE","<NO>","PS","PR","PL","PK","Pg","Pr","Ps","Pa","PP","PZ","CM"],I18nProxy.getKey("ui.item.characteristics").split(","));
                  }
                  bIsNot = sOperator == "!";
                  sOperator = StringUtils.replace(sOperator,["!"],[I18nProxy.getKey("ui.item.no")]);
                  switch(sProperty)
                  {
                     case "BI":
                        aTmp3.push(I18nProxy.getKey("ui.common.unusable"));
                        continue;
                     case "PO":
                        if(bIsNot)
                        {
                           aTmp3.push(I18nProxy.getKey("ui.common.doNotPossess",[sValue]) + " <" + sOperator + ">");
                        }
                        else
                        {
                           aTmp3.push(I18nProxy.getKey("ui.common.doPossess",[sValue]) + " <" + sOperator + ">");
                        }
                        continue;
                     default:
                        aTmp3.push((k > 0?I18nProxy.getKey("ui.common.or") + " ":"") + sProperty + " " + sOperator + " " + sValue);
                        continue;
                  }
               }
            }
         }
         this._conditions = aTmp3;
         return aTmp3;
      }
   }
}
