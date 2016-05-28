package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatCommandAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatLoadedAction;
   import com.ankamagames.dofus.logic.common.actions.AuthorizedCommandAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.NicknameChoiceRequestAction;
   import com.ankamagames.dofus.logic.connection.actions.ServerSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.SubscribersGiftListRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.NewsLoginRequestAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeCharacterAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeServerAction;
   import com.ankamagames.dofus.logic.common.actions.QuitGameAction;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterCreationAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterDeletionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterNameSuggestionRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterRecolorSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayWithRecolorRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterRenameSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayWithRenameRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.GameContextQuitAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenCurrentFightAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenFriendsAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMainMenuAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.CloseInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenMapAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenBookAction;
   import com.ankamagames.dofus.logic.game.common.actions.CloseBookAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenServerSelectionAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSmileysAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenStatsAction;
   import com.ankamagames.dofus.logic.game.common.actions.IncreaseSpellLevelAction;
   import com.ankamagames.dofus.logic.game.common.actions.BasicWhoIsRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ChallengeTargetsListRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightReadyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightSpellCastAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightTurnFinishAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.BannerEmptySlotClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleDematerializationAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleHelpWantedAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockFightAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleLockPartyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleWitnessForbiddenAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TogglePointCellAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameContextKickAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.TeleportRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectSetPositionAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectDropAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.SpellSetPositionAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.StatsUpgradeRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.DeleteObjectAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectUseAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcDialogReplyAction;
   import com.ankamagames.dofus.logic.game.common.actions.InteractiveElementActivationAction;
   import com.ankamagames.dofus.logic.game.common.actions.PivotCharacterAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAcceptInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyRefuseInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyKickRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAbdicateThroneAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyFollowMemberAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAllFollowMemberAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyStopFollowingMemberAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyAllStopFollowingMemberAction;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyShowMenuAction;
   import com.ankamagames.dofus.logic.game.common.actions.spectator.MapRunningFightDetailsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.spectator.JoinAsSpectatorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildShareAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildRightsViewAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseGuildRightsChangeAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.LeaveDialogAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseSellAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseSellFromInsideAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseKickAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseKickIndoorMerchantAction;
   import com.ankamagames.dofus.logic.game.common.actions.LockableChangeCodeAction;
   import com.ankamagames.dofus.logic.game.common.actions.LockableUseCodeAction;
   import com.ankamagames.dofus.logic.game.common.actions.HouseLockFromInsideAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.GameRolePlayFreeSoulRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestStartRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestObjectiveValidationAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeReturnRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.alignment.GetPVPActivationCostAction;
   import com.ankamagames.dofus.logic.game.common.actions.alignment.SetEnablePVPRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismCurrentBonusRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismBalanceRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismFightJoinLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismFightSwapRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismInfoJoinLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismWorldInformationRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismAttackRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.prism.PrismUseRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ObjectUseOnCellAction;
   import com.ankamagames.dofus.logic.game.approach.actions.GiftAssignRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationUpdateFlagAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationResetAction;
   import com.ankamagames.dofus.logic.game.common.actions.PlaySoundAction;
   
   public class ApiActionList
   {
      
      public static const ChatCommand:ApiAction = new ApiAction("ChatCommand",ChatCommandAction,true);
      
      public static const ChatLoaded:ApiAction = new ApiAction("ChatLoaded",ChatLoadedAction,true);
      
      public static const AuthorizedCommand:ApiAction = new ApiAction("AuthorizedCommand",AuthorizedCommandAction,true);
      
      public static const LoginValidation:ApiAction = new ApiAction("LoginValidation",LoginValidationAction,true);
      
      public static const NicknameChoiceRequest:ApiAction = new ApiAction("NicknameChoiceRequest",NicknameChoiceRequestAction,true);
      
      public static const ServerSelection:ApiAction = new ApiAction("ServerSelection",ServerSelectionAction,true);
      
      public static const SubscribersGiftListRequest:ApiAction = new ApiAction("SubscribersGiftListRequest",SubscribersGiftListRequestAction,true);
      
      public static const NewsLoginRequest:ApiAction = new ApiAction("NewsLoginRequest",NewsLoginRequestAction,true);
      
      public static const ChangeCharacter:ApiAction = new ApiAction("ChangeCharacter",ChangeCharacterAction,true);
      
      public static const ChangeServer:ApiAction = new ApiAction("ChangeServer",ChangeServerAction,true);
      
      public static const QuitGame:ApiAction = new ApiAction("QuitGame",QuitGameAction,true);
      
      public static const ResetGame:ApiAction = new ApiAction("ResetGame",ResetGameAction,true);
      
      public static const CharacterCreation:ApiAction = new ApiAction("CharacterCreation",CharacterCreationAction,true);
      
      public static const CharacterDeletion:ApiAction = new ApiAction("CharacterDeletion",CharacterDeletionAction,true);
      
      public static const CharacterNameSuggestionRequest:ApiAction = new ApiAction("CharacterNameSuggestionRequest",CharacterNameSuggestionRequestAction,true);
      
      public static const CharacterReplayRequest:ApiAction = new ApiAction("CharacterReplayRequest",CharacterReplayRequestAction,true);
      
      public static const CharacterSelection:ApiAction = new ApiAction("CharacterSelection",CharacterSelectionAction,true);
      
      public static const CharacterRecolorSelection:ApiAction = new ApiAction("CharacterRecolorSelection",CharacterRecolorSelectionAction,true);
      
      public static const CharacterReplayWithRecolorRequest:ApiAction = new ApiAction("CharacterReplayWithRecolorRequest",CharacterReplayWithRecolorRequestAction,true);
      
      public static const CharacterRenameSelection:ApiAction = new ApiAction("CharacterRenameSelection",CharacterRenameSelectionAction,true);
      
      public static const CharacterReplayWithRenameRequest:ApiAction = new ApiAction("CharacterReplayWithRenameRequest",CharacterReplayWithRenameRequestAction,true);
      
      public static const GameContextQuit:ApiAction = new ApiAction("GameContextQuit",GameContextQuitAction,true);
      
      public static const OpenCurrentFight:ApiAction = new ApiAction("OpenCurrentFight",OpenCurrentFightAction,true);
      
      public static const OpenFriends:ApiAction = new ApiAction("OpenFriends",OpenFriendsAction,true);
      
      public static const OpenMainMenu:ApiAction = new ApiAction("OpenMainMenu",OpenMainMenuAction,true);
      
      public static const OpenMount:ApiAction = new ApiAction("OpenMount",OpenMountAction,true);
      
      public static const OpenInventory:ApiAction = new ApiAction("OpenInventory",OpenInventoryAction,true);
      
      public static const CloseInventory:ApiAction = new ApiAction("CloseInventory",CloseInventoryAction,true);
      
      public static const OpenMap:ApiAction = new ApiAction("OpenMap",OpenMapAction,true);
      
      public static const OpenBook:ApiAction = new ApiAction("OpenBook",OpenBookAction,true);
      
      public static const CloseBook:ApiAction = new ApiAction("CloseBook",CloseBookAction,true);
      
      public static const OpenServerSelection:ApiAction = new ApiAction("OpenServerSelection",OpenServerSelectionAction,true);
      
      public static const OpenSmileys:ApiAction = new ApiAction("OpenSmileys",OpenSmileysAction,true);
      
      public static const OpenStats:ApiAction = new ApiAction("OpenStats",OpenStatsAction,true);
      
      public static const IncreaseSpellLevel:ApiAction = new ApiAction("IncreaseSpellLevel",IncreaseSpellLevelAction,true);
      
      public static const BasicWhoIsRequest:ApiAction = new ApiAction("BasicWhoIsRequest",BasicWhoIsRequestAction,true);
      
      public static const ChallengeTargetsListRequest:ApiAction = new ApiAction("ChallengeTargetsListRequest",ChallengeTargetsListRequestAction,true);
      
      public static const GameFightReady:ApiAction = new ApiAction("GameFightReady",GameFightReadyAction,true);
      
      public static const GameFightSpellCast:ApiAction = new ApiAction("GameFightSpellCast",GameFightSpellCastAction,true);
      
      public static const GameFightTurnFinish:ApiAction = new ApiAction("GameFightTurnFinish",GameFightTurnFinishAction,true);
      
      public static const TimelineEntityClick:ApiAction = new ApiAction("TimelineEntityClick",TimelineEntityClickAction,true);
      
      public static const BannerEmptySlotClick:ApiAction = new ApiAction("BannerEmptySlotClick",BannerEmptySlotClickAction,true);
      
      public static const TimelineEntityOver:ApiAction = new ApiAction("TimelineEntityOver",TimelineEntityOverAction,true);
      
      public static const TimelineEntityOut:ApiAction = new ApiAction("TimelineEntityOut",TimelineEntityOutAction,true);
      
      public static const ToggleDematerialization:ApiAction = new ApiAction("ToggleDematerialization",ToggleDematerializationAction,true);
      
      public static const ToggleHelpWanted:ApiAction = new ApiAction("ToggleHelpWanted",ToggleHelpWantedAction,true);
      
      public static const ToggleLockFight:ApiAction = new ApiAction("ToggleLockFight",ToggleLockFightAction,true);
      
      public static const ToggleLockParty:ApiAction = new ApiAction("ToggleLockParty",ToggleLockPartyAction,true);
      
      public static const ToggleWitnessForbidden:ApiAction = new ApiAction("ToggleWitnessForbidden",ToggleWitnessForbiddenAction,true);
      
      public static const TogglePointCell:ApiAction = new ApiAction("TogglePointCell",TogglePointCellAction,true);
      
      public static const GameContextKick:ApiAction = new ApiAction("GameContextKick",GameContextKickAction,true);
      
      public static const LeaveDialogRequest:ApiAction = new ApiAction("LeaveDialogRequest",LeaveDialogRequestAction,true);
      
      public static const TeleportRequest:ApiAction = new ApiAction("TeleportRequest",TeleportRequestAction,true);
      
      public static const ObjectSetPosition:ApiAction = new ApiAction("ObjectSetPosition",ObjectSetPositionAction,true);
      
      public static const ObjectDrop:ApiAction = new ApiAction("ObjectDrop",ObjectDropAction,true);
      
      public static const SpellSetPosition:ApiAction = new ApiAction("SpellSetPosition",SpellSetPositionAction,true);
      
      public static const StatsUpgradeRequest:ApiAction = new ApiAction("StatsUpgradeRequest",StatsUpgradeRequestAction,true);
      
      public static const DeleteObject:ApiAction = new ApiAction("DeleteObject",DeleteObjectAction,true);
      
      public static const ObjectUse:ApiAction = new ApiAction("ObjectUse",ObjectUseAction,true);
      
      public static const NpcDialogReply:ApiAction = new ApiAction("NpcDialogReply",NpcDialogReplyAction,true);
      
      public static const InteractiveElementActivation:ApiAction = new ApiAction("InteractiveElementActivation",InteractiveElementActivationAction,true);
      
      public static const PivotCharacter:ApiAction = new ApiAction("PivotCharacter",PivotCharacterAction,true);
      
      public static const PartyInvitation:ApiAction = new ApiAction("PartyInvitation",PartyInvitationAction,true);
      
      public static const PartyAcceptInvitation:ApiAction = new ApiAction("PartyAcceptInvitation",PartyAcceptInvitationAction,true);
      
      public static const PartyRefuseInvitation:ApiAction = new ApiAction("PartyRefuseInvitation",PartyRefuseInvitationAction,true);
      
      public static const PartyLeaveRequest:ApiAction = new ApiAction("PartyLeaveRequest",PartyLeaveRequestAction,true);
      
      public static const PartyKickRequest:ApiAction = new ApiAction("PartyKickRequest",PartyKickRequestAction,true);
      
      public static const PartyAbdicateThrone:ApiAction = new ApiAction("PartyAbdicateThrone",PartyAbdicateThroneAction,true);
      
      public static const PartyFollowMember:ApiAction = new ApiAction("PartyFollowMember",PartyFollowMemberAction,true);
      
      public static const PartyAllFollowMember:ApiAction = new ApiAction("PartyAllFollowMember",PartyAllFollowMemberAction,true);
      
      public static const PartyStopFollowingMember:ApiAction = new ApiAction("PartyStopFollowingMember",PartyStopFollowingMemberAction,true);
      
      public static const PartyAllStopFollowingMember:ApiAction = new ApiAction("PartyAllStopFollowingMember",PartyAllStopFollowingMemberAction,true);
      
      public static const PartyShowMenu:ApiAction = new ApiAction("PartyShowMenu",PartyShowMenuAction,true);
      
      public static const MapRunningFightDetailsRequest:ApiAction = new ApiAction("MapRunningFightDetailsRequest",MapRunningFightDetailsRequestAction,true);
      
      public static const JoinAsSpectatorRequest:ApiAction = new ApiAction("JoinAsSpectatorRequest",JoinAsSpectatorRequestAction,true);
      
      public static const HouseGuildShare:ApiAction = new ApiAction("HouseGuildShare",HouseGuildShareAction,true);
      
      public static const HouseGuildRightsView:ApiAction = new ApiAction("HouseGuildRightsView",HouseGuildRightsViewAction,true);
      
      public static const HouseGuildRightsChange:ApiAction = new ApiAction("HouseGuildRightsChange",HouseGuildRightsChangeAction,true);
      
      public static const HouseBuy:ApiAction = new ApiAction("HouseBuy",HouseBuyAction,true);
      
      public static const LeaveDialog:ApiAction = new ApiAction("LeaveDialog",LeaveDialogAction,true);
      
      public static const HouseSell:ApiAction = new ApiAction("HouseSell",HouseSellAction,true);
      
      public static const HouseSellFromInside:ApiAction = new ApiAction("HouseSellFromInside",HouseSellFromInsideAction,true);
      
      public static const HouseKick:ApiAction = new ApiAction("HouseKick",HouseKickAction,true);
      
      public static const HouseKickMerchant:ApiAction = new ApiAction("HouseKickIndoorMerchant",HouseKickIndoorMerchantAction,true);
      
      public static const LockableChangeCode:ApiAction = new ApiAction("LockableChangeCode",LockableChangeCodeAction,true);
      
      public static const LockableUseCode:ApiAction = new ApiAction("LockableUseCode",LockableUseCodeAction,true);
      
      public static const HouseLockFromInside:ApiAction = new ApiAction("HouseLockFromInside",HouseLockFromInsideAction,true);
      
      public static const GameRolePlayFreeSoulRequest:ApiAction = new ApiAction("GameRolePlayFreeSoulRequest",GameRolePlayFreeSoulRequestAction,true);
      
      public static const QuestInfosRequest:ApiAction = new ApiAction("QuestInfosRequest",QuestInfosRequestAction,true);
      
      public static const QuestListRequest:ApiAction = new ApiAction("QuestListRequest",QuestListRequestAction,true);
      
      public static const QuestStartRequest:ApiAction = new ApiAction("QuestStartRequest",QuestStartRequestAction,true);
      
      public static const QuestObjectiveValidation:ApiAction = new ApiAction("QuestObjectiveValidation",QuestObjectiveValidationAction,true);
      
      public static const GuidedModeReturnRequest:ApiAction = new ApiAction("GuidedModeReturnRequest",GuidedModeReturnRequestAction,true);
      
      public static const GuidedModeQuitRequest:ApiAction = new ApiAction("GuidedModeQuitRequest",GuidedModeQuitRequestAction,true);
      
      public static const GetPVPActivationCost:ApiAction = new ApiAction("GetPVPActivationCost",GetPVPActivationCostAction,true);
      
      public static const SetEnablePVPRequest:ApiAction = new ApiAction("SetEnablePVPRequest",SetEnablePVPRequestAction,true);
      
      public static const PrismCurrentBonusRequest:ApiAction = new ApiAction("PrismCurrentBonusRequest",PrismCurrentBonusRequestAction,true);
      
      public static const PrismBalanceRequest:ApiAction = new ApiAction("PrismBalanceRequest",PrismBalanceRequestAction,true);
      
      public static const PrismFightJoinLeaveRequest:ApiAction = new ApiAction("PrismFightJoinLeaveRequest",PrismFightJoinLeaveRequestAction,true);
      
      public static const PrismFightSwapRequest:ApiAction = new ApiAction("PrismFightSwapRequest",PrismFightSwapRequestAction,true);
      
      public static const PrismInfoJoinLeaveRequest:ApiAction = new ApiAction("PrismInfoJoinLeaveRequest",PrismInfoJoinLeaveRequestAction,true);
      
      public static const PrismWorldInformationRequest:ApiAction = new ApiAction("PrismWorldInformationRequest",PrismWorldInformationRequestAction,true);
      
      public static const PrismAttackRequest:ApiAction = new ApiAction("PrismAttackRequest",PrismAttackRequestAction,true);
      
      public static const PrismUseRequest:ApiAction = new ApiAction("PrismUseRequest",PrismUseRequestAction,true);
      
      public static const ObjectUseOnCell:ApiAction = new ApiAction("ObjectUseOnCell",ObjectUseOnCellAction,true);
      
      public static const GiftAssignRequest:ApiAction = new ApiAction("GiftAssignRequest",GiftAssignRequestAction,true);
      
      public static const NotificationUpdateFlag:ApiAction = new ApiAction("NotificationUpdateFlag",NotificationUpdateFlagAction,true);
      
      public static const NotificationReset:ApiAction = new ApiAction("NotificationReset",NotificationResetAction,true);
      
      public static const PlaySound:ApiAction = new ApiAction("PlaySound",PlaySoundAction,true);
       
      public function ApiActionList()
      {
         super();
      }
   }
}
