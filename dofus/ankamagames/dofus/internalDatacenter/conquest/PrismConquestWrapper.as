package com.ankamagames.dofus.internalDatacenter.conquest
{
   public class PrismConquestWrapper
   {
      
      private static var _cache:Array = new Array();
       
      private var _subId:uint;
      
      private var _align:uint;
      
      private var _isEntered:Boolean;
      
      private var _isInRoom:Boolean;
      
      public function PrismConquestWrapper()
      {
         super();
      }
      
      public static function create(subId:uint, align:uint, isEntered:Boolean, isInRoom:Boolean, useCache:Boolean = false) : PrismConquestWrapper
      {
         var prism:PrismConquestWrapper = null;
         if(!_cache[subId] || !useCache)
         {
            prism = new PrismConquestWrapper();
            prism._subId = subId;
            prism._align = align;
            prism._isEntered = isEntered;
            prism._isInRoom = isInRoom;
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
      
      public function get isEntered() : Boolean
      {
         return this._isEntered;
      }
      
      public function get isInRoom() : Boolean
      {
         return this._isInRoom;
      }
   }
}
