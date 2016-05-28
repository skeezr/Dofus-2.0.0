package com.ankamagames.jerakine.types.positions
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class PathElement
   {
       
      protected var _log:Logger;
      
      private var _oStep:com.ankamagames.jerakine.types.positions.MapPoint;
      
      private var _nOrientation:uint;
      
      public function PathElement()
      {
         this._log = Log.getLogger(getQualifiedClassName(PathElement));
         super();
         this._oStep = new com.ankamagames.jerakine.types.positions.MapPoint();
      }
      
      public function get orientation() : uint
      {
         return this._nOrientation;
      }
      
      public function set orientation(nValue:uint) : void
      {
         this._nOrientation = nValue;
      }
      
      public function get step() : com.ankamagames.jerakine.types.positions.MapPoint
      {
         return this._oStep;
      }
      
      public function set step(nValue:com.ankamagames.jerakine.types.positions.MapPoint) : void
      {
         this._oStep = nValue;
      }
   }
}
