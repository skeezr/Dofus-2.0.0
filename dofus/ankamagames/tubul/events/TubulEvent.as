package com.ankamagames.tubul.events
{
   import flash.events.Event;
   
   public class TubulEvent extends Event
   {
      
      public static const ACTIVATION:String = "activation";
       
      public var activated:Boolean;
      
      public function TubulEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}
