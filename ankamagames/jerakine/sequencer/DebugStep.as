package com.ankamagames.jerakine.sequencer
{
   public class DebugStep extends AbstractSequencable implements ISequencableListener
   {
       
      private var _message:String;
      
      private var _subStep:com.ankamagames.jerakine.sequencer.ISequencable;
      
      public function DebugStep(message:String, subStep:com.ankamagames.jerakine.sequencer.ISequencable = null)
      {
         super();
         this._message = message;
         this._subStep = subStep;
      }
      
      override public function start() : void
      {
         _log.debug(this._message);
         if(this._subStep)
         {
            this._subStep.addListener(this);
            this._subStep.start();
         }
         else
         {
            executeCallbacks();
         }
      }
      
      public function stepFinished() : void
      {
         this._subStep.removeListener(this);
         executeCallbacks();
      }
   }
}
