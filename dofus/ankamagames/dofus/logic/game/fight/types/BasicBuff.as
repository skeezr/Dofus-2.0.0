package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class BasicBuff
   {
      
      protected static var _unicID:uint = 0;
       
      protected var _id:uint;
      
      protected var _effect:EffectInstance;
      
      public var duration:uint;
      
      public var castingSpell:com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
      
      public var targetId:int;
      
      public var critical:Boolean = false;
      
      public var dispellable:Boolean = true;
      
      public var actionId:uint;
      
      public var id:uint;
      
      public function BasicBuff(targetId:int, castingSpell:com.ankamagames.dofus.logic.game.fight.types.CastingSpell, actionId:uint, param1:*, param2:*, param3:*, duration:uint)
      {
         super();
         this.actionId = actionId;
         this.targetId = targetId;
         this.castingSpell = castingSpell;
         this.duration = duration;
         this._effect = EffectInstance.create(actionId,duration,param1,param2,param3,0,0,0,0);
      }
      
      public function get effects() : EffectInstance
      {
         return this._effect;
      }
      
      public function get type() : String
      {
         return "BasicBuff";
      }
      
      public function get param1() : *
      {
         return this._effect.param1;
      }
      
      public function get param2() : *
      {
         return this._effect.param2;
      }
      
      public function get param3() : *
      {
         return this._effect.param3;
      }
      
      public function set param1(v:*) : void
      {
         this._effect.param1 = v == 0?null:v;
      }
      
      public function set param2(v:*) : void
      {
         this._effect.param2 = v == 0?null:v;
      }
      
      public function set param3(v:*) : void
      {
         this._effect.param3 = v == 0?null:v;
      }
      
      public function canBeDispell(forceUndispellable:Boolean = false, criticalDispell:Boolean = false) : Boolean
      {
         return (!this.critical || Boolean(criticalDispell)) && (Boolean(this.dispellable) || Boolean(forceUndispellable));
      }
      
      public function onRemoved() : void
      {
      }
      
      public function onApplyed() : void
      {
      }
   }
}
