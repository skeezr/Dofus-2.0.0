package com.ankamagames.tubul.events
{
   import flash.events.Event;
   
   public class PlaylistEvent extends Event
   {
      
      public static const PLAYLIST_COMPLETE:String = "playlist_complete";
       
      public function PlaylistEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var pe:PlaylistEvent = new PlaylistEvent(type,bubbles,cancelable);
         return pe;
      }
   }
}
