package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class EmotePlayRequestAction implements Action
   {
       
      private var _emoteId:uint;
      
      public function EmotePlayRequestAction()
      {
         super();
      }
      
      public static function create(emoteId:uint) : EmotePlayRequestAction
      {
         var a:EmotePlayRequestAction = new EmotePlayRequestAction();
         a._emoteId = emoteId;
         return a;
      }
      
      public function get emoteId() : uint
      {
         return this._emoteId;
      }
   }
}
