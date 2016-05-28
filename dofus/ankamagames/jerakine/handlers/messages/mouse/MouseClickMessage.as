package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseClickMessage extends MouseMessage
   {
       
      public function MouseClickMessage(target:InteractiveObject, mouseEvent:MouseEvent)
      {
         super(target,mouseEvent);
      }
   }
}
