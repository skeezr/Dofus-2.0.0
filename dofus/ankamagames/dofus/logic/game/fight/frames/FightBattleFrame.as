package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSynchronizeMessage;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnStartMessage;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnReadyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import gs.TweenMax;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.network.messages.game.actions.GameActionAcknowledgementMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnReadyMessage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFight;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   
   public class FightBattleFrame implements Frame
   {
      
      public static const FIGHT_SEQUENCER_NAME:String = "FightBattleSequencer";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightBattleFrame));
       
      private var _turnFrame:com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
      
      private var _currentSequenceFrame:com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame;
      
      private var _sequenceFrames:Array;
      
      private var _executingSequence:Boolean;
      
      private var _confirmTurnEnd:Boolean;
      
      private var _endBattle:Boolean;
      
      private var _leaveSpectator:Boolean;
      
      private var _battleResults:GameFightEndMessage;
      
      private var _refreshTurnsList:Boolean;
      
      private var _newTurnsList:Vector.<int>;
      
      private var _newDeadTurnsList:Vector.<int>;
      
      private var _turnsList:Vector.<int>;
      
      private var _deadTurnsList:Vector.<int>;
      
      public var entitiesListCastSpell:Array;
      
      private var _playerRGBOffset:Number;
      
      private var _playerNewTurn:AnimatedCharacter;
      
      public function FightBattleFrame()
      {
         this._turnFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get fightersList() : Vector.<int>
      {
         return this._turnsList;
      }
      
      public function get deadFightersList() : Vector.<int>
      {
         return this._deadTurnsList;
      }
      
      public function pushed() : Boolean
      {
         this._sequenceFrames = new Array();
         this.entitiesListCastSpell = new Array();
         Kernel.getWorker().addFrame(this._turnFrame);
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gftmsg:GameFightTurnListMessage = null;
         var gftcimsg:GameFightSynchronizeMessage = null;
         var entitiesFrame:MessageHandler = null;
         var gftsmsg:GameFightTurnStartMessage = null;
         var sapi:SoundApi = null;
         var gftemsg:GameFightTurnEndMessage = null;
         var ssmsg:SequenceStartMessage = null;
         var semsg:SequenceEndMessage = null;
         var gflmsg:GameFightLeaveMessage = null;
         var leaveSequenceFrame:com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame = null;
         var fakeDeathMessage:GameActionFightLeaveMessage = null;
         var gfemsg:GameFightEndMessage = null;
         var fighterInfos:GameFightFighterInformations = null;
         var gfsfmsg:GameFightShowFighterMessage = null;
         var entity:AnimatedCharacter = null;
         var ss:SerialSequencer = null;
         var yOffset:Number = NaN;
         var ss2:SerialSequencer = null;
         var playerColorTransformManager:PlayerColorTransformManager = null;
         var seqEnd:SequenceEndMessage = null;
         switch(true)
         {
            case msg is GameFightTurnListMessage:
               gftmsg = msg as GameFightTurnListMessage;
               if(this._executingSequence)
               {
                  _log.debug("There was a turns list update during this sequence... Let\'s wait its finish before doing it.");
                  this._refreshTurnsList = true;
                  this._newTurnsList = gftmsg.ids;
                  this._newDeadTurnsList = gftmsg.deadsIds;
               }
               else
               {
                  this.updateTurnsList(gftmsg.ids,gftmsg.deadsIds);
               }
               this.checkEntitiesCastList(gftmsg.ids);
               return true;
            case msg is GameFightSynchronizeMessage:
               gftcimsg = msg as GameFightSynchronizeMessage;
               entitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame);
               for each(fighterInfos in gftcimsg.fighters)
               {
                  if(fighterInfos.alive)
                  {
                     gfsfmsg = new GameFightShowFighterMessage();
                     gfsfmsg.initGameFightShowFighterMessage(fighterInfos);
                     entitiesFrame.process(gfsfmsg);
                  }
               }
               return true;
            case msg is GameFightTurnStartMessage:
               gftsmsg = msg as GameFightTurnStartMessage;
               this._turnFrame.turnDuration = gftsmsg.waitTime;
               if(gftsmsg.id > 0)
               {
                  if(FightEntitiesFrame.getCurrentInstance().getEntityInfos(gftsmsg.id).disposition.cellId != -1 && !FightEntitiesHolder.getInstance().getEntity(gftsmsg.id))
                  {
                     entity = DofusEntities.getEntity(gftsmsg.id) as AnimatedCharacter;
                     ss = new SerialSequencer();
                     ss.addStep(new AddGfxEntityStep(154,entity.position.cellId));
                     ss.start();
                     yOffset = 65 * entity.look.getScaleY();
                     ss2 = new SerialSequencer();
                     ss2.addStep(new AddGfxEntityStep(153,entity.position.cellId,0,-yOffset));
                     ss2.start();
                     this._playerNewTurn = entity;
                     playerColorTransformManager = new PlayerColorTransformManager(this._playerNewTurn);
                     playerColorTransformManager.enlightPlayer();
                  }
               }
               sapi = new SoundApi();
               if(gftsmsg.id == PlayedCharacterManager.getInstance().id)
               {
                  if(sapi.playSoundAtTurnStart())
                  {
                     SoundManager.getInstance().manager.playUISound(UISoundEnum.PLAYER_TURN);
                  }
                  this._turnFrame.myTurn = true;
                  SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(gftsmsg.id);
               }
               else
               {
                  if(sapi.playSoundAtTurnStart())
                  {
                     SoundManager.getInstance().manager.playUISound(UISoundEnum.NPC_TURN);
                  }
                  this._turnFrame.myTurn = false;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnStart,gftsmsg.id,gftsmsg.waitTime,Dofus.getInstance().options.turnPicture);
               return true;
            case msg is GameFightTurnEndMessage:
               gftemsg = msg as GameFightTurnEndMessage;
               if(gftemsg.id == PlayedCharacterManager.getInstance().id)
               {
                  this._turnFrame.myTurn = false;
               }
               this.updateCastSpellsEntity(gftemsg.id);
               BuffManager.getInstance().decrementDuration(gftemsg.id);
               if(gftemsg.id == PlayedCharacterManager.getInstance().id)
               {
                  SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(gftemsg.id);
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightTurnEnd,gftemsg.id);
               return true;
            case msg is SequenceStartMessage:
               ssmsg = msg as SequenceStartMessage;
               this._currentSequenceFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame(this);
               Kernel.getWorker().addFrame(this._currentSequenceFrame);
               return true;
            case msg is SequenceEndMessage:
               semsg = msg as SequenceEndMessage;
               if(!this._currentSequenceFrame)
               {
                  _log.warn("Wow wow wow, I\'ve got a Sequence End but no Sequence Start? What the hell?");
                  return true;
               }
               this._currentSequenceFrame.mustAck = semsg.authorId == PlayedCharacterManager.getInstance().id;
               this._currentSequenceFrame.ackIdent = semsg.actionId;
               Kernel.getWorker().removeFrame(this._currentSequenceFrame);
               this._sequenceFrames.push(this._currentSequenceFrame);
               this._currentSequenceFrame = null;
               this.executeNextSequence();
               return true;
            case msg is GameFightTurnReadyRequestMessage:
               if(this._executingSequence)
               {
                  _log.debug("Delaying turn end acknowledgement because we\'re still in a sequence.");
                  this._confirmTurnEnd = true;
               }
               else
               {
                  this.confirmTurnEnd();
               }
               return true;
            case msg is GameFightLeaveMessage:
               gflmsg = msg as GameFightLeaveMessage;
               leaveSequenceFrame = new com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame(this);
               fakeDeathMessage = new GameActionFightLeaveMessage();
               leaveSequenceFrame.process(fakeDeathMessage.initGameActionFightLeaveMessage(0,0,gflmsg.charId));
               this._sequenceFrames.push(leaveSequenceFrame);
               this.executeNextSequence();
               if(gflmsg.charId == PlayedCharacterManager.getInstance().infos.id && Boolean(PlayedCharacterManager.getInstance().isSpectator))
               {
                  if(this._executingSequence)
                  {
                     this._leaveSpectator = true;
                  }
                  else
                  {
                     this.leaveSpectatorMode();
                  }
                  this.entitiesListCastSpell = new Array();
                  PlayedCharacterManager.getInstance().resetSummonedCreature();
               }
               return true;
            case msg is GameFightEndMessage:
               gfemsg = msg as GameFightEndMessage;
               if(this._currentSequenceFrame)
               {
                  _log.error("/!\\ Fight end but no SequenceEnd was received");
                  seqEnd = new SequenceEndMessage();
                  seqEnd.initSequenceEndMessage();
                  this.process(seqEnd);
               }
               if(this._executingSequence)
               {
                  _log.debug("Delaying fight end because we\'re still in a sequence.");
                  this._endBattle = true;
                  this._battleResults = gfemsg;
               }
               else
               {
                  this.endBattle(gfemsg);
               }
               this.entitiesListCastSpell = new Array();
               PlayedCharacterManager.getInstance().resetSummonedCreature();
               PlayedCharacterManager.getInstance().fightStates = new Array();
               return true;
            case msg is GameContextDestroyMessage:
               if(this._battleResults)
               {
                  this.endBattle(this._battleResults);
               }
               else
               {
                  this.endBattle(new GameFightEndMessage());
               }
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         TweenMax.killAllTweens(false);
         if(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame))
         {
            Kernel.getWorker().removeFrame(this._turnFrame);
         }
         BuffManager.getInstance().destroy();
         MarkedCellsManager.getInstance().destroy();
         if(Boolean(this._executingSequence) || Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame)))
         {
            _log.warn("Wow, wait. We\'re pulling FightBattle but there\'s still sequences inside the worker !!");
         }
         if(this._executingSequence)
         {
            SerialSequencer.clearByType(FIGHT_SEQUENCER_NAME);
         }
         return true;
      }
      
      private function executeNextSequence() : Boolean
      {
         if(this._executingSequence)
         {
            return false;
         }
         var nextSequenceFrame:com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame = this._sequenceFrames.shift();
         if(nextSequenceFrame)
         {
            this._executingSequence = true;
            nextSequenceFrame.execute(this.finishSequence(nextSequenceFrame));
            return true;
         }
         return false;
      }
      
      private function finishSequence(sequenceFrame:com.ankamagames.dofus.logic.game.fight.frames.FightSequenceFrame) : Function
      {
         return function():void
         {
            var ack:* = undefined;
            Kernel.getWorker().removeFrame(sequenceFrame);
            if(sequenceFrame.mustAck)
            {
               ack = new GameActionAcknowledgementMessage();
               ack.initGameActionAcknowledgementMessage(true,sequenceFrame.ackIdent);
               ConnectionsHandler.getConnection().send(ack);
            }
            _log.debug("Sequence finished.");
            _executingSequence = false;
            if(executeNextSequence())
            {
               return;
            }
            if(_endBattle)
            {
               _log.debug("This fight must end ! Finishing things now.");
               _endBattle = false;
               endBattle(_battleResults);
               _battleResults = null;
               return;
            }
            if(_refreshTurnsList)
            {
               _log.debug("There was a turns list refresh delayed, what about updating it now?");
               _refreshTurnsList = false;
               updateTurnsList(_newTurnsList,_newDeadTurnsList);
               _newTurnsList = null;
               _newDeadTurnsList = null;
            }
            if(_confirmTurnEnd)
            {
               _log.debug("There was a turn end delayed, dispatching now.");
               _confirmTurnEnd = false;
               confirmTurnEnd();
            }
         };
      }
      
      private function updateTurnsList(turnsList:Vector.<int>, deadTurnsList:Vector.<int>) : void
      {
         this._turnsList = turnsList;
         this._deadTurnsList = deadTurnsList;
         KernelEventsManager.getInstance().processCallback(HookList.FightersListUpdated);
      }
      
      private function confirmTurnEnd() : void
      {
         var turnEnd:GameFightTurnReadyMessage = new GameFightTurnReadyMessage();
         turnEnd.initGameFightTurnReadyMessage(true);
         ConnectionsHandler.getConnection().send(turnEnd);
      }
      
      private function leaveSpectatorMode() : void
      {
         var entityListCastSpell:EntityListCastSpell = null;
         var gfemsg:GameFightEndMessage = null;
         var spellCastInFight:SpellCastInFight = null;
         var spellW:SpellWrapper = null;
         for each(entityListCastSpell in this.entitiesListCastSpell)
         {
            for each(spellCastInFight in entityListCastSpell.spellCastInFight)
            {
               spellW = SpellWrapper.getSpellWrapperById(spellCastInFight.spellId,spellCastInFight.casterId);
               if(spellW)
               {
                  spellW.actualCooldown = 0;
               }
            }
         }
         Kernel.getWorker().removeFrame(this);
         gfemsg = new GameFightEndMessage();
         gfemsg.initGameFightEndMessage();
         Kernel.getWorker().process(gfemsg);
      }
      
      private function endBattle(fightEnd:GameFightEndMessage) : void
      {
         var coward:* = undefined;
         var entityListCastSpell:EntityListCastSpell = null;
         var spellCastInFight:SpellCastInFight = null;
         var spellW:SpellWrapper = null;
         var _holder:FightEntitiesHolder = FightEntitiesHolder.getInstance();
         for each(coward in _holder.getEntities())
         {
            (coward as AnimatedCharacter).display();
            _holder.unholdEntity(coward.id);
         }
         for each(entityListCastSpell in this.entitiesListCastSpell)
         {
            for each(spellCastInFight in entityListCastSpell.spellCastInFight)
            {
               spellW = SpellWrapper.getSpellWrapperById(spellCastInFight.spellId,spellCastInFight.casterId);
               if(spellW)
               {
                  spellW.actualCooldown = 0;
               }
            }
         }
         Kernel.getWorker().removeFrame(this);
         Kernel.getWorker().process(fightEnd);
      }
      
      private function updateCastSpellsEntity(pSourceId:int) : void
      {
         var entityListCastSpell:EntityListCastSpell = null;
         var spellAlreadyIn:Boolean = false;
         var newEntityListCastSpell:Array = null;
         var spellCastInFight:SpellCastInFight = null;
         for each(entityListCastSpell in this.entitiesListCastSpell)
         {
            if(entityListCastSpell.entityId == pSourceId)
            {
               spellAlreadyIn = false;
               newEntityListCastSpell = new Array();
               for each(spellCastInFight in entityListCastSpell.spellCastInFight)
               {
                  spellCastInFight.update(spellCastInFight.nextCast - 1 <= 0?uint(0):uint(spellCastInFight.nextCast - 1),spellCastInFight.maxCastPerTurn);
                  if(spellCastInFight.nextCast > 0)
                  {
                     newEntityListCastSpell.push(spellCastInFight);
                  }
               }
               entityListCastSpell.spellCastInFight = newEntityListCastSpell;
               break;
            }
         }
      }
      
      public function checkEntityCastList(id:int) : Boolean
      {
         var entityListCastSpell:EntityListCastSpell = null;
         var elcs:EntityListCastSpell = null;
         for each(entityListCastSpell in this.entitiesListCastSpell)
         {
            if(id == entityListCastSpell.entityId)
            {
               return true;
            }
         }
         elcs = new EntityListCastSpell();
         elcs.entityId = id;
         elcs.spellCastInFight = new Array();
         this.entitiesListCastSpell.push(elcs);
         return false;
      }
      
      private function checkEntitiesCastList(ids:Vector.<int>) : void
      {
         var id:int = 0;
         for each(id in ids)
         {
            this.checkEntityCastList(id);
         }
      }
      
      public function updateCastSpell(pSourceId:int, pSpellId:uint, pSpellLevel:uint, forcedCoolDown:int = -1) : void
      {
         var entityListCastSpell:EntityListCastSpell = null;
         var spellAlreadyIn:Boolean = false;
         var spellCastInFight:SpellCastInFight = null;
         var nbTurnBetweenCast:uint = 0;
         var currentSpellObject:* = undefined;
         var spell:Spell = null;
         var nbCastPerTurn:int = 0;
         var newSpellCastInFight:SpellCastInFight = null;
         for each(entityListCastSpell in this.entitiesListCastSpell)
         {
            this.checkEntityCastList(entityListCastSpell.entityId);
            if(entityListCastSpell.entityId == pSourceId)
            {
               spellAlreadyIn = false;
               for each(spellCastInFight in entityListCastSpell.spellCastInFight)
               {
                  if(spellCastInFight.spellId == pSpellId)
                  {
                     spellCastInFight.update(spellCastInFight.nextCast,spellCastInFight.numberOfCastLeft - 1);
                     spellAlreadyIn = true;
                  }
               }
               currentSpellObject = SpellWrapper.getSpellWrapperById(pSpellId,pSourceId);
               if(!currentSpellObject)
               {
                  spell = Spell.getSpellById(pSpellId);
                  currentSpellObject = SpellLevel.getLevelById(spell.spellLevels[pSpellLevel - 1]);
               }
               nbTurnBetweenCast = forcedCoolDown == -1?uint(currentSpellObject.minCastInterval):uint(forcedCoolDown);
               if(!spellAlreadyIn)
               {
                  nbCastPerTurn = currentSpellObject.maxCastPerTurn;
                  if(nbTurnBetweenCast > 0)
                  {
                     newSpellCastInFight = new SpellCastInFight(pSourceId,pSpellId,nbTurnBetweenCast,nbCastPerTurn);
                     entityListCastSpell.spellCastInFight.push(newSpellCastInFight);
                  }
               }
            }
         }
      }
   }
}

