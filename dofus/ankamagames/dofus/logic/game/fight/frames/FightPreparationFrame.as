package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPossiblePositionsMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightReadyAction;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightReadyMessage;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.GameContextKickAction;
   import com.ankamagames.dofus.network.messages.game.context.GameContextKickMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPositionRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionErrorMessage;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   
   public class FightPreparationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightPreparationFrame));
      
      private static const COLOR_CHALLENGER:Color = new Color(255);
      
      private static const COLOR_DEFENDER:Color = new Color(16711680);
      
      private static const SELECTION_CHALLENGER:String = "FightPlacementChallengerTeam";
      
      private static const SELECTION_DEFENDER:String = "FightPlacementDefenderTeam";
       
      private var _fightContextFrame:com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
      
      private var _playerTeam:uint;
      
      private var _challengerPositions:Vector.<uint>;
      
      private var _defenderPositions:Vector.<uint>;
      
      public function FightPreparationFrame(fightContextFrame:com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame)
      {
         super();
         this._fightContextFrame = fightContextFrame;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gfpppmsg:GameFightPlacementPossiblePositionsMessage = null;
         var ccmsg:CellClickMessage = null;
         var gfra:GameFightReadyAction = null;
         var gfrmsg:GameFightReadyMessage = null;
         var ecmsg:EntityClickMessage = null;
         var fighter:Object = null;
         var commonMod:Object = null;
         var menu:Array = null;
         var gcka:GameContextKickAction = null;
         var playerId:uint = 0;
         var gckmsg:GameContextKickMessage = null;
         var gfutmsg:GameFightUpdateTeamMessage = null;
         var gfrtmmsg:GameFightRemoveTeamMemberMessage = null;
         var gfpprmsg:GameFightPlacementPositionRequestMessage = null;
         switch(true)
         {
            case msg is GameFightPlacementPossiblePositionsMessage:
               gfpppmsg = msg as GameFightPlacementPossiblePositionsMessage;
               this.displayZone(SELECTION_CHALLENGER,this._challengerPositions = gfpppmsg.positionsForChallengers,COLOR_CHALLENGER);
               this.displayZone(SELECTION_DEFENDER,this._defenderPositions = gfpppmsg.positionsForDefenders,COLOR_DEFENDER);
               this._playerTeam = gfpppmsg.teamNumber;
               return true;
            case msg is CellClickMessage:
               ccmsg = msg as CellClickMessage;
               if(this.isValidPlacementCell(ccmsg.cellId,this._playerTeam))
               {
                  gfpprmsg = new GameFightPlacementPositionRequestMessage();
                  gfpprmsg.initGameFightPlacementPositionRequestMessage(ccmsg.cellId);
                  ConnectionsHandler.getConnection().send(gfpprmsg);
               }
               return true;
            case msg is GameEntityDispositionErrorMessage:
               _log.error("Cette position n\'est pas accessible.");
               return true;
            case msg is GameFightReadyAction:
               gfra = msg as GameFightReadyAction;
               gfrmsg = new GameFightReadyMessage();
               gfrmsg.initGameFightReadyMessage(gfra.isReady);
               ConnectionsHandler.getConnection().send(gfrmsg);
               return true;
            case msg is EntityClickMessage:
               ecmsg = msg as EntityClickMessage;
               if(ecmsg.entity.id < 0)
               {
                  return true;
               }
               fighter = new Object();
               fighter.name = this._fightContextFrame.getFighterName(ecmsg.entity.id);
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               menu = MenusFactory.create(fighter,"player",[ecmsg.entity]);
               commonMod.createContextMenu(menu);
               return true;
            case msg is GameContextKickAction:
               gcka = msg as GameContextKickAction;
               playerId = PlayedCharacterManager.getInstance().infos.id;
               gckmsg = new GameContextKickMessage();
               gckmsg.initGameContextKickMessage(gcka.targetId);
               ConnectionsHandler.getConnection().send(gckmsg);
               return true;
            case msg is GameFightUpdateTeamMessage:
               gfutmsg = msg as GameFightUpdateTeamMessage;
               this._fightContextFrame.isFightLeader = gfutmsg.team.leaderId == PlayedCharacterManager.getInstance().infos.id;
               return true;
            case msg is GameFightRemoveTeamMemberMessage:
               gfrtmmsg = msg as GameFightRemoveTeamMemberMessage;
               this._fightContextFrame.entitiesFrame.process(RemoveEntityAction.create(gfrtmmsg.charId));
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var sc:Selection = SelectionManager.getInstance().getSelection(SELECTION_CHALLENGER);
         if(sc)
         {
            sc.remove();
         }
         var sd:Selection = SelectionManager.getInstance().getSelection(SELECTION_DEFENDER);
         if(sd)
         {
            sd.remove();
         }
         return true;
      }
      
      private function displayZone(name:String, cells:Vector.<uint>, color:Color) : void
      {
         var s:Selection = new Selection();
         s.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_FIGHT_START_PLACEMENT);
         s.color = color;
         s.zone = new Custom(cells);
         SelectionManager.getInstance().addSelection(s,name);
         SelectionManager.getInstance().update(name);
      }
      
      private function isValidPlacementCell(cellId:uint, team:uint) : Boolean
      {
         var validCells:Vector.<uint> = null;
         if(Atouin.getInstance().getEntityOnCell(cellId) != null)
         {
            return false;
         }
         switch(team)
         {
            case TeamEnum.TEAM_CHALLENGER:
               validCells = this._challengerPositions;
               break;
            case TeamEnum.TEAM_DEFENDER:
               validCells = this._defenderPositions;
               break;
            case TeamEnum.TEAM_SPECTATOR:
               return false;
         }
         for(var i:uint = 0; i < validCells.length; i++)
         {
            if(validCells[i] == cellId)
            {
               return true;
            }
         }
         return false;
      }
   }
}
