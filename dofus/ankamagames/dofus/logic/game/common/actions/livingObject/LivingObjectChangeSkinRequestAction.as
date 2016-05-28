package com.ankamagames.dofus.logic.game.common.actions.livingObject
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LivingObjectChangeSkinRequestAction implements Action
   {
       
      private var _livingUID:uint;
      
      private var _livingPosition:uint;
      
      private var _skinId:uint;
      
      public function LivingObjectChangeSkinRequestAction()
      {
         super();
      }
      
      public static function create(livingUID:uint, livingPosition:uint, skinId:uint) : LivingObjectChangeSkinRequestAction
      {
         var action:LivingObjectChangeSkinRequestAction = new LivingObjectChangeSkinRequestAction();
         action._livingUID = livingUID;
         action._livingPosition = livingPosition;
         action._skinId = skinId;
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
      
      public function get skinId() : uint
      {
         return this._skinId;
      }
   }
}
