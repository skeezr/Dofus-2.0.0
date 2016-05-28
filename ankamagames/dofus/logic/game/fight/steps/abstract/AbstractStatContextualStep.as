package com.ankamagames.dofus.logic.game.fight.steps.abstract
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextual;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import flash.text.TextFormat;
   import com.ankamagames.berilia.types.event.BeriliaEvent;
   import flash.events.Event;
   
   public class AbstractStatContextualStep extends AbstractSequencable
   {
       
      protected var _color:uint;
      
      protected var _value:String;
      
      protected var _targetId:int;
      
      protected var _blocking:Boolean;
      
      protected var _virtual:Boolean;
      
      private var _ccm:CharacteristicContextual;
      
      public function AbstractStatContextualStep(color:uint, value:String, targetId:int, blocking:Boolean = true)
      {
         super();
         this._color = color;
         this._value = value;
         this._targetId = targetId;
         this._blocking = blocking;
      }
      
      override public function start() : void
      {
         if(!this._virtual && this._value != "0" && OptionManager.getOptionManager("tiphon").pointsOverhead != 0)
         {
            this._ccm = CharacteristicContextualManager.getInstance().addStatContextual(this._value,DofusEntities.getEntity(this._targetId),new TextFormat("VerdanaBold",24,this._color,true),OptionManager.getOptionManager("tiphon").pointsOverhead);
         }
         if(!this._ccm)
         {
            executeCallbacks();
            return;
         }
         if(!this._blocking)
         {
            executeCallbacks();
         }
         else
         {
            this._ccm.addEventListener(BeriliaEvent.REMOVE_COMPONENT,this.remove);
         }
      }
      
      private function remove(e:Event) : void
      {
         this._ccm.removeEventListener(BeriliaEvent.REMOVE_COMPONENT,this.remove);
         executeCallbacks();
      }
   }
}
