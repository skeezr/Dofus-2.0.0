package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierSubEntityBehaviour;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import flash.events.Event;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarriedDirectionModifier;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightCarryCharacterStep extends AbstractSequencable implements IFightStep
   {
      
      static const CARRIED_SUBENTITY_CATEGORY:uint = 3;
      
      static const CARRIED_SUBENTITY_INDEX:uint = 0;
      
      private static var _holder:FightEntitiesHolder = FightEntitiesHolder.getInstance();
       
      private var _fighterId:int;
      
      private var _carriedId:int;
      
      private var _carrySubSequence:ISequencer;
      
      public function FightCarryCharacterStep(fighterId:int, carriedId:int)
      {
         super();
         this._fighterId = fighterId;
         this._carriedId = carriedId;
      }
      
      public function get stepType() : String
      {
         return "carryCharacter";
      }
      
      override public function start() : void
      {
         var carryingEntity:IEntity = DofusEntities.getEntity(this._fighterId);
         var carriedEntity:IEntity = DofusEntities.getEntity(this._carriedId);
         if(!carryingEntity || !carriedEntity)
         {
            _log.warn("Unable to make " + this._fighterId + " carry " + this._carriedId + ", one of them is not in the stage.");
            this.carryFinished();
            return;
         }
         if(carryingEntity is TiphonSprite && carriedEntity is TiphonSprite && TiphonSprite(carriedEntity).parentSprite == carryingEntity)
         {
            executeCallbacks();
            return;
         }
         var visible:Boolean = !!_holder.getEntity(carriedEntity.id)?false:true;
         this._carrySubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(carryingEntity is TiphonSprite)
         {
            this._carrySubSequence.addStep(new SetDirectionStep(carryingEntity as TiphonSprite,carryingEntity.position.advancedOrientationTo(carriedEntity.position)));
         }
         var look:TiphonEntityLook = (carriedEntity as TiphonSprite).look;
         if(!visible)
         {
            look.resetSkins();
            look.setBone(761);
         }
         DisplayObject(carriedEntity).x = 0;
         DisplayObject(carriedEntity).y = 0;
         this._carrySubSequence.addStep(new FightAddSubEntityStep(this._fighterId,this._carriedId,CARRIED_SUBENTITY_CATEGORY,CARRIED_SUBENTITY_INDEX,new CarrierSubEntityBehaviour((carriedEntity as AnimatedCharacter).alpha)));
         if(carryingEntity is TiphonSprite)
         {
            this._carrySubSequence.addStep(new PlayAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_PICKUP,false));
            this._carrySubSequence.addStep(new SetAnimationStep(carryingEntity as TiphonSprite,AnimationEnum.ANIM_STATIQUE_CARRYING));
         }
         this._carrySubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.carryFinished);
         this._carrySubSequence.start();
      }
      
      private function carryFinished(e:Event = null) : void
      {
         if(this._carrySubSequence)
         {
            this._carrySubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.carryFinished);
            this._carrySubSequence = null;
         }
         var carryingEntity:IEntity = DofusEntities.getEntity(this._fighterId);
         if(Boolean(carryingEntity) && carryingEntity is TiphonSprite)
         {
            (carryingEntity as TiphonSprite).animationModifier = CarrierAnimationModifier.getInstance();
         }
         var carriedEntity:IEntity = DofusEntities.getEntity(this._carriedId);
         DisplayObject(carriedEntity).x = 0;
         DisplayObject(carriedEntity).y = 0;
         if(Boolean(carriedEntity) && carriedEntity is TiphonSprite)
         {
            (carriedEntity as TiphonSprite).directionModifier = CarriedDirectionModifier.getInstance();
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_CARRY,[this._fighterId,this._carriedId]);
         executeCallbacks();
      }
   }
}
