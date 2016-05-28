package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInformationsRequestAction implements Action
   {
       
      private var _type:uint;
      
      public function GuildInformationsRequestAction()
      {
         super();
      }
      
      public static function create(type:uint = 1) : GuildInformationsRequestAction
      {
         var a:GuildInformationsRequestAction = new GuildInformationsRequestAction();
         a._type = type;
         return a;
      }
      
      public function get type() : uint
      {
         return this._type;
      }
   }
}
