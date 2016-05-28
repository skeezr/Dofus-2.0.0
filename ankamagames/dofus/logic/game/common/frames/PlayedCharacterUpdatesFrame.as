package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.initialization.SetCharacterRestrictionsMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterStatsListMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.logic.game.common.actions.IncreaseSpellLevelAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellUpgradeSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgottenMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellUpgradeFailureMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.StatsUpgradeRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.stats.StatsUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.stats.StatsUpgradeResultMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayPlayerLifeStatusMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayGameOverMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellItemBoostMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.SetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdateMessage;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterLevelUpInformationMessage;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.common.managers.SpellsBoostsManager;
   import com.ankamagames.dofus.types.data.PlayerSetInfo;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdatePvpSeekMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdatePartyMemberMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   
   public class PlayedCharacterUpdatesFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayedCharacterUpdatesFrame));
      
      private static const ACTION_CHARACTER_ACTION_POINTS_USE:uint = 102;
      
      private static const ACTION_CHARACTER_ACTION_POINTS_LOST:uint = 101;
      
      private static const ACTION_CHARACTER_MOVEMENT_POINTS_USE:uint = 129;
      
      private static const ACTION_CHARACTER_MOVEMENT_POINTS_LOST:uint = 127;
       
      public var setList:Array;
      
      private var _roleplayContextFrame:RoleplayContextFrame;
      
      public function PlayedCharacterUpdatesFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function set roleplayContextFrame(pRoleplayContextFrame:RoleplayContextFrame) : void
      {
         this._roleplayContextFrame = pRoleplayContextFrame;
      }
      
      public function pushed() : Boolean
      {
         this.setList = new Array();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var scrmsg:SetCharacterRestrictionsMessage = null;
         var cslmsg:CharacterStatsListMessage = null;
         var lastCharacteristics:CharacterCharacteristicsInformations = null;
         var isla:IncreaseSpellLevelAction = null;
         var spurmsg:SpellUpgradeRequestMessage = null;
         var susmsg:SpellUpgradeSuccessMessage = null;
         var position:uint = 0;
         var updated:Boolean = false;
         var sfmsg:SpellForgottenMessage = null;
         var sufmsg:SpellUpgradeFailureMessage = null;
         var sura:StatsUpgradeRequestAction = null;
         var surqmsg:StatsUpgradeRequestMessage = null;
         var surmsg:StatsUpgradeResultMessage = null;
         var clumsg:CharacterLevelUpMessage = null;
         var messageId:uint = 0;
         var grplsmsg:GameRolePlayPlayerLifeStatusMessage = null;
         var grpgomsg:GameRolePlayGameOverMessage = null;
         var sibmsg:SpellItemBoostMessage = null;
         var sumsg:SetUpdateMessage = null;
         var cumsg:CompassUpdateMessage = null;
         var legend:String = null;
         var sw:SpellWrapper = null;
         var swn:SpellWrapper = null;
         var newSW:SpellWrapper = null;
         var spellPointEarned:uint = 0;
         var caracPointEarned:uint = 0;
         var healPointEarned:uint = 0;
         var playerLook:TiphonEntityLook = null;
         var newSpell:Array = null;
         var playerBreed:Breed = null;
         var ssequencer:SerialSequencer = null;
         var cluimsg:CharacterLevelUpInformationMessage = null;
         var onSameMap:Boolean = false;
         var displayTextInfo:String = null;
         var swBreed:Spell = null;
         var spellAllreadyIn:Boolean = false;
         var obtentionLevel:uint = 0;
         var swrapper:SpellWrapper = null;
         var entityId:int = 0;
         var ss:SerialSequencer = null;
         var pmFrame:PartyManagementFrame = null;
         var memberInfo:PartyMemberInformations = null;
         switch(true)
         {
            case msg is SetCharacterRestrictionsMessage:
               scrmsg = msg as SetCharacterRestrictionsMessage;
               PlayedCharacterManager.getInstance().restrictions = scrmsg.restrictions;
               return true;
            case msg is CharacterStatsListMessage:
               cslmsg = msg as CharacterStatsListMessage;
               lastCharacteristics = PlayedCharacterManager.getInstance().characteristics;
               if(lastCharacteristics)
               {
                  if(lastCharacteristics.energyPoints > cslmsg.stats.energyPoints)
                  {
                     KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerIsDead);
                  }
               }
               PlayedCharacterManager.getInstance().characteristics = cslmsg.stats;
               KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               if(PlayedCharacterManager.getInstance().isFighting)
               {
                  SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
               }
               return true;
            case msg is IncreaseSpellLevelAction:
               isla = msg as IncreaseSpellLevelAction;
               spurmsg = new SpellUpgradeRequestMessage();
               spurmsg.initSpellUpgradeRequestMessage(isla.spellId);
               ConnectionsHandler.getConnection().send(spurmsg);
               return true;
            case msg is SpellUpgradeSuccessMessage:
               susmsg = msg as SpellUpgradeSuccessMessage;
               position = 63;
               updated = false;
               for each(sw in PlayedCharacterManager.getInstance().spellsInventory)
               {
                  if(sw.id == susmsg.spellId)
                  {
                     SpellWrapper.create(sw.position,sw.id,susmsg.spellLevel,true,sw.playerId);
                     position = sw.position;
                     updated = true;
                     break;
                  }
               }
               if(!updated)
               {
                  swn = SpellWrapper.create(63,susmsg.spellId,susmsg.spellLevel,true,PlayedCharacterManager.getInstance().id);
                  PlayedCharacterManager.getInstance().spellsInventory.push(swn);
                  KernelEventsManager.getInstance().processCallback(HookList.SpellList,PlayedCharacterManager.getInstance().spellsInventory);
               }
               else
               {
                  newSW = SpellWrapper.create(position,susmsg.spellId,susmsg.spellLevel,true,PlayedCharacterManager.getInstance().id);
                  KernelEventsManager.getInstance().processCallback(HookList.SpellUpgradeSuccess,newSW);
               }
               return true;
            case msg is SpellForgottenMessage:
               sfmsg = msg as SpellForgottenMessage;
               KernelEventsManager.getInstance().processCallback(HookList.SpellForgotten,sfmsg.boostPoint,sfmsg.spellsId);
               return true;
            case msg is SpellUpgradeFailureMessage:
               sufmsg = msg as SpellUpgradeFailureMessage;
               KernelEventsManager.getInstance().processCallback(HookList.SpellUpgradeFail);
               return true;
            case msg is StatsUpgradeRequestAction:
               sura = msg as StatsUpgradeRequestAction;
               surqmsg = new StatsUpgradeRequestMessage();
               surqmsg.initStatsUpgradeRequestMessage(sura.statId,sura.boostPoint);
               ConnectionsHandler.getConnection().send(surqmsg);
               return true;
            case msg is StatsUpgradeResultMessage:
               surmsg = msg as StatsUpgradeResultMessage;
               KernelEventsManager.getInstance().processCallback(HookList.StatsUpgradeResult,surmsg.nbCharacBoost);
               if(surmsg.nbCharacBoost == 0)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getText(I18nProxy.getKeyId("ui.popup.statboostFailed.text")),ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is CharacterLevelUpMessage:
               clumsg = msg as CharacterLevelUpMessage;
               messageId = clumsg.getMessageId();
               switch(messageId)
               {
                  case CharacterLevelUpMessage.protocolId:
                     spellPointEarned = clumsg.newLevel - PlayedCharacterManager.getInstance().infos.level;
                     caracPointEarned = (clumsg.newLevel - PlayedCharacterManager.getInstance().infos.level) * 5;
                     healPointEarned = (clumsg.newLevel - PlayedCharacterManager.getInstance().infos.level) * 5;
                     playerLook = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
                     newSpell = new Array();
                     KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerNewSpell);
                     playerBreed = Breed.getBreedById(PlayedCharacterManager.getInstance().infos.breed);
                     for each(swBreed in playerBreed.breedSpells)
                     {
                        spellAllreadyIn = false;
                        obtentionLevel = SpellLevel.getLevelById(swBreed.spellLevels[0]).minPlayerLevel;
                        if(obtentionLevel <= clumsg.newLevel && obtentionLevel > PlayedCharacterManager.getInstance().infos.level)
                        {
                           swrapper = SpellWrapper.create(68,swBreed.id,1,false,PlayedCharacterManager.getInstance().id);
                           newSpell.push(swrapper);
                        }
                     }
                     PlayedCharacterManager.getInstance().infos.level = clumsg.newLevel;
                     ssequencer = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
                     ssequencer.addStep(new AddGfxEntityStep(152,DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id).position.cellId));
                     ssequencer.start();
                     SoundManager.getInstance().manager.playUISound(UISoundEnum.LEVEL_UP);
                     KernelEventsManager.getInstance().processCallback(HookList.CharacterLevelUp,playerLook,clumsg.newLevel,spellPointEarned,caracPointEarned,healPointEarned,newSpell);
                     break;
                  case CharacterLevelUpInformationMessage.protocolId:
                     cluimsg = msg as CharacterLevelUpInformationMessage;
                     onSameMap = false;
                     try
                     {
                        for each(entityId in this._roleplayContextFrame.entitiesFrame.getEntitiesIdsList())
                        {
                           if(entityId == cluimsg.id)
                           {
                              onSameMap = true;
                           }
                        }
                        if(onSameMap)
                        {
                           ss = new SerialSequencer();
                           ss.addStep(new AddGfxEntityStep(152,DofusEntities.getEntity(cluimsg.id).position.cellId));
                           ss.start();
                        }
                     }
                     catch(e:Error)
                     {
                        _log.warn("Un problème est survenu lors du traitement du message CharacterLevelUpInformationMessage. " + "Un personnage vient de changer de niveau mais on n\'est surement pas encore sur la map");
                     }
                     displayTextInfo = I18n.getText(I18nProxy.getKeyId("ui.common.characterLevelUp"),[cluimsg.name,cluimsg.newLevel]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,displayTextInfo,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               }
               return true;
            case msg is GameRolePlayPlayerLifeStatusMessage:
               grplsmsg = msg as GameRolePlayPlayerLifeStatusMessage;
               PlayedCharacterManager.getInstance().state = grplsmsg.state;
               KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayPlayerLifeStatus,grplsmsg.state,0);
               return true;
            case msg is GameRolePlayGameOverMessage:
               grpgomsg = msg as GameRolePlayGameOverMessage;
               KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayPlayerLifeStatus,2,1);
               return true;
            case msg is SpellItemBoostMessage:
               sibmsg = msg as SpellItemBoostMessage;
               SpellsBoostsManager.getInstance().setSpellModificator(sibmsg.statId,sibmsg.spellId,sibmsg.value);
               KernelEventsManager.getInstance().processCallback(HookList.TooltipSpellReset);
               return true;
            case msg is SetUpdateMessage:
               sumsg = msg as SetUpdateMessage;
               this.setList[sumsg.setId] = new PlayerSetInfo(sumsg.setId,sumsg.setObjects,sumsg.setEffects);
               return true;
            case msg is CompassUpdatePartyMemberMessage:
            case msg is CompassUpdatePvpSeekMessage:
            case msg is CompassUpdateMessage:
               cumsg = msg as CompassUpdateMessage;
               switch(cumsg.type)
               {
                  case CompassTypeEnum.COMPASS_TYPE_PARTY:
                     break;
                  case CompassTypeEnum.COMPASS_TYPE_PVP_SEEK:
                     break;
                  case CompassTypeEnum.COMPASS_TYPE_SIMPLE:
                     break;
                  case CompassTypeEnum.COMPASS_TYPE_SPOUSE:
               }
               if(msg is CompassUpdatePvpSeekMessage)
               {
                  legend = CompassUpdatePvpSeekMessage(msg).memberName;
               }
               if(msg is CompassUpdatePartyMemberMessage)
               {
                  pmFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
                  if(pmFrame)
                  {
                     memberInfo = pmFrame.getGroupMemberById(CompassUpdatePartyMemberMessage(msg).memberId);
                     if(memberInfo)
                     {
                        legend = memberInfo.name;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.AddMapFlag,"srvFlag_" + cumsg.type,legend,cumsg.worldX,cumsg.worldY,true);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function getPlayerSet(objectGID:uint) : PlayerSetInfo
      {
         var playerSetInfo:PlayerSetInfo = null;
         var itemList:Vector.<uint> = null;
         var nbItem:int = 0;
         var k:int = 0;
         var nbSet:int = this.setList.length;
         for(var i:int = 0; i < nbSet; i++)
         {
            playerSetInfo = this.setList[i];
            if(playerSetInfo)
            {
               itemList = playerSetInfo.setObjects;
               nbItem = itemList.length;
               for(k = 0; k < nbItem; k++)
               {
                  if(itemList[k] == objectGID)
                  {
                     return playerSetInfo;
                  }
               }
            }
         }
         return null;
      }
   }
}
