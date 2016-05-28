package com.ankamagames.jerakine.types.events
{
   import flash.events.Event;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   
   public class SequencerEvent extends Event
   {
      
      public static const SEQUENCE_END:String = "onSequenceEnd";
       
      private var _sequancer:ISequencer;
      
      public function SequencerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, sequancer:ISequencer = null)
      {
         super(type,bubbles,cancelable);
         this._sequancer = sequancer;
      }
      
      public function get sequencer() : ISequencer
      {
         return this._sequancer;
      }
   }
}
