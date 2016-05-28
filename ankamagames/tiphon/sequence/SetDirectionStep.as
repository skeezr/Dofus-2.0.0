package com.ankamagames.tiphon.sequence
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public class SetDirectionStep extends AbstractSequencable
   {
       
      private var _nDirection:uint;
      
      private var _target:TiphonSprite;
      
      public function SetDirectionStep(target:TiphonSprite, nDirection:uint)
      {
         super();
         this._target = target;
         this._nDirection = nDirection;
      }
      
      override public function start() : void
      {
         this._target.setDirection(this._nDirection);
         executeCallbacks();
      }
      
      override public function toString() : String
      {
         return "set direction " + this._nDirection + " on " + this._target.name;
      }
   }
}
