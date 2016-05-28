package com.ankamagames.tubul.events
{
   import flash.events.Event;
   import com.ankamagames.tubul.interfaces.ISound;
   
   public class FadeEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
       
      public var sound:ISound;
      
      public function FadeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var fe:FadeEvent = new FadeEvent(type,bubbles,cancelable);
         return fe;
      }
   }
}
