package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.ISequencable;
   
   public interface IFightStep extends ISequencable
   {
       
      function get stepType() : String;
   }
}
