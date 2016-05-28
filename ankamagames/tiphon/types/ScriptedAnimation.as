package com.ankamagames.tiphon.types
{
   import flash.display.MovieClip;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   
   public class ScriptedAnimation extends MovieClip
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ScriptedAnimation));
      
      public static var currentSpriteHandler:com.ankamagames.tiphon.types.IAnimationSpriteHandler;
      
      private static const EVENT_SHOT:String = "SHOT";
      
      private static const EVENT_END:String = "END";
      
      private static const PLAYER_STOP:String = "STOP";
      
      private static const EVENTS:Object = {
         "SHOT":TiphonEvent.ANIMATION_SHOT,
         "END":TiphonEvent.ANIMATION_END
      };
       
      public var SHOT:String;
      
      public var END:String;
      
      private var events:Array;
      
      private var anims:Array;
      
      private var _maxFrame:uint;
      
      public var spriteHandler:com.ankamagames.tiphon.types.IAnimationSpriteHandler;
      
      private var _lastFrame:uint = 0;
      
      public function ScriptedAnimation()
      {
         var animationName:* = null;
         this.events = [];
         this.anims = [];
         super();
         this.spriteHandler = currentSpriteHandler;
         if(this.spriteHandler != null)
         {
            switch(this.spriteHandler.getDirection())
            {
               case 1:
               case 3:
                  animationName = this.spriteHandler.getAnimation() + "_1";
                  break;
               case 5:
               case 7:
                  animationName = this.spriteHandler.getAnimation() + "_5";
                  break;
               default:
                  animationName = this.spriteHandler.getAnimation() + "_" + this.spriteHandler.getDirection();
            }
            this.spriteHandler.tiphonEventManager.parseLabels(currentScene,animationName);
         }
         this._maxFrame = totalFrames - 1;
      }
      
      override public function gotoAndStop(frame:Object, scene:String = null) : void
      {
         super.gotoAndStop(frame,scene);
         if(int(frame) == this._maxFrame)
         {
            this.spriteHandler.onAnimationEvent(TiphonEvent.ANIMATION_END);
         }
         if(currentLabel == PLAYER_STOP)
         {
            stop();
            FpsControler.uncontrolFps(this);
         }
         this.spriteHandler.tiphonEventManager.dispatchEvents(frame);
      }
      
      public function setAnimation(... args) : void
      {
         trace("setAnimation",args);
      }
      
      public function event(... args) : void
      {
         trace("event",args);
      }
      
      public function help() : void
      {
         trace("Fonctions utilisables : ");
         trace("\t\t- setAnimation([nom_anim])");
         trace("\t\t- event([nom])");
         trace("");
         trace("Events :");
         trace("\t\t- SHOT : la cible du sort est touché");
         trace("\t\t- END : l\'animation est finie");
      }
   }
}
