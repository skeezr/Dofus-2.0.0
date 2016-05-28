package com.ankamagames.tiphon.sequence
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.events.TimerEvent;
   
   public class PlayAnimationStep extends AbstractSequencable
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayAnimationStep));
       
      private var _target:TiphonSprite;
      
      private var _animationName:String;
      
      private var _loop:int;
      
      private var _endEvent:String;
      
      private var _waitEvent:Boolean;
      
      private var _lastAnimName:String;
      
      private var _backToLastAnimationAtEnd:Boolean;
      
      private var _callbackExecuted:Boolean = false;
      
      public function PlayAnimationStep(target:TiphonSprite, animationName:String, backToLastAnimationAtEnd:Boolean = true, waitEvent:Boolean = true, eventEnd:String = "animation_event_end", loop:int = 1)
      {
         super();
         this._endEvent = eventEnd;
         this._target = target;
         this._animationName = animationName;
         this._loop = loop;
         this._waitEvent = waitEvent;
         this._backToLastAnimationAtEnd = backToLastAnimationAtEnd;
      }
      
      public function get target() : TiphonSprite
      {
         return this._target;
      }
      
      public function get animation() : String
      {
         return this._animationName;
      }
      
      public function set waitEvent(v:Boolean) : void
      {
         this._waitEvent = v;
      }
      
      override public function start() : void
      {
         if(this._endEvent != TiphonEvent.ANIMATION_END)
         {
            this._target.addEventListener(this._endEvent,this.onCustomEvent);
         }
         this._target.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         this._target.addEventListener(TiphonEvent.RENDER_FAILED,this.onAnimationEnd);
         this._lastAnimName = this._target.getAnimation();
         this._target.setAnimation(this._animationName);
         if(!this._waitEvent)
         {
            this._callbackExecuted = true;
            executeCallbacks();
         }
      }
      
      private function onCustomEvent(e:TiphonEvent) : void
      {
         this._target.removeEventListener(this._endEvent,this.onCustomEvent);
         this._callbackExecuted = true;
         executeCallbacks();
      }
      
      private function onAnimationEnd(e:TiphonEvent) : void
      {
         if(this._target)
         {
            if(this._endEvent != TiphonEvent.ANIMATION_END)
            {
               this._target.removeEventListener(this._endEvent,this.onCustomEvent);
            }
            this._target.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
            this._target.removeEventListener(TiphonEvent.RENDER_FAILED,this.onAnimationEnd);
            if(this._backToLastAnimationAtEnd)
            {
               this._target.setAnimation("AnimStatique");
            }
         }
         if(!this._callbackExecuted)
         {
            executeCallbacks();
         }
      }
      
      override public function toString() : String
      {
         return "play " + this._animationName + " on " + this._target.name;
      }
      
      override protected function onTimeOut(e:TimerEvent) : void
      {
         this._callbackExecuted = true;
         this.onAnimationEnd(null);
         super.onTimeOut(e);
      }
   }
}
