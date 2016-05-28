package com.ankamagames.jerakine.sequencer
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.ankamagames.jerakine.utils.misc.FightProfiler;
   
   public class AbstractSequencable implements ISequencable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractSequencable));
       
      private var _aListener:Array;
      
      private var _timeOut:Timer;
      
      public function AbstractSequencable()
      {
         this._aListener = new Array();
         super();
      }
      
      public function start() : void
      {
      }
      
      public function addListener(listener:ISequencableListener) : void
      {
         this._timeOut = new Timer(5000);
         this._timeOut.addEventListener(TimerEvent.TIMER,this.onTimeOut);
         this._timeOut.start();
         this._aListener.push(listener);
      }
      
      protected function executeCallbacks() : void
      {
         var listener:ISequencableListener = null;
         FightProfiler.getInstance().stop();
         if(this._timeOut)
         {
            this._timeOut.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
         }
         for each(listener in this._aListener)
         {
            if(listener)
            {
               listener.stepFinished();
            }
         }
      }
      
      public function removeListener(listener:ISequencableListener) : void
      {
         for(var i:uint = 0; i < this._aListener.length; i++)
         {
            if(this._aListener[i] == listener)
            {
               this._aListener = this._aListener.slice(0,i).concat(this._aListener.slice(i + 1,this._aListener.length));
               break;
            }
         }
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this);
      }
      
      public function clear() : void
      {
         if(this._timeOut)
         {
            this._timeOut.stop();
         }
         this._timeOut = null;
         this._aListener = null;
      }
      
      protected function onTimeOut(e:TimerEvent) : void
      {
         this.executeCallbacks();
         _log.error("Time out sur la step " + this);
      }
   }
}