class EntityListCastSpell
{
    
   public var entityId:int;
   
   public var spellCastInFight:Array;
   
   function EntityListCastSpell()
   {
      super();
   }
}

import com.ankamagames.dofus.types.entities.AnimatedCharacter;
import com.ankamagames.atouin.Atouin;
import flash.geom.ColorTransform;
import com.ankamagames.atouin.AtouinConstants;
import gs.TweenMax;

class PlayerColorTransformManager
{
    
   private var _offSetValue:Number;
   
   private var _alphaValue:Number;
   
   private var _player:AnimatedCharacter;
   
   function PlayerColorTransformManager(pPlayer:AnimatedCharacter)
   {
      super();
      this._player = pPlayer;
      this._alphaValue = pPlayer.alpha;
      this.offSetValue = 0;
   }
   
   public function set offSetValue(pValue:Number) : void
   {
      this._offSetValue = pValue;
      if(Atouin.getInstance().options.transparentOverlayMode)
      {
         this._player.transform.colorTransform = new ColorTransform(1,1,1,this._alphaValue != 1?Number(this._alphaValue):Number(AtouinConstants.OVERLAY_MODE_ALPHA),pValue,pValue,pValue,0);
      }
      else
      {
         this._player.transform.colorTransform = new ColorTransform(1,1,1,this._alphaValue,pValue,pValue,pValue,0);
      }
   }
   
   public function get offSetValue() : Number
   {
      return this._offSetValue;
   }
   
   public function enlightPlayer() : void
   {
      TweenMax.to(this,0.7,{
         "offSetValue":50,
         "yoyo":1
      });
   }
}
