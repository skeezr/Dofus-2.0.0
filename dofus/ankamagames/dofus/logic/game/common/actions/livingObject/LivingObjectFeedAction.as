package com.ankamagames.dofus.logic.game.common.actions.livingObject
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LivingObjectFeedAction implements Action
   {
       
      private var _livingUID:uint;
      
      private var _livingPosition:uint;
      
      private var _foodUID:uint;
      
      public function LivingObjectFeedAction()
      {
         super();
      }
      
      public static function create(livingUID:uint, livingPosition:uint, foodUID:uint) : LivingObjectFeedAction
      {
         var action:LivingObjectFeedAction = new LivingObjectFeedAction();
         action._livingUID = livingUID;
         action._livingPosition = livingPosition;
         action._foodUID = foodUID;
         return action;
      }
      
      public function get livingUID() : uint
      {
         return this._livingUID;
      }
      
      public function get livingPosition() : uint
      {
         return this._livingPosition;
      }
      
      public function get foodUID() : uint
      {
         return this._foodUID;
      }
   }
}
