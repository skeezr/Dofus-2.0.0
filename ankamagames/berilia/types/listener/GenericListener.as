package com.ankamagames.berilia.types.listener
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class GenericListener
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GenericListener));
       
      private var _sEvent:String;
      
      private var _oListener;
      
      private var _fCallback:Function;
      
      private var _nSortIndex:int;
      
      public function GenericListener(sEvent:String = null, oListener:* = null, fCallback:Function = null, nSortIndex:int = 0)
      {
         super();
         if(sEvent != null)
         {
            this._sEvent = sEvent;
         }
         if(oListener != null)
         {
            this.listener = oListener;
         }
         if(fCallback != null)
         {
            this._fCallback = fCallback;
         }
         this._nSortIndex = nSortIndex;
      }
      
      public function get event() : String
      {
         return this._sEvent;
      }
      
      public function set event(sEvent:String) : void
      {
         this._sEvent = sEvent;
      }
      
      public function get listener() : *
      {
         return this._oListener;
      }
      
      public function set listener(oListener:*) : void
      {
         this._oListener = oListener;
      }
      
      public function getCallback() : Function
      {
         return this._fCallback;
      }
      
      public function set callback(fCallback:Function) : void
      {
         this._fCallback = fCallback;
      }
      
      public function get sortIndex() : int
      {
         return this._nSortIndex;
      }
      
      public function set sortIndex(n:int) : void
      {
         this._nSortIndex = n;
      }
   }
}
