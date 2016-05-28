package com.ankamagames.atouin.data.map
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.AtouinConstants;
   
   public class CellData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CellData));
       
      public var speed:int;
      
      public var mapChangeData:uint;
      
      private var _losmov:int;
      
      private var _floor:int;
      
      private var _map:com.ankamagames.atouin.data.map.Map;
      
      public function CellData(map:com.ankamagames.atouin.data.map.Map)
      {
         super();
         this._map = map;
      }
      
      public function get map() : com.ankamagames.atouin.data.map.Map
      {
         return this._map;
      }
      
      public function get los() : Boolean
      {
         return (this._losmov & 2) >> 1 == 1;
      }
      
      public function get mov() : Boolean
      {
         return (this._losmov & 1) == 1 && !this.nonWalkableDuringFight;
      }
      
      public function get nonWalkableDuringFight() : Boolean
      {
         return (this._losmov & 3) >> 2 == 1;
      }
      
      public function get red() : Boolean
      {
         return (this._losmov & 4) >> 3 == 1;
      }
      
      public function get blue() : Boolean
      {
         return (this._losmov & 5) >> 4 == 1;
      }
      
      public function get floor() : int
      {
         return this._floor;
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         try
         {
            this._floor = raw.readByte() * 10;
            if(this._floor == -1280)
            {
               return;
            }
            this._losmov = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("  (CellData) LOS+MOV : " + this._losmov);
            }
            this.speed = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("  (CellData) Speed : " + this.speed);
            }
            this.mapChangeData = raw.readUnsignedByte();
            if(AtouinConstants.DEBUG_FILES_PARSING)
            {
               _log.debug("  (CellData) MapChangeData : " + this.mapChangeData);
            }
         }
         catch(e:*)
         {
            throw e;
         }
      }
   }
}
