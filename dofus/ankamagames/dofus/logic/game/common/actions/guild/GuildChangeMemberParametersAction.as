package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildChangeMemberParametersAction implements Action
   {
       
      private var _memberId:uint;
      
      private var _rank:uint;
      
      private var _experienceGivenPercent:uint;
      
      private var _rights:Array;
      
      public function GuildChangeMemberParametersAction()
      {
         super();
      }
      
      public static function create(pMemberId:uint, pRank:uint, pExperienceGivenPercent:uint, pRights:Array) : GuildChangeMemberParametersAction
      {
         var action:GuildChangeMemberParametersAction = new GuildChangeMemberParametersAction();
         action._memberId = pMemberId;
         action._rank = pRank;
         action._experienceGivenPercent = pExperienceGivenPercent;
         action._rights = pRights;
         return action;
      }
      
      public function get memberId() : uint
      {
         return this._memberId;
      }
      
      public function get rank() : uint
      {
         return this._rank;
      }
      
      public function get experienceGivenPercent() : uint
      {
         return this._experienceGivenPercent;
      }
      
      public function get rights() : Array
      {
         return this._rights;
      }
   }
}
