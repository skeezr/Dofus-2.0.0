package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import flash.display.DisplayObject;
   
   public class FightChangeVisibilityStep extends AbstractSequencable implements IFightStep
   {
      
      private static var _holder:FightEntitiesHolder = FightEntitiesHolder.getInstance();
       
      private var _entityId:int;
      
      private var _visibilityState:int;
      
      private var _oldVisibilityState:int;
      
      public function FightChangeVisibilityStep(entityId:int, visibilityState:int)
      {
         super();
         var fighterInfos:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(entityId) as GameFightFighterInformations;
         this._oldVisibilityState = fighterInfos.stats.invisibilityState;
         this._entityId = entityId;
         this._visibilityState = visibilityState;
      }
      
      public function get stepType() : String
      {
         return "changeVisibility";
      }
      
      override public function start() : void
      {
         var dispatchedState:uint = 0;
         switch(this._visibilityState)
         {
            case GameActionFightInvisibilityStateEnum.VISIBLE:
               this.respawnEntity().alpha = 1;
               if(this._oldVisibilityState == GameActionFightInvisibilityStateEnum.DETECTED || this._oldVisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE)
               {
                  dispatchedState = GameActionFightInvisibilityStateEnum.VISIBLE;
               }
               break;
            case GameActionFightInvisibilityStateEnum.DETECTED:
               if(this._oldVisibilityState == GameActionFightInvisibilityStateEnum.VISIBLE)
               {
                  dispatchedState = GameActionFightInvisibilityStateEnum.INVISIBLE;
               }
               this.respawnEntity().alpha = 0.5;
               break;
            case GameActionFightInvisibilityStateEnum.INVISIBLE:
               if(this._oldVisibilityState == GameActionFightInvisibilityStateEnum.VISIBLE)
               {
                  dispatchedState = GameActionFightInvisibilityStateEnum.INVISIBLE;
               }
               this.unspawnEntity();
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_VISIBILITY_CHANGED,[this._entityId,dispatchedState]);
         var fighterInfos:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._entityId) as GameFightFighterInformations;
         fighterInfos.stats.invisibilityState = this._visibilityState;
         executeCallbacks();
      }
      
      private function unspawnEntity() : void
      {
         if(_holder.getEntity(this._entityId))
         {
            return;
         }
         var entity:IDisplayable = DofusEntities.getEntity(this._entityId) as IDisplayable;
         _holder.holdEntity(entity as IEntity);
         entity.remove();
      }
      
      private function respawnEntity() : DisplayObject
      {
         var entity:IDisplayable = null;
         if(_holder.getEntity(this._entityId))
         {
            entity = DofusEntities.getEntity(this._entityId) as IDisplayable;
            entity.display();
            _holder.unholdEntity(this._entityId);
         }
         return DofusEntities.getEntity(this._entityId) as DisplayObject;
      }
   }
}
