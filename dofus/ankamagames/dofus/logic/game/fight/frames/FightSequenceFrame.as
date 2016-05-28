package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCastMessage;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightExchangePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSlideMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightUnmarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightChangeLookMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibilityMessage;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDodgePointLossMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleObstacleMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightKillMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPassNextTurnsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReduceDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStateChangeMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStealKamaMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTackledMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellableEffectMessage;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCloseCombatMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporarySpellBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTriggeredEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostWeaponDamagesEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostStateEffect;
   import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.jerakine.managers.LangManager;
   import flash.utils.getTimer;
   import com.ankamagames.jerakine.script.ScriptExec;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDeathStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkTriggeredStep;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntityMovementStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTeleportStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightExchangePositionsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntitySlideStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSummonStep;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightUnmarkCellsStep;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeLookStep;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTemporaryBoostStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellEffectStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightInvisibleObstacleStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightKillStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSkipNextTurnStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReducedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCastStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEnteringStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLeavingStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightStealingKamasStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTackledStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightThrowCharacterStep;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   
   public class FightSequenceFrame implements Frame, ISpellCastProvider
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSequenceFrame));
       
      private var _fxScriptId:uint;
      
      private var _scriptStarted:uint;
      
      private var _castingSpell:CastingSpell;
      
      private var _stepsBuffer:Vector.<ISequencable>;
      
      public var mustAck:Boolean;
      
      public var ackIdent:int;
      
      private var _fightBattleFrame:com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
      
      private var _fightEntitiesFrame:com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
      
      public function FightSequenceFrame(pFightBattleFrame:com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame)
      {
         super();
         this._fightBattleFrame = pFightBattleFrame;
         this.clearBuffer();
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get castingSpell() : CastingSpell
      {
         return this._castingSpell;
      }
      
      public function get stepsBuffer() : Vector.<ISequencable>
      {
         return this._stepsBuffer;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function get fightEntitiesFrame() : com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame
      {
         if(!this._fightEntitiesFrame)
         {
            this._fightEntitiesFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame) as com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
         }
         return this._fightEntitiesFrame;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gafscmsg:GameActionFightSpellCastMessage = null;
         var critical:* = false;
         var entities:Dictionary = null;
         var fighter:GameFightFighterInformations = null;
         var gmmmsg:GameMapMovementMessage = null;
         var gafpvmsg:GameActionFightPointsVariationMessage = null;
         var gaflpvmsg:GameActionFightLifePointsVariationMessage = null;
         var gaftosmmsg:GameActionFightTeleportOnSameMapMessage = null;
         var gafepmsg:GameActionFightExchangePositionsMessage = null;
         var gafsmsg:GameActionFightSlideMessage = null;
         var gafsnmsg:GameActionFightSummonMessage = null;
         var gafmcmsg:GameActionFightMarkCellsMessage = null;
         var gafucmsg:GameActionFightUnmarkCellsMessage = null;
         var gafclmsg:GameActionFightChangeLookMessage = null;
         var gafimsg:GameActionFightInvisibilityMessage = null;
         var gaflmsg:GameActionFightLeaveMessage = null;
         var entitiesL:Dictionary = null;
         var entityInfosL:GameContextActorInformations = null;
         var gafdmsg:GameActionFightDeathMessage = null;
         var entitiesDictionnary:Dictionary = null;
         var playerId:int = 0;
         var sourceInfos:GameFightFighterInformations = null;
         var targetInfos:GameFightFighterInformations = null;
         var playerInfos:GameFightFighterInformations = null;
         var entityInfos:GameContextActorInformations = null;
         var gafdiemsg:GameActionFightDispellEffectMessage = null;
         var gafdimsg:GameActionFightDispellMessage = null;
         var gafdplmsg:GameActionFightDodgePointLossMessage = null;
         var gafiomsg:GameActionFightInvisibleObstacleMessage = null;
         var gafkmsg:GameActionFightKillMessage = null;
         var gafpntmsg:GameActionFightPassNextTurnsMessage = null;
         var gafredmsg:GameActionFightReduceDamagesMessage = null;
         var gafrfdmsg:GameActionFightReflectDamagesMessage = null;
         var gafrsmsg:GameActionFightReflectSpellMessage = null;
         var gafstcmsg:GameActionFightStateChangeMessage = null;
         var gafskmsg:GameActionFightStealKamaMessage = null;
         var gaftmsg:GameActionFightTackledMessage = null;
         var gaftgtmsg:GameActionFightTriggerGlyphTrapMessage = null;
         var triggeredCellId:int = 0;
         var gaftbmsg:GameActionFightDispellableEffectMessage = null;
         var buff:BasicBuff = null;
         var castingSpell:CastingSpell = null;
         var buffEffect:* = undefined;
         var gafccmsg:GameActionFightCarryCharacterMessage = null;
         var gaftcmsg:GameActionFightThrowCharacterMessage = null;
         var gafdcmsg:GameActionFightDropCharacterMessage = null;
         var gafccmsg2:GameActionFightCloseCombatMessage = null;
         var gcaiL:GameContextActorInformations = null;
         var summonerIdL:int = 0;
         var summonedEntityInfosL:GameFightFighterInformations = null;
         var gcai:GameContextActorInformations = null;
         var summonerId:int = 0;
         var summonedEntityInfos:GameFightFighterInformations = null;
         var gafdemsg:FightTemporarySpellBoostEffect = null;
         var fte:FightTriggeredEffect = null;
         var ftbwde:FightTemporaryBoostWeaponDamagesEffect = null;
         var ftbse:FightTemporaryBoostStateEffect = null;
         var boostStateBuffVar:String = null;
         var boostStatBuffVar:String = null;
         var isABoost:Boolean = false;
         switch(true)
         {
            case msg is GameActionFightCloseCombatMessage:
            case msg is GameActionFightSpellCastMessage:
               if(msg is GameActionFightSpellCastMessage)
               {
                  gafscmsg = msg as GameActionFightSpellCastMessage;
               }
               else
               {
                  gafccmsg2 = msg as GameActionFightCloseCombatMessage;
                  gafscmsg = new GameActionFightSpellCastMessage();
                  gafscmsg.initGameActionFightSpellCastMessage(gafccmsg2.actionId,gafccmsg2.sourceId,gafccmsg2.destinationCellId,gafccmsg2.critical,gafccmsg2.silentCast,0,1);
               }
               critical = gafscmsg.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               entities = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               fighter = entities[gafscmsg.sourceId];
               this.pushSpellCriticalEffect(gafscmsg.critical,fighter.disposition.cellId);
               this.pushSpellCastStep(gafscmsg.sourceId,gafscmsg.spellId,gafscmsg.spellLevel,gafscmsg.critical);
               if(gafscmsg.sourceId == PlayedCharacterManager.getInstance().infos.id)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.FightSpellCast);
               }
               this._castingSpell = new CastingSpell();
               this._castingSpell.casterId = gafscmsg.sourceId;
               this._castingSpell.spell = Spell.getSpellById(gafscmsg.spellId);
               this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(gafscmsg.spellLevel);
               this._castingSpell.isCriticalFail = gafscmsg.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL;
               this._castingSpell.isCriticalHit = gafscmsg.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               this._castingSpell.silentCast = gafscmsg.silentCast;
               if(gafscmsg.destinationCellId != -1)
               {
                  this._castingSpell.targetedCell = MapPoint.fromCellId(gafscmsg.destinationCellId);
               }
               if(this._castingSpell.isCriticalFail)
               {
                  this._fxScriptId = 0;
               }
               else
               {
                  this._fxScriptId = this._castingSpell.spell.scriptId;
                  this._fightBattleFrame.updateCastSpell(gafscmsg.sourceId,gafscmsg.spellId,gafscmsg.spellLevel);
               }
               if(msg is GameActionFightCloseCombatMessage)
               {
                  this._fxScriptId = 7;
                  this._castingSpell.weaponId = GameActionFightCloseCombatMessage(msg).weaponGenericId;
               }
               playerId = PlayedCharacterManager.getInstance().infos.id;
               sourceInfos = this.fightEntitiesFrame.getEntityInfos(gafscmsg.sourceId) as GameFightFighterInformations;
               playerInfos = this.fightEntitiesFrame.getEntityInfos(playerId) as GameFightFighterInformations;
               if(critical)
               {
                  if(gafscmsg.sourceId == PlayedCharacterManager.getInstance().infos.id)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_OWNER);
                  }
                  else if(Boolean(playerInfos) && sourceInfos.teamId == playerInfos.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ENEMY);
                  }
               }
               else if(gafscmsg.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
               {
                  if(gafscmsg.sourceId == PlayedCharacterManager.getInstance().infos.id)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_OWNER);
                  }
                  else if(Boolean(playerInfos) && sourceInfos.teamId == playerInfos.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ENEMY);
                  }
               }
               return true;
            case msg is GameMapMovementMessage:
               gmmmsg = msg as GameMapMovementMessage;
               if(gmmmsg.actorId == PlayedCharacterManager.getInstance().infos.id)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerFightMove);
               }
               this.pushMovementStep(gmmmsg.actorId,MapMovementAdapter.getClientMovement(gmmmsg.keyMovements));
               return true;
            case msg is GameActionFightPointsVariationMessage:
               gafpvmsg = msg as GameActionFightPointsVariationMessage;
               this.pushPointsVariationStep(gafpvmsg.targetId,gafpvmsg.actionId,gafpvmsg.delta);
               return true;
            case msg is GameActionFightLifePointsVariationMessage:
               gaflpvmsg = msg as GameActionFightLifePointsVariationMessage;
               this.pushLifePointsVariationStep(gaflpvmsg.targetId,gaflpvmsg.delta);
               return true;
            case msg is GameActionFightTeleportOnSameMapMessage:
               gaftosmmsg = msg as GameActionFightTeleportOnSameMapMessage;
               this.pushTeleportStep(gaftosmmsg.targetId,gaftosmmsg.cellId);
               return true;
            case msg is GameActionFightExchangePositionsMessage:
               gafepmsg = msg as GameActionFightExchangePositionsMessage;
               this.pushExchangePositionsStep(gafepmsg.sourceId,gafepmsg.casterCellId,gafepmsg.targetId,gafepmsg.targetCellId);
               return true;
            case msg is GameActionFightSlideMessage:
               gafsmsg = msg as GameActionFightSlideMessage;
               this.pushSlideStep(gafsmsg.targetId,gafsmsg.startCellId,gafsmsg.endCellId);
               return true;
            case msg is GameActionFightSummonMessage:
               gafsnmsg = msg as GameActionFightSummonMessage;
               this.pushSummonStep(gafsnmsg.sourceId,gafsnmsg.summon);
               if(gafsnmsg.sourceId == PlayedCharacterManager.getInstance().id)
               {
                  PlayedCharacterManager.getInstance().addSummonedCreature();
               }
               return true;
            case msg is GameActionFightMarkCellsMessage:
               gafmcmsg = msg as GameActionFightMarkCellsMessage;
               if(this._castingSpell)
               {
                  this._castingSpell.markId = gafmcmsg.markId;
                  this.pushMarkCellsStep(gafmcmsg.markId,gafmcmsg.markType,gafmcmsg.cells);
               }
               return true;
            case msg is GameActionFightUnmarkCellsMessage:
               gafucmsg = msg as GameActionFightUnmarkCellsMessage;
               this.pushUnmarkCellsStep(gafucmsg.markId);
               return true;
            case msg is GameActionFightChangeLookMessage:
               gafclmsg = msg as GameActionFightChangeLookMessage;
               this.pushChangeLookStep(gafclmsg.targetId,gafclmsg.entityLook);
               return true;
            case msg is GameActionFightInvisibilityMessage:
               gafimsg = msg as GameActionFightInvisibilityMessage;
               this.pushChangeVisibilityStep(gafimsg.targetId,gafimsg.state);
               return true;
            case msg is GameActionFightLeaveMessage:
               gaflmsg = msg as GameActionFightLeaveMessage;
               entitiesL = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(gcaiL in entitiesL)
               {
                  if(gcaiL is GameFightFighterInformations)
                  {
                     summonerIdL = (gcaiL as GameFightFighterInformations).stats.summoner;
                     if(summonerIdL == gaflmsg.targetId)
                     {
                        this.pushDeathStep(gcaiL.contextualId);
                     }
                  }
               }
               this.pushDeathStep(gaflmsg.targetId,false);
               entityInfosL = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntityInfos(gaflmsg.targetId);
               if(entityInfosL is GameFightFighterInformations)
               {
                  summonedEntityInfosL = entityInfosL as GameFightFighterInformations;
                  if(summonedEntityInfosL.stats.summoner == PlayedCharacterManager.getInstance().id)
                  {
                     PlayedCharacterManager.getInstance().removeSummonedCreature();
                  }
               }
               return true;
            case msg is GameActionFightDeathMessage:
               gafdmsg = msg as GameActionFightDeathMessage;
               entitiesDictionnary = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(gcai in entitiesDictionnary)
               {
                  if(gcai is GameFightFighterInformations)
                  {
                     summonerId = (gcai as GameFightFighterInformations).stats.summoner;
                     if(summonerId == gafdmsg.targetId)
                     {
                        this.pushDeathStep(gcai.contextualId);
                     }
                  }
               }
               playerId = PlayedCharacterManager.getInstance().infos.id;
               sourceInfos = this.fightEntitiesFrame.getEntityInfos(gafdmsg.sourceId) as GameFightFighterInformations;
               targetInfos = this.fightEntitiesFrame.getEntityInfos(gafdmsg.targetId) as GameFightFighterInformations;
               playerInfos = this.fightEntitiesFrame.getEntityInfos(playerId) as GameFightFighterInformations;
               if(gafdmsg.targetId == playerId)
               {
                  if(gafdmsg.sourceId == gafdmsg.targetId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_HIMSELF);
                  }
                  else if(sourceInfos.teamId != playerInfos.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
               }
               else if(gafdmsg.sourceId == playerId)
               {
                  if(targetInfos.teamId != playerInfos.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ALLY);
                  }
               }
               this.pushDeathStep(gafdmsg.targetId);
               entityInfos = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntityInfos(gafdmsg.targetId);
               if(entityInfos is GameFightFighterInformations)
               {
                  summonedEntityInfos = entityInfos as GameFightFighterInformations;
                  if(summonedEntityInfos.stats.summoner == PlayedCharacterManager.getInstance().id)
                  {
                     PlayedCharacterManager.getInstance().removeSummonedCreature();
                     SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
                  }
               }
               return true;
            case msg is GameActionFightDispellEffectMessage:
               gafdiemsg = msg as GameActionFightDispellEffectMessage;
               this.pushDispellEffectStep(gafdiemsg.targetId,gafdiemsg.boostUID);
               return true;
            case msg is GameActionFightDispellMessage:
               gafdimsg = msg as GameActionFightDispellMessage;
               this.pushDispellStep(gafdimsg.targetId);
               return true;
            case msg is GameActionFightDodgePointLossMessage:
               gafdplmsg = msg as GameActionFightDodgePointLossMessage;
               this.pushPointsLossDodgeStep(gafdplmsg.targetId,gafdplmsg.actionId,gafdplmsg.amount);
               return true;
            case msg is GameActionFightInvisibleObstacleMessage:
               gafiomsg = msg as GameActionFightInvisibleObstacleMessage;
               this.pushInvisibleObstacleStep(gafiomsg.sourceId,gafiomsg.sourceSpellId);
               return true;
            case msg is GameActionFightKillMessage:
               gafkmsg = msg as GameActionFightKillMessage;
               this.pushKillStep(gafkmsg.targetId,gafkmsg.sourceId);
               return true;
            case msg is GameActionFightPassNextTurnsMessage:
               gafpntmsg = msg as GameActionFightPassNextTurnsMessage;
               this.pushSkipNextTurnStep(gafpntmsg.targetId,gafpntmsg.turnCount);
               return true;
            case msg is GameActionFightReduceDamagesMessage:
               gafredmsg = msg as GameActionFightReduceDamagesMessage;
               this.pushReducedDamagesStep(gafredmsg.targetId,gafredmsg.amount);
               return true;
            case msg is GameActionFightReflectDamagesMessage:
               gafrfdmsg = msg as GameActionFightReflectDamagesMessage;
               this.pushReflectedDamagesStep(gafrfdmsg.sourceId,gafrfdmsg.amount);
               return true;
            case msg is GameActionFightReflectSpellMessage:
               gafrsmsg = msg as GameActionFightReflectSpellMessage;
               this.pushReflectedSpellStep(gafrsmsg.targetId);
               return true;
            case msg is GameActionFightStateChangeMessage:
               gafstcmsg = msg as GameActionFightStateChangeMessage;
               this.pushStateChangeStep(gafstcmsg.targetId,gafstcmsg.stateId,gafstcmsg.active);
               return true;
            case msg is GameActionFightStealKamaMessage:
               gafskmsg = msg as GameActionFightStealKamaMessage;
               this.pushStealKamasStep(gafskmsg.sourceId,gafskmsg.targetId,gafskmsg.amount);
               return true;
            case msg is GameActionFightTackledMessage:
               gaftmsg = msg as GameActionFightTackledMessage;
               this.pushTackledStep(gaftmsg.sourceId);
               return true;
            case msg is GameActionFightTriggerGlyphTrapMessage:
               gaftgtmsg = msg as GameActionFightTriggerGlyphTrapMessage;
               this.pushMarkTriggeredStep(gaftgtmsg.triggeringCharacterId,gaftgtmsg.sourceId,gaftgtmsg.markId);
               this._fxScriptId = 1;
               this._castingSpell = new CastingSpell();
               this._castingSpell.casterId = gaftgtmsg.sourceId;
               this._castingSpell.castingSpellId = 0;
               triggeredCellId = com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame.getCurrentInstance().getEntityInfos(gaftgtmsg.triggeringCharacterId).disposition.cellId;
               if(triggeredCellId != -1)
               {
                  this._castingSpell.targetedCell = MapPoint.fromCellId(triggeredCellId);
                  this._castingSpell.spell = Spell.getSpellById(1750);
                  this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(1);
               }
               return true;
            case msg is GameActionFightDispellableEffectMessage:
               gaftbmsg = msg as GameActionFightDispellableEffectMessage;
               castingSpell = new CastingSpell(this._castingSpell == null);
               if(this._castingSpell)
               {
                  castingSpell.castingSpellId = this._castingSpell.castingSpellId;
               }
               castingSpell.spell = Spell.getSpellById(gaftbmsg.effect.spellId);
               castingSpell.casterId = gaftbmsg.sourceId;
               buffEffect = gaftbmsg.effect;
               switch(true)
               {
                  case buffEffect is FightTemporarySpellBoostEffect:
                     gafdemsg = gaftbmsg.effect as FightTemporarySpellBoostEffect;
                     buff = new BasicBuff(gafdemsg.targetId,castingSpell,gaftbmsg.actionId,gafdemsg.boostedSpellId,null,gafdemsg.delta,gaftbmsg.effect.turnDuration);
                     break;
                  case buffEffect is FightTriggeredEffect:
                     fte = gaftbmsg.effect as FightTriggeredEffect;
                     buff = new BasicBuff(gaftbmsg.effect.targetId,castingSpell,gaftbmsg.actionId,fte.param1,fte.param2,fte.param3,gaftbmsg.effect.turnDuration);
                     break;
                  case buffEffect is FightTemporaryBoostWeaponDamagesEffect:
                     ftbwde = gaftbmsg.effect as FightTemporaryBoostWeaponDamagesEffect;
                     buff = new BasicBuff(ftbwde.targetId,castingSpell,gaftbmsg.actionId,ftbwde.weaponTypeId,ftbwde.delta,ftbwde.turnDuration,ftbwde.weaponTypeId);
                     break;
                  case buffEffect is FightTemporaryBoostStateEffect:
                     ftbse = gaftbmsg.effect as FightTemporaryBoostStateEffect;
                     boostStateBuffVar = ActionIdConverter.getActionStatName(gaftbmsg.actionId);
                     buff = new StateBuff(gaftbmsg.effect.targetId,castingSpell,gaftbmsg.actionId,ftbse.stateId,gaftbmsg.effect.turnDuration,boostStateBuffVar);
                     break;
                  case buffEffect is FightTemporaryBoostEffect:
                     boostStatBuffVar = ActionIdConverter.getActionStatName(gaftbmsg.actionId);
                     isABoost = ActionIdConverter.getIsABoost(gaftbmsg.actionId);
                     buff = new StatBuff(gaftbmsg.effect.targetId,castingSpell,gaftbmsg.actionId,FightTemporaryBoostEffect(gaftbmsg.effect).delta,gaftbmsg.effect.turnDuration,boostStatBuffVar,isABoost);
                     if(gaftbmsg.actionId != ActionIdConverter.ACTION_CHARACTER_MAKE_INVISIBLE)
                     {
                        this.pushTemporaryBoostStep(gaftbmsg.effect.targetId,buff.effects.description,buff.effects.durationString);
                     }
               }
               buff.id = buffEffect.uid;
               BuffManager.getInstance().addBuff(buff);
               return true;
            case msg is GameActionFightCarryCharacterMessage:
               gafccmsg = msg as GameActionFightCarryCharacterMessage;
               this.pushCarryCharacterStep(gafccmsg.sourceId,gafccmsg.targetId);
               return true;
            case msg is GameActionFightThrowCharacterMessage:
               gaftcmsg = msg as GameActionFightThrowCharacterMessage;
               this.pushThrowCharacterStep(gaftcmsg.sourceId,gaftcmsg.targetId,gaftcmsg.cellId);
               return true;
            case msg is GameActionFightDropCharacterMessage:
               gafdcmsg = msg as GameActionFightDropCharacterMessage;
               this.pushThrowCharacterStep(gafdcmsg.sourceId,gafdcmsg.targetId,gafdcmsg.cellId);
               return true;
            case msg is AbstractGameActionMessage:
               _log.error("Unsupported game action " + msg + " ! This action was discarded.");
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function execute(callback:Function = null) : void
      {
         var scriptUri:Uri = null;
         var scriptRunner:SpellFxRunner = null;
         if(this._fxScriptId > 0)
         {
            scriptUri = new Uri(LangManager.getInstance().getEntry("config.script.spellFx") + this._fxScriptId + ".dx");
            scriptRunner = new SpellFxRunner(this);
            this._scriptStarted = getTimer();
            ScriptExec.exec(scriptUri,scriptRunner,false,new Callback(this.executeBuffer,callback,true,true),new Callback(this.executeBuffer,callback,true,false));
         }
         else
         {
            this.executeBuffer(callback,false);
         }
      }
      
      private function executeBuffer(callback:Function, hadScript:Boolean, scriptSuccess:Boolean = false) : void
      {
         var step:ISequencable = null;
         var allowHitAnim:Boolean = false;
         var allowSpellEffects:Boolean = false;
         var removed:Boolean = false;
         var i:int = 0;
         var scriptTook:uint = 0;
         var animStep:PlayAnimationStep = null;
         var deathStep:FightDeathStep = null;
         if(hadScript)
         {
            scriptTook = getTimer() - this._scriptStarted;
            if(!scriptSuccess)
            {
               _log.warn("Script failed during a fight sequence, but still took " + scriptTook + "ms.");
            }
            else
            {
               _log.info("Script successfuly executed in " + scriptTook + "ms.");
            }
         }
         var cleanedBuffer:Array = [];
         var deathStepRef:Dictionary = new Dictionary(true);
         var hitStep:Dictionary = new Dictionary(true);
         var waitHitEnd:Boolean = false;
         for each(step in this._stepsBuffer)
         {
            switch(true)
            {
               case step is FightMarkTriggeredStep:
                  waitHitEnd = true;
                  continue;
               default:
                  continue;
            }
         }
         allowHitAnim = OptionManager.getOptionManager("dofus")["allowHitAnim"];
         allowSpellEffects = OptionManager.getOptionManager("dofus")["allowSpellEffects"];
         for(i = this._stepsBuffer.length; --i >= 0; )
         {
            if(Boolean(removed) && Boolean(step))
            {
               step.clear();
            }
            removed = true;
            step = this._stepsBuffer[i];
            switch(true)
            {
               case step is PlayAnimationStep:
                  animStep = step as PlayAnimationStep;
                  if(animStep.animation == "AnimHit")
                  {
                     if(!allowHitAnim)
                     {
                        continue;
                     }
                     animStep.waitEvent = waitHitEnd;
                     if(deathStepRef[EntitiesManager.getInstance().getEntityID(animStep.target as IEntity)])
                     {
                        continue;
                     }
                     if(hitStep[animStep.target])
                     {
                        continue;
                     }
                     hitStep[animStep.target] = true;
                  }
                  break;
               case step is FightDeathStep:
                  deathStep = step as FightDeathStep;
                  deathStepRef[deathStep.entityId] = true;
                  break;
               case step is AddGfxEntityStep:
               case step is AddGfxInLineStep:
               case step is ParableGfxMovementStep:
               case step is AddWorldEntityStep:
                  if(!allowSpellEffects)
                  {
                     continue;
                  }
                  break;
            }
            removed = false;
            cleanedBuffer.unshift(step);
         }
         var ss:SerialSequencer = new SerialSequencer();
         for each(step in cleanedBuffer)
         {
            ss.addStep(step);
         }
         this.clearBuffer();
         if(callback != null)
         {
            ss.addStep(new CallbackStep(new Callback(callback)));
         }
         ss.start();
      }
      
      private function pushMovementStep(fighterId:int, path:MovementPath) : void
      {
         this._stepsBuffer.push(new FightEntityMovementStep(fighterId,path));
      }
      
      private function pushTeleportStep(fighterId:int, destinationCell:int) : void
      {
         this._stepsBuffer.push(new FightTeleportStep(fighterId,MapPoint.fromCellId(destinationCell)));
      }
      
      private function pushExchangePositionsStep(fighterOneId:int, fighterOneNewCell:int, fighterTwoId:int, fighterTwoNewCell:int) : void
      {
         this._stepsBuffer.push(new FightExchangePositionsStep(fighterOneId,fighterOneNewCell,fighterTwoId,fighterTwoNewCell));
      }
      
      private function pushSlideStep(fighterId:int, startCell:int, endCell:int) : void
      {
         this._stepsBuffer.push(new FightEntitySlideStep(fighterId,MapPoint.fromCellId(startCell),MapPoint.fromCellId(endCell)));
      }
      
      private function pushSummonStep(summonerId:int, summonInfos:GameFightFighterInformations) : void
      {
         this._stepsBuffer.push(new FightSummonStep(summonerId,summonInfos));
      }
      
      private function pushMarkCellsStep(markId:int, markType:int, cells:Vector.<GameActionMarkedCell>) : void
      {
         var t:GameActionMarkedCell = null;
         this._stepsBuffer.push(new FightMarkCellsStep(markId,markType,this._castingSpell.spellRank,cells));
      }
      
      private function pushUnmarkCellsStep(markId:int) : void
      {
         this._stepsBuffer.push(new FightUnmarkCellsStep(markId));
      }
      
      private function pushChangeLookStep(fighterId:int, newLook:EntityLook) : void
      {
         this._stepsBuffer.push(new FightChangeLookStep(fighterId,EntityLookAdapter.fromNetwork(newLook)));
      }
      
      private function pushChangeVisibilityStep(fighterId:int, visibilityState:int) : void
      {
         this._stepsBuffer.push(new FightChangeVisibilityStep(fighterId,visibilityState));
      }
      
      private function pushPointsVariationStep(fighterId:int, actionId:uint, delta:int) : void
      {
         var step:IFightStep = null;
         switch(actionId)
         {
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_USE:
               step = new FightActionPointsVariationStep(fighterId,delta,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_WIN:
               step = new FightActionPointsVariationStep(fighterId,delta,false);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_USE:
               step = new FightMovementPointsVariationStep(fighterId,delta,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_WIN:
               step = new FightMovementPointsVariationStep(fighterId,delta,false);
               break;
            default:
               _log.warn("Points variation with unsupported action (" + actionId + "), skipping.");
               return;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushTemporaryBoostStep(fighterId:int, statName:String, duration:String) : void
      {
         this._stepsBuffer.push(new FightTemporaryBoostStep(fighterId,statName,duration));
      }
      
      private function pushPointsLossDodgeStep(fighterId:int, actionId:uint, amount:int) : void
      {
         var step:IFightStep = null;
         switch(actionId)
         {
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PA:
               step = new FightActionPointsLossDodgeStep(fighterId,amount);
               break;
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PM:
               step = new FightMovementPointsLossDodgeStep(fighterId,amount);
               break;
            default:
               _log.warn("Points dodge with unsupported action (" + actionId + "), skipping.");
               return;
         }
         this._stepsBuffer.push(step);
      }
      
      private function pushLifePointsVariationStep(fighterId:int, delta:int) : void
      {
         this._stepsBuffer.push(new FightLifeVariationStep(fighterId,delta));
      }
      
      private function pushDeathStep(fighterId:int, naturalDeath:Boolean = true) : void
      {
         this._stepsBuffer.push(new FightDeathStep(fighterId,naturalDeath));
         this._stepsBuffer.push(new CallbackStep(new Callback(this.deleteTooltip,fighterId)));
      }
      
      private function pushDispellStep(fighterId:int) : void
      {
         this._stepsBuffer.push(new FightDispellStep(fighterId));
      }
      
      private function pushDispellEffectStep(fighterId:int, boostUID:int) : void
      {
         this._stepsBuffer.push(new FightDispellEffectStep(fighterId,boostUID));
      }
      
      private function pushInvisibleObstacleStep(fighterId:int, spellLevelId:int) : void
      {
         this._stepsBuffer.push(new FightInvisibleObstacleStep(fighterId,spellLevelId));
      }
      
      private function pushKillStep(fighterId:int, killerId:int) : void
      {
         this._stepsBuffer.push(new FightKillStep(fighterId,killerId));
      }
      
      private function pushSkipNextTurnStep(fighterId:int, turnCount:uint) : void
      {
         this._stepsBuffer.push(new FightSkipNextTurnStep(fighterId,turnCount));
      }
      
      private function pushReducedDamagesStep(fighterId:int, amount:int) : void
      {
         this._stepsBuffer.push(new FightReducedDamagesStep(fighterId,amount));
      }
      
      private function pushReflectedDamagesStep(fighterId:int, amount:int) : void
      {
         this._stepsBuffer.push(new FightReflectedDamagesStep(fighterId,amount));
      }
      
      private function pushReflectedSpellStep(fighterId:int) : void
      {
         this._stepsBuffer.push(new FightReflectedSpellStep(fighterId));
      }
      
      private function pushSpellCastStep(fighterId:int, spellId:int, spellRank:uint, critical:uint) : void
      {
         this._stepsBuffer.push(new FightSpellCastStep(fighterId,spellId,spellRank,critical));
      }
      
      private function pushSpellCriticalEffect(criticalType:int, cellId:int) : void
      {
         if(criticalType == FightSpellCastCriticalEnum.CRITICAL_FAIL)
         {
            this._stepsBuffer.push(new AddGfxEntityStep(1070,cellId));
         }
         else if(criticalType == FightSpellCastCriticalEnum.CRITICAL_HIT)
         {
            this._stepsBuffer.push(new AddGfxEntityStep(1062,cellId));
         }
      }
      
      private function pushStateChangeStep(fighterId:int, stateId:int, active:Boolean) : void
      {
         if(active)
         {
            this._stepsBuffer.push(new FightEnteringStateStep(fighterId,stateId));
         }
         else
         {
            this._stepsBuffer.push(new FightLeavingStateStep(fighterId,stateId));
         }
      }
      
      private function pushStealKamasStep(robberId:int, victimId:int, amount:uint) : void
      {
         this._stepsBuffer.push(new FightStealingKamasStep(robberId,victimId,amount));
      }
      
      private function pushTackledStep(fighterId:int) : void
      {
         this._stepsBuffer.push(new FightTackledStep(fighterId));
      }
      
      private function pushMarkTriggeredStep(fighterId:int, casterId:int, markId:int) : void
      {
         this._stepsBuffer.push(new FightMarkTriggeredStep(fighterId,casterId,markId));
      }
      
      private function pushCarryCharacterStep(fighterId:int, carriedId:int) : void
      {
         this._stepsBuffer.push(new FightCarryCharacterStep(fighterId,carriedId));
         this._stepsBuffer.push(new CallbackStep(new Callback(this.deleteTooltip,carriedId)));
      }
      
      private function pushThrowCharacterStep(fighterId:int, carriedId:int, cellId:int) : void
      {
         this._stepsBuffer.push(new FightThrowCharacterStep(fighterId,carriedId,cellId));
      }
      
      private function clearBuffer() : void
      {
         this._stepsBuffer = new Vector.<ISequencable>(0,false);
      }
      
      private function deleteTooltip(fighterId:int) : void
      {
         var s:Selection = null;
         if(FightContextFrame.fighterEntityTooltipId == fighterId)
         {
            TooltipManager.hide();
            TooltipManager.hide("fighter");
            s = SelectionManager.getInstance().getSelection("movementRange");
            if(s)
            {
               s.remove();
            }
         }
      }
   }
}
