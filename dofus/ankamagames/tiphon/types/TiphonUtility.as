package com.ankamagames.tiphon.types
{
   public class TiphonUtility
   {
       
      public function TiphonUtility()
      {
         super();
      }
      
      public static function getFlipDirection(direction:int) : uint
      {
         switch(direction)
         {
            case 0:
               return 4;
            case 1:
               return 3;
            case 7:
               return 5;
            case 4:
               return 0;
            case 3:
               return 1;
            case 5:
               return 7;
            default:
               return direction;
         }
      }
   }
}
