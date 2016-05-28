package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction implements Action
   {
       
      private var _allow:Boolean;
      
      public function ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction()
      {
         super();
      }
      
      public static function create(pAllow:Boolean) : ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction
      {
         var action:ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction = new ExchangeMultiCraftSetCrafterCanUseHisRessourcesAction();
         action._allow = pAllow;
         return action;
      }
      
      public function get allow() : Boolean
      {
         return this._allow;
      }
   }
}
