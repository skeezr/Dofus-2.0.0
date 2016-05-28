package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChallengeTargetsListRequestAction implements Action
   {
       
      private var _challengeId:uint;
      
      public function ChallengeTargetsListRequestAction()
      {
         super();
      }
      
      public static function create(challengeId:uint) : ChallengeTargetsListRequestAction
      {
         var a:ChallengeTargetsListRequestAction = new ChallengeTargetsListRequestAction();
         a._challengeId = challengeId;
         return a;
      }
      
      public function get challengeId() : uint
      {
         return this._challengeId;
      }
   }
}
