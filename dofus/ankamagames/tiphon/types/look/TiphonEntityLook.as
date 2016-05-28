package com.ankamagames.tiphon.types.look
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.DefaultableColor;
   
   public class TiphonEntityLook implements EntityLookObserver
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonEntityLook));
       
      private var _observers:Dictionary;
      
      private var _locked:Boolean;
      
      private var _boneChangedWhileLocked:Boolean;
      
      private var _skinsChangedWhileLocked:Boolean;
      
      private var _colorsChangedWhileLocked:Boolean;
      
      private var _scalesChangedWhileLocked:Boolean;
      
      private var _subEntitiesChangedWhileLocked:Boolean;
      
      private var _bone:uint;
      
      private var _skins:Vector.<uint>;
      
      private var _colors:Array;
      
      private var _scaleX:Number = 1;
      
      private var _scaleY:Number = 1;
      
      private var _subEntities:Array;
      
      public function TiphonEntityLook()
      {
         super();
      }
      
      public static function fromString(str:String) : TiphonEntityLook
      {
         return EntityLookParser.fromString(str);
      }
      
      public function get skins() : Vector.<uint>
      {
         return this._skins;
      }
      
      public function getBone() : uint
      {
         return this._bone;
      }
      
      public function setBone(bone:uint) : void
      {
         var elo:* = null;
         if(this._bone == bone)
         {
            return;
         }
         this._bone = bone;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.boneChanged(this);
            }
         }
         else
         {
            this._boneChangedWhileLocked = true;
         }
      }
      
      public function getSkins(byRef:Boolean = false) : Vector.<uint>
      {
         if(!this._skins)
         {
            return null;
         }
         if(byRef)
         {
            return this._skins;
         }
         var skinsLength:uint = this._skins.length;
         var skinsDeepCopy:Vector.<uint> = new Vector.<uint>(skinsLength,true);
         for(var i:uint = 0; i < skinsLength; i++)
         {
            skinsDeepCopy[i] = this._skins[i];
         }
         return skinsDeepCopy;
      }
      
      public function resetSkins() : void
      {
         var elo:* = null;
         if(!this._skins || this._skins.length == 0)
         {
            return;
         }
         this._skins = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.skinsChanged(this);
            }
         }
         else
         {
            this._skinsChangedWhileLocked = true;
         }
      }
      
      public function addSkin(skin:uint) : void
      {
         var elo:* = null;
         if(!this._skins)
         {
            this._skins = new Vector.<uint>(0,false);
         }
         this._skins.push(skin);
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.skinsChanged(this);
            }
         }
         else
         {
            this._skinsChangedWhileLocked = true;
         }
      }
      
      public function getColors(byRef:Boolean = false) : Array
      {
         var colorIndex:* = null;
         if(!this._colors)
         {
            return null;
         }
         if(byRef)
         {
            return this._colors;
         }
         var colorsDeepCopy:Array = new Array();
         for(colorIndex in this._colors)
         {
            colorsDeepCopy[uint(colorIndex)] = this._colors[colorIndex];
         }
         return colorsDeepCopy;
      }
      
      public function getColor(index:uint) : DefaultableColor
      {
         var defaultColor:DefaultableColor = null;
         if(!this._colors || !this._colors[index])
         {
            defaultColor = new DefaultableColor();
            defaultColor.isDefault = true;
            return defaultColor;
         }
         return new DefaultableColor(this._colors[index]);
      }
      
      public function hasColor(index:uint) : Boolean
      {
         return Boolean(this._colors) && Boolean(this._colors[index]);
      }
      
      public function resetColor(index:uint) : void
      {
         var elo:* = null;
         if(!this._colors || !this._colors[index])
         {
            return;
         }
         delete this._colors[index];
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function resetColors() : void
      {
         var elo:* = null;
         if(!this._colors)
         {
            return;
         }
         this._colors = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function setColor(index:uint, color:uint) : void
      {
         var elo:* = null;
         if(!this._colors)
         {
            this._colors = new Array();
         }
         if(Boolean(this._colors[index]) && this._colors[index] == color)
         {
            return;
         }
         if(color == 0)
         {
            this._colors[index] = 1;
         }
         else
         {
            this._colors[index] = color;
         }
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.colorsChanged(this);
            }
         }
         else
         {
            this._colorsChangedWhileLocked = true;
         }
      }
      
      public function getScaleX() : Number
      {
         return this._scaleX;
      }
      
      public function setScaleX(value:Number) : void
      {
         var elo:* = null;
         if(this._scaleX == value)
         {
            return;
         }
         this._scaleX = value;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function getScaleY() : Number
      {
         return this._scaleY;
      }
      
      public function setScaleY(value:Number) : void
      {
         var elo:* = null;
         if(this._scaleY == value)
         {
            return;
         }
         this._scaleY = value;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function setScales(x:Number, y:Number) : void
      {
         var elo:* = null;
         if(this._scaleX == x && this._scaleY == y)
         {
            return;
         }
         this._scaleX = x;
         this._scaleY = y;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.scalesChanged(this);
            }
         }
         else
         {
            this._scalesChangedWhileLocked = true;
         }
      }
      
      public function getSubEntities(byRef:Boolean = false) : Array
      {
         var subEntityCategory:* = null;
         var category:uint = 0;
         var subEntityIndex:* = null;
         var index:uint = 0;
         if(!this._subEntities)
         {
            return null;
         }
         if(byRef)
         {
            return this._subEntities;
         }
         var subEntitesDeepCopy:Array = new Array();
         for(subEntityCategory in this._subEntities)
         {
            category = uint(subEntityCategory);
            if(!subEntitesDeepCopy[category])
            {
               subEntitesDeepCopy[category] = new Array();
            }
            for(subEntityIndex in this._subEntities[subEntityCategory])
            {
               index = uint(subEntityIndex);
               subEntitesDeepCopy[category][index] = this._subEntities[subEntityCategory][subEntityIndex];
            }
         }
         return subEntitesDeepCopy;
      }
      
      public function getSubEntitiesFromCategory(category:uint) : Array
      {
         var subEntityIndex:* = null;
         var index:uint = 0;
         if(!this._subEntities)
         {
            return null;
         }
         var subEntitiesDeepCopy:Array = new Array();
         for(subEntityIndex in this._subEntities[category])
         {
            index = uint(subEntityIndex);
            subEntitiesDeepCopy[index] = this._subEntities[category][subEntityIndex];
         }
         return subEntitiesDeepCopy;
      }
      
      public function getSubEntity(category:uint, index:uint) : TiphonEntityLook
      {
         if(!this._subEntities)
         {
            return null;
         }
         if(!this._subEntities[category])
         {
            return null;
         }
         return this._subEntities[category][index];
      }
      
      public function resetSubEntities() : void
      {
         var subEntityCategory:* = null;
         var subEntityIndex:* = null;
         var subEntity:TiphonEntityLook = null;
         var elo:* = null;
         if(!this._subEntities)
         {
            return;
         }
         for(subEntityCategory in this._subEntities)
         {
            for(subEntityIndex in this._subEntities[subEntityCategory])
            {
               subEntity = this._subEntities[subEntityCategory][subEntityIndex];
               subEntity.removeObserver(this);
            }
         }
         this._subEntities = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function addSubEntity(category:uint, index:uint, subEntity:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._subEntities)
         {
            this._subEntities = new Array();
         }
         if(!this._subEntities[category])
         {
            this._subEntities[category] = new Array();
         }
         subEntity.addObserver(this);
         this._subEntities[category][index] = subEntity;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function removeSubEntity(category:uint, index:uint = 0) : void
      {
         var elo:* = null;
         if(!this._subEntities || !this._subEntities[category] || !this._subEntities[category][index])
         {
            return;
         }
         delete this._subEntities[category][index];
         if(this._subEntities[category].length == 1)
         {
            delete this._subEntities[category];
         }
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function lock() : void
      {
         if(this._locked)
         {
            return;
         }
         this._locked = true;
         this._boneChangedWhileLocked = false;
         this._skinsChangedWhileLocked = false;
         this._colorsChangedWhileLocked = false;
         this._scalesChangedWhileLocked = false;
         this._subEntitiesChangedWhileLocked = false;
      }
      
      public function unlock(silentUnlock:Boolean = false) : void
      {
         var elo0:* = null;
         var elo1:* = null;
         var elo2:* = null;
         var elo3:* = null;
         var elo4:* = null;
         if(!this._locked)
         {
            return;
         }
         this._locked = false;
         if(!silentUnlock)
         {
            if(this._boneChangedWhileLocked)
            {
               for(elo0 in this._observers)
               {
                  elo0.boneChanged(this);
               }
               this._boneChangedWhileLocked = false;
            }
            if(this._skinsChangedWhileLocked)
            {
               for(elo1 in this._observers)
               {
                  elo1.skinsChanged(this);
               }
               this._skinsChangedWhileLocked = false;
            }
            if(this._colorsChangedWhileLocked)
            {
               for(elo2 in this._observers)
               {
                  elo2.colorsChanged(this);
               }
               this._colorsChangedWhileLocked = false;
            }
            if(this._scalesChangedWhileLocked)
            {
               for(elo3 in this._observers)
               {
                  elo3.scalesChanged(this);
               }
               this._scalesChangedWhileLocked = false;
            }
            if(this._subEntitiesChangedWhileLocked)
            {
               for(elo4 in this._observers)
               {
                  elo4.subEntitiesChanged(this);
               }
               this._subEntitiesChangedWhileLocked = false;
            }
         }
      }
      
      public function addObserver(elo:EntityLookObserver) : void
      {
         if(!this._observers)
         {
            this._observers = new Dictionary(true);
         }
         this._observers[elo] = 1;
      }
      
      public function removeObserver(elo:EntityLookObserver) : void
      {
         if(!this._observers)
         {
            return;
         }
         delete this._observers[elo];
      }
      
      public function toString() : String
      {
         return EntityLookParser.toString(this);
      }
      
      public function equals(el:TiphonEntityLook) : Boolean
      {
         var skin:uint = 0;
         var colorIndexStr:* = null;
         var colorIndexStr2:* = null;
         var subEntityCatStr:* = null;
         var subEntityCatStr2:* = null;
         var subEntityCatIndexStr:* = null;
         var se:TiphonEntityLook = null;
         var subEntityCatIndexStr2:* = null;
         var se2:TiphonEntityLook = null;
         if(this._bone != el._bone)
         {
            return false;
         }
         if(this._scaleX != el._scaleX)
         {
            return false;
         }
         if(this._scaleY != el._scaleY)
         {
            return false;
         }
         if(this._skins == null && el._skins != null || this._skins != null && el._skins == null)
         {
            return false;
         }
         if(Boolean(this._skins) && Boolean(el._skins))
         {
            if(this._skins.length != el._skins.length)
            {
               return false;
            }
            for each(skin in this._skins)
            {
               if(el._skins.indexOf(skin) == -1)
               {
                  return false;
               }
            }
         }
         if(this._colors == null && el._colors != null || this._colors != null && el._colors == null)
         {
            return false;
         }
         if(Boolean(this._colors) && Boolean(el._colors))
         {
            for(colorIndexStr in this._colors)
            {
               if(el._colors[colorIndexStr] != this._colors[colorIndexStr])
               {
                  return false;
               }
            }
            for(colorIndexStr2 in el._colors)
            {
               if(this._colors[colorIndexStr2] != el._colors[colorIndexStr2])
               {
                  return false;
               }
            }
         }
         if(this._subEntities == null && el._subEntities != null || this._subEntities != null && el._subEntities == null)
         {
            return false;
         }
         if(Boolean(this._subEntities) && Boolean(el._subEntities))
         {
            for(subEntityCatStr in this._subEntities)
            {
               if(!el._subEntities || el._subEntities[subEntityCatStr] == null)
               {
                  return false;
               }
               for(subEntityCatIndexStr in this._subEntities[subEntityCatStr])
               {
                  se = el._subEntities[subEntityCatStr][subEntityCatIndexStr];
                  if(se == null)
                  {
                     return false;
                  }
                  if(!se.equals(this._subEntities[subEntityCatStr][subEntityCatIndexStr]))
                  {
                     return false;
                  }
               }
            }
            for(subEntityCatStr2 in el._subEntities)
            {
               if(!this._subEntities || this._subEntities[subEntityCatStr2] == null)
               {
                  return false;
               }
               for(subEntityCatIndexStr2 in el._subEntities[subEntityCatStr2])
               {
                  se2 = this._subEntities[subEntityCatStr2][subEntityCatIndexStr2];
                  if(se2 == null)
                  {
                     return false;
                  }
                  if(!se2.equals(el._subEntities[subEntityCatStr2][subEntityCatIndexStr2]))
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      public function updateFrom(el:TiphonEntityLook) : void
      {
         if(this.equals(el))
         {
            return;
         }
         this.lock();
         this.setBone(el.getBone());
         this.resetColors();
         this._colors = el.getColors();
         this.resetSkins();
         this._skinsChangedWhileLocked = true;
         this._skins = el.getSkins();
         this.resetSubEntities();
         this._subEntitiesChangedWhileLocked = true;
         this._subEntities = el.getSubEntities();
         this.setScales(el.getScaleX(),el.getScaleY());
         this.unlock(false);
      }
      
      public function boneChanged(look:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function skinsChanged(look:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function colorsChanged(look:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function scalesChanged(look:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
      
      public function subEntitiesChanged(look:TiphonEntityLook) : void
      {
         var elo:* = null;
         if(!this._locked)
         {
            for(elo in this._observers)
            {
               elo.subEntitiesChanged(this);
            }
         }
         else
         {
            this._subEntitiesChangedWhileLocked = true;
         }
      }
   }
}
