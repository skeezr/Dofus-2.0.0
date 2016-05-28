package com.ankamagames.atouin
{
   public class AtouinConstants
   {
      
      public static const DEBUG_FILES_PARSING:Boolean = false;
      
      public static const DEBUG_FILES_PARSING_ELEMENTS:Boolean = false;
      
      public static const MAP_WIDTH:uint = 14;
      
      public static const MAP_HEIGHT:uint = 20;
      
      public static const MAP_CELLS_COUNT:uint = 560;
      
      public static const CELL_WIDTH:uint = 86;
      
      public static const CELL_HALF_WIDTH:uint = 43;
      
      public static const CELL_HEIGHT:uint = 43;
      
      public static const CELL_HALF_HEIGHT:Number = 21.5;
      
      public static const ALTITUDE_PIXEL_UNIT:uint = 10;
      
      public static const LOADERS_POOL_INITIAL_SIZE:int = 30;
      
      public static const LOADERS_POOL_GROW_SIZE:int = 5;
      
      public static const LOADERS_POOL_WARN_LIMIT:int = 100;
      
      public static const OVERLAY_MODE_ALPHA:Number = 0.6;
      
      public static const PATHFINDER_MIN_X:int = 0;
      
      public static const PATHFINDER_MAX_X:int = 33 + 1;
      
      public static const PATHFINDER_MIN_Y:int = -19;
      
      public static const PATHFINDER_MAX_Y:int = 13 + 1;
      
      public static const VIEW_DETECT_CELL_WIDTH:int = 2 * CELL_WIDTH;
      
      public static const MIN_MAP_X:int = -255;
      
      public static const MAX_MAP_X:int = 255;
      
      public static const MIN_MAP_Y:int = -255;
      
      public static const MAX_MAP_Y:int = 255;
       
      public function AtouinConstants()
      {
         super();
      }
   }
}
