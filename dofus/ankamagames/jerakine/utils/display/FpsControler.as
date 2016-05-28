package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class FpsControler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FpsControler));
      
      private static var _controledClips:Dictionary = new Dictionary(true);
      
      private static var _controledClipsDependencies:Dictionary = new Dictionary();
      
      private static var _controledClipsCount:uint;
      
      private static var _recycledDependencies:Vector.<MovieClip> = new Vector.<MovieClip>(0,false);
      
      private static var _garbageTimer:Timer;
      
      public static var enterFrameDispatcher:Object;
       
      public function FpsControler()
      {
         super();
      }
      
      public static function get controledClipsCount() : uint
      {
         return _controledClipsCount;
      }
      
      public static function Init() : void
      {
         if(!_garbageTimer)
         {
            _garbageTimer = new Timer(10000);
            _garbageTimer.addEventListener(TimerEvent.TIMER,onGarbageTimer);
            _garbageTimer.start();
         }
      }
      
      private static function onGarbageTimer(E:Event) : void
      {
         var clip:* = null;
         var movieClip:MovieClip = null;
         for(clip in _controledClips)
         {
            movieClip = clip as MovieClip;
            if(!movieClip.stage)
            {
               uncontrolFps(movieClip);
            }
         }
      }
      
      public static function controlFps(clip:MovieClip, framerate:uint, forbidRecursivity:Boolean = false) : MovieClip
      {
         controlSingleClip(clip,framerate,forbidRecursivity);
         if(_recycledDependencies.length > 0)
         {
            _controledClipsDependencies[clip] = _recycledDependencies;
            _recycledDependencies = new Vector.<MovieClip>(0,false);
         }
         return clip;
      }
      
      public static function uncontrolFps(clip:MovieClip) : void
      {
         var dependency:MovieClip = null;
         if(!clip || Boolean(MovieClipUtils.isSingleFrame(clip)))
         {
            return;
         }
         if(_controledClipsDependencies[clip])
         {
            for each(dependency in _controledClipsDependencies[clip])
            {
               uncontrolFps(dependency);
            }
            delete _controledClipsDependencies[clip];
         }
         if(_controledClips[clip])
         {
            enterFrameDispatcher.removeEventListener(_controledClips[clip]);
            clip.stop();
            delete _controledClips[clip];
            _controledClipsCount--;
         }
      }
      
      private static function controlSingleClip(clip:MovieClip, framerate:uint, forbidRecursivity:Boolean = false) : MovieClip
      {
         var numChildren:uint = 0;
         var i:uint = 0;
         var child:DisplayObject = null;
         var dep:MovieClip = null;
         if(!forbidRecursivity)
         {
            numChildren = clip.numChildren;
            for(i = 0; i < numChildren; i++)
            {
               child = clip.getChildAt(i);
               if(child is MovieClip)
               {
                  dep = controlSingleClip(child as MovieClip,framerate);
                  if(dep)
                  {
                     _recycledDependencies.push(dep);
                  }
               }
            }
         }
         if(!clip || Boolean(MovieClipUtils.isSingleFrame(clip)) || Boolean(_controledClips[clip]))
         {
            return null;
         }
         clip.gotoAndStop(clip.currentFrame > 0?clip.currentFrame:1);
         _controledClips[clip] = getControlingMethod(clip);
         _controledClipsCount++;
         enterFrameDispatcher.addEventListener(_controledClips[clip],"FpsControler" + clip.name,framerate);
         return clip;
      }
      
      private static function getControlingMethod(clip:MovieClip) : Function
      {
         return function(e:Event):void
         {
            clip.gotoAndStop((clip.currentFrame + 1) % (clip.totalFrames + 1));
         };
      }
   }
}
