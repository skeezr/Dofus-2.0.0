package com.ankamagames.jerakine.sequencer
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.utils.misc.FightProfiler;
   import flash.utils.Dictionary;
   
   public class SerialSequencer extends EventDispatcher implements ISequencer, IEventDispatcher
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(SerialSequencer));
      
      public static const DEFAULT_SEQUENCER_NAME:String = "SerialSequencerDefault";
      
      private static var SEQUENCERS:Array = [];
       
      private var _aStep:Array;
      
      private var _currentStep:com.ankamagames.jerakine.sequencer.ISequencable;
      
      private var _running:Boolean = false;
      
      private var _type:String;
      
      public function SerialSequencer(type:String = "SerialSequencerDefault")
      {
         this._aStep = new Array();
         super();
         if(!SEQUENCERS[type])
         {
            SEQUENCERS[type] = new Dictionary(true);
         }
         SEQUENCERS[type][this] = true;
      }
      
      public static function clearByType(type:String) : void
      {
         var seq:* = null;
         for(seq in SEQUENCERS[type])
         {
            SerialSequencer(seq).clear();
         }
         delete SEQUENCERS[type];
      }
      
      public function get currentStep() : com.ankamagames.jerakine.sequencer.ISequencable
      {
         return this._currentStep;
      }
      
      public function get length() : uint
      {
         return this._aStep.length;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get steps() : Array
      {
         return this._aStep;
      }
      
      public function addStep(item:com.ankamagames.jerakine.sequencer.ISequencable) : void
      {
         this._aStep.push(item);
      }
      
      public function start() : void
      {
         if(!this._running)
         {
            this._running = this._aStep.length != 0;
            if(this._running)
            {
               this.execute();
            }
            else
            {
               dispatchEvent(new SequencerEvent(SequencerEvent.SEQUENCE_END,false,false,this));
            }
         }
      }
      
      public function clear() : void
      {
         var step:com.ankamagames.jerakine.sequencer.ISequencable = null;
         for each(step in this._aStep)
         {
            step.clear();
         }
         this._aStep = new Array();
      }
      
      override public function toString() : String
      {
         var str:String = "";
         for(var i:uint = 0; i < this._aStep.length; i++)
         {
            str = str + (this._aStep[i].toString() + "\n");
         }
         return str;
      }
      
      private function execute() : void
      {
         this._currentStep = this._aStep.shift();
         if(!this._currentStep)
         {
            return;
         }
         FightProfiler.getInstance().start();
         this._currentStep.addListener(this);
         this._currentStep.start();
      }
      
      public function stepFinished() : void
      {
         if(this._running)
         {
            this._running = this._aStep.length != 0;
            if(!this._running)
            {
               dispatchEvent(new SequencerEvent(SequencerEvent.SEQUENCE_END,false,false,this));
            }
            else
            {
               this.execute();
            }
         }
      }
   }
}
