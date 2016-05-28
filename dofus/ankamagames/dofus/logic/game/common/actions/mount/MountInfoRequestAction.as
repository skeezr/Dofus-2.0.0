package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class MountInfoRequestAction implements Action
   {
      
      public static const EFFECT_ID_MOUNT:int = 995;
      
      public static const EFFECT_ID_VALIDITY:int = 998;
       
      private var _item:ItemWrapper;
      
      private var _mountId:Number;
      
      private var _time:Number;
      
      public function MountInfoRequestAction()
      {
         super();
      }
      
      public static function create(item:ItemWrapper) : MountInfoRequestAction
      {
         var effect:EffectInstance = null;
         var o:MountInfoRequestAction = new MountInfoRequestAction();
         o._item = item;
         for each(effect in item.effects)
         {
            switch(effect.effectId)
            {
               case EFFECT_ID_MOUNT:
                  o._time = effect.param1;
                  o._mountId = effect.param3;
                  continue;
               default:
                  continue;
            }
         }
         return o;
      }
      
      public function get mountId() : Number
      {
         return this._mountId;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
   }
}
