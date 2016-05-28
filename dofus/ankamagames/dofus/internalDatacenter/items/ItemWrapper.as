package com.ankamagames.dofus.internalDatacenter.items
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.misc.ObjectEffectAdapter;
   import com.ankamagames.jerakine.data.XmlConfig;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.utils.display.spellZone.IZoneShape;
   import com.ankamagames.jerakine.utils.display.spellZone.ZoneEffect;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.dofus.datacenter.livingObjects.LivingObjectSkinJntMood;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   use namespace flash_proxy;
   
   public dynamic class ItemWrapper extends Proxy implements ISlotData, ICellZoneProvider
   {
      
      public static const ITEM_TYPE_CERTIFICATE:uint = 97;
      
      public static const ITEM_TYPE_LIVING_OBJECT:uint = 113;
      
      public static const ACTION_ID_LIVING_OBJECT_FOOD_DATE:uint = 808;
      
      public static const ACTION_ID_LIVING_OBJECT_ID:uint = 970;
      
      public static const ACTION_ID_LIVING_OBJECT_MOOD:uint = 971;
      
      public static const ACTION_ID_LIVING_OBJECT_SKIN:uint = 972;
      
      public static const ACTION_ID_LIVING_OBJECT_CATEGORY:uint = 973;
      
      public static const ACTION_ID_LIVING_OBJECT_LEVEL:uint = 974;
      
      private static const LEVEL_STEP:Array = [0,10,21,33,46,60,75,91,108,126,145,165,186,208,231,255,280,306,333,361];
      
      private static var _cache:Array = new Array();
      
      private static var _errorIconUri:Uri;
      
      private static var _properties:Array;
       
      private var _uri:Uri;
      
      private var _pngMode:Boolean;
      
      public var position:uint = 63;
      
      public var objectUID:uint = 0;
      
      public var objectGID:uint = 0;
      
      public var quantity:uint = 0;
      
      public var effects:Vector.<EffectInstance>;
      
      public var effectsList:Vector.<ObjectEffect>;
      
      public var livingObjectId:uint;
      
      public var livingObjectMood:uint;
      
      public var livingObjectSkin:uint;
      
      public var livingObjectCategory:uint;
      
      public var livingObjectXp:uint;
      
      public var livingObjectLevel:uint;
      
      public var livingObjectFoodDate:String;
      
      public function ItemWrapper()
      {
         this.effects = new Vector.<EffectInstance>();
         super();
      }
      
      public static function create(position:uint, objectUID:uint, objectGID:uint, quantity:uint, newEffects:Vector.<ObjectEffect>, useCache:Boolean = true) : ItemWrapper
      {
         var item:ItemWrapper = null;
         var effect:ObjectEffect = null;
         var effectInstance:EffectInstance = null;
         if(!_cache[objectUID] || !useCache)
         {
            item = new ItemWrapper();
            item.objectUID = objectUID;
            if(useCache)
            {
               _cache[objectUID] = item;
            }
         }
         else
         {
            item = _cache[objectUID];
         }
         item.effectsList = newEffects;
         if(item.objectGID != objectGID)
         {
            item._uri = null;
         }
         item.position = position;
         item.objectGID = objectGID;
         item.quantity = quantity;
         var itbt:Item = Item.getItemById(objectGID);
         var shape:uint = 0;
         var ray:uint = 0;
         if(Boolean(itbt) && Boolean(itbt.isWeapon))
         {
            switch(itbt.typeId)
            {
               case 7:
                  shape = 88;
                  ray = 1;
                  break;
               case 4:
                  shape = 84;
                  ray = 1;
            }
         }
         item.livingObjectCategory = 0;
         item.effects = new Vector.<EffectInstance>();
         for each(effect in newEffects)
         {
            effectInstance = ObjectEffectAdapter.fromNetwork(effect);
            if(Boolean(shape) && effectInstance.category == 2)
            {
               effectInstance.zoneShape = shape;
               effectInstance.zoneSize = ray;
            }
            item.effects.push(effectInstance);
            item.updateLivingObjects(effectInstance);
         }
         return item;
      }
      
      public static function getItemFromUId(objectUID:uint) : ItemWrapper
      {
         return _cache[objectUID];
      }
      
      public function get iconUri() : Uri
      {
         return this.getIconUri(true);
      }
      
      public function get fullSizeIconUri() : Uri
      {
         return this.getIconUri(false);
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat("error.png"));
         }
         return _errorIconUri;
      }
      
      public function get livingObjectNextLevel() : int
      {
         if(this.livingObjectLevel >= LEVEL_STEP.length)
         {
            return -1;
         }
         return LEVEL_STEP[this.livingObjectLevel + 1];
      }
      
      public function get isLivingObject() : Boolean
      {
         return this.livingObjectCategory != 0;
      }
      
      public function get info1() : String
      {
         return this.quantity > 1?this.quantity.toString():null;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function set minimalRange(pMinRange:uint) : void
      {
      }
      
      public function get minimalRange() : uint
      {
         return this.getProperty("minRange");
      }
      
      public function set maximalRange(pRange:uint) : void
      {
      }
      
      public function get maximalRange() : uint
      {
         return this.getProperty("range");
      }
      
      public function set castZoneInLine(pCastInLine:Boolean) : void
      {
      }
      
      public function get castZoneInLine() : Boolean
      {
         return this.getProperty("castInLine");
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
      
      override flash_proxy function getProperty(name:*) : *
      {
         var l:* = undefined;
         var r:* = undefined;
         if(isAttribute(name))
         {
            return this[name];
         }
         l = Item.getItemById(this.objectGID);
         if(!l)
         {
            r = "";
         }
         try
         {
            return l[name];
         }
         catch(e:Error)
         {
            return "Error_on_item_" + name;
         }
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         var i:* = undefined;
         if(index == 0 && !_properties)
         {
            _properties = ["position","objectUID","objectGID","quantity","effects"];
            i = Item.getItemById(this.objectGID);
            _properties = _properties.concat(DescribeTypeCache.getVariables(i));
         }
         if(index < _properties.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return _properties[index - 1];
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         return isAttribute(name);
      }
      
      public function get isCertificate() : Boolean
      {
         var itbt:Item = Item.getItemById(this.objectGID);
         return Boolean(itbt) && itbt.typeId == ITEM_TYPE_CERTIFICATE;
      }
      
      public function update(position:uint, objectUID:uint, objectGID:uint, quantity:uint, updateEffects:Vector.<ObjectEffect>) : void
      {
         var effect:ObjectEffect = null;
         var effectInstance:EffectInstance = null;
         if(this.objectGID != objectGID || this.effectsList != updateEffects)
         {
            this._uri = null;
         }
         this.position = position;
         this.objectGID = objectGID;
         this.quantity = quantity;
         this.effectsList = updateEffects;
         this.effects = new Vector.<EffectInstance>();
         this.livingObjectCategory = 0;
         for each(effect in updateEffects)
         {
            effectInstance = ObjectEffectAdapter.fromNetwork(effect);
            this.effects.push(effectInstance);
            this.updateLivingObjects(effectInstance);
         }
      }
      
      public function getIconUri(pngMode:Boolean = true) : Uri
      {
         var item:Item = null;
         var iconId:String = null;
         var update:Boolean = false;
         if(this._uri)
         {
            if(pngMode != this._pngMode)
            {
               update = true;
            }
         }
         else
         {
            update = true;
         }
         if(update)
         {
            item = Item.getItemById(this.objectGID);
            if(this.isLivingObject)
            {
               iconId = LivingObjectSkinJntMood.getLivingObjectSkin(this.livingObjectCategory,this.livingObjectMood,this.livingObjectSkin).toString();
            }
            else
            {
               iconId = !!item?item.iconId.toString():"error_on_item_" + this.objectGID + ".png";
            }
            if(pngMode)
            {
               this._pngMode = true;
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat(iconId).concat(".png"));
            }
            else
            {
               this._pngMode = false;
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.vector").concat(iconId).concat(".swf"));
            }
         }
         return this._uri;
      }
      
      public function clone() : ItemWrapper
      {
         var item:ItemWrapper = new ItemWrapper();
         item.objectUID = this.objectUID;
         item.position = this.position;
         item.objectGID = this.objectGID;
         item.quantity = this.quantity;
         item.effects = this.effects;
         return item;
      }
      
      public function addHolder(h:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
      }
      
      private function updateLivingObjects(effect:EffectInstance) : void
      {
         switch(effect.effectId)
         {
            case ACTION_ID_LIVING_OBJECT_FOOD_DATE:
               this.livingObjectFoodDate = effect.description;
               break;
            case ACTION_ID_LIVING_OBJECT_ID:
               this.livingObjectId = effect.param3;
               break;
            case ACTION_ID_LIVING_OBJECT_MOOD:
               this.livingObjectMood = effect.param3;
               break;
            case ACTION_ID_LIVING_OBJECT_SKIN:
               this.livingObjectSkin = effect.param3;
               break;
            case ACTION_ID_LIVING_OBJECT_CATEGORY:
               this.livingObjectCategory = effect.param3;
               break;
            case ACTION_ID_LIVING_OBJECT_LEVEL:
               this.livingObjectXp = effect.param3;
               this.livingObjectLevel = this.getLivingObjectLevel(this.livingObjectXp);
         }
      }
      
      private function getLivingObjectLevel(xp:int) : uint
      {
         for(var i:int = 0; i < LEVEL_STEP.length; i++)
         {
            if(LEVEL_STEP[i] > xp)
            {
               return i--;
            }
         }
         return LEVEL_STEP.length;
      }
   }
}
