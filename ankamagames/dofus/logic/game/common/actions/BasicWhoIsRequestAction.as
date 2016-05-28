package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class BasicWhoIsRequestAction implements Action
   {
       
      private var _playerName:String;
      
      public function BasicWhoIsRequestAction()
      {
         super();
      }
      
      public static function create(playerName:String) : BasicWhoIsRequestAction
      {
         var a:BasicWhoIsRequestAction = new BasicWhoIsRequestAction();
         a._playerName = playerName;
         return a;
      }
      
      public function get playerName() : String
      {
         return this._playerName;
      }
   }
}
