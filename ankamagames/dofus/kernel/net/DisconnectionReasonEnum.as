package com.ankamagames.dofus.kernel.net
{
   public final class DisconnectionReasonEnum
   {
      
      public static const UNEXPECTED:uint = 0;
      
      public static const SWITCHING_TO_GAME_SERVER:uint = 1;
      
      public static const SWITCHING_TO_HUMAN_VENDOR:uint = 2;
       
      public function DisconnectionReasonEnum()
      {
         super();
      }
   }
}
