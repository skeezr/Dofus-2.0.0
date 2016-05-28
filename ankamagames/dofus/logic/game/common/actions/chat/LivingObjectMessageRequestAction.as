package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LivingObjectMessageRequestAction implements Action
   {
       
      private var _msgId:uint;
      
      private var _livingObjectUID:uint;
      
      public function LivingObjectMessageRequestAction()
      {
         super();
      }
      
      public static function create(msgId:uint, livingObjectUID:uint) : LivingObjectMessageRequestAction
      {
         var a:LivingObjectMessageRequestAction = new LivingObjectMessageRequestAction();
         a._msgId = msgId;
         a._livingObjectUID = livingObjectUID;
         return a;
      }
      
      public function get msgId() : uint
      {
         return this._msgId;
      }
      
      public function get livingObjectUID() : uint
      {
         return this._livingObjectUID;
      }
   }
}
