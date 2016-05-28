package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class EffectsListWrapper
   {
       
      public var effects:Vector.<EffectInstance>;
      
      public function EffectsListWrapper(effect:Vector.<EffectInstance>)
      {
         super();
         this.effects = effect;
      }
   }
}
