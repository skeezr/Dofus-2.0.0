package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class HookList
   {
      
      public static const LangFileLoaded:Hook = new Hook("LangFileLoaded",true);
      
      public static const ConfigStart:Hook = new Hook("ConfigStart",true);
      
      public static const AuthentificationStart:Hook = new Hook("AuthentificationStart",true);
      
      public static const IdentificationFailed:Hook = new Hook("IdentificationFailed",true);
      
      public static const IdentificationFailedForBadVersion:Hook = new Hook("IdentificationFailedForBadVersion",true);
      
      public static const LoginQueueStart:Hook = new Hook("LoginQueueStart",true);
      
      public static const LoginQueueStatus:Hook = new Hook("LoginQueueStatus",true);
      
      public static const QueueStatus:Hook = new Hook("QueueStatus",true);
      
      public static const SubscribersList:Hook = new Hook("SubscribersList",true);
      
      public static const NewsLogin:Hook = new Hook("NewsLogin",true);
      
      public static const ServerConnectionFailed:Hook = new Hook("ServerConnectionFailed",true);
      
      public static const SelectedServerRefused:Hook = new Hook("SelectedServerRefused",true);
      
      public static const AuthenticationTicket:Hook = new Hook("AuthenticationTicket",true);
      
      public static const ConsoleOutput:Hook = new Hook("ConsoleOutput",true);
      
      public static const ConnectionStart:Hook = new Hook("ConnectionStart",true);
      
      public static const ServersList:Hook = new Hook("ServersList",true);
      
      public static const CharacterSelectionStart:Hook = new Hook("CharacterSelectionStart",true);
      
      public static const CharacterCreationStart:Hook = new Hook("CharacterCreationStart",true);
      
      public static const CharactersListUpdated:Hook = new Hook("CharactersListUpdated",true);
      
      public static const TutorielAvailable:Hook = new Hook("TutorielAvailable",true);
      
      public static const CharacterStatsList:Hook = new Hook("CharacterStatsList",true);
      
      public static const CharacterLevelUp:Hook = new Hook("CharacterLevelUp",true);
      
      public static const CharacterNameSuggestioned:Hook = new Hook("CharacterNameSuggestioned",true);
      
      public static const CharacterDeletionError:Hook = new Hook("CharacterDeletionError",true);
      
      public static const CharacterCreationResult:Hook = new Hook("CharacterCreationResult",true);
      
      public static const CharacterImpossibleSelection:Hook = new Hook("CharacterImpossibleSelection",true);
      
      public static const NicknameRegistration:Hook = new Hook("NicknameRegistration",true);
      
      public static const NicknameRefused:Hook = new Hook("NicknameRefused",true);
      
      public static const NicknameAccepted:Hook = new Hook("NicknameAccepted",true);
      
      public static const GameStart:Hook = new Hook("GameStart",true);
      
      public static const SpellList:Hook = new Hook("SpellList",true);
      
      public static const SmileysStart:Hook = new Hook("SmileysStart",false);
      
      public static const UnexpectedSocketClosure:Hook = new Hook("UnexpectedSocketClosure",true);
      
      public static const CurrentMap:Hook = new Hook("CurrentMap",true);
      
      public static const EntityMouseOver:Hook = new Hook("EntityMouseOver",false);
      
      public static const EntityMouseOut:Hook = new Hook("EntityMouseOut",false);
      
      public static const OpenMap:Hook = new Hook("OpenMap",false);
      
      public static const MapDisplay:Hook = new Hook("MapDisplay",false);
      
      public static const OpenBook:Hook = new Hook("OpenBook",false);
      
      public static const OpenGrimoireSpellTab:Hook = new Hook("OpenGrimoireSpellTab",false);
      
      public static const OpenSpellInterface:Hook = new Hook("OpenSpellInterface",false);
      
      public static const OpenRecipe:Hook = new Hook("OpenRecipe",false);
      
      public static const HouseProperties:Hook = new Hook("HouseProperties",false);
      
      public static const HouseEntered:Hook = new Hook("HouseEntered",false);
      
      public static const HouseExit:Hook = new Hook("HouseExit",false);
      
      public static const HouseGuildNone:Hook = new Hook("HouseGuildNone",false);
      
      public static const HouseGuildRights:Hook = new Hook("HouseGuildRights",false);
      
      public static const PurchasableDialog:Hook = new Hook("PurchasableDialog",false);
      
      public static const HouseBuyResult:Hook = new Hook("HouseBuyResult",false);
      
      public static const HouseSold:Hook = new Hook("HouseSold",false);
      
      public static const LockableShowCode:Hook = new Hook("LockableShowCode",false);
      
      public static const LockableCodeResult:Hook = new Hook("LockableCodeResult",false);
      
      public static const LockableStateUpdateHouseDoor:Hook = new Hook("LockableStateUpdateHouseDoor",false);
      
      public static const FightEvent:Hook = new Hook("FightEvent",false);
      
      public static const GameFightStarting:Hook = new Hook("GameFightStarting",false);
      
      public static const GameFightJoin:Hook = new Hook("GameFightJoin",false);
      
      public static const GameFightTurnChangeInformations:Hook = new Hook("GameFightTurnChangeInformations",false);
      
      public static const GameFightTurnEnd:Hook = new Hook("GameFightTurnEnd",false);
      
      public static const FightersListUpdated:Hook = new Hook("FightersListUpdated",false);
      
      public static const GameFightTurnStart:Hook = new Hook("GameFightTurnStart",false);
      
      public static const GameFightStart:Hook = new Hook("GameFightStart",false);
      
      public static const GameFightEnd:Hook = new Hook("GameFightEnd",false);
      
      public static const GameFightLeave:Hook = new Hook("GameFightLeave",false);
      
      public static const GameActionFightPointsVariation:Hook = new Hook("GameActionFightPointsVariation",false);
      
      public static const GameActionFightPointsUse:Hook = new Hook("GameActionFightPointsUse",false);
      
      public static const GameActionFightLifePointsVariation:Hook = new Hook("GameActionFightLifePointsVariation",false);
      
      public static const GameActionFightDying:Hook = new Hook("GameActionFightDying",false);
      
      public static const GameActionFightDeathEnd:Hook = new Hook("GameActionFightDeathEnd",false);
      
      public static const CancelCastSpell:Hook = new Hook("CancelCastSpell",false);
      
      public static const CastSpellMode:Hook = new Hook("CastSpellMode",false);
      
      public static const ShowCell:Hook = new Hook("ShowCell",false);
      
      public static const OptionLockFight:Hook = new Hook("OptionLockFight",false);
      
      public static const OptionLockParty:Hook = new Hook("OptionLockParty",false);
      
      public static const OptionHelpWanted:Hook = new Hook("OptionHelpWanted",false);
      
      public static const OptionWitnessForbidden:Hook = new Hook("OptionWitnessForbidden",false);
      
      public static const MapsLoadingComplete:Hook = new Hook("MapsLoadingComplete",false);
      
      public static const MapFightCount:Hook = new Hook("MapFightCount",false);
      
      public static const ZaapList:Hook = new Hook("ZaapList",false);
      
      public static const LeaveDialog:Hook = new Hook("LeaveDialog",false);
      
      public static const GameRolePlayShowChallenge:Hook = new Hook("GameRolePlayShowChallenge",false);
      
      public static const MapComplementaryInformationsData:Hook = new Hook("MapComplementaryInformationsData",false);
      
      public static const StatsUpgradeResult:Hook = new Hook("StatsUpgradeResult",false);
      
      public static const OpenStats:Hook = new Hook("OpenStats",false);
      
      public static const OpenInventory:Hook = new Hook("OpenInventory",false);
      
      public static const OpenMount:Hook = new Hook("OpenMount",false);
      
      public static const OpenMainMenu:Hook = new Hook("OpenMainMenu",false);
      
      public static const CloseInventory:Hook = new Hook("CloseInventory",false);
      
      public static const SpellUpgradeSuccess:Hook = new Hook("SpellUpgradeSuccess",false);
      
      public static const SpellForgotten:Hook = new Hook("SpellForgotten",false);
      
      public static const SpellUpgradeFail:Hook = new Hook("SpellUpgradeFail",false);
      
      public static const PartyFollowStatusUpdate:Hook = new Hook("PartyFollowStatusUpdate",false);
      
      public static const CompassUpdate:Hook = new Hook("CompassUpdate",false);
      
      public static const JobsListUpdated:Hook = new Hook("JobsListUpdated",false);
      
      public static const JobsExpUpdated:Hook = new Hook("JobsExpUpdated",false);
      
      public static const NpcDialogCreation:Hook = new Hook("NpcDialogCreation",false);
      
      public static const PonyDialogCreation:Hook = new Hook("PonyDialogCreation",false);
      
      public static const NpcDialogCreationFailure:Hook = new Hook("NpcDialogCreationFailure",false);
      
      public static const NpcDialogQuestion:Hook = new Hook("NpcDialogQuestion",false);
      
      public static const SpellMovement:Hook = new Hook("SpellMovement",false);
      
      public static const SpellInventoryUpdate:Hook = new Hook("SpellInventoryUpdate",false);
      
      public static const PartyInvitation:Hook = new Hook("PartyInvitation",false);
      
      public static const PartyJoin:Hook = new Hook("PartyJoin",false);
      
      public static const PartyCannotJoinError:Hook = new Hook("PartyCannotJoinError",false);
      
      public static const PartyLeaderUpdate:Hook = new Hook("PartyLeaderUpdate",false);
      
      public static const PartyLeave:Hook = new Hook("PartyLeave",false);
      
      public static const PartyKickedBy:Hook = new Hook("PartyKickedBy",false);
      
      public static const PartyLocateMembers:Hook = new Hook("PartyLocateMembers",false);
      
      public static const PartyMemberRemove:Hook = new Hook("PartyMemberRemove",false);
      
      public static const PartyRefuseInvitationNotification:Hook = new Hook("PartyRefuseInvitationNotification",false);
      
      public static const PartyUpdate:Hook = new Hook("PartyUpdate",false);
      
      public static const PartyMemberLifeUpdate:Hook = new Hook("PartyMemberLifeUpdate",false);
      
      public static const PartyMemberUpdate:Hook = new Hook("PartyMemberUpdate",false);
      
      public static const PlayedCharacterLookChange:Hook = new Hook("PlayedCharacterLookChange",false);
      
      public static const PartyPlayerAcceptInvitation:Hook = new Hook("PartyPlayerAcceptInvitation",false);
      
      public static const MapRunningFightList:Hook = new Hook("MapRunningFightList",false);
      
      public static const MapRunningFightDetails:Hook = new Hook("MapRunningFightDetails",false);
      
      public static const GameRolePlayRemoveFight:Hook = new Hook("GameRolePlayRemoveFight",false);
      
      public static const GameRolePlayAllowSpectatorInFight:Hook = new Hook("GameRolePlayAllowSpectatorInFight",false);
      
      public static const ConfigPropertyChange:Hook = new Hook("ConfigPropertyChange",false);
      
      public static const OpenChatOptions:Hook = new Hook("OpenChatOptions",false);
      
      public static const UpdateChatOptions:Hook = new Hook("UpdateChatOptions",false);
      
      public static const GameRolePlayPlayerLifeStatus:Hook = new Hook("GameRolePlayPlayerLifeStatus",false);
      
      public static const TooltipSpellReset:Hook = new Hook("TooltipSpellReset",false);
      
      public static const DoubleClickItemInventory:Hook = new Hook("DoubleClickItemInventory",false);
      
      public static const NonSubscriberPopup:Hook = new Hook("NonSubscriberPopup",false);
      
      public static const SubscriptionZone:Hook = new Hook("SubscriptionZone",false);
      
      public static const GiftList:Hook = new Hook("GiftList",false);
      
      public static const GiftAssigned:Hook = new Hook("GiftAssigned",false);
      
      public static const DocumentReadingBeginMessage:Hook = new Hook("DocumentReadingBeginMessage",false);
      
      public static const AddMapFlag:Hook = new Hook("AddMapFlag",false);
      
      public static const ContextChanged:Hook = new Hook("ContextChanged",false);
      
      public static const LevelUiClosed:Hook = new Hook("LevelUiClosed",false);
      
      public static const NotificationReset:Hook = new Hook("NotificationReset",false);
      
      public static const ArtworkMode:Hook = new Hook("ArtworkMode",false);
       
      public function HookList()
      {
         super();
      }
   }
}
