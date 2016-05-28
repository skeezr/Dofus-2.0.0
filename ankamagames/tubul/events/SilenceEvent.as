package com.ankamagames.tubul.events
{
   import flash.events.Event;
   import com.ankamagames.tubul.interfaces.ISound;
   
   public class SilenceEvent extends Event
   {
      
      public static const SOUND_SILENCE_COMPLETE:String = "sound_silence_complete";
       
      public var sound:ISound;
      
      public function SilenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var se:SilenceEvent = new SilenceEvent(type,bubbles,cancelable);
         se.sound = this.sound;
         return se;
      }
   }
}
