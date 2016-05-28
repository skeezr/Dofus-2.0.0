package com.ankamagames.atouin.types.sequences
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   
   public class AddWorldEntityStep extends AbstractSequencable
   {
       
      private var _entity:IEntity;
      
      public function AddWorldEntityStep(entity:IEntity)
      {
         super();
         this._entity = entity;
      }
      
      override public function start() : void
      {
         (this._entity as IDisplayable).display();
         executeCallbacks();
      }
   }
}
