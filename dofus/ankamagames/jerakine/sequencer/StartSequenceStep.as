package com.ankamagames.jerakine.sequencer
{
   public class StartSequenceStep extends AbstractSequencable
   {
       
      private var _sequence:com.ankamagames.jerakine.sequencer.ISequencer;
      
      public function StartSequenceStep(sequence:com.ankamagames.jerakine.sequencer.ISequencer)
      {
         super();
         this._sequence = sequence;
      }
      
      override public function start() : void
      {
         if(this._sequence)
         {
            this._sequence.start();
         }
         executeCallbacks();
      }
   }
}
