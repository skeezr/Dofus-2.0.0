package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TeleportRequestAction implements Action
   {
       
      private var _mapId:uint;
      
      private var _teleportType:uint;
      
      private var _cost:uint;
      
      public function TeleportRequestAction()
      {
         super();
      }
      
      public static function create(teleportType:uint, mapId:uint, cost:uint) : TeleportRequestAction
      {
         var action:TeleportRequestAction = new TeleportRequestAction();
         action._teleportType = teleportType;
         action._mapId = mapId;
         action._cost = cost;
         return action;
      }
      
      public function get mapId() : uint
      {
         return this._mapId;
      }
      
      public function get teleportType() : uint
      {
         return this._teleportType;
      }
      
      public function get cost() : uint
      {
         return this._cost;
      }
   }
}
