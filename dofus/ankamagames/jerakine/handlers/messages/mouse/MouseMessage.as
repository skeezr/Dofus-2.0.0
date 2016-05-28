package com.ankamagames.jerakine.handlers.messages.mouse
{
   import com.ankamagames.jerakine.handlers.messages.HumanInputMessage;
   import flash.events.MouseEvent;
   import flash.display.InteractiveObject;
   
   public class MouseMessage extends HumanInputMessage
   {
       
      public function MouseMessage(target:InteractiveObject, mouseEvent:MouseEvent)
      {
         super(target,mouseEvent);
      }
      
      public function get mouseEvent() : MouseEvent
      {
         return MouseEvent(_nativeEvent);
      }
   }
}
