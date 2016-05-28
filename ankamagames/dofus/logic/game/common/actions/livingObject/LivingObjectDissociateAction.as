package com.ankamagames.dofus.logic.game.common.actions.livingObject
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LivingObjectDissociateAction implements Action
   {
       
      private var _livingUID:uint;
      
      private var _livingPosition:uint;
      
      public function LivingObjectDissociateAction()
      {
         super();
      }
      
      public static function create(livingUID:uint, livingPosition:uint) : LivingObjectDissociateAction
      {
         var action:LivingObjectDissociateAction = new LivingObjectDissociateAction();
         action._livingUID = livingUID;
         action._livingPosition = livingPosition;
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
   }
}
