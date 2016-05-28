package com.ankamagames.jerakine.utils.display
{
   import flash.display.MovieClip;
   import flash.display.DisplayObject;
   
   public class MovieClipUtils
   {
       
      public function MovieClipUtils()
      {
         super();
      }
      
      public static function isSingleFrame(mc:MovieClip) : Boolean
      {
         var i:uint = 0;
         var child:DisplayObject = null;
         if(mc.totalFrames > 1)
         {
            return false;
         }
         for(i = 0; i < mc.numChildren; i++)
         {
            child = mc.getChildAt(i);
            if(child is MovieClip && !isSingleFrame(child as MovieClip))
            {
               return false;
            }
         }
         return true;
      }
   }
}
