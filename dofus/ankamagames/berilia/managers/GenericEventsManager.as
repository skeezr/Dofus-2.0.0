package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class GenericEventsManager
   {
       
      protected var _aEvent:Array;
      
      protected var _log:Logger;
      
      public function GenericEventsManager()
      {
         this._aEvent = new Array();
         this._log = Log.getLogger(getQualifiedClassName(GenericEventsManager));
         super();
      }
      
      public function initialize() : void
      {
         this._aEvent = new Array();
      }
      
      public function registerEvent(e:GenericListener) : void
      {
         if(this._aEvent[e.event] == null)
         {
            this._aEvent[e.event] = new Array();
         }
         this._aEvent[e.event].push(e);
         (this._aEvent[e.event] as Array).sortOn("sortIndex",Array.NUMERIC | Array.DESCENDING);
      }
      
      public function removeEventListener(ge:GenericListener) : void
      {
         var i:* = null;
         var j:* = null;
         for(i in this._aEvent)
         {
            for(j in this._aEvent[i])
            {
               if(!(this._aEvent[i] == null || this._aEvent[i][j] == null))
               {
                  if(this._aEvent[i][j] == ge)
                  {
                     delete this._aEvent[i][j];
                     if(!this._aEvent[i].length)
                     {
                        this._aEvent[i] = null;
                        delete this._aEvent[i];
                     }
                  }
               }
            }
         }
      }
      
      public function removeEvent(sListener:*) : void
      {
         var e:GenericListener = null;
         var i:* = null;
         var j:* = null;
         for(i in this._aEvent)
         {
            for(j in this._aEvent[i])
            {
               if(!(this._aEvent[i] == null || this._aEvent[i][j] == null))
               {
                  e = this._aEvent[i][j];
                  if(e.listener == sListener)
                  {
                     this._aEvent[i][j] = null;
                     delete this._aEvent[i][j];
                     if(!this._aEvent[i].length)
                     {
                        this._aEvent[i] = null;
                        delete this._aEvent[i];
                     }
                  }
               }
            }
         }
      }
   }
}
