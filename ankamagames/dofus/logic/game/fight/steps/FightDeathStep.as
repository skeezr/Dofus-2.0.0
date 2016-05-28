package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import flash.events.Event;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightDeathStep extends AbstractSequencable implements IFightStep
   {
       
      private var _entityId:int;
      
      private var _deathSubSequence:ISequencer;
      
      private var _naturalDeath:Boolean;
      
      public function FightDeathStep(entityId:int, naturalDeath:Boolean = true)
      {
         super();
         this._entityId = entityId;
         this._naturalDeath = naturalDeath;
      }
      
      public function get stepType() : String
      {
         return "death";
      }
      
      public function get entityId() : int
      {
         return this._entityId;
      }
      
      override public function start() : void
      {
         var dyingEntity:IEntity = DofusEntities.getEntity(this._entityId);
         if(!dyingEntity)
         {
            _log.warn("Unable to play death of an unexisting fighter " + this._entityId + ".");
            this.deathFinished();
            return;
         }
         this._deathSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(dyingEntity is TiphonSprite)
         {
            this._deathSubSequence.addStep(new PlayAnimationStep(dyingEntity as TiphonSprite,AnimationEnum.ANIM_MORT));
            this._deathSubSequence.addStep(new CallbackStep(new Callback(this.onAnimEnd,dyingEntity)));
         }
         this._deathSubSequence.addStep(new FightDestroyEntityStep(dyingEntity));
         this._deathSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.deathFinished);
         this._deathSubSequence.start();
      }
      
      private function onAnimEnd(dyingEntity:TiphonSprite) : void
      {
         var subEntity:* = undefined;
         var subEntities:Array = dyingEntity.getSubEntitiesList();
         for each(subEntity in subEntities)
         {
            if(subEntity is IMovable && subEntity is IDisplayable)
            {
               IDisplayable(subEntity).display();
            }
         }
      }
      
      private function deathFinished(e:Event = null) : void
      {
         if(this._deathSubSequence)
         {
            this._deathSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.deathFinished);
            this._deathSubSequence = null;
         }
         if(this._naturalDeath)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_DEATH,[this._entityId]);
         }
         else
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LEAVE,[this._entityId]);
         }
         executeCallbacks();
      }
   }
}
