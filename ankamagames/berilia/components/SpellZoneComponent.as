package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellZoneCellManager;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   import com.ankamagames.jerakine.utils.display.spellZone.IZoneShape;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellZoneComponent extends GraphicContainer implements FinalizableUIComponent
   {
       
      private var _cellWidth:Number;
      
      private var _cellHeight:Number;
      
      private var _spellRange:uint;
      
      private var _centerCellId:uint;
      
      private var _verticalCells:uint;
      
      private var _horizontalCells:uint;
      
      private var _cellRatio:Number = 2;
      
      private var _spellZoneManager:SpellZoneCellManager;
      
      private var _spellLevel:ICellZoneProvider;
      
      private var _infiniteLabel:com.ankamagames.berilia.components.Label;
      
      private var _minRange:uint;
      
      private var _maxRange:uint;
      
      private var _infiniteRange:Boolean = false;
      
      private var _finalized:Boolean;
      
      public function SpellZoneComponent()
      {
         super();
         disabled = false;
         this._spellZoneManager = new SpellZoneCellManager();
         addChild(this._spellZoneManager);
      }
      
      public function setSpellLevel(pSpellLevel:ICellZoneProvider) : void
      {
         var zoneEffect:Object = null;
         var effect:Object = null;
         this._spellLevel = pSpellLevel;
         this._spellZoneManager.spellLevel = this._spellLevel;
         var infiniteRange:Boolean = this._spellLevel.minimalRange == 0 && this._spellLevel.maximalRange == 0;
         var infiniteZoneEffect:Boolean = false;
         var affectOneCharacter:Boolean = true;
         for each(zoneEffect in this._spellLevel.spellZoneEffects)
         {
            if(zoneEffect.zoneSize == 63)
            {
               infiniteZoneEffect = true;
            }
            if(!(zoneEffect.zoneSize == 0 && zoneEffect.zoneShape == 80))
            {
               affectOneCharacter = false;
            }
         }
         if(Boolean(infiniteRange) && !affectOneCharacter || Boolean(infiniteZoneEffect))
         {
            this._infiniteRange = true;
            for each(effect in this._spellLevel.spellZoneEffects)
            {
               if(effect.zoneSize > 0 && effect.zoneSize != 63)
               {
                  this._infiniteRange = false;
               }
            }
            return;
         }
         this._infiniteRange = false;
         this.setRange(this._spellLevel.minimalRange,this._spellLevel.maximalRange);
      }
      
      private function setRange(minRange:uint, maxRange:uint) : void
      {
         var additionalRange:uint = 0;
         var shape:IZoneShape = null;
         this._minRange = minRange;
         this._maxRange = maxRange;
         this._horizontalCells = this._maxRange + 2 + 1;
         if(this._spellLevel)
         {
            additionalRange = 0;
            for each(shape in this._spellLevel.spellZoneEffects)
            {
               if(additionalRange < shape.zoneSize / 2)
               {
                  additionalRange = shape.zoneSize;
               }
            }
            this._horizontalCells = this._horizontalCells + additionalRange;
         }
         if(this._horizontalCells % 2 == 0)
         {
            this._horizontalCells++;
         }
         if(this._horizontalCells > 14)
         {
            this._horizontalCells = 14;
         }
         this._verticalCells = this._horizontalCells * 2 - 1;
         if(this._verticalCells > 20)
         {
            this._verticalCells = 20;
         }
         this._centerCellId = this.getCenterCellId(this._horizontalCells);
      }
      
      public function removeCells() : void
      {
         this._spellZoneManager.remove();
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
      
      public function finalize() : void
      {
         var infiniteText:String = null;
         if(this._infiniteRange)
         {
            if(this.contains(this._spellZoneManager))
            {
               removeChild(this._spellZoneManager);
            }
            if(Boolean(this._infiniteLabel) && Boolean(this.contains(this._infiniteLabel)))
            {
               return;
            }
            this._infiniteLabel = new com.ankamagames.berilia.components.Label();
            this._infiniteLabel.width = this.width;
            this._infiniteLabel.multiline = true;
            this._infiniteLabel.wordWrap = true;
            this._infiniteLabel.css = new Uri("mod://Ankama_Common/css/52.css");
            infiniteText = I18nProxy.getKey("ui.common.infiniteRange");
            if(infiniteText == null)
            {
               infiniteText = "Infinite range (TED)";
            }
            this._infiniteLabel.text = infiniteText;
            addChild(this._infiniteLabel);
            this._infiniteLabel.y = (height - this._infiniteLabel.height) / 2;
         }
         else
         {
            if(Boolean(this._infiniteLabel) && Boolean(this.contains(this._infiniteLabel)))
            {
               removeChild(this._infiniteLabel);
            }
            if(!this.contains(this._spellZoneManager))
            {
               addChild(this._spellZoneManager);
            }
            this._spellZoneManager.setDisplayZone(__width,__height);
            this._cellWidth = __width / this._horizontalCells;
            this._cellHeight = this._cellWidth / this._cellRatio;
            this._spellZoneManager.show();
            this._finalized = true;
            getUi().iAmFinalized(this);
         }
      }
      
      override public function remove() : void
      {
         this.removeCells();
      }
      
      override public function process(msg:Message) : Boolean
      {
         return false;
      }
      
      private function getCenterCellId(spellRange:uint) : uint
      {
         var posX:uint = spellRange;
         var posY:uint = 0;
         var centerCellId:uint = MapPoint.fromCoords(posX,posY).cellId;
         return centerCellId;
      }
   }
}
