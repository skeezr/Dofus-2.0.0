package com.ankamagames.jerakine.handlers.messages.mouse
{
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   
   public class MouseOverMessage extends MouseMessage
   {
       
      public function MouseOverMessage(target:InteractiveObject, mouseEvent:MouseEvent)
      {
         super(target,mouseEvent);
      }
   }
}
