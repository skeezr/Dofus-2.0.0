package com.ankamagames.jerakine.handlers.messages.keyboard
{
   import com.ankamagames.jerakine.handlers.messages.HumanInputMessage;
   import flash.events.KeyboardEvent;
   import flash.display.InteractiveObject;
   
   public class KeyboardMessage extends HumanInputMessage
   {
       
      public function KeyboardMessage(target:InteractiveObject, keyboardEvent:KeyboardEvent)
      {
         super(target,keyboardEvent);
      }
      
      public function get keyboardEvent() : KeyboardEvent
      {
         return KeyboardEvent(_nativeEvent);
      }
   }
}
