package com.ankamagames.jerakine.utils.display
{
   import flash.display.Stage;
   import flash.display.DisplayObjectContainer;
   
   public class StageShareManager
   {
      
      private static var _stage:Stage;
      
      private static var _startWidth:uint;
      
      private static var _startHeight:uint;
      
      private static var _rootContainer:DisplayObjectContainer;
       
      public function StageShareManager()
      {
         super();
      }
      
      public static function set rootContainer(d:DisplayObjectContainer) : void
      {
         _rootContainer = d;
      }
      
      public static function get rootContainer() : DisplayObjectContainer
      {
         return _rootContainer;
      }
      
      public static function get stage() : Stage
      {
         return _stage;
      }
      
      public static function set stage(value:Stage) : void
      {
         _stage = value;
         _startWidth = 1280;
         _startHeight = 1024;
      }
      
      public static function get startWidth() : uint
      {
         return _startWidth;
      }
      
      public static function get startHeight() : uint
      {
         return _startHeight;
      }
      
      public static function get mouseX() : int
      {
         return _rootContainer.mouseX;
      }
      
      public static function get mouseY() : int
      {
         return _rootContainer.mouseY;
      }
      
      public static function get stageOffsetX() : int
      {
         return _rootContainer.x;
      }
      
      public static function get stageOffsetY() : int
      {
         return _rootContainer.y;
      }
      
      public static function get stageScaleX() : Number
      {
         return _rootContainer.scaleX;
      }
      
      public static function get stageScaleY() : Number
      {
         return _rootContainer.scaleY;
      }
   }
}
