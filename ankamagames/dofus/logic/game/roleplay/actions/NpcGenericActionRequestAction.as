package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NpcGenericActionRequestAction implements Action
   {
       
      private var _npcId:int;
      
      private var _actionId:int;
      
      public function NpcGenericActionRequestAction()
      {
         super();
      }
      
      public static function create(npcId:int, actionId:int) : NpcGenericActionRequestAction
      {
         var a:NpcGenericActionRequestAction = new NpcGenericActionRequestAction();
         a._npcId = npcId;
         a._actionId = actionId;
         return a;
      }
      
      public function get npcId() : int
      {
         return this._npcId;
      }
      
      public function get actionId() : int
      {
         return this._actionId;
      }
   }
}
