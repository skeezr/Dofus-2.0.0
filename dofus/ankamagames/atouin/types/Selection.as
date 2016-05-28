package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   
   public class Selection
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Selection));
       
      private var _mapId:uint;
      
      public var renderer:IZoneRenderer;
      
      public var zone:IZone;
      
      public var cells:Vector.<uint>;
      
      public var color:Color;
      
      public var alpha:Boolean = true;
      
      public var cellId:uint;
      
      public function Selection()
      {
         super();
      }
      
      public function set mapId(id:uint) : void
      {
         this._mapId = id;
      }
      
      public function get mapId() : uint
      {
         if(isNaN(this._mapId))
         {
            return MapDisplayManager.getInstance().currentMapPoint.mapId;
         }
         return this._mapId;
      }
      
      public function update() : void
      {
         if(this.renderer)
         {
            this.renderer.render(this.cells,this.color,MapDisplayManager.getInstance().getDataMapContainer(),this.alpha);
         }
      }
      
      public function remove(aCells:Vector.<uint> = null) : void
      {
         if(this.renderer)
         {
            if(!aCells)
            {
               this.renderer.remove(this.cells,MapDisplayManager.getInstance().getDataMapContainer());
            }
            else
            {
               this.renderer.remove(aCells,MapDisplayManager.getInstance().getDataMapContainer());
            }
         }
         delete this[this];
      }
      
      public function isInside(cellId:uint) : Boolean
      {
         if(!this.cells)
         {
            return false;
         }
         for(var i:uint = 0; i < this.cells.length; i++)
         {
            if(this.cells[i] == cellId)
            {
               return true;
            }
         }
         return false;
      }
   }
}
