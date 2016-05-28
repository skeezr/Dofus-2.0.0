package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.types.sequences.DestroyEntityStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   
   public class FightDestroyEntityStep extends DestroyEntityStep implements IFightStep
   {
       
      public function FightDestroyEntityStep(entity:IEntity)
      {
         super(entity);
      }
      
      public function get stepType() : String
      {
         return "destroyEntity";
      }
   }
}
