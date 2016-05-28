package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightTeleportStep extends AbstractSequencable implements IFightStep
   {
       
      private var _fighterId:int;
      
      private var _destinationCell:MapPoint;
      
      public function FightTeleportStep(fighterId:int, destinationCell:MapPoint)
      {
         super();
         this._fighterId = fighterId;
         this._destinationCell = destinationCell;
      }
      
      public function get stepType() : String
      {
         return "teleport";
      }
      
      override public function start() : void
      {
         var entity:IMovable = DofusEntities.getEntity(this._fighterId) as IMovable;
         if(entity)
         {
            entity.jump(this._destinationCell);
         }
         else
         {
            _log.warn("Unable to teleport unknown entity " + this._fighterId + ".");
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_TELEPORTED,[this._fighterId]);
         executeCallbacks();
      }
   }
}
