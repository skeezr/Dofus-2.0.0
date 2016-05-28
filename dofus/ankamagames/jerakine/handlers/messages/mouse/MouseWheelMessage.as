package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseWheelMessage extends MouseMessage
   {
       
      public function MouseWheelMessage(target:InteractiveObject, mouseEvent:MouseEvent)
      {
         super(target,mouseEvent);
      }
   }
}
