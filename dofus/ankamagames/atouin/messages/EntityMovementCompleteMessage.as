package com.ankamagames.atouin.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   
   public class EntityMovementCompleteMessage implements Message
   {
       
      private var _entity:IEntity;
      
      public function EntityMovementCompleteMessage(entity:IEntity)
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
