package com.ankamagames.dofus.factories
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.network.enums.AlignmentSideEnum;
   import com.ankamagames.dofusModuleLibrary.enum.AlignementSideEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.enums.FightTypeEnum;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class RolePlayEntitiesFactory
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RolePlayEntitiesFactory));
      
      private static const TEAM_CHALLENGER_LOOK:TiphonEntityLook = TiphonEntityLook.fromString("{19}");
      
      private static const TEAM_DEFENDER_LOOK:TiphonEntityLook = TiphonEntityLook.fromString("{20}");
      
      private static const TEAM_TAX_COLLECTOR_LOOK:TiphonEntityLook = TiphonEntityLook.fromString("{21}");
      
      private static const TEAM_ANGEL_LOOK:TiphonEntityLook = TiphonEntityLook.fromString("{32}");
      
      private static const TEAM_DEMON_LOOK:TiphonEntityLook = TiphonEntityLook.fromString("{33}");
       
      public function RolePlayEntitiesFactory()
      {
         super();
      }
      
      public static function createFightEntity(fightInfos:FightCommonInformations, teamInfos:FightTeamInformations, position:MapPoint) : IEntity
      {
         var entityId:int = EntitiesManager.getInstance().getFreeEntityId();
         var teamLook:TiphonEntityLook = null;
         switch(fightInfos.fightType)
         {
            case FightTypeEnum.FIGHT_TYPE_AGRESSION:
            case FightTypeEnum.FIGHT_TYPE_PvMA:
               switch(teamInfos.teamSide)
               {
                  case AlignmentSideEnum.ALIGNMENT_ANGEL:
                     teamLook = TEAM_ANGEL_LOOK;
                     break;
                  case AlignementSideEnum.ALIGNMENT_EVIL:
                     teamLook = TEAM_DEMON_LOOK;
                     break;
                  case AlignementSideEnum.ALIGNMENT_NEUTRAL:
                  case AlignementSideEnum.ALIGNMENT_WITHOUT:
                  case AlignementSideEnum.ALIGNMENT_MERCENARY:
                     teamLook = TEAM_CHALLENGER_LOOK;
               }
               break;
            case FightTypeEnum.FIGHT_TYPE_PvT:
               switch(teamInfos.teamId)
               {
                  case TeamEnum.TEAM_DEFENDER:
                     teamLook = TEAM_TAX_COLLECTOR_LOOK;
                     break;
                  case TeamEnum.TEAM_CHALLENGER:
                     teamLook = TEAM_CHALLENGER_LOOK;
               }
               break;
            case FightTypeEnum.FIGHT_TYPE_CHALLENGE:
               teamLook = TEAM_CHALLENGER_LOOK;
               break;
            default:
               switch(teamInfos.teamId)
               {
                  case TeamEnum.TEAM_CHALLENGER:
                     teamLook = TEAM_CHALLENGER_LOOK;
                     break;
                  case TeamEnum.TEAM_DEFENDER:
                     teamLook = TEAM_DEFENDER_LOOK;
               }
         }
         var challenger:IEntity = new AnimatedCharacter(entityId,teamLook);
         challenger.position = position;
         IAnimated(challenger).setDirection(0);
         return challenger;
      }
   }
}
