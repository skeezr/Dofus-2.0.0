package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.TrapZoneTile;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.filters.ColorMatrixFilter;
   
   public class TrapZoneRenderer implements IZoneRenderer
   {
       
      private var _aZoneTile:Array;
      
      private var _aCellTile:Array;
      
      public var strata:uint;
      
      public function TrapZoneRenderer(nStrata:uint = 0)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this.strata = nStrata;
      }
      
      public function render(cells:Vector.<uint>, oColor:Color, mapContainer:DataMapContainer, alpha:Boolean = false) : void
      {
         var tzt:TrapZoneTile = null;
         var daCellId:uint = 0;
         var daPoint:MapPoint = null;
         var zzTop:Boolean = false;
         var zzBottom:Boolean = false;
         var zzRight:Boolean = false;
         var zzLeft:Boolean = false;
         var cid:uint = 0;
         var mp:MapPoint = null;
         for(var j:int = 0; j < cells.length; j++)
         {
            if(!this._aZoneTile[j])
            {
               this._aZoneTile[j] = tzt = new TrapZoneTile();
               tzt.mouseChildren = false;
               tzt.mouseEnabled = false;
               tzt.strata = this.strata;
               tzt.filters = [new ColorMatrixFilter([0,0,0,0,oColor.red,0,0,0,0,oColor.green,0,0,0,0,oColor.blue,0,0,0,0.7,0])];
            }
            this._aCellTile[j] = cells[j];
            daCellId = cells[j];
            daPoint = MapPoint.fromCellId(daCellId);
            TrapZoneTile(this._aZoneTile[j]).cellId = daCellId;
            zzTop = false;
            zzBottom = false;
            zzRight = false;
            zzLeft = false;
            for each(cid in cells)
            {
               if(cid != daCellId)
               {
                  mp = MapPoint.fromCellId(cid);
                  if(mp.x == daPoint.x)
                  {
                     if(mp.y == daPoint.y - 1)
                     {
                        zzTop = true;
                     }
                     else if(mp.y == daPoint.y + 1)
                     {
                        zzBottom = true;
                     }
                  }
                  else if(mp.y == daPoint.y)
                  {
                     if(mp.x == daPoint.x - 1)
                     {
                        zzRight = true;
                     }
                     else if(mp.x == daPoint.x + 1)
                     {
                        zzLeft = true;
                     }
                  }
               }
            }
            TrapZoneTile(this._aZoneTile[j]).drawStroke(zzTop,zzRight,zzBottom,zzLeft);
            TrapZoneTile(this._aZoneTile[j]).display();
         }
         while(j < this._aZoneTile.length)
         {
            if(this._aZoneTile[j])
            {
               (this._aZoneTile[j] as TrapZoneTile).remove();
            }
            j++;
         }
      }
      
      public function remove(cells:Vector.<uint>, mapContainer:DataMapContainer) : void
      {
         if(!cells)
         {
            return;
         }
         var mapping:Array = new Array();
         for(var j:int = 0; j < cells.length; j++)
         {
            mapping[cells[j]] = true;
         }
         for(j = 0; j < this._aCellTile.length; j++)
         {
            if(mapping[this._aCellTile[j]])
            {
               if(this._aZoneTile[j])
               {
                  TrapZoneTile(this._aZoneTile[j]).remove();
               }
               delete this._aZoneTile[j];
               delete this._aCellTile[j];
            }
         }
      }
   }
}
