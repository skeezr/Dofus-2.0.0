package com.ankamagames.jerakine.handlers.messages.keyboard
{
   import flash.display.InteractiveObject;
   import flash.events.KeyboardEvent;
   
   public class KeyboardKeyDownMessage extends KeyboardMessage
   {
       
      public function KeyboardKeyDownMessage(target:InteractiveObject, keyboardEvent:KeyboardEvent)
      {
         super(target,keyboardEvent);
      }
   }
}
