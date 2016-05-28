package com.ankamagames.dofus.misc
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectDate;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectMount;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectString;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectInteger;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectMinMax;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectDice;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectDuration;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectCreature;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffectLadder;
   
   public class ObjectEffectAdapter
   {
       
      public function ObjectEffectAdapter()
      {
         super();
      }
      
      public static function fromNetwork(oe:ObjectEffect) : EffectInstance
      {
         var oed:ObjectEffectDate = null;
         var day:String = null;
         var month:String = null;
         var hour:String = null;
         var minute:String = null;
         var o:ObjectEffectMount = null;
         var effect:EffectInstance = new EffectInstance();
         effect.effectId = oe.actionId;
         effect.duration = 0;
         switch(true)
         {
            case oe is ObjectEffectString:
               effect.param4 = ObjectEffectString(oe).value;
               break;
            case oe is ObjectEffectInteger:
               effect.param1 = ObjectEffectInteger(oe).value;
               break;
            case oe is ObjectEffectMinMax:
               effect.param1 = ObjectEffectMinMax(oe).min;
               if(effect.param1 != ObjectEffectMinMax(oe).max)
               {
                  effect.param2 = ObjectEffectMinMax(oe).max;
               }
               break;
            case oe is ObjectEffectDice:
               effect.param1 = ObjectEffectDice(oe).diceNum;
               effect.param2 = ObjectEffectDice(oe).diceSide;
               effect.param3 = ObjectEffectDice(oe).diceConst;
               break;
            case oe is ObjectEffectDate:
               oed = oe as ObjectEffectDate;
               day = oed.day > 9?new String(oed.day):"0" + new String(oed.day);
               month = oed.month > 9?new String(oed.month):"0" + new String(oed.month);
               hour = oed.hour > 9?new String(oed.hour):"0" + new String(oed.hour);
               minute = oed.minute > 9?new String(oed.minute):"0" + new String(oed.minute);
               effect.param1 = new String(oed.year);
               effect.param2 = month + day;
               effect.param3 = hour + minute;
               break;
            case oe is ObjectEffectDuration:
               effect.param1 = ObjectEffectDuration(oe).days;
               effect.param2 = ObjectEffectDuration(oe).hours;
               effect.param3 = ObjectEffectDuration(oe).minutes;
               break;
            case oe is ObjectEffectCreature:
               effect.param1 = ObjectEffectCreature(oe).monsterFamilyId;
               break;
            case oe is ObjectEffectLadder:
               effect.param1 = ObjectEffectLadder(oe).monsterFamilyId;
               effect.param2 = ObjectEffectLadder(oe).monsterCount;
               break;
            case oe is ObjectEffectMount:
               o = ObjectEffectMount(oe);
               effect.param1 = o.date;
               effect.param2 = o.modelId;
               effect.param3 = o.mountId;
         }
         return effect;
      }
   }
}
