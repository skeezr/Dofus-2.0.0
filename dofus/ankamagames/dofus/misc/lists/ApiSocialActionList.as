package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSocialAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendsListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.EnemiesListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.SpouseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddEnemyAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveEnemyAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinSpouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendSpouseFollowAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendWarningSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendOrGuildMemberWarningSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.GuildInformationsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildGetInformationsAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCreationValidAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationByNameAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAnswerAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildKickRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildChangeMemberParametersAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildSpellUpgradeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCharacsUpgradeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFarmTeleportRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildHouseTeleportRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightJoinRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.TaxCollectorHireRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.TaxCollectorFireRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.GameRolePlayTaxCollectorFightRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.CharacterReportAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.ChatReportAction;
   
   public class ApiSocialActionList
   {
      
      public static const OpenSocial:ApiAction = new ApiAction("OpenSocial",OpenSocialAction,true);
      
      public static const FriendsListRequest:ApiAction = new ApiAction("FriendsListRequest",FriendsListRequestAction,true);
      
      public static const EnemiesListRequest:ApiAction = new ApiAction("EnemiesListRequest",EnemiesListRequestAction,true);
      
      public static const SpouseRequest:ApiAction = new ApiAction("SpouseRequest",SpouseRequestAction,true);
      
      public static const AddFriend:ApiAction = new ApiAction("AddFriend",AddFriendAction,true);
      
      public static const AddEnemy:ApiAction = new ApiAction("AddEnemy",AddEnemyAction,true);
      
      public static const RemoveFriend:ApiAction = new ApiAction("RemoveFriend",RemoveFriendAction,true);
      
      public static const RemoveEnemy:ApiAction = new ApiAction("RemoveEnemy",RemoveEnemyAction,true);
      
      public static const AddIgnored:ApiAction = new ApiAction("AddIgnored",AddIgnoredAction,true);
      
      public static const RemoveIgnored:ApiAction = new ApiAction("RemoveIgnored",RemoveIgnoredAction,true);
      
      public static const JoinFriend:ApiAction = new ApiAction("JoinFriend",JoinFriendAction,true);
      
      public static const JoinSpouse:ApiAction = new ApiAction("JoinSpouse",JoinSpouseAction,true);
      
      public static const FriendSpouseFollow:ApiAction = new ApiAction("FriendSpouseFollow",FriendSpouseFollowAction,true);
      
      public static const FriendWarningSet:ApiAction = new ApiAction("FriendWarningSet",FriendWarningSetAction,true);
      
      public static const FriendOrGuildMemberLevelUpWarningSet:ApiAction = new ApiAction("FriendOrGuildMemberLevelUpWarningSet",FriendOrGuildMemberWarningSetAction,true);
      
      public static const GuildInformationsRequest:ApiAction = new ApiAction("GuildInformationsRequest",GuildInformationsRequestAction,true);
      
      public static const GuildGetInformations:ApiAction = new ApiAction("GuildGetInformations",GuildGetInformationsAction,true);
      
      public static const GuildCreationValid:ApiAction = new ApiAction("GuildCreationValid",GuildCreationValidAction,true);
      
      public static const GuildInvitation:ApiAction = new ApiAction("GuildInvitation",GuildInvitationAction,true);
      
      public static const GuildInvitationByName:ApiAction = new ApiAction("GuildInvitationByName",GuildInvitationByNameAction,true);
      
      public static const GuildInvitationAnswer:ApiAction = new ApiAction("GuildInvitationAnswer",GuildInvitationAnswerAction,true);
      
      public static const GuildKickRequest:ApiAction = new ApiAction("GuildKickRequest",GuildKickRequestAction,true);
      
      public static const GuildChangeMemberParameters:ApiAction = new ApiAction("GuildChangeMemberParameters",GuildChangeMemberParametersAction,true);
      
      public static const GuildSpellUpgradeRequest:ApiAction = new ApiAction("GuildSpellUpgradeRequest",GuildSpellUpgradeRequestAction,true);
      
      public static const GuildCharacsUpgradeRequest:ApiAction = new ApiAction("GuildCharacsUpgradeRequest",GuildCharacsUpgradeRequestAction,true);
      
      public static const GuildFarmTeleportRequest:ApiAction = new ApiAction("GuildFarmTeleportRequest",GuildFarmTeleportRequestAction,true);
      
      public static const GuildHouseTeleportRequest:ApiAction = new ApiAction("GuildHouseTeleportRequest",GuildHouseTeleportRequestAction,true);
      
      public static const GuildFightJoinRequest:ApiAction = new ApiAction("GuildFightJoinRequest",GuildFightJoinRequestAction,true);
      
      public static const GuildFightLeaveRequest:ApiAction = new ApiAction("GuildFightLeaveRequest",GuildFightLeaveRequestAction,true);
      
      public static const TaxCollectorHireRequest:ApiAction = new ApiAction("TaxCollectorHireRequest",TaxCollectorHireRequestAction,true);
      
      public static const TaxCollectorFireRequest:ApiAction = new ApiAction("TaxCollectorFireRequest",TaxCollectorFireRequestAction,true);
      
      public static const GameRolePlayTaxCollectorFightRequest:ApiAction = new ApiAction("GameRolePlayTaxCollectorFightRequest",GameRolePlayTaxCollectorFightRequestAction,true);
      
      public static const CharacterReportRequest:ApiAction = new ApiAction("CharacterReport",CharacterReportAction,true);
      
      public static const ChatReportRequest:ApiAction = new ApiAction("ChatReport",ChatReportAction,true);
       
      public function ApiSocialActionList()
      {
         super();
      }
   }
}
