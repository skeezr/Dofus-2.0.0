package com.ankamagames.jerakine.entities.messages
{
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   
   public class EntityMouseOutMessage extends EntityInteractionMessage
   {
       
      public function EntityMouseOutMessage(entity:IInteractive)
      {
         super(entity);
      }
   }
}
