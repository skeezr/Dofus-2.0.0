package com.ankamagames.dofus.logic.game.common.actions.spectator
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MapRunningFightDetailsRequestAction implements Action
   {
       
      private var _fightId:uint;
      
      public function MapRunningFightDetailsRequestAction()
      {
         super();
      }
      
      public static function create(fightId:uint) : MapRunningFightDetailsRequestAction
      {
         var a:MapRunningFightDetailsRequestAction = new MapRunningFightDetailsRequestAction();
         a._fightId = fightId;
         return a;
      }
      
      public function get fightId() : uint
      {
         return this._fightId;
      }
   }
}
