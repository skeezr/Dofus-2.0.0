package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangePlayerMultiCraftRequestAction implements Action
   {
       
      private var _exchangeType:int;
      
      private var _target:uint;
      
      private var _skillId:uint;
      
      public function ExchangePlayerMultiCraftRequestAction()
      {
         super();
      }
      
      public static function create(pExchangeType:int, pTarget:uint, pSkillId:uint) : ExchangePlayerMultiCraftRequestAction
      {
         var action:ExchangePlayerMultiCraftRequestAction = new ExchangePlayerMultiCraftRequestAction();
         action._exchangeType = pExchangeType;
         action._target = pTarget;
         action._skillId = pSkillId;
         return action;
      }
      
      public function get exchangeType() : int
      {
         return this._exchangeType;
      }
      
      public function get target() : uint
      {
         return this._target;
      }
      
      public function get skillId() : uint
      {
         return this._skillId;
      }
   }
}
