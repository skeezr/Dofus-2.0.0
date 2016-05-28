package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightThrowCharacterStep extends AbstractSequencable implements IFightStep
   {
      
      private static const THROWING_PROJECTILE_FX:uint = 21109;
      
      private static const THROWING_HIT_FX:uint = 21110;
      
      private static var _holder:FightEntitiesHolder = FightEntitiesHolder.getInstance();
       
      private var _fighterId:int;
      
      private var _carriedId:int;
      
      private var _cellId:int;
      
      private var _throwSubSequence:ISequencer;
      
      public function FightThrowCharacterStep(fighterId:int, carriedId:int, cellId:int)
      {
         super();
         this._fighterId = fighterId;
         this._carriedId = carriedId;
         this._cellId = cellId;
      }
      
      public function get stepType() : String
      {
         return "throwCharacter";
      }
      
      override public function start() : void
      {
         var projectile:Projectile = null;
         var carryingEntity:IEntity = DofusEntities.getEntity(this._fighterId);
         var carriedEntity:IEntity = DofusEntities.getEntity(this._carriedId);
         if(!carryingEntity || !carriedEntity)
         {
            _log.warn("Unable to make " + this._fighterId + " throw " + this._carriedId + ", one of them is not in the stage.");
            this.throwFinished();
            return;
         }
         var invisibility:Boolean = false;
         if(TiphonSprite(carriedEntity).look.getBone() == 761)
         {
            invisibility = true;
         }
         _log.debug(this._fighterId + " is throwing " + this._carriedId + " (invisibility : " + invisibility + ")");
         if(!invisibility)
         {
            _holder.unholdEntity(this._carriedId);
         }
         if(Boolean(carryingEntity) && carryingEntity is TiphonSprite)
         {
            (carryingEntity as TiphonSprite).animationModifier = null;
         }
         this._throwSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(this._cellId == -1 || Boolean(invisibility))
         {
            if(carryingEntity is TiphonSprite)
            {
               this._throwSubSequence.addStep(new SetAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
            }
            this.startSubSequence();
            return;
         }
         var targetCell:MapPoint = MapPoint.fromCellId(this._cellId);
         var targetDistance:int = carryingEntity.position.distanceToCell(targetCell);
         var targetDirection:int = carryingEntity.position.advancedOrientationTo(targetCell);
         carriedEntity.position = targetCell;
         if(carryingEntity is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetDirectionStep(carryingEntity as TiphonSprite,targetDirection));
         }
         if(carriedEntity is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetDirectionStep(carriedEntity as TiphonSprite,targetDirection));
         }
         if(targetDistance == 1)
         {
            _log.debug("Dropping nearby.");
            if(carryingEntity is TiphonSprite)
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_DROP,false));
            }
         }
         else
         {
            _log.debug("Throwing away.");
            if(carryingEntity is TiphonSprite)
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_THROW,false,true,TiphonEvent.ANIMATION_SHOT));
               this._throwSubSequence.addStep(new SetAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
            }
            projectile = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"));
            projectile.position = carryingEntity.position.getNearestCellInDirection(targetDirection);
            this._throwSubSequence.addStep(new AddWorldEntityStep(projectile));
            this._throwSubSequence.addStep(new ParableGfxMovementStep(projectile,targetCell,200,0.3,-70,true,1));
            this._throwSubSequence.addStep(new FightDestroyEntityStep(projectile));
         }
         this._throwSubSequence.addStep(new FightRemoveSubEntityStep(this._fighterId,FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX));
         this._throwSubSequence.addStep(new AddWorldEntityStep(carriedEntity));
         this._throwSubSequence.addStep(new SetAnimationStep(carriedEntity as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         if(carryingEntity is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         }
         if(targetDistance > 1)
         {
            if(carriedEntity is TiphonSprite)
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(carriedEntity as TiphonSprite,AnimationEnum.ANIM_HIT));
            }
            this._throwSubSequence.addStep(new AddGfxEntityStep(THROWING_HIT_FX,targetCell.cellId));
         }
         this.startSubSequence();
      }
      
      private function startSubSequence() : void
      {
         this._throwSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
         this._throwSubSequence.start();
      }
      
      private function throwFinished(e:Event = null) : void
      {
         if(this._throwSubSequence)
         {
            this._throwSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
            this._throwSubSequence = null;
         }
         var carryingEntity:IEntity = DofusEntities.getEntity(this._fighterId);
         var carriedEntity:IEntity = DofusEntities.getEntity(this._carriedId);
         if(Boolean(carryingEntity) && carryingEntity is TiphonSprite)
         {
            (carryingEntity as TiphonSprite).animationModifier = null;
            (carryingEntity as TiphonSprite).removeSubEntity(carriedEntity as DisplayObject);
         }
         if(carriedEntity is IMovable)
         {
            IMovable(carriedEntity).movementBehavior.synchroniseSubEntitiesPosition(IMovable(carriedEntity));
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_THROW,[this._fighterId,this._carriedId,this._cellId]);
         executeCallbacks();
      }
      
      override public function toString() : String
      {
         return "[FightThrowCharacterStep(carrier=" + this._fighterId + ", carried=" + this._carriedId + ", cell=" + this._cellId + ")]";
      }
   }
}
