package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class Fight
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Fight));
       
      public var fightId:uint;
      
      public var teams:Vector.<com.ankamagames.dofus.logic.game.roleplay.types.FightTeam>;
      
      public function Fight(fightId:uint, teams:Vector.<com.ankamagames.dofus.logic.game.roleplay.types.FightTeam>)
      {
         super();
         this.fightId = fightId;
         this.teams = teams;
      }
      
      public function getTeamByType(teamType:uint) : com.ankamagames.dofus.logic.game.roleplay.types.FightTeam
      {
         var team:com.ankamagames.dofus.logic.game.roleplay.types.FightTeam = null;
         for each(team in this.teams)
         {
            if(team.teamType == teamType)
            {
               return team;
            }
         }
         return null;
      }
   }
}
