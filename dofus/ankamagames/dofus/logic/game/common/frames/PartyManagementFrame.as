package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import flash.utils.Timer;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyInvitationAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyCannotJoinErrorMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAcceptInvitationAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyAcceptInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyRefuseInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyJoinMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyKickRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyKickedByMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyMemberRemoveMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyLeaveRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaderUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyUpdateLightMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAbdicateThroneAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyAbdicateThroneMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyFollowMemberAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowMemberRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyStopFollowingMemberAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyStopFollowRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAllFollowMemberAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowThisMemberRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAllStopFollowingMemberAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyShowMenuAction;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdatePartyMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLocateMembersMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.network.enums.PartyJoinErrorEnum;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.utils.ObjectCompare;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyRefuseInvitationAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyRefuseInvitationNotificationMessage;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyCancelInvitationAction;
   import flash.events.TimerEvent;
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorAlignmentInformations;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.berilia.factories.MenusFactory;
   
   public class PartyManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PartyManagementFrame));
       
      private var _roleplaypContextFrame:RoleplayContextFrame;
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _playerNameInvited:String;
      
      private var _isInviting:Boolean = false;
      
      private var _partyMembers:Vector.<PartyMember>;
      
      private var _timerRegen:Timer;
      
      private var _dicRegen:Dictionary;
      
      public var allMemberFollowPlayerId:uint = 0;
      
      public function PartyManagementFrame(parentFrame:RoleplayContextFrame)
      {
         this._partyMembers = new Vector.<PartyMember>();
         super();
         this._roleplaypContextFrame = parentFrame;
         this._roleplayEntitiesFrame = this._roleplaypContextFrame.entitiesFrame;
         this._dicRegen = new Dictionary();
         this._timerRegen = new Timer(1000);
         this._timerRegen.addEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get partyMembers() : Vector.<PartyMember>
      {
         return this._partyMembers;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var pia:PartyInvitationAction = null;
         var pirmsg:PartyInvitationRequestMessage = null;
         var partyInvitationmsg:PartyInvitationMessage = null;
         var pcjenmsg:PartyCannotJoinErrorMessage = null;
         var reasonText:String = null;
         var paimsg:PartyAcceptInvitationAction = null;
         var pacceptimsg:PartyAcceptInvitationMessage = null;
         var prefuseimsg:PartyRefuseInvitationMessage = null;
         var pcancelimsg:* = undefined;
         var pjmsg:PartyJoinMessage = null;
         var pka:PartyKickRequestAction = null;
         var pkickrimsg:PartyKickRequestMessage = null;
         var pkbmsg:PartyKickedByMessage = null;
         var plmsg:PartyLeaveMessage = null;
         var pumsg:PartyUpdateMessage = null;
         var newPlayer:Boolean = false;
         var newMember:PartyMember = null;
         var lptm:LifePointTickManager = null;
         var pmrmsg:PartyMemberRemoveMessage = null;
         var compt:uint = 0;
         var plra:PartyLeaveRequestAction = null;
         var plrmsg:PartyLeaveRequestMessage = null;
         var plulmsg:PartyLeaderUpdateMessage = null;
         var pulmsg:PartyUpdateLightMessage = null;
         var pata:PartyAbdicateThroneAction = null;
         var patmsg:PartyAbdicateThroneMessage = null;
         var pfma:PartyFollowMemberAction = null;
         var pfmrmsg:PartyFollowMemberRequestMessage = null;
         var psfma:PartyStopFollowingMemberAction = null;
         var psfrmsg:PartyStopFollowRequestMessage = null;
         var pafma:PartyAllFollowMemberAction = null;
         var pftmrmsg:PartyFollowThisMemberRequestMessage = null;
         var pasfma:PartyAllStopFollowingMemberAction = null;
         var pftmrmsg2:PartyFollowThisMemberRequestMessage = null;
         var psma:PartyShowMenuAction = null;
         var commonMod:Object = null;
         var menu:Array = null;
         var cupmmsg:CompassUpdatePartyMemberMessage = null;
         var plmmsg:PartyLocateMembersMessage = null;
         var member:PartyMemberInformations = null;
         var partyMember:PartyMember = null;
         var pMember:PartyMember = null;
         var newSkin:TiphonEntityLook = null;
         var playerLook:EntityLook = null;
         var partyM:PartyMember = null;
         var partyMem:PartyMember = null;
         var partyMemb:PartyMember = null;
         var lptmanager:LifePointTickManager = null;
         switch(true)
         {
            case msg is PartyInvitationAction:
               pia = msg as PartyInvitationAction;
               this._isInviting = true;
               this._playerNameInvited = pia.name;
               pirmsg = new PartyInvitationRequestMessage();
               pirmsg.initPartyInvitationRequestMessage(pia.name);
               ConnectionsHandler.getConnection().send(pirmsg);
               return true;
            case msg is PartyInvitationMessage:
               partyInvitationmsg = msg as PartyInvitationMessage;
               KernelEventsManager.getInstance().processCallback(HookList.PartyInvitation,partyInvitationmsg.fromId,partyInvitationmsg.fromName,partyInvitationmsg.toId,partyInvitationmsg.toName);
               return true;
            case msg is PartyCannotJoinErrorMessage:
               pcjenmsg = msg as PartyCannotJoinErrorMessage;
               this._isInviting = false;
               reasonText = "";
               switch(pcjenmsg.reason)
               {
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PARTY_FULL:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.party.partyFull"));
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PARTY_NOT_FOUND:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.party.cantFindParty"));
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PLAYER_ALREADY_IN_A_PARTY:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.party.playerAllreadyInAParty"));
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PLAYER_BUSY:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.party.cantInvitPlayerBusy"));
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PLAYER_IS_ALREADY_BEING_INVITED:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.party.playerAlreayBeingInvited"));
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_PLAYER_NOT_FOUND:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.common.playerNotFound"),[this._playerNameInvited]);
                     break;
                  case PartyJoinErrorEnum.PARTY_JOIN_ERROR_UNKNOWN:
                  default:
                     reasonText = I18n.getText(I18nProxy.getKeyId("ui.common.error"));
               }
               KernelEventsManager.getInstance().processCallback(HookList.PartyCannotJoinError,reasonText);
               return true;
            case msg is PartyAcceptInvitationAction:
               paimsg = msg as PartyAcceptInvitationAction;
               pacceptimsg = new PartyAcceptInvitationMessage();
               pacceptimsg.initPartyAcceptInvitationMessage();
               ConnectionsHandler.getConnection().send(pacceptimsg);
               return true;
            case msg is PartyRefuseInvitationAction:
               prefuseimsg = new PartyRefuseInvitationMessage();
               prefuseimsg.initPartyRefuseInvitationMessage();
               ConnectionsHandler.getConnection().send(prefuseimsg);
               return true;
            case msg is PartyRefuseInvitationNotificationMessage:
               this._isInviting = false;
               KernelEventsManager.getInstance().processCallback(HookList.PartyRefuseInvitationNotification);
               return true;
            case msg is PartyCancelInvitationAction:
               this._isInviting = false;
               pcancelimsg = new PartyRefuseInvitationMessage();
               pcancelimsg.initPartyRefuseInvitationMessage();
               ConnectionsHandler.getConnection().send(pcancelimsg);
               return true;
            case msg is PartyJoinMessage:
               pjmsg = msg as PartyJoinMessage;
               this._isInviting = false;
               this._partyMembers = new Vector.<PartyMember>();
               for each(member in pjmsg.members)
               {
                  partyMember = new PartyMember();
                  partyMember.infos = member;
                  if(member.id == pjmsg.partyLeaderId)
                  {
                     partyMember.isLeader = true;
                  }
                  partyMember.skin = EntityLookAdapter.fromNetwork(member.entityLook);
                  this._partyMembers.push(partyMember);
               }
               this._partyMembers.sort(this.membersSortFunction);
               this._timerRegen.start();
               KernelEventsManager.getInstance().processCallback(HookList.PartyJoin,this.partyMembers);
               PlayedCharacterManager.getInstance().isInParty = true;
               if(pjmsg.partyLeaderId == PlayedCharacterManager.getInstance().infos.id)
               {
                  PlayedCharacterManager.getInstance().isPartyLeader = true;
               }
               return true;
            case msg is PartyKickRequestAction:
               pka = msg as PartyKickRequestAction;
               pkickrimsg = new PartyKickRequestMessage();
               pkickrimsg.initPartyKickRequestMessage(pka.playerId);
               ConnectionsHandler.getConnection().send(pkickrimsg);
               return true;
            case msg is PartyKickedByMessage:
               pkbmsg = msg as PartyKickedByMessage;
               KernelEventsManager.getInstance().processCallback(HookList.PartyKickedBy,pkbmsg.kickerId);
               this._timerRegen.stop();
               PlayedCharacterManager.getInstance().isInParty = false;
               PlayedCharacterManager.getInstance().isPartyLeader = false;
               return true;
            case msg is PartyLeaveMessage:
               plmsg = msg as PartyLeaveMessage;
               this._timerRegen.stop();
               KernelEventsManager.getInstance().processCallback(HookList.PartyLeave);
               PlayedCharacterManager.getInstance().isInParty = false;
               PlayedCharacterManager.getInstance().isPartyLeader = false;
               this._partyMembers = new Vector.<PartyMember>();
               return true;
            case msg is PartyUpdateMessage:
               pumsg = msg as PartyUpdateMessage;
               newPlayer = true;
               for each(pMember in this._partyMembers)
               {
                  if(pMember.infos.id == pumsg.memberInformations.id)
                  {
                     pMember.infos = pumsg.memberInformations;
                     newSkin = EntityLookAdapter.fromNetwork(pumsg.memberInformations.entityLook);
                     if(ObjectCompare.compareObjects(newSkin,pMember.skin))
                     {
                        pMember.skin = newSkin;
                        pMember.skinModified = true;
                     }
                     else
                     {
                        pMember.skinModified = false;
                     }
                     newPlayer = false;
                  }
               }
               if(newPlayer)
               {
                  playerLook = pumsg.memberInformations.entityLook;
                  newMember = new PartyMember();
                  newMember.infos = pumsg.memberInformations;
                  newMember.skin = EntityLookAdapter.fromNetwork(playerLook);
                  newMember.skinModified = true;
                  this._partyMembers.push(newMember);
               }
               if(this._dicRegen[pumsg.memberInformations.id] == null)
               {
                  lptm = new LifePointTickManager();
               }
               else
               {
                  lptm = this._dicRegen[pumsg.memberInformations.id];
               }
               lptm.originalLifePoint = pumsg.memberInformations.lifePoints;
               lptm.regenRate = pumsg.memberInformations.regenRate;
               lptm.tickNumber = 1;
               this._dicRegen[pumsg.memberInformations.id] = lptm;
               if(Boolean(this._isInviting) && Boolean(newPlayer))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.PartyPlayerAcceptInvitation,newMember.infos.id);
                  this._isInviting = false;
               }
               this._partyMembers.sort(this.membersSortFunction);
               KernelEventsManager.getInstance().processCallback(HookList.PartyUpdate,this.partyMembers);
               return true;
            case msg is PartyMemberRemoveMessage:
               pmrmsg = msg as PartyMemberRemoveMessage;
               compt = 0;
               for each(partyM in this._partyMembers)
               {
                  partyM.skinModified = true;
                  if(partyM.infos.id == pmrmsg.leavingPlayerId)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.PartyMemberRemove,partyM);
                     partyM = null;
                     this._partyMembers.splice(compt,1);
                  }
                  else
                  {
                     compt++;
                  }
               }
               this._partyMembers.sort(this.membersSortFunction);
               KernelEventsManager.getInstance().processCallback(HookList.PartyUpdate,this.partyMembers);
               if(pmrmsg.leavingPlayerId == PlayedCharacterManager.getInstance().infos.id)
               {
                  PlayedCharacterManager.getInstance().isPartyLeader = false;
                  PlayedCharacterManager.getInstance().isInParty = false;
               }
               return true;
            case msg is PartyLeaveRequestAction:
               plra = msg as PartyLeaveRequestAction;
               plrmsg = new PartyLeaveRequestMessage();
               plrmsg.initPartyLeaveRequestMessage();
               ConnectionsHandler.getConnection().send(plrmsg);
               return true;
            case msg is PartyLeaderUpdateMessage:
               plulmsg = msg as PartyLeaderUpdateMessage;
               for each(partyMem in this._partyMembers)
               {
                  if(partyMem.infos.id == plulmsg.partyLeaderId)
                  {
                     partyMem.isLeader = true;
                  }
                  else
                  {
                     partyMem.isLeader = false;
                  }
               }
               if(plulmsg.partyLeaderId == PlayedCharacterManager.getInstance().infos.id)
               {
                  PlayedCharacterManager.getInstance().isPartyLeader = true;
               }
               else
               {
                  PlayedCharacterManager.getInstance().isPartyLeader = false;
               }
               this._partyMembers.sort(this.membersSortFunction);
               KernelEventsManager.getInstance().processCallback(HookList.PartyUpdate,this.partyMembers);
               KernelEventsManager.getInstance().processCallback(HookList.PartyLeaderUpdate,plulmsg.partyLeaderId);
               return true;
            case msg is PartyUpdateLightMessage:
               pulmsg = msg as PartyUpdateLightMessage;
               for each(partyMemb in this._partyMembers)
               {
                  if(partyMemb.infos.id == pulmsg.id)
                  {
                     partyMemb.infos.lifePoints = pulmsg.lifePoints;
                     partyMemb.infos.maxLifePoints = pulmsg.maxLifePoints;
                     partyMemb.infos.prospecting = pulmsg.prospecting;
                     partyMemb.infos.regenRate = pulmsg.regenRate;
                  }
                  if(this._dicRegen[partyMemb.infos.id] == null)
                  {
                     lptmanager = new LifePointTickManager();
                  }
                  else
                  {
                     lptmanager = this._dicRegen[partyMemb.infos.id];
                  }
                  lptmanager.originalLifePoint = partyMemb.infos.lifePoints;
                  lptmanager.regenRate = partyMemb.infos.regenRate;
                  lptmanager.tickNumber = 1;
                  this._dicRegen[partyMemb.infos.id] = lptmanager;
               }
               KernelEventsManager.getInstance().processCallback(HookList.PartyMemberUpdate,pulmsg.id,pulmsg.lifePoints,pulmsg.maxLifePoints,pulmsg.prospecting,pulmsg.regenRate);
               return true;
            case msg is PartyAbdicateThroneAction:
               pata = msg as PartyAbdicateThroneAction;
               patmsg = new PartyAbdicateThroneMessage();
               patmsg.initPartyAbdicateThroneMessage(pata.playerId);
               ConnectionsHandler.getConnection().send(patmsg);
               return true;
            case msg is PartyFollowMemberAction:
               pfma = msg as PartyFollowMemberAction;
               pfmrmsg = new PartyFollowMemberRequestMessage();
               pfmrmsg.initPartyFollowMemberRequestMessage(pfma.playerId);
               ConnectionsHandler.getConnection().send(pfmrmsg);
               return true;
            case msg is PartyStopFollowingMemberAction:
               psfma = msg as PartyStopFollowingMemberAction;
               psfrmsg = new PartyStopFollowRequestMessage();
               psfrmsg.initPartyStopFollowRequestMessage();
               ConnectionsHandler.getConnection().send(psfrmsg);
               return true;
            case msg is PartyAllFollowMemberAction:
               pafma = msg as PartyAllFollowMemberAction;
               pftmrmsg = new PartyFollowThisMemberRequestMessage();
               pftmrmsg.initPartyFollowThisMemberRequestMessage(pafma.playerId,true);
               this.allMemberFollowPlayerId = pafma.playerId;
               ConnectionsHandler.getConnection().send(pftmrmsg);
               return true;
            case msg is PartyAllStopFollowingMemberAction:
               pasfma = msg as PartyAllStopFollowingMemberAction;
               pftmrmsg2 = new PartyFollowThisMemberRequestMessage();
               pftmrmsg2.initPartyFollowThisMemberRequestMessage(pasfma.playerId,false);
               this.allMemberFollowPlayerId = 0;
               ConnectionsHandler.getConnection().send(pftmrmsg2);
               return true;
            case msg is PartyShowMenuAction:
               psma = msg as PartyShowMenuAction;
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               menu = this.createPartyPlayerContextMenu(psma.playerId);
               commonMod.createContextMenu(menu);
               return true;
            case msg is CompassUpdatePartyMemberMessage:
               cupmmsg = msg as CompassUpdatePartyMemberMessage;
               KernelEventsManager.getInstance().processCallback(HookList.CompassUpdate,cupmmsg.type,cupmmsg.worldX,cupmmsg.worldY,cupmmsg.memberId);
               return true;
            case msg is PartyLocateMembersMessage:
               plmmsg = msg as PartyLocateMembersMessage;
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         this._timerRegen.stop();
         this._timerRegen.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         this._timerRegen = null;
         return true;
      }
      
      public function getGroupMemberById(id:int) : PartyMemberInformations
      {
         var m:PartyMember = null;
         for each(m in this._partyMembers)
         {
            if(m.infos.id == id)
            {
               return m.infos;
            }
         }
         return null;
      }
      
      private function createPartyPlayerContextMenu(pPlayerId:uint) : Array
      {
         var playerAlignmentInfos:ActorAlignmentInformations = null;
         var member:PartyMember = null;
         var entityId:int = 0;
         var menu:Array = new Array();
         var playerName:String = "";
         var socialApi:SocialApi = new SocialApi();
         var playerIsOnSameMap:Boolean = false;
         for each(member in this._partyMembers)
         {
            if(member.infos.id == pPlayerId)
            {
               playerName = member.infos.name;
            }
         }
         if(playerName == "")
         {
            return menu;
         }
         for each(entityId in this._roleplayEntitiesFrame.playersId)
         {
            if(entityId == pPlayerId)
            {
               playerIsOnSameMap = true;
               if(this._roleplayEntitiesFrame.getEntityInfos(entityId) is GameRolePlayCharacterInformations)
               {
                  playerAlignmentInfos = (this._roleplayEntitiesFrame.getEntityInfos(entityId) as GameRolePlayCharacterInformations).alignmentInfos;
                  continue;
               }
               return new Array();
            }
         }
         menu = MenusFactory.create({
            "id":pPlayerId,
            "name":playerName,
            "onSameMap":playerIsOnSameMap,
            "alignmentInfos":playerAlignmentInfos
         },"partyMember",null);
         return menu;
      }
      
      private function membersSortFunction(pMember1:PartyMember, pMember2:PartyMember) : Number
      {
         if(pMember1.isLeader)
         {
            return -1;
         }
         if(pMember2.isLeader)
         {
            return 1;
         }
         if(pMember1.infos.initiative > pMember2.infos.initiative)
         {
            return -1;
         }
         if(pMember1.infos.initiative < pMember2.infos.initiative)
         {
            return 1;
         }
         return 0;
      }
      
      private function onTimerTick(pEvent:TimerEvent) : void
      {
         var member:PartyMember = null;
         var playerLPTM:LifePointTickManager = null;
         var additionalLifePoint:uint = 0;
         var newLifePoints:uint = 0;
         var lptm:LifePointTickManager = null;
         for each(member in this._partyMembers)
         {
            if(member.infos.lifePoints < member.infos.maxLifePoints && member.infos.regenRate > 0)
            {
               if(this._dicRegen[member.infos.id] == null)
               {
                  lptm = new LifePointTickManager();
                  lptm.originalLifePoint = member.infos.lifePoints;
                  lptm.regenRate = member.infos.regenRate;
                  lptm.tickNumber = 1;
                  this._dicRegen[member.infos.id] = lptm;
               }
               playerLPTM = this._dicRegen[member.infos.id] as LifePointTickManager;
               additionalLifePoint = Math.floor(playerLPTM.tickNumber * (10 / playerLPTM.regenRate));
               newLifePoints = playerLPTM.originalLifePoint + additionalLifePoint;
               if(newLifePoints >= member.infos.maxLifePoints)
               {
                  newLifePoints = member.infos.maxLifePoints;
               }
               member.infos.lifePoints = newLifePoints;
               playerLPTM.tickNumber++;
               KernelEventsManager.getInstance().processCallback(HookList.PartyMemberLifeUpdate,member.infos.id,member.infos.lifePoints);
            }
            member.skinModified = false;
         }
      }
   }
}

import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
import com.ankamagames.tiphon.types.look.TiphonEntityLook;

class PartyMember
{
    
   public var isLeader:Boolean = false;
   
   public var infos:PartyMemberInformations;
   
   public var skin:TiphonEntityLook;
   
   public var skinModified:Boolean = false;
   
   function PartyMember()
   {
      super();
   }
}

class LifePointTickManager
{
    
   public var originalLifePoint:uint;
   
   public var regenRate:uint;
   
   public var tickNumber:uint;
   
   function LifePointTickManager()
   {
      super();
   }
}
