package com.ankamagames.dofus.internalDatacenter.conquest
{
   public class PrismSubAreaWrapper
   {
      
      private static var _cache:Array = new Array();
       
      private var _subId:uint;
      
      private var _align:uint;
      
      private var _mapId:uint;
      
      private var _isInFight:Boolean;
      
      private var _isFightable:Boolean;
      
      public function PrismSubAreaWrapper()
      {
         super();
      }
      
      public static function create(subId:uint, align:uint, mapId:uint, isInFight:Boolean, isFightable:Boolean, useCache:Boolean = false) : PrismSubAreaWrapper
      {
         var prism:PrismSubAreaWrapper = null;
         if(!_cache[subId] || !useCache)
         {
            prism = new PrismSubAreaWrapper();
            prism._subId = subId;
            prism._align = align;
            prism._mapId = mapId;
            prism._isInFight = isInFight;
            prism._isFightable = isFightable;
            if(useCache)
            {
               _cache[subId] = prism;
            }
         }
         else
         {
            prism = _cache[subId];
         }
         return prism;
      }
      
      public function get subAreaId() : uint
      {
         return this._subId;
      }
      
      public function get alignmentId() : uint
      {
         return this._align;
      }
      
      public function get mapId() : uint
      {
         return this._mapId;
      }
      
      public function get isInFight() : Boolean
      {
         return this._isInFight;
      }
      
      public function get isFightable() : Boolean
      {
         return this._isFightable;
      }
   }
}
