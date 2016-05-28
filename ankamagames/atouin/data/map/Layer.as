package com.ankamagames.atouin.data.map
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.AtouinConstants;
   
   public class Layer
   {
      
      public static const LAYER_GROUND:uint = 0;
      
      public static const LAYER_ADDITIONAL_GROUND:uint = 1;
      
      public static const LAYER_DECOR:uint = 2;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Layer));
       
      public var layerId:int;
      
      public var refCell:int = 0;
      
      public var cellsCount:int;
      
      public var cells:Array;
      
      private var _map:com.ankamagames.atouin.data.map.Map;
      
      public function Layer(map:com.ankamagames.atouin.data.map.Map)
      {
         super();
         this._map = map;
      }
      
      public function get map() : com.ankamagames.atouin.data.map.Map
      {
         return this._map;
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         var i:int = 0;
         var c:Cell = null;
         try
         {
            this.layerId = raw.readInt();
            this.cellsCount = raw.readShort();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("  (Layer) Cells count : " + this.cellsCount);
            }
            this.cells = new Array();
            for(i = 0; i < this.cellsCount; i++)
            {
               c = new Cell(this);
               if(AtouinConstants.DEBUG_FILES_PARSING)
               {
                  _log.debug("  (Layer) Cell at index " + i + " :");
               }
               c.fromRaw(raw);
               this.cells.push(c);
            }
         }
         catch(e:*)
         {
            throw e;
         }
      }
   }
}
