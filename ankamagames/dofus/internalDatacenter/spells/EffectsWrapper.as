package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   
   public class EffectsWrapper
   {
       
      public var effects:Vector.<EffectInstance>;
      
      public var spellName:String = "";
      
      public function EffectsWrapper(effect:Vector.<EffectInstance>, spell:Spell)
      {
         super();
         this.effects = effect;
         this.spellName = spell.name;
      }
   }
}
