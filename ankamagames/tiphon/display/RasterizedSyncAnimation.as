package com.ankamagames.tiphon.display
{
   import flash.utils.Dictionary;
   import com.ankamagames.tiphon.types.IAnimationSpriteHandler;
   import flash.display.MovieClip;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   
   public class RasterizedSyncAnimation extends RasterizedAnimation
   {
      
      private static var _events:Dictionary = new Dictionary(true);
       
      public var spriteHandler:IAnimationSpriteHandler;
      
      public function RasterizedSyncAnimation(target:MovieClip, lookCode:String)
      {
         var animationName:* = null;
         super(target,lookCode);
         _target = target;
         _totalFrames = _target.totalFrames;
         this.spriteHandler = (target as ScriptedAnimation).spriteHandler;
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
         if(this.spriteHandler != null)
         {
            this.spriteHandler.tiphonEventManager.parseLabels(currentScene,animationName);
         }
      }
      
      override public function gotoAndStop(frame:Object, scene:String = null) : void
      {
         var targetFrame:uint = frame as uint;
         if(targetFrame > 0)
         {
            targetFrame--;
         }
         this.displayFrame(targetFrame % _totalFrames);
      }
      
      override public function gotoAndPlay(frame:Object, scene:String = null) : void
      {
         this.gotoAndStop(frame,scene);
         play();
      }
      
      override protected function displayFrame(frameIndex:uint) : Boolean
      {
         var changed:Boolean = super.displayFrame(frameIndex);
         if(changed)
         {
            this.spriteHandler.tiphonEventManager.dispatchEvents(frameIndex);
         }
         return changed;
      }
   }
}
