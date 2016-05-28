package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.ZoneTile;
   import flash.filters.ColorMatrixFilter;
   
   public class ZoneDARenderer implements IZoneRenderer
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ZoneDARenderer));
       
      private var _aZoneTile:Array;
      
      private var _aCellTile:Array;
      
      private var _alpha:Number = 0.7;
      
      public var strata:uint = 0;
      
      public function ZoneDARenderer(nStrata:uint = 0, alpha:Number = 0.7)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this.strata = nStrata;
         this._alpha = alpha;
      }
      
      public function render(cells:Vector.<uint>, oColor:Color, mapContainer:DataMapContainer, bAlpha:Boolean = false) : void
      {
         var j:uint = 0;
         var zt:ZoneTile = null;
         var alpha:Number = NaN;
         for(j = 0; j < cells.length; j++)
         {
            if(!this._aZoneTile[j])
            {
               alpha = 1;
               if(bAlpha)
               {
                  alpha = this._alpha;
               }
               zt = this._aZoneTile[j] = new ZoneTile();
               zt.mouseChildren = false;
               zt.mouseEnabled = false;
               zt.strata = this.strata;
               zt.filters = [new ColorMatrixFilter([0,0,0,0,oColor.red,0,0,0,0,oColor.green,0,0,0,0,oColor.blue,0,0,0,alpha,0])];
            }
            this._aCellTile[j] = cells[j];
            ZoneTile(this._aZoneTile[j]).cellId = cells[j];
            ZoneTile(this._aZoneTile[j]).display();
         }
         while(j < this._aZoneTile.length)
         {
            if(this._aZoneTile[j])
            {
               this._aZoneTile[j].remove();
            }
            j++;
         }
      }
      
      public function remove(cells:Vector.<uint>, mapContainer:DataMapContainer) : void
      {
         var j:uint = 0;
         if(!cells)
         {
            return;
         }
         var count:int = 0;
         var mapping:Array = new Array();
         for(j = 0; j < cells.length; j++)
         {
            mapping[cells[j]] = true;
         }
         for(var i:uint = 0; i < this._aCellTile.length; i++)
         {
            if(mapping[this._aCellTile[i]])
            {
               count++;
               if(this._aZoneTile[i])
               {
                  this._aZoneTile[i].remove();
               }
               delete this._aZoneTile[i];
               delete this._aCellTile[i];
            }
         }
      }
   }
}
