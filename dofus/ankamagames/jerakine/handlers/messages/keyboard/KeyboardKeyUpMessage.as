package com.ankamagames.jerakine.handlers.messages.keyboard
{
   import flash.display.InteractiveObject;
   import flash.events.KeyboardEvent;
   
   public class KeyboardKeyUpMessage extends KeyboardMessage
   {
       
      public function KeyboardKeyUpMessage(target:InteractiveObject, keyboardEvent:KeyboardEvent)
      {
         super(target,keyboardEvent);
      }
   }
}
