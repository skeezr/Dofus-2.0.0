package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PlaySoundAction implements Action
   {
       
      private var _soundId:String;
      
      public function PlaySoundAction()
      {
         super();
      }
      
      public static function create(pSoundId:String) : PlaySoundAction
      {
         var action:PlaySoundAction = new PlaySoundAction();
         action._soundId = pSoundId;
         return action;
      }
      
      public function get soundId() : String
      {
         return this._soundId;
      }
   }
}
