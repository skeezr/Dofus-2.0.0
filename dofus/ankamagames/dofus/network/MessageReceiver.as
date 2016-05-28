package com.ankamagames.dofus.network
{
   import com.ankamagames.jerakine.network.RawDataParser;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.messages.handshake.ProtocolRequired;
   import com.ankamagames.dofus.network.messages.queues.LoginQueueStatusMessage;
   import com.ankamagames.dofus.network.messages.queues.QueueStatusMessage;
   import com.ankamagames.dofus.network.messages.authorized.ConsoleMessage;
   import com.ankamagames.dofus.network.messages.connection.HelloConnectMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRegistrationMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameAcceptedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedForBadVersionMessage;
   import com.ankamagames.dofus.network.messages.connection.ServersListMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.HelloGameMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketAcceptedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.GameModeMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AlreadyConnectedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AccountLoggingKickedMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsListMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.character.deletion.CharacterDeletionErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListWithModificationsMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicDateMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicTimeMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicNoOperationMessage;
   import com.ankamagames.dofus.network.messages.game.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.messages.game.basic.TextInformationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectMessageMessage;
   import com.ankamagames.dofus.network.messages.game.initialization.OnConnectionEventMessage;
   import com.ankamagames.dofus.network.messages.game.initialization.SetCharacterRestrictionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveMultipleElementsMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextMoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextMoveMultipleElementsMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapNoMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntitiesDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionErrorMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsNoMatchMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicPongMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicLatencyStatsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.script.CinematicMessage;
   import com.ankamagames.dofus.network.messages.debug.DebugHighlightCellsMessage;
   import com.ankamagames.dofus.network.messages.debug.DebugClearHighlightCellsMessage;
   import com.ankamagames.dofus.network.messages.debug.DebugInClientMessage;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValueMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.TeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightDetailsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.GameRolePlayShowActorMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterStatsListMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.CharacterLevelUpInformationMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.UpdateLifePointsMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenBeginMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayPlayerLifeStatusMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayGameOverMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayFightRequestCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayAggressionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyRequestedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnsweredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayShowChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayRemoveChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.visual.GameRolePlaySpellAnimMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPossiblePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightHumanReadyStateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnReadyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSynchronizeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.messages.game.actions.GameActionNoopMessage;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionWithAckMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.AbstractGameActionFightTargetedAbilityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCloseCombatMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTackledMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightKillMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellableEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStateChangeMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReduceDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDodgePointLossMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSlideMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightExchangePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPassNextTurnsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStealKamaMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightChangeLookMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibilityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightUnmarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleObstacleMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayAbstractMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMassiveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayErrorMessage;
   import com.ankamagames.dofus.network.messages.game.chat.smiley.ChatSmileyMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatAbstractServerMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerCopyMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerCopyWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatErrorMessage;
   import com.ankamagames.dofus.network.messages.game.chat.channel.EnabledChannelsMessage;
   import com.ankamagames.dofus.network.messages.game.chat.channel.ChannelEnablingChangeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.spells.SpellListMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.PauseDialogMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseEndedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportDestinationsListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgetUIMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgottenMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellUpgradeSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellUpgradeFailureMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellItemBoostMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.stats.StatsUpgradeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeResultMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.PVPActivationCostMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentRankUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentSubAreasListMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentAreaUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentSubAreaUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassResetMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdatePartyMemberMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.AtlasPointInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.atlas.compass.CompassUpdatePvpSeekMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyRefuseInvitationNotificationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyCannotJoinErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyUpdateLightMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyMemberRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaderUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLocateMembersMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyKickedByMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsListWithSpouseMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddFailureMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddedMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnConnectionStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnLevelGainStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddFailureMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddedMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecruterMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecrutedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildJoinedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMemberOnlineStatusMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildUIOpenedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsGeneralMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMembersMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMemberUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsPaddocksMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMemberLeavingMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildLeftMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMembershipMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInfosUpgradeMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHousesInformationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockBoughtMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementAddMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersJoinMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemiesListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemyRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismBalanceResultMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismAlignmentBonusResultMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefendersStateMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefenderAddMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefenderLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefendersSwapMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAttackedMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAttackerAddMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightAttackerRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismWorldInformationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.ChallengeFightJoinRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismInfoCloseMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismInfoValidMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismInfoInValidMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepNoInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationListMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationByServerMessage;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionLimitationMessage;
   import com.ankamagames.dofus.network.messages.game.subscriber.SubscriptionZoneMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.MapNpcsQuestStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogCreationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogQuestionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.TaxCollectorDialogQuestionBasicMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.TaxCollectorDialogQuestionExtendedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.EntityTalkMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobDescriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobUnlearntMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceMultiUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobAllowMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobMultiCraftAvailableSkillsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectorySettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobListedUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.KamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMultipleMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.InventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageInventoryContentMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageKamasUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.storage.StorageObjectsRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.SetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.InventoryWeightMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectMovementMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectsAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.GoldAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectDeletedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectsDeletedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectQuantityMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectJobAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectFoundWhileRecoltingMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplayCountModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectPutInBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectRemovedFromBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeObjectModifiedInBagMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeKamaModifiedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ExchangeMultiCraftCrafterCanUseHisRessourcesMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemAddOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseItemRemoveOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseGenericItemRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidHouseInListRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeIsReadyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectIdMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultWithObjectDescMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftInformationObjectMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkHumanVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockMultiMovementRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMountStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidPriceMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeTypesItemsExchangerDescriptionForUserMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeWeightMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkTaxCollectorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeGuildTaxCollectorGetMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ItemNoMoreAvailableMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplyTaxVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeWaitingResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountWithOutPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMountMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountPaddockAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableBornAddMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountStableRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountPaddockRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountTakenFromPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountFreeFromPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeMountSterilizeFromPaddockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBidSearchOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemAutoCraftStopedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemAutoCraftRemainingMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCrafterMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkMulticraftCustomerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkJobIndexMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeGoldPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeItemPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeModifiedPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRemovedPaymentForCraftMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.purchasable.PurchasableDialogMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HousePropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseBuyResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseSoldMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.house.HouseEnteredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.house.HouseExitedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildNoneMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild.HouseGuildRightsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockPropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockSellBuyDialogMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.GameDataPlayFarmObjectAnimationMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSterilizedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRenamedMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountXpRatioMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountUnSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountEquipedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountRidingMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectListAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountEmoteIconUsedOkMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableShowCodeDialogMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableCodeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableStateUpdateAbstractMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableStateUpdateHouseDoorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.lockable.LockableStateUpdateStorageMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.DocumentReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookErrorMessage;
   
   public class MessageReceiver implements RawDataParser
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(MessageReceiver));
       
      public function MessageReceiver()
      {
         super();
      }
      
      public function parse(input:IDataInput, messageId:uint, messageLength:uint) : INetworkMessage
      {
         var message:INetworkMessage = null;
         switch(messageId)
         {
            case 1:
               message = new ProtocolRequired();
               message.unpack(input,messageLength);
               return message;
            case 10:
               message = new LoginQueueStatusMessage();
               message.unpack(input,messageLength);
               return message;
            case 6100:
               message = new QueueStatusMessage();
               message.unpack(input,messageLength);
               return message;
            case 75:
               message = new ConsoleMessage();
               message.unpack(input,messageLength);
               return message;
            case 3:
               message = new HelloConnectMessage();
               message.unpack(input,messageLength);
               return message;
            case 5640:
               message = new NicknameRegistrationMessage();
               return message;
            case 5638:
               message = new NicknameRefusedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5641:
               message = new NicknameAcceptedMessage();
               return message;
            case 22:
               message = new IdentificationSuccessMessage();
               message.unpack(input,messageLength);
               return message;
            case 20:
               message = new IdentificationFailedMessage();
               message.unpack(input,messageLength);
               return message;
            case 21:
               message = new IdentificationFailedForBadVersionMessage();
               message.unpack(input,messageLength);
               return message;
            case 30:
               message = new ServersListMessage();
               message.unpack(input,messageLength);
               return message;
            case 50:
               message = new ServerStatusUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 42:
               message = new SelectedServerDataMessage();
               message.unpack(input,messageLength);
               return message;
            case 41:
               message = new SelectedServerRefusedMessage();
               message.unpack(input,messageLength);
               return message;
            case 101:
               message = new HelloGameMessage();
               return message;
            case 111:
               message = new AuthenticationTicketAcceptedMessage();
               return message;
            case 6003:
               message = new GameModeMessage();
               message.unpack(input,messageLength);
               return message;
            case 112:
               message = new AuthenticationTicketRefusedMessage();
               return message;
            case 109:
               message = new AlreadyConnectedMessage();
               return message;
            case 6029:
               message = new AccountLoggingKickedMessage();
               message.unpack(input,messageLength);
               return message;
            case 1301:
               message = new StartupActionsListMessage();
               message.unpack(input,messageLength);
               return message;
            case 1304:
               message = new StartupActionFinishedMessage();
               message.unpack(input,messageLength);
               return message;
            case 161:
               message = new CharacterCreationResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 166:
               message = new CharacterDeletionErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5544:
               message = new CharacterNameSuggestionSuccessMessage();
               message.unpack(input,messageLength);
               return message;
            case 164:
               message = new CharacterNameSuggestionFailureMessage();
               message.unpack(input,messageLength);
               return message;
            case 151:
               message = new CharactersListMessage();
               message.unpack(input,messageLength);
               return message;
            case 6120:
               message = new CharactersListWithModificationsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5545:
               message = new CharactersListErrorMessage();
               return message;
            case 153:
               message = new CharacterSelectedSuccessMessage();
               message.unpack(input,messageLength);
               return message;
            case 6068:
               message = new CharacterSelectedForceMessage();
               message.unpack(input,messageLength);
               return message;
            case 5836:
               message = new CharacterSelectedErrorMessage();
               return message;
            case 177:
               message = new BasicDateMessage();
               message.unpack(input,messageLength);
               return message;
            case 175:
               message = new BasicTimeMessage();
               message.unpack(input,messageLength);
               return message;
            case 176:
               message = new BasicNoOperationMessage();
               return message;
            case 189:
               message = new SystemMessageDisplayMessage();
               message.unpack(input,messageLength);
               return message;
            case 780:
               message = new TextInformationMessage();
               message.unpack(input,messageLength);
               return message;
            case 6065:
               message = new LivingObjectMessageMessage();
               message.unpack(input,messageLength);
               return message;
            case 5726:
               message = new OnConnectionEventMessage();
               message.unpack(input,messageLength);
               return message;
            case 170:
               message = new SetCharacterRestrictionsMessage();
               message.unpack(input,messageLength);
               return message;
            case 200:
               message = new GameContextCreateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6024:
               message = new GameContextCreateErrorMessage();
               return message;
            case 201:
               message = new GameContextDestroyMessage();
               return message;
            case 251:
               message = new GameContextRemoveElementMessage();
               message.unpack(input,messageLength);
               return message;
            case 252:
               message = new GameContextRemoveMultipleElementsMessage();
               message.unpack(input,messageLength);
               return message;
            case 253:
               message = new GameContextMoveElementMessage();
               message.unpack(input,messageLength);
               return message;
            case 254:
               message = new GameContextMoveMultipleElementsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5637:
               message = new GameContextRefreshEntityLookMessage();
               message.unpack(input,messageLength);
               return message;
            case 954:
               message = new GameMapNoMovementMessage();
               return message;
            case 951:
               message = new GameMapMovementMessage();
               message.unpack(input,messageLength);
               return message;
            case 946:
               message = new GameMapChangeOrientationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5693:
               message = new GameEntityDispositionMessage();
               message.unpack(input,messageLength);
               return message;
            case 5696:
               message = new GameEntitiesDispositionMessage();
               message.unpack(input,messageLength);
               return message;
            case 5695:
               message = new GameEntityDispositionErrorMessage();
               return message;
            case 180:
               message = new BasicWhoIsMessage();
               message.unpack(input,messageLength);
               return message;
            case 179:
               message = new BasicWhoIsNoMatchMessage();
               message.unpack(input,messageLength);
               return message;
            case 183:
               message = new BasicPongMessage();
               message.unpack(input,messageLength);
               return message;
            case 5816:
               message = new BasicLatencyStatsRequestMessage();
               return message;
            case 6053:
               message = new CinematicMessage();
               message.unpack(input,messageLength);
               return message;
            case 2001:
               message = new DebugHighlightCellsMessage();
               message.unpack(input,messageLength);
               return message;
            case 2002:
               message = new DebugClearHighlightCellsMessage();
               return message;
            case 6028:
               message = new DebugInClientMessage();
               message.unpack(input,messageLength);
               return message;
            case 5808:
               message = new DisplayNumericalValueMessage();
               message.unpack(input,messageLength);
               return message;
            case 220:
               message = new CurrentMapMessage();
               message.unpack(input,messageLength);
               return message;
            case 6048:
               message = new TeleportOnSameMapMessage();
               message.unpack(input,messageLength);
               return message;
            case 210:
               message = new MapFightCountMessage();
               message.unpack(input,messageLength);
               return message;
            case 5743:
               message = new MapRunningFightListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5751:
               message = new MapRunningFightDetailsMessage();
               message.unpack(input,messageLength);
               return message;
            case 6051:
               message = new MapObstacleUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 226:
               message = new MapComplementaryInformationsDataMessage();
               message.unpack(input,messageLength);
               return message;
            case 5632:
               message = new GameRolePlayShowActorMessage();
               message.unpack(input,messageLength);
               return message;
            case 500:
               message = new CharacterStatsListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5670:
               message = new CharacterLevelUpMessage();
               message.unpack(input,messageLength);
               return message;
            case 6076:
               message = new CharacterLevelUpInformationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5658:
               message = new UpdateLifePointsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5684:
               message = new LifePointsRegenBeginMessage();
               message.unpack(input,messageLength);
               return message;
            case 5686:
               message = new LifePointsRegenEndMessage();
               message.unpack(input,messageLength);
               return message;
            case 5996:
               message = new GameRolePlayPlayerLifeStatusMessage();
               message.unpack(input,messageLength);
               return message;
            case 746:
               message = new GameRolePlayGameOverMessage();
               return message;
            case 5822:
               message = new GameRolePlayFightRequestCanceledMessage();
               message.unpack(input,messageLength);
               return message;
            case 6073:
               message = new GameRolePlayAggressionMessage();
               message.unpack(input,messageLength);
               return message;
            case 5937:
               message = new GameRolePlayPlayerFightFriendlyRequestedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5733:
               message = new GameRolePlayPlayerFightFriendlyAnsweredMessage();
               message.unpack(input,messageLength);
               return message;
            case 301:
               message = new GameRolePlayShowChallengeMessage();
               message.unpack(input,messageLength);
               return message;
            case 300:
               message = new GameRolePlayRemoveChallengeMessage();
               message.unpack(input,messageLength);
               return message;
            case 6114:
               message = new GameRolePlaySpellAnimMessage();
               message.unpack(input,messageLength);
               return message;
            case 5612:
               message = new ShowCellMessage();
               message.unpack(input,messageLength);
               return message;
            case 700:
               message = new GameFightStartingMessage();
               message.unpack(input,messageLength);
               return message;
            case 702:
               message = new GameFightJoinMessage();
               message.unpack(input,messageLength);
               return message;
            case 703:
               message = new GameFightPlacementPossiblePositionsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5927:
               message = new GameFightOptionStateUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5572:
               message = new GameFightUpdateTeamMessage();
               message.unpack(input,messageLength);
               return message;
            case 711:
               message = new GameFightRemoveTeamMemberMessage();
               message.unpack(input,messageLength);
               return message;
            case 740:
               message = new GameFightHumanReadyStateMessage();
               message.unpack(input,messageLength);
               return message;
            case 721:
               message = new GameFightLeaveMessage();
               message.unpack(input,messageLength);
               return message;
            case 712:
               message = new GameFightStartMessage();
               return message;
            case 6069:
               message = new GameFightSpectateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6067:
               message = new GameFightResumeMessage();
               message.unpack(input,messageLength);
               return message;
            case 720:
               message = new GameFightEndMessage();
               message.unpack(input,messageLength);
               return message;
            case 713:
               message = new GameFightTurnListMessage();
               message.unpack(input,messageLength);
               return message;
            case 714:
               message = new GameFightTurnStartMessage();
               message.unpack(input,messageLength);
               return message;
            case 715:
               message = new GameFightTurnReadyRequestMessage();
               message.unpack(input,messageLength);
               return message;
            case 5921:
               message = new GameFightSynchronizeMessage();
               message.unpack(input,messageLength);
               return message;
            case 719:
               message = new GameFightTurnEndMessage();
               message.unpack(input,messageLength);
               return message;
            case 5864:
               message = new GameFightShowFighterMessage();
               message.unpack(input,messageLength);
               return message;
            case 955:
               message = new SequenceStartMessage();
               message.unpack(input,messageLength);
               return message;
            case 956:
               message = new SequenceEndMessage();
               message.unpack(input,messageLength);
               return message;
            case 1000:
               message = new AbstractGameActionMessage();
               message.unpack(input,messageLength);
               return message;
            case 1002:
               message = new GameActionNoopMessage();
               return message;
            case 1001:
               message = new AbstractGameActionWithAckMessage();
               message.unpack(input,messageLength);
               return message;
            case 6118:
               message = new AbstractGameActionFightTargetedAbilityMessage();
               message.unpack(input,messageLength);
               return message;
            case 1010:
               message = new GameActionFightSpellCastMessage();
               message.unpack(input,messageLength);
               return message;
            case 6116:
               message = new GameActionFightCloseCombatMessage();
               message.unpack(input,messageLength);
               return message;
            case 1030:
               message = new GameActionFightPointsVariationMessage();
               message.unpack(input,messageLength);
               return message;
            case 1004:
               message = new GameActionFightTackledMessage();
               message.unpack(input,messageLength);
               return message;
            case 1099:
               message = new GameActionFightDeathMessage();
               message.unpack(input,messageLength);
               return message;
            case 5571:
               message = new GameActionFightKillMessage();
               message.unpack(input,messageLength);
               return message;
            case 5598:
               message = new GameActionFightLifePointsVariationMessage();
               message.unpack(input,messageLength);
               return message;
            case 6070:
               message = new GameActionFightDispellableEffectMessage();
               message.unpack(input,messageLength);
               return message;
            case 5569:
               message = new GameActionFightStateChangeMessage();
               message.unpack(input,messageLength);
               return message;
            case 5531:
               message = new GameActionFightReflectSpellMessage();
               message.unpack(input,messageLength);
               return message;
            case 5526:
               message = new GameActionFightReduceDamagesMessage();
               message.unpack(input,messageLength);
               return message;
            case 5530:
               message = new GameActionFightReflectDamagesMessage();
               message.unpack(input,messageLength);
               return message;
            case 5828:
               message = new GameActionFightDodgePointLossMessage();
               message.unpack(input,messageLength);
               return message;
            case 5525:
               message = new GameActionFightSlideMessage();
               message.unpack(input,messageLength);
               return message;
            case 5528:
               message = new GameActionFightTeleportOnSameMapMessage();
               message.unpack(input,messageLength);
               return message;
            case 5527:
               message = new GameActionFightExchangePositionsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5529:
               message = new GameActionFightPassNextTurnsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5533:
               message = new GameActionFightDispellMessage();
               message.unpack(input,messageLength);
               return message;
            case 6113:
               message = new GameActionFightDispellEffectMessage();
               message.unpack(input,messageLength);
               return message;
            case 5535:
               message = new GameActionFightStealKamaMessage();
               message.unpack(input,messageLength);
               return message;
            case 5532:
               message = new GameActionFightChangeLookMessage();
               message.unpack(input,messageLength);
               return message;
            case 5821:
               message = new GameActionFightInvisibilityMessage();
               message.unpack(input,messageLength);
               return message;
            case 5825:
               message = new GameActionFightSummonMessage();
               message.unpack(input,messageLength);
               return message;
            case 5540:
               message = new GameActionFightMarkCellsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5570:
               message = new GameActionFightUnmarkCellsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5741:
               message = new GameActionFightTriggerGlyphTrapMessage();
               message.unpack(input,messageLength);
               return message;
            case 5820:
               message = new GameActionFightInvisibleObstacleMessage();
               message.unpack(input,messageLength);
               return message;
            case 5830:
               message = new GameActionFightCarryCharacterMessage();
               message.unpack(input,messageLength);
               return message;
            case 5829:
               message = new GameActionFightThrowCharacterMessage();
               message.unpack(input,messageLength);
               return message;
            case 5826:
               message = new GameActionFightDropCharacterMessage();
               message.unpack(input,messageLength);
               return message;
            case 5689:
               message = new EmoteListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5644:
               message = new EmoteAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5687:
               message = new EmoteRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5690:
               message = new EmotePlayAbstractMessage();
               message.unpack(input,messageLength);
               return message;
            case 5683:
               message = new EmotePlayMessage();
               message.unpack(input,messageLength);
               return message;
            case 5691:
               message = new EmotePlayMassiveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5688:
               message = new EmotePlayErrorMessage();
               return message;
            case 801:
               message = new ChatSmileyMessage();
               message.unpack(input,messageLength);
               return message;
            case 880:
               message = new ChatAbstractServerMessage();
               message.unpack(input,messageLength);
               return message;
            case 881:
               message = new ChatServerMessage();
               message.unpack(input,messageLength);
               return message;
            case 883:
               message = new ChatServerWithObjectMessage();
               message.unpack(input,messageLength);
               return message;
            case 882:
               message = new ChatServerCopyMessage();
               message.unpack(input,messageLength);
               return message;
            case 884:
               message = new ChatServerCopyWithObjectMessage();
               message.unpack(input,messageLength);
               return message;
            case 870:
               message = new ChatErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 892:
               message = new EnabledChannelsMessage();
               message.unpack(input,messageLength);
               return message;
            case 891:
               message = new ChannelEnablingChangeMessage();
               message.unpack(input,messageLength);
               return message;
            case 1200:
               message = new SpellListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5502:
               message = new LeaveDialogMessage();
               return message;
            case 6012:
               message = new PauseDialogMessage();
               return message;
            case 5745:
               message = new InteractiveUsedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6112:
               message = new InteractiveUseEndedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5002:
               message = new InteractiveMapUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5716:
               message = new StatedMapUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5708:
               message = new InteractiveElementUpdatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5709:
               message = new StatedElementUpdatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5960:
               message = new TeleportDestinationsListMessage();
               message.unpack(input,messageLength);
               return message;
            case 1604:
               message = new ZaapListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5565:
               message = new SpellForgetUIMessage();
               message.unpack(input,messageLength);
               return message;
            case 5834:
               message = new SpellForgottenMessage();
               message.unpack(input,messageLength);
               return message;
            case 5746:
               message = new SpellMovementMessage();
               message.unpack(input,messageLength);
               return message;
            case 1201:
               message = new SpellUpgradeSuccessMessage();
               message.unpack(input,messageLength);
               return message;
            case 1202:
               message = new SpellUpgradeFailureMessage();
               return message;
            case 6011:
               message = new SpellItemBoostMessage();
               message.unpack(input,messageLength);
               return message;
            case 5609:
               message = new StatsUpgradeResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5613:
               message = new ChallengeTargetsListMessage();
               message.unpack(input,messageLength);
               return message;
            case 6022:
               message = new ChallengeInfoMessage();
               message.unpack(input,messageLength);
               return message;
            case 6123:
               message = new ChallengeTargetUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6019:
               message = new ChallengeResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 1801:
               message = new PVPActivationCostMessage();
               message.unpack(input,messageLength);
               return message;
            case 6058:
               message = new AlignmentRankUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6059:
               message = new AlignmentSubAreasListMessage();
               message.unpack(input,messageLength);
               return message;
            case 6060:
               message = new AlignmentAreaUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6057:
               message = new AlignmentSubAreaUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5584:
               message = new CompassResetMessage();
               return message;
            case 5591:
               message = new CompassUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5589:
               message = new CompassUpdatePartyMemberMessage();
               message.unpack(input,messageLength);
               return message;
            case 5956:
               message = new AtlasPointInformationsMessage();
               message.unpack(input,messageLength);
               return message;
            case 6013:
               message = new CompassUpdatePvpSeekMessage();
               message.unpack(input,messageLength);
               return message;
            case 5586:
               message = new PartyInvitationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5596:
               message = new PartyRefuseInvitationNotificationMessage();
               return message;
            case 5583:
               message = new PartyCannotJoinErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5576:
               message = new PartyJoinMessage();
               message.unpack(input,messageLength);
               return message;
            case 5575:
               message = new PartyUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6054:
               message = new PartyUpdateLightMessage();
               message.unpack(input,messageLength);
               return message;
            case 5579:
               message = new PartyMemberRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5578:
               message = new PartyLeaderUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5581:
               message = new PartyFollowStatusUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5595:
               message = new PartyLocateMembersMessage();
               message.unpack(input,messageLength);
               return message;
            case 5594:
               message = new PartyLeaveMessage();
               return message;
            case 5590:
               message = new PartyKickedByMessage();
               message.unpack(input,messageLength);
               return message;
            case 4002:
               message = new FriendsListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5931:
               message = new FriendsListWithSpouseMessage();
               message.unpack(input,messageLength);
               return message;
            case 5600:
               message = new FriendAddFailureMessage();
               message.unpack(input,messageLength);
               return message;
            case 5599:
               message = new FriendAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5924:
               message = new FriendUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5601:
               message = new FriendDeleteResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5630:
               message = new FriendWarnOnConnectionStateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6078:
               message = new FriendWarnOnLevelGainStateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5674:
               message = new IgnoredListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5679:
               message = new IgnoredAddFailureMessage();
               message.unpack(input,messageLength);
               return message;
            case 5678:
               message = new IgnoredAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5677:
               message = new IgnoredDeleteResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5920:
               message = new GuildCreationStartedMessage();
               return message;
            case 5554:
               message = new GuildCreationResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5552:
               message = new GuildInvitedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5563:
               message = new GuildInvitationStateRecruterMessage();
               message.unpack(input,messageLength);
               return message;
            case 5548:
               message = new GuildInvitationStateRecrutedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5564:
               message = new GuildJoinedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6061:
               message = new GuildMemberOnlineStatusMessage();
               message.unpack(input,messageLength);
               return message;
            case 5561:
               message = new GuildUIOpenedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5557:
               message = new GuildInformationsGeneralMessage();
               message.unpack(input,messageLength);
               return message;
            case 5558:
               message = new GuildInformationsMembersMessage();
               message.unpack(input,messageLength);
               return message;
            case 5597:
               message = new GuildInformationsMemberUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5959:
               message = new GuildInformationsPaddocksMessage();
               message.unpack(input,messageLength);
               return message;
            case 5923:
               message = new GuildMemberLeavingMessage();
               message.unpack(input,messageLength);
               return message;
            case 5562:
               message = new GuildLeftMessage();
               return message;
            case 5835:
               message = new GuildMembershipMessage();
               message.unpack(input,messageLength);
               return message;
            case 6062:
               message = new GuildLevelUpMessage();
               message.unpack(input,messageLength);
               return message;
            case 5636:
               message = new GuildInfosUpgradeMessage();
               message.unpack(input,messageLength);
               return message;
            case 5919:
               message = new GuildHousesInformationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5952:
               message = new GuildPaddockBoughtMessage();
               message.unpack(input,messageLength);
               return message;
            case 5955:
               message = new GuildPaddockRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5633:
               message = new TaxCollectorMovementMessage();
               message.unpack(input,messageLength);
               return message;
            case 5634:
               message = new TaxCollectorErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5930:
               message = new TaxCollectorListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5917:
               message = new TaxCollectorMovementAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5915:
               message = new TaxCollectorMovementRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5918:
               message = new TaxCollectorAttackedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5635:
               message = new TaxCollectorAttackedResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5720:
               message = new GuildFightPlayersHelpersJoinMessage();
               message.unpack(input,messageLength);
               return message;
            case 5719:
               message = new GuildFightPlayersHelpersLeaveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5928:
               message = new GuildFightPlayersEnemiesListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5929:
               message = new GuildFightPlayersEnemyRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5841:
               message = new PrismBalanceResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5842:
               message = new PrismAlignmentBonusResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5899:
               message = new PrismFightDefendersStateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5895:
               message = new PrismFightDefenderAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5892:
               message = new PrismFightDefenderLeaveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5902:
               message = new PrismFightDefendersSwapMessage();
               message.unpack(input,messageLength);
               return message;
            case 5894:
               message = new PrismFightAttackedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5893:
               message = new PrismFightAttackerAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5897:
               message = new PrismFightAttackerRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5854:
               message = new PrismWorldInformationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5908:
               message = new ChallengeFightJoinRefusedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5853:
               message = new PrismInfoCloseMessage();
               return message;
            case 5858:
               message = new PrismInfoValidMessage();
               message.unpack(input,messageLength);
               return message;
            case 5859:
               message = new PrismInfoInValidMessage();
               message.unpack(input,messageLength);
               return message;
            case 6040:
               message = new PrismFightStateUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5626:
               message = new QuestListMessage();
               message.unpack(input,messageLength);
               return message;
            case 6091:
               message = new QuestStartedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6097:
               message = new QuestValidatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6098:
               message = new QuestObjectiveValidatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6099:
               message = new QuestStepValidatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6096:
               message = new QuestStepStartedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5627:
               message = new QuestStepNoInfoMessage();
               message.unpack(input,messageLength);
               return message;
            case 5625:
               message = new QuestStepInfoMessage();
               message.unpack(input,messageLength);
               return message;
            case 6087:
               message = new NotificationListMessage();
               message.unpack(input,messageLength);
               return message;
            case 6103:
               message = new NotificationByServerMessage();
               message.unpack(input,messageLength);
               return message;
            case 5542:
               message = new SubscriptionLimitationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5573:
               message = new SubscriptionZoneMessage();
               message.unpack(input,messageLength);
               return message;
            case 5642:
               message = new MapNpcsQuestStatusUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5900:
               message = new NpcGenericActionFailureMessage();
               return message;
            case 5618:
               message = new NpcDialogCreationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5617:
               message = new NpcDialogQuestionMessage();
               message.unpack(input,messageLength);
               return message;
            case 5619:
               message = new TaxCollectorDialogQuestionBasicMessage();
               message.unpack(input,messageLength);
               return message;
            case 5615:
               message = new TaxCollectorDialogQuestionExtendedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6110:
               message = new EntityTalkMessage();
               message.unpack(input,messageLength);
               return message;
            case 5655:
               message = new JobDescriptionMessage();
               message.unpack(input,messageLength);
               return message;
            case 5656:
               message = new JobLevelUpMessage();
               message.unpack(input,messageLength);
               return message;
            case 5657:
               message = new JobUnlearntMessage();
               message.unpack(input,messageLength);
               return message;
            case 5809:
               message = new JobExperienceMultiUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5654:
               message = new JobExperienceUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5748:
               message = new JobAllowMultiCraftRequestMessage();
               message.unpack(input,messageLength);
               return message;
            case 5747:
               message = new JobMultiCraftAvailableSkillsMessage();
               message.unpack(input,messageLength);
               return message;
            case 6046:
               message = new JobCrafterDirectoryListMessage();
               message.unpack(input,messageLength);
               return message;
            case 5652:
               message = new JobCrafterDirectorySettingsMessage();
               message.unpack(input,messageLength);
               return message;
            case 6016:
               message = new JobListedUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5653:
               message = new JobCrafterDirectoryRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5651:
               message = new JobCrafterDirectoryAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 6044:
               message = new JobCrafterDirectoryEntryMessage();
               message.unpack(input,messageLength);
               return message;
            case 5537:
               message = new KamasUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 3017:
               message = new ObjectGroundAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5925:
               message = new ObjectGroundListAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 3014:
               message = new ObjectGroundRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5944:
               message = new ObjectGroundRemovedMultipleMessage();
               message.unpack(input,messageLength);
               return message;
            case 3016:
               message = new InventoryContentMessage();
               message.unpack(input,messageLength);
               return message;
            case 5646:
               message = new StorageInventoryContentMessage();
               message.unpack(input,messageLength);
               return message;
            case 5645:
               message = new StorageKamasUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5647:
               message = new StorageObjectUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 6036:
               message = new StorageObjectsUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 5648:
               message = new StorageObjectRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 6035:
               message = new StorageObjectsRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5503:
               message = new SetUpdateMessage();
               message.unpack(input,messageLength);
               return message;
            case 3009:
               message = new InventoryWeightMessage();
               message.unpack(input,messageLength);
               return message;
            case 3010:
               message = new ObjectMovementMessage();
               message.unpack(input,messageLength);
               return message;
            case 3025:
               message = new ObjectAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6033:
               message = new ObjectsAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6030:
               message = new GoldAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 3004:
               message = new ObjectErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 3024:
               message = new ObjectDeletedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6034:
               message = new ObjectsDeletedMessage();
               message.unpack(input,messageLength);
               return message;
            case 3023:
               message = new ObjectQuantityMessage();
               message.unpack(input,messageLength);
               return message;
            case 3029:
               message = new ObjectModifiedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6014:
               message = new ObjectJobAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6017:
               message = new ObjectFoundWhileRecoltingMessage();
               message.unpack(input,messageLength);
               return message;
            case 6023:
               message = new ExchangeReplayCountModifiedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5515:
               message = new ExchangeObjectMessage();
               message.unpack(input,messageLength);
               return message;
            case 5516:
               message = new ExchangeObjectAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5517:
               message = new ExchangeObjectRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5519:
               message = new ExchangeObjectModifiedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6009:
               message = new ExchangeObjectPutInBagMessage();
               message.unpack(input,messageLength);
               return message;
            case 6010:
               message = new ExchangeObjectRemovedFromBagMessage();
               message.unpack(input,messageLength);
               return message;
            case 6008:
               message = new ExchangeObjectModifiedInBagMessage();
               message.unpack(input,messageLength);
               return message;
            case 5521:
               message = new ExchangeKamaModifiedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6020:
               message = new ExchangeMultiCraftCrafterCanUseHisRessourcesMessage();
               message.unpack(input,messageLength);
               return message;
            case 5522:
               message = new ExchangeRequestedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5523:
               message = new ExchangeRequestedTradeMessage();
               message.unpack(input,messageLength);
               return message;
            case 5512:
               message = new ExchangeStartedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5945:
               message = new ExchangeBidHouseItemAddOkMessage();
               message.unpack(input,messageLength);
               return message;
            case 5946:
               message = new ExchangeBidHouseItemRemoveOkMessage();
               message.unpack(input,messageLength);
               return message;
            case 5947:
               message = new ExchangeBidHouseGenericItemAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5948:
               message = new ExchangeBidHouseGenericItemRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5949:
               message = new ExchangeBidHouseInListAddedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5950:
               message = new ExchangeBidHouseInListRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5509:
               message = new ExchangeIsReadyMessage();
               message.unpack(input,messageLength);
               return message;
            case 5513:
               message = new ExchangeErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5628:
               message = new ExchangeLeaveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5785:
               message = new ExchangeStartOkNpcTradeMessage();
               message.unpack(input,messageLength);
               return message;
            case 5761:
               message = new ExchangeStartOkNpcShopMessage();
               message.unpack(input,messageLength);
               return message;
            case 5768:
               message = new ExchangeOkMultiCraftMessage();
               message.unpack(input,messageLength);
               return message;
            case 5790:
               message = new ExchangeCraftResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 6000:
               message = new ExchangeCraftResultWithObjectIdMessage();
               message.unpack(input,messageLength);
               return message;
            case 5999:
               message = new ExchangeCraftResultWithObjectDescMessage();
               message.unpack(input,messageLength);
               return message;
            case 5794:
               message = new ExchangeCraftInformationObjectMessage();
               message.unpack(input,messageLength);
               return message;
            case 5767:
               message = new ExchangeStartOkHumanVendorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5910:
               message = new ExchangeShopStockStartedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5909:
               message = new ExchangeShopStockMovementUpdatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6038:
               message = new ExchangeShopStockMultiMovementUpdatedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5907:
               message = new ExchangeShopStockMovementRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6037:
               message = new ExchangeShopStockMultiMovementRemovedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5984:
               message = new ExchangeStartedMountStockMessage();
               message.unpack(input,messageLength);
               return message;
            case 5905:
               message = new ExchangeStartedBidSellerMessage();
               message.unpack(input,messageLength);
               return message;
            case 5904:
               message = new ExchangeStartedBidBuyerMessage();
               message.unpack(input,messageLength);
               return message;
            case 5755:
               message = new ExchangeBidPriceMessage();
               message.unpack(input,messageLength);
               return message;
            case 5765:
               message = new ExchangeTypesExchangerDescriptionForUserMessage();
               message.unpack(input,messageLength);
               return message;
            case 5752:
               message = new ExchangeTypesItemsExchangerDescriptionForUserMessage();
               message.unpack(input,messageLength);
               return message;
            case 5793:
               message = new ExchangeWeightMessage();
               message.unpack(input,messageLength);
               return message;
            case 5780:
               message = new ExchangeStartOkTaxCollectorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5762:
               message = new ExchangeGuildTaxCollectorGetMessage();
               message.unpack(input,messageLength);
               return message;
            case 5769:
               message = new ItemNoMoreAvailableMessage();
               return message;
            case 5759:
               message = new ExchangeBuyOkMessage();
               return message;
            case 5792:
               message = new ExchangeSellOkMessage();
               return message;
            case 5787:
               message = new ExchangeReplyTaxVendorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5786:
               message = new ExchangeWaitingResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5991:
               message = new ExchangeStartOkMountWithOutPaddockMessage();
               message.unpack(input,messageLength);
               return message;
            case 5979:
               message = new ExchangeStartOkMountMessage();
               message.unpack(input,messageLength);
               return message;
            case 5981:
               message = new ExchangeMountStableErrorMessage();
               return message;
            case 5971:
               message = new ExchangeMountStableAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 6049:
               message = new ExchangeMountPaddockAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5966:
               message = new ExchangeMountStableBornAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5964:
               message = new ExchangeMountStableRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 6050:
               message = new ExchangeMountPaddockRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5994:
               message = new ExchangeMountTakenFromPaddockMessage();
               message.unpack(input,messageLength);
               return message;
            case 6055:
               message = new ExchangeMountFreeFromPaddockMessage();
               message.unpack(input,messageLength);
               return message;
            case 6056:
               message = new ExchangeMountSterilizeFromPaddockMessage();
               message.unpack(input,messageLength);
               return message;
            case 5802:
               message = new ExchangeBidSearchOkMessage();
               return message;
            case 5810:
               message = new ExchangeItemAutoCraftStopedMessage();
               message.unpack(input,messageLength);
               return message;
            case 6015:
               message = new ExchangeItemAutoCraftRemainingMessage();
               message.unpack(input,messageLength);
               return message;
            case 5813:
               message = new ExchangeStartOkCraftMessage();
               return message;
            case 5941:
               message = new ExchangeStartOkCraftWithInformationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5818:
               message = new ExchangeStartOkMulticraftCrafterMessage();
               message.unpack(input,messageLength);
               return message;
            case 5817:
               message = new ExchangeStartOkMulticraftCustomerMessage();
               message.unpack(input,messageLength);
               return message;
            case 5819:
               message = new ExchangeStartOkJobIndexMessage();
               message.unpack(input,messageLength);
               return message;
            case 5833:
               message = new ExchangeGoldPaymentForCraftMessage();
               message.unpack(input,messageLength);
               return message;
            case 5831:
               message = new ExchangeItemPaymentForCraftMessage();
               message.unpack(input,messageLength);
               return message;
            case 5832:
               message = new ExchangeModifiedPaymentForCraftMessage();
               message.unpack(input,messageLength);
               return message;
            case 6031:
               message = new ExchangeRemovedPaymentForCraftMessage();
               message.unpack(input,messageLength);
               return message;
            case 5739:
               message = new PurchasableDialogMessage();
               message.unpack(input,messageLength);
               return message;
            case 5734:
               message = new HousePropertiesMessage();
               message.unpack(input,messageLength);
               return message;
            case 5735:
               message = new HouseBuyResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5737:
               message = new HouseSoldMessage();
               message.unpack(input,messageLength);
               return message;
            case 5860:
               message = new HouseEnteredMessage();
               message.unpack(input,messageLength);
               return message;
            case 5861:
               message = new HouseExitedMessage();
               return message;
            case 5701:
               message = new HouseGuildNoneMessage();
               message.unpack(input,messageLength);
               return message;
            case 5703:
               message = new HouseGuildRightsMessage();
               message.unpack(input,messageLength);
               return message;
            case 5824:
               message = new PaddockPropertiesMessage();
               message.unpack(input,messageLength);
               return message;
            case 6018:
               message = new PaddockSellBuyDialogMessage();
               message.unpack(input,messageLength);
               return message;
            case 6026:
               message = new GameDataPlayFarmObjectAnimationMessage();
               message.unpack(input,messageLength);
               return message;
            case 5977:
               message = new MountSterilizedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5983:
               message = new MountRenamedMessage();
               message.unpack(input,messageLength);
               return message;
            case 5970:
               message = new MountXpRatioMessage();
               message.unpack(input,messageLength);
               return message;
            case 5973:
               message = new MountDataMessage();
               message.unpack(input,messageLength);
               return message;
            case 5968:
               message = new MountSetMessage();
               message.unpack(input,messageLength);
               return message;
            case 5982:
               message = new MountUnSetMessage();
               return message;
            case 5963:
               message = new MountEquipedErrorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5967:
               message = new MountRidingMessage();
               message.unpack(input,messageLength);
               return message;
            case 5993:
               message = new GameDataPaddockObjectRemoveMessage();
               message.unpack(input,messageLength);
               return message;
            case 5990:
               message = new GameDataPaddockObjectAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5992:
               message = new GameDataPaddockObjectListAddMessage();
               message.unpack(input,messageLength);
               return message;
            case 5978:
               message = new MountEmoteIconUsedOkMessage();
               message.unpack(input,messageLength);
               return message;
            case 5740:
               message = new LockableShowCodeDialogMessage();
               message.unpack(input,messageLength);
               return message;
            case 5672:
               message = new LockableCodeResultMessage();
               message.unpack(input,messageLength);
               return message;
            case 5671:
               message = new LockableStateUpdateAbstractMessage();
               message.unpack(input,messageLength);
               return message;
            case 5668:
               message = new LockableStateUpdateHouseDoorMessage();
               message.unpack(input,messageLength);
               return message;
            case 5669:
               message = new LockableStateUpdateStorageMessage();
               message.unpack(input,messageLength);
               return message;
            case 5675:
               message = new DocumentReadingBeginMessage();
               message.unpack(input,messageLength);
               return message;
            case 5934:
               message = new ContactLookMessage();
               message.unpack(input,messageLength);
               return message;
            case 6045:
               message = new ContactLookErrorMessage();
               message.unpack(input,messageLength);
               return message;
            default:
               _log.warn("Unknown packet received (ID " + messageId + ", length " + messageLength + ")");
               return null;
         }
      }
   }
}
