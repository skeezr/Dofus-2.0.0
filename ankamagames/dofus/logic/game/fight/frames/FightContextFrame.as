package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeMessage;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionToggleMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.TogglePointCellAction;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateRequestMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.ChallengeTargetsListRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporarySpellBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostStateEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTriggeredEffect;
   import com.ankamagames.dofus.internalDatacenter.fight.FightResultEntryWrapper;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.context.GameContextReadyMessage;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.dofus.network.enums.FightOptionsEnum;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEventsHelper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPlayerListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultTaxCollectorListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultFighterListEntry;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.network.enums.FightOutcomeEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleWitnessForbiddenAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockPartyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockFightAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleHelpWantedAction;
   import com.ankamagames.dofus.logic.game.roleplay.types.FighterTooltipInformation;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.atouin.utils.DataMapProvider;
   
   public class FightContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame));
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
      
      public static var preFightIsActive:Boolean = true;
      
      public static var fighterEntityTooltipId:int;
       
      private const TYPE_LOG_FIGHT:uint = 30000.0;
      
      private var _entitiesFrame:com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
      
      private var _preparationFrame:com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
      
      private var _battleFrame:com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
      
      private var _pointCellFrame:com.ankamagames.dofus.logic.game.fight.frames.FightPointCellFrame;
      
      private var _rangeSelection:Selection;
      
      public var _challengesList:Array;
      
      private var _fightType:uint;
      
      public var isFightLeader:Boolean;
      
      public function FightContextFrame()
      {
         super();
         _self = this;
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame
      {
         return _self;
      }
      
      public static function destroy() : void
      {
         _self = null;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get entitiesFrame() : com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      public function get battleFrame() : com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame
      {
         return this._battleFrame;
      }
      
      public function get challengesList() : Array
      {
         return this._challengesList;
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function pushed() : Boolean
      {
         if(!Kernel.beingInReconection)
         {
            Atouin.getInstance().displayGrid(true);
         }
         this._entitiesFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame();
         this._preparationFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame(this);
         this._battleFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame();
         this._pointCellFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightPointCellFrame();
         this._challengesList = new Array();
         return true;
      }
      
      public function getFighterName(fighterId:int) : String
      {
         var fighterInfos:GameFightFighterInformations = null;
         var taxInfos:GameFightTaxCollectorInformations = null;
         fighterInfos = this.getFighterInfos(fighterId);
         if(!fighterInfos)
         {
            return "Unknown Fighter";
         }
         switch(true)
         {
            case fighterInfos is GameFightFighterNamedInformations:
               return (fighterInfos as GameFightFighterNamedInformations).name;
            case fighterInfos is GameFightMonsterInformations:
               return Monster.getMonsterById((fighterInfos as GameFightMonsterInformations).creatureGenericId).name;
            case fighterInfos is GameFightTaxCollectorInformations:
               taxInfos = fighterInfos as GameFightTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(taxInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(taxInfos.lastNameId).name;
            default:
               return "Unknown Fighter Type";
         }
      }
      
      public function getFighterLevel(fighterId:int) : uint
      {
         var fighterInfos:GameFightFighterInformations = null;
         var monster:Monster = null;
         fighterInfos = this.getFighterInfos(fighterId);
         if(!fighterInfos)
         {
            return 0;
         }
         switch(true)
         {
            case fighterInfos is GameFightMutantInformations:
               return (fighterInfos as GameFightMutantInformations).powerLevel;
            case fighterInfos is GameFightCharacterInformations:
               return (fighterInfos as GameFightCharacterInformations).level;
            case fighterInfos is GameFightMonsterInformations:
               monster = Monster.getMonsterById((fighterInfos as GameFightMonsterInformations).creatureGenericId);
               return monster.getMonsterGrade((fighterInfos as GameFightMonsterInformations).creatureGrade).level;
            case fighterInfos is GameFightTaxCollectorInformations:
               return (fighterInfos as GameFightTaxCollectorInformations).level;
            default:
               return 0;
         }
      }
      
      public function getChallengeById(challengeId:uint) : ChallengeWrapper
      {
         var challenge:ChallengeWrapper = null;
         for each(challenge in this._challengesList)
         {
            if(challenge.id == challengeId)
            {
               return challenge;
            }
         }
         return null;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gfsmsg:GameFightStartingMessage = null;
         var mcmsg:CurrentMapMessage = null;
         var wp:WorldPoint = null;
         var gfrmsg:GameFightResumeMessage = null;
         var castingSpellPool:Array = null;
         var targetPool:Array = null;
         var durationPool:Array = null;
         var castingSpell:CastingSpell = null;
         var gfjmsg:GameFightJoinMessage = null;
         var timeBeforeStart:int = 0;
         var emovmsg:EntityMouseOverMessage = null;
         var s:Selection = null;
         var teoa:TimelineEntityOverAction = null;
         var gfosumsg:GameFightOptionStateUpdateMessage = null;
         var option:uint = 0;
         var gfotmsg:GameFightOptionToggleMessage = null;
         var option2:uint = 0;
         var gfotmsg2:GameFightOptionToggleMessage = null;
         var option3:uint = 0;
         var gfotmsg3:GameFightOptionToggleMessage = null;
         var option4:uint = 0;
         var gfotmsg4:GameFightOptionToggleMessage = null;
         var tpca:TogglePointCellAction = null;
         var gfemsg:GameFightEndMessage = null;
         var gccrmsg:GameContextCreateRequestMessage = null;
         var ctlra:ChallengeTargetsListRequestAction = null;
         var ctlrmsg:ChallengeTargetsListRequestMessage = null;
         var ctlmsg:ChallengeTargetsListMessage = null;
         var cimsg:ChallengeInfoMessage = null;
         var challenge:ChallengeWrapper = null;
         var crmsg:ChallengeResultMessage = null;
         var moumsg:MapObstacleUpdateMessage = null;
         var spellCooldown:GameFightSpellCooldown = null;
         var spellW:SpellWrapper = null;
         var buff:FightDispellableEffectExtendedInformations = null;
         var buffTmp:BasicBuff = null;
         var gafdemsg:FightTemporarySpellBoostEffect = null;
         var ftbse:FightTemporaryBoostStateEffect = null;
         var boostStateBuffVar:String = null;
         var boostStatBuffVar:String = null;
         var isABoost:Boolean = false;
         var fte:FightTriggeredEffect = null;
         var results:Vector.<FightResultEntryWrapper> = null;
         var resultIndex:uint = 0;
         var resultEntry:FightResultListEntry = null;
         var resultsRecap:Object = null;
         var frew:FightResultEntryWrapper = null;
         var cell:Number = NaN;
         var mo:MapObstacle = null;
         switch(true)
         {
            case msg is GameFightStartingMessage:
               gfsmsg = msg as GameFightStartingMessage;
               MapDisplayManager.getInstance().activeIdentifiedElements(false);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStarting,gfsmsg.fightType);
               this._fightType = gfsmsg.fightType;
               SoundManager.getInstance().manager.playUISound(UISoundEnum.INTRO_FIGHT);
               SoundManager.getInstance().manager.playFightMusic();
               return true;
            case msg is CurrentMapMessage:
               mcmsg = msg as CurrentMapMessage;
               wp = WorldPoint.fromMapId(mcmsg.mapId);
               Atouin.getInstance().initPreDisplay(wp);
               Atouin.getInstance().clearEntities();
               Atouin.getInstance().display(wp);
               PlayedCharacterManager.getInstance().currentMap = wp;
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,mcmsg.mapId);
               return true;
            case msg is MapsLoadingCompleteMessage:
               Atouin.getInstance().showWorld(true);
               Atouin.getInstance().displayGrid(true);
               ConnectionsHandler.getConnection().send(new GameContextReadyMessage());
               break;
            case msg is GameFightResumeMessage:
               gfrmsg = msg as GameFightResumeMessage;
               PlayedCharacterManager.getInstance().currentSummonedCreature = gfrmsg.summonCount;
               this._battleFrame.checkEntityCastList(PlayedCharacterManager.getInstance().id);
               for each(spellCooldown in gfrmsg.spellCooldowns)
               {
                  spellW = SpellWrapper.getSpellWrapperById(spellCooldown.spellId,PlayedCharacterManager.getInstance().id);
                  if(spellW)
                  {
                     spellW.actualCooldown = spellCooldown.cooldown;
                     this._battleFrame.updateCastSpell(PlayedCharacterManager.getInstance().id,spellW.id,spellW.spellLevel,spellCooldown.cooldown);
                     KernelEventsManager.getInstance().processCallback(HookList.FightEvent,FightEventEnum.FIGHTER_CASTED_SPELL,[PlayedCharacterManager.getInstance().id,spellW.id,spellW.spellLevel]);
                  }
               }
               castingSpellPool = [];
               for each(buff in gfrmsg.effects)
               {
                  if(!castingSpellPool[buff.effect.targetId])
                  {
                     castingSpellPool[buff.effect.targetId] = [];
                  }
                  targetPool = castingSpellPool[buff.effect.targetId];
                  if(!targetPool[buff.effect.turnDuration])
                  {
                     targetPool[buff.effect.turnDuration] = [];
                  }
                  durationPool = targetPool[buff.effect.turnDuration];
                  castingSpell = durationPool[buff.effect.spellId];
                  if(!castingSpell)
                  {
                     castingSpell = new CastingSpell();
                     castingSpell.casterId = buff.sourceId;
                     castingSpell.spell = Spell.getSpellById(buff.effect.spellId);
                     durationPool[buff.effect.spellId] = castingSpell;
                  }
                  switch(true)
                  {
                     case buff.effect is FightTemporarySpellBoostEffect:
                        gafdemsg = buff.effect as FightTemporarySpellBoostEffect;
                        buffTmp = new BasicBuff(buff.effect.targetId,castingSpell,buff.actionId,gafdemsg.boostedSpellId,null,gafdemsg.delta,buff.effect.turnDuration);
                        break;
                     case buff.effect is FightTemporaryBoostStateEffect:
                        ftbse = buff.effect as FightTemporaryBoostStateEffect;
                        boostStateBuffVar = ActionIdConverter.getActionStatName(buff.actionId);
                        buffTmp = new StateBuff(buff.effect.targetId,castingSpell,buff.actionId,ftbse.stateId,buff.effect.turnDuration,boostStateBuffVar);
                        if(buff.effect.targetId == PlayedCharacterManager.getInstance().id)
                        {
                           if(!PlayedCharacterManager.getInstance().fightStates)
                           {
                              PlayedCharacterManager.getInstance().fightStates = new Array();
                           }
                           PlayedCharacterManager.getInstance().fightStates.push(ftbse.stateId);
                        }
                        break;
                     case buff.effect is FightTemporaryBoostEffect:
                        boostStatBuffVar = ActionIdConverter.getActionStatName(buff.actionId);
                        isABoost = ActionIdConverter.getIsABoost(buff.actionId);
                        buffTmp = new StatBuff(buff.effect.targetId,castingSpell,buff.actionId,FightTemporaryBoostEffect(buff.effect).delta,buff.effect.turnDuration,boostStatBuffVar,isABoost);
                        break;
                     default:
                        fte = buff.effect as FightTriggeredEffect;
                        buffTmp = new BasicBuff(buff.effect.targetId,castingSpell,buff.actionId,fte.param1,fte.param2,fte.param3,buff.effect.turnDuration);
                  }
                  buffTmp.id = buff.effect.uid;
                  BuffManager.getInstance().addBuff(buffTmp);
               }
               Kernel.beingInReconection = false;
               return true;
            case msg is INetworkMessage && INetworkMessage(msg).getMessageId() == GameFightJoinMessage.protocolId:
               gfjmsg = msg as GameFightJoinMessage;
               preFightIsActive = !gfjmsg.isFightStarted;
               this._fightType = gfjmsg.fightType;
               Kernel.getWorker().addFrame(this._entitiesFrame);
               if(!gfjmsg.isSpectator && Boolean(preFightIsActive))
               {
                  Kernel.getWorker().addFrame(this._preparationFrame);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               }
               PlayedCharacterManager.getInstance().isSpectator = gfjmsg.isSpectator;
               PlayedCharacterManager.getInstance().isFighting = true;
               timeBeforeStart = gfjmsg.timeMaxBeforeFightStart;
               if(timeBeforeStart == 0 && Boolean(preFightIsActive))
               {
                  timeBeforeStart = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,gfjmsg.canBeCancelled,gfjmsg.canSayReady,gfjmsg.isSpectator,timeBeforeStart,gfjmsg.fightType);
               return true;
            case msg is GameFightStartMessage:
               preFightIsActive = false;
               Kernel.getWorker().removeFrame(this._preparationFrame);
               this._entitiesFrame.removeSwords();
               Kernel.getWorker().addFrame(this._battleFrame);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               return true;
            case msg is EntityMouseOverMessage:
               emovmsg = msg as EntityMouseOverMessage;
               this.overEntity(emovmsg.entity.id);
               return true;
            case msg is EntityMouseOutMessage:
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               s = SelectionManager.getInstance().getSelection("movementRange");
               if(s)
               {
                  s.remove();
                  this._rangeSelection = null;
               }
               return true;
            case msg is TimelineEntityOverAction:
               teoa = msg as TimelineEntityOverAction;
               this.overEntity(teoa.targetId);
               return true;
            case msg is TimelineEntityOutAction:
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               s = SelectionManager.getInstance().getSelection("movementRange");
               if(s)
               {
                  s.remove();
                  this._rangeSelection = null;
               }
               return true;
            case msg is GameFightOptionStateUpdateMessage:
               gfosumsg = msg as GameFightOptionStateUpdateMessage;
               _log.error("option recue : " + gfosumsg.option + " -> " + gfosumsg.state);
               switch(gfosumsg.option)
               {
                  case FightOptionsEnum.FIGHT_OPTION_SET_SECRET:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionWitnessForbidden,gfosumsg.state);
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionLockParty,gfosumsg.state);
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_SET_CLOSED:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionLockFight,gfosumsg.state);
                     break;
                  case FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP:
                     KernelEventsManager.getInstance().processCallback(HookList.OptionHelpWanted,gfosumsg.state);
               }
               return true;
            case msg is ToggleWitnessForbiddenAction:
               option = FightOptionsEnum.FIGHT_OPTION_SET_SECRET;
               gfotmsg = new GameFightOptionToggleMessage();
               gfotmsg.initGameFightOptionToggleMessage(option);
               ConnectionsHandler.getConnection().send(gfotmsg);
               return true;
            case msg is ToggleLockPartyAction:
               option2 = FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY;
               gfotmsg2 = new GameFightOptionToggleMessage();
               gfotmsg2.initGameFightOptionToggleMessage(option2);
               ConnectionsHandler.getConnection().send(gfotmsg2);
               return true;
            case msg is ToggleLockFightAction:
               option3 = FightOptionsEnum.FIGHT_OPTION_SET_CLOSED;
               gfotmsg3 = new GameFightOptionToggleMessage();
               gfotmsg3.initGameFightOptionToggleMessage(option3);
               ConnectionsHandler.getConnection().send(gfotmsg3);
               return true;
            case msg is ToggleHelpWantedAction:
               option4 = FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP;
               gfotmsg4 = new GameFightOptionToggleMessage();
               gfotmsg4.initGameFightOptionToggleMessage(option4);
               ConnectionsHandler.getConnection().send(gfotmsg4);
               return true;
            case msg is TogglePointCellAction:
               tpca = msg as TogglePointCellAction;
               if(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.fight.frames.FightPointCellFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
                  Kernel.getWorker().removeFrame(this._pointCellFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._pointCellFrame);
               }
               return true;
            case msg is GameFightEndMessage:
               gfemsg = msg as GameFightEndMessage;
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               s = SelectionManager.getInstance().getSelection("movementRange");
               if(s)
               {
                  s.remove();
                  this._rangeSelection = null;
               }
               MapDisplayManager.getInstance().activeIdentifiedElements(true);
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHT_END,[]);
               SoundManager.getInstance().manager.stopFightMusic();
               gccrmsg = new GameContextCreateRequestMessage();
               gccrmsg.initGameContextCreateRequestMessage();
               ConnectionsHandler.getConnection().send(gccrmsg);
               PlayedCharacterManager.getInstance().isFighting = false;
               SpellWrapper.restricted_namespace::removeAllSpellWrapperBut(PlayedCharacterManager.getInstance().id);
               SpellWrapper.restricted_namespace::resetAllCoolDown(PlayedCharacterManager.getInstance().id);
               if(gfemsg.results == null)
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.SpectatorWantLeave);
               }
               else
               {
                  results = new Vector.<FightResultEntryWrapper>(gfemsg.results.length,true);
                  resultIndex = 0;
                  for each(resultEntry in gfemsg.results)
                  {
                     switch(true)
                     {
                        case resultEntry is FightResultPlayerListEntry:
                           frew = new FightResultEntryWrapper(resultEntry,this._entitiesFrame.getEntityInfos((resultEntry as FightResultPlayerListEntry).id) as GameFightFighterInformations);
                           frew.alive = FightResultPlayerListEntry(resultEntry).alive;
                           break;
                        case resultEntry is FightResultTaxCollectorListEntry:
                           frew = new FightResultEntryWrapper(resultEntry,this._entitiesFrame.getEntityInfos((resultEntry as FightResultTaxCollectorListEntry).id) as GameFightFighterInformations);
                           frew.alive = FightResultTaxCollectorListEntry(resultEntry).alive;
                           break;
                        case resultEntry is FightResultFighterListEntry:
                           frew = new FightResultEntryWrapper(resultEntry,this._entitiesFrame.getEntityInfos((resultEntry as FightResultFighterListEntry).id) as GameFightFighterInformations);
                           frew.alive = FightResultFighterListEntry(resultEntry).alive;
                           break;
                        case resultEntry is FightResultListEntry:
                           frew = new FightResultEntryWrapper(resultEntry);
                           return true;
                     }
                     results[resultIndex++] = frew;
                     if(frew.id == PlayedCharacterManager.getInstance().infos.id)
                     {
                        switch(resultEntry.outcome)
                        {
                           case FightOutcomeEnum.RESULT_VICTORY:
                              KernelEventsManager.getInstance().processCallback(TriggerHookList.FightResultVictory);
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_WON);
                              break;
                           case FightOutcomeEnum.RESULT_LOST:
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_LOST);
                        }
                        if(frew.rewards.objects.length >= SpeakingItemManager.GREAT_DROP_LIMIT)
                        {
                           SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_GREAT_DROP);
                        }
                     }
                  }
                  resultsRecap = new Object();
                  resultsRecap.results = results;
                  resultsRecap.ageBonus = gfemsg.ageBonus;
                  resultsRecap.duration = gfemsg.duration;
                  resultsRecap.challenges = this.challengesList;
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightEnd,resultsRecap);
               }
               Kernel.getWorker().removeFrame(this);
               return true;
            case msg is ChallengeTargetsListRequestAction:
               ctlra = msg as ChallengeTargetsListRequestAction;
               ctlrmsg = new ChallengeTargetsListRequestMessage();
               ctlrmsg.initChallengeTargetsListRequestMessage(ctlra.challengeId);
               ConnectionsHandler.getConnection().send(ctlrmsg);
               return true;
            case msg is ChallengeTargetsListMessage:
               ctlmsg = msg as ChallengeTargetsListMessage;
               for each(cell in ctlmsg.targetCells)
               {
                  if(cell != -1)
                  {
                     HyperlinkShowCellManager.showCell(cell);
                  }
               }
               return true;
            case msg is ChallengeInfoMessage:
               cimsg = msg as ChallengeInfoMessage;
               challenge = this.getChallengeById(cimsg.challengeId);
               if(!challenge)
               {
                  challenge = new ChallengeWrapper();
                  this.challengesList.push(challenge);
               }
               challenge.id = cimsg.challengeId;
               challenge.targetId = cimsg.targetId;
               challenge.baseXpBonus = cimsg.baseXpBonus;
               challenge.extraXpBonus = cimsg.extraXpBonus;
               challenge.baseDropBonus = cimsg.baseDropBonus;
               challenge.extraDropBonus = cimsg.extraDropBonus;
               challenge.result = 0;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case msg is ChallengeResultMessage:
               crmsg = msg as ChallengeResultMessage;
               challenge = this.getChallengeById(crmsg.challengeId);
               challenge.result = !!crmsg.success?uint(1):uint(2);
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case msg is MapObstacleUpdateMessage:
               moumsg = msg as MapObstacleUpdateMessage;
               for each(mo in moumsg.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(mo.obstacleCellId,mo.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         if(this._entitiesFrame)
         {
            Kernel.getWorker().removeFrame(this._entitiesFrame);
         }
         if(this._preparationFrame)
         {
            Kernel.getWorker().removeFrame(this._preparationFrame);
         }
         if(this._battleFrame)
         {
            Kernel.getWorker().removeFrame(this._battleFrame);
         }
         if(this._pointCellFrame)
         {
            Kernel.getWorker().removeFrame(this._pointCellFrame);
         }
         this._preparationFrame = null;
         this._battleFrame = null;
         this._pointCellFrame = null;
         Atouin.getInstance().displayGrid(false);
         return true;
      }
      
      private function getFighterInfos(fighterId:int) : GameFightFighterInformations
      {
         return this.entitiesFrame.getEntityInfos(fighterId) as GameFightFighterInformations;
      }
      
      private function overEntity(id:int) : void
      {
         var GameUiCoreMod:Object = null;
         var ref:Object = null;
         var infos2:FighterTooltipInformation = null;
         var range:int = 0;
         fighterEntityTooltipId = id;
         var entity:IEntity = DofusEntities.getEntity(fighterEntityTooltipId);
         if(!entity)
         {
            _log.warn("Mouse over an unknown entity : " + id);
            return;
         }
         var infos:GameFightFighterInformations = this._entitiesFrame.getEntityInfos(entity.id) as GameFightFighterInformations;
         if(!infos)
         {
            _log.warn("Mouse over an unknown entity : " + id);
            return;
         }
         if(Dofus.getInstance().options.showEntityInfos)
         {
            GameUiCoreMod = UiModuleManager.getInstance().getModule("Ankama_GameUiCore").mainClass;
            ref = GameUiCoreMod.getTooltipFightPlacer();
            infos2 = new FighterTooltipInformation(infos);
            TooltipManager.show(infos2,ref,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"fighter",LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
         }
         if(infos.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE)
         {
            _log.warn("Mouse over an invisible entity.");
            return;
         }
         TooltipManager.show(infos,(entity as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,TooltipManager.TOOLTIP_STANDAR_NAME,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
         if(Boolean(Dofus.getInstance().options.showMovementRange) && Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame)) && !Kernel.getWorker().contains(FightSpellCastFrame))
         {
            range = infos.stats.movementPoints;
            range = Math.min(range,AtouinConstants.MAP_WIDTH * AtouinConstants.MAP_HEIGHT);
            this._rangeSelection = new Selection();
            this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
            this._rangeSelection.color = new Color(52326);
            this._rangeSelection.zone = new Lozenge(1,range,DataMapProvider.getInstance());
            SelectionManager.getInstance().addSelection(this._rangeSelection,"movementRange",entity.position.cellId);
         }
      }
   }
}
