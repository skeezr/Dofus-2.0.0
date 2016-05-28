package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseOutMessage extends MouseMessage
   {
       
      public function MouseOutMessage(target:InteractiveObject, mouseEvent:MouseEvent)
      {
         super(target,mouseEvent);
      }
   }
}
