package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyInvitationAction implements Action
   {
       
      private var _name:String;
      
      public function PartyInvitationAction()
      {
         super();
      }
      
      public static function create(name:String) : PartyInvitationAction
      {
         var a:PartyInvitationAction = new PartyInvitationAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
