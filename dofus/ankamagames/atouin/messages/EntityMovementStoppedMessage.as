package com.ankamagames.atouin.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   
   public class EntityMovementStoppedMessage implements Message
   {
       
      private var _entity:IEntity;
      
      public function EntityMovementStoppedMessage(entity:IEntity)
      {
         super();
         this._entity = entity;
      }
      
      public function get entity() : IEntity
      {
         return this._entity;
      }
   }
}
