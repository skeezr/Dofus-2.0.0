package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildHouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsGetListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredGetListMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMembershipMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsListWithSpouseMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredListMessage;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSocialAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendsListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.EnemiesListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.SpouseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddFriendAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddedMessage;
   import com.ankamagames.dofus.internalDatacenter.people.FriendWrapper;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddFailureMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddEnemyAction;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddedMessage;
   import com.ankamagames.dofus.internalDatacenter.people.EnemyWrapper;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddFailureMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveFriendAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendUpdateMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveEnemyAction;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteResultMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinFriendAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendJoinRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinSpouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendSpouseFollowAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseFollowWithCompassRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendWarningSetAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnConnectionMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendOrGuildMemberWarningSetAction;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnLevelGainMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnConnectionStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnLevelGainStateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMembersMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecruterMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecrutedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildJoinedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildUIOpenedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsGeneralMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMemberUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMemberLeavingMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInfosUpgradeMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersJoinMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemiesListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemyRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHousesInformationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementAddMessage;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsPaddocksMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.TaxCollectorDialogQuestionExtendedMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildGetInformationsAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCreationValidAction;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationValidMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationByNameAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationByNameMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAnswerAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationAnswerMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildKickRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildKickRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildChangeMemberParametersAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildChangeMemberParametersMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildSpellUpgradeRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildSpellUpgradeRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCharacsUpgradeRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCharacsUpgradeRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFarmTeleportRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockTeleportRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildHouseTeleportRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHouseTeleportRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightJoinRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightJoinRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightLeaveRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightLeaveRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.TaxCollectorHireRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.TaxCollectorFireRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorFireRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.CharacterReportAction;
   import com.ankamagames.dofus.network.messages.game.report.CharacterReportMessage;
   import com.ankamagames.dofus.logic.game.common.actions.social.ChatReportAction;
   import com.ankamagames.dofus.network.messages.game.chat.report.ChatMessageReportMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddRequestMessage;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsForGuild;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorFightersInformation;
   import com.ankamagames.dofus.network.messages.game.guild.GuildGetInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorHireRequestMessage;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.ListAddFailureEnum;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseJoinRequestMessage;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.GuildCreationResultEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.dofus.network.enums.TaxCollectorErrorReasonEnum;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformationsInWaitForHelpState;
   import flash.utils.getTimer;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.GuildInformationsTypeEnum;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildLeftMessage;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper;
   
   public class SocialFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SocialFrame));
       
      private var _friendsList:Array;
      
      private var _enemiesList:Array;
      
      private var _ignoredList:Array;
      
      private var _spouse:SpouseWrapper;
      
      private var _hasGuild:Boolean = false;
      
      private var _guild:GuildWrapper;
      
      private var _guildMembers:Vector.<GuildMember>;
      
      private var _maxCollectorCount:uint;
      
      private var _taxCollectorHireCost:uint;
      
      private var _taxCollectors:Array;
      
      private var _taxCollectorList:Boolean = false;
      
      private var _taxCollectorListUpdate:Boolean = false;
      
      private var _taxCollectorFightListBegin:Dictionary;
      
      private var _taxCollectorFightList:Dictionary;
      
      private var _guildHouses:Vector.<GuildHouseWrapper>;
      
      private var _guildHousesList:Boolean = false;
      
      private var _guildHousesListUpdate:Boolean = false;
      
      private var _upGuildEmblem:EmblemWrapper;
      
      private var _backGuildEmblem:EmblemWrapper;
      
      private var _warnOnFrienConnec:Boolean;
      
      private var _warnWhenFriendOrGuildMemberLvlUp:Boolean;
      
      public function SocialFrame()
      {
         this._taxCollectors = new Array();
         this._taxCollectorFightListBegin = new Dictionary();
         this._guildHouses = new Vector.<GuildHouseWrapper>();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get friendsList() : Array
      {
         return this._friendsList;
      }
      
      public function get enemiesList() : Array
      {
         return this._enemiesList;
      }
      
      public function get ignoredList() : Array
      {
         return this._ignoredList;
      }
      
      public function get spouse() : SpouseWrapper
      {
         return this._spouse;
      }
      
      public function get hasGuild() : Boolean
      {
         return this._hasGuild;
      }
      
      public function get guild() : GuildWrapper
      {
         return this._guild;
      }
      
      public function get warnFriendConnec() : Boolean
      {
         return this._warnOnFrienConnec;
      }
      
      public function get warnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this._warnWhenFriendOrGuildMemberLvlUp;
      }
      
      public function get maxCollectorCount() : uint
      {
         return this._maxCollectorCount;
      }
      
      public function get taxCollectors() : Array
      {
         return this._taxCollectors;
      }
      
      public function get guildmembers() : Vector.<GuildMember>
      {
         return this._guildMembers;
      }
      
      public function get taxCollectorHireCost() : uint
      {
         return this._taxCollectorHireCost;
      }
      
      public function get guildHouses() : Vector.<GuildHouseWrapper>
      {
         return this._guildHouses;
      }
      
      public function pushed() : Boolean
      {
         this._friendsList = new Array();
         this._enemiesList = new Array();
         this._ignoredList = new Array();
         this._taxCollectorFightList = new Dictionary();
         ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
         ConnectionsHandler.getConnection().send(new IgnoredGetListMessage());
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gmmsg:GuildMembershipMessage = null;
         var flmsg:FriendsListMessage = null;
         var flwsmsg:FriendsListWithSpouseMessage = null;
         var sw:SpouseWrapper = null;
         var ilmsg:IgnoredListMessage = null;
         var osa:OpenSocialAction = null;
         var flra:FriendsListRequestAction = null;
         var elra:EnemiesListRequestAction = null;
         var sra:SpouseRequestAction = null;
         var afa:AddFriendAction = null;
         var famsg:FriendAddedMessage = null;
         var friendToAdd:FriendWrapper = null;
         var fafmsg:FriendAddFailureMessage = null;
         var reason:String = null;
         var aea:AddEnemyAction = null;
         var iamsg:IgnoredAddedMessage = null;
         var enemyToAdd:EnemyWrapper = null;
         var iafmsg:IgnoredAddFailureMessage = null;
         var reason2:String = null;
         var rfa:RemoveFriendAction = null;
         var fdrqmsg:FriendDeleteRequestMessage = null;
         var fdrmsg:FriendDeleteResultMessage = null;
         var output:String = null;
         var fumsg:FriendUpdateMessage = null;
         var friendToUpdate:FriendWrapper = null;
         var rea:RemoveEnemyAction = null;
         var idrqmsg:IgnoredDeleteRequestMessage = null;
         var idrmsg:IgnoredDeleteResultMessage = null;
         var aia:AddIgnoredAction = null;
         var ria:RemoveIgnoredAction = null;
         var jfa:JoinFriendAction = null;
         var fjrmsg:FriendJoinRequestMessage = null;
         var jsa:JoinSpouseAction = null;
         var fsfa:FriendSpouseFollowAction = null;
         var fsfwcmsg:FriendSpouseFollowWithCompassRequestMessage = null;
         var fwsa:FriendWarningSetAction = null;
         var fsocmsg:FriendSetWarnOnConnectionMessage = null;
         var fogmwsa:FriendOrGuildMemberWarningSetAction = null;
         var fswolgmsg:FriendSetWarnOnLevelGainMessage = null;
         var fwocsmsg:FriendWarnOnConnectionStateMessage = null;
         var fwolgsmsg:FriendWarnOnLevelGainStateMessage = null;
         var pfsumsg:PartyFollowStatusUpdateMessage = null;
         var gimmsg:GuildInformationsMembersMessage = null;
         var gcrmsg:GuildCreationResultMessage = null;
         var errorMessage:String = null;
         var gimsg:GuildInvitedMessage = null;
         var gisrermsg:GuildInvitationStateRecruterMessage = null;
         var gisredmsg:GuildInvitationStateRecrutedMessage = null;
         var gjmsg:GuildJoinedMessage = null;
         var joinMessage:String = null;
         var guiomsg:GuildUIOpenedMessage = null;
         var gigmsg:GuildInformationsGeneralMessage = null;
         var gimumsg:GuildInformationsMemberUpdateMessage = null;
         var nm:int = 0;
         var gmlmsg:GuildMemberLeavingMessage = null;
         var comptgm:uint = 0;
         var gipmsg:GuildInfosUpgradeMessage = null;
         var gfphjmsg:GuildFightPlayersHelpersJoinMessage = null;
         var gfphlmsg:GuildFightPlayersHelpersLeaveMessage = null;
         var gfpelmsg:GuildFightPlayersEnemiesListMessage = null;
         var gfpermsg:GuildFightPlayersEnemyRemoveMessage = null;
         var ghimsg:GuildHousesInformationMessage = null;
         var tcmmsg:TaxCollectorMovementMessage = null;
         var infoText:String = null;
         var taxCollectorName:String = null;
         var positionX:String = null;
         var positionY:String = null;
         var worldPoint:String = null;
         var tcamsg:TaxCollectorAttackedMessage = null;
         var taxCollectorN:String = null;
         var sentenceToDisplatch:String = null;
         var tcarmsg:TaxCollectorAttackedResultMessage = null;
         var sentenceToDisplatchResultAttack:String = null;
         var taxCName:String = null;
         var worldPosX:int = 0;
         var worldPosY:int = 0;
         var tcemsg:TaxCollectorErrorMessage = null;
         var errorTaxCollectorMessage:String = null;
         var tclmamsg:TaxCollectorListMessage = null;
         var tcmamsg:TaxCollectorMovementAddMessage = null;
         var tcwadded:TaxCollectorWrapper = null;
         var isUpdate:Boolean = false;
         var indexTcw:uint = 0;
         var comptTcwAdded:uint = 0;
         var tcmrmsg:TaxCollectorMovementRemoveMessage = null;
         var comptTax:uint = 0;
         var gifmsg:GuildInformationsPaddocksMessage = null;
         var tcdqemsg:TaxCollectorDialogQuestionExtendedMessage = null;
         var clmsg:ContactLookMessage = null;
         var ggia:GuildGetInformationsAction = null;
         var askInformation:Boolean = false;
         var gcva:GuildCreationValidAction = null;
         var guildEmblem:GuildEmblem = null;
         var gcvmsg:GuildCreationValidMessage = null;
         var gia:GuildInvitationAction = null;
         var ginvitationmsg:GuildInvitationMessage = null;
         var gibna:GuildInvitationByNameAction = null;
         var gibnmsg:GuildInvitationByNameMessage = null;
         var giaa:GuildInvitationAnswerAction = null;
         var giamsg:GuildInvitationAnswerMessage = null;
         var gkra:GuildKickRequestAction = null;
         var gkrmsg:GuildKickRequestMessage = null;
         var gcmpa:GuildChangeMemberParametersAction = null;
         var newRights:Number = NaN;
         var gcmpmsg:GuildChangeMemberParametersMessage = null;
         var gsura:GuildSpellUpgradeRequestAction = null;
         var gsurmsg:GuildSpellUpgradeRequestMessage = null;
         var gcura:GuildCharacsUpgradeRequestAction = null;
         var gcurmsg:GuildCharacsUpgradeRequestMessage = null;
         var gftra:GuildFarmTeleportRequestAction = null;
         var gftrmsg:GuildPaddockTeleportRequestMessage = null;
         var ghtra:GuildHouseTeleportRequestAction = null;
         var ghtrmsg:GuildHouseTeleportRequestMessage = null;
         var gfjra:GuildFightJoinRequestAction = null;
         var gfjrmsg:GuildFightJoinRequestMessage = null;
         var gflra:GuildFightLeaveRequestAction = null;
         var gflrmsg:GuildFightLeaveRequestMessage = null;
         var tchra:TaxCollectorHireRequestAction = null;
         var tcfra:TaxCollectorFireRequestAction = null;
         var tcfrmsg:TaxCollectorFireRequestMessage = null;
         var cra:CharacterReportAction = null;
         var crm:CharacterReportMessage = null;
         var chra:ChatReportAction = null;
         var cmr:ChatMessageReportMessage = null;
         var chatFrame:ChatFrame = null;
         var timeStamp:uint = 0;
         var f:* = undefined;
         var fw:FriendWrapper = null;
         var f2:* = undefined;
         var fw2:FriendWrapper = null;
         var i:* = undefined;
         var ew:EnemyWrapper = null;
         var farmsg:FriendAddRequestMessage = null;
         var iarmsg:IgnoredAddRequestMessage = null;
         var fd:* = undefined;
         var frd:* = undefined;
         var ed:* = undefined;
         var ignored:* = undefined;
         var il:* = undefined;
         var k:int = 0;
         var member:GuildMember = null;
         var guildMember:GuildMember = null;
         var taxCollectorWrapper:TaxCollectorWrapper = null;
         var enemy:CharacterMinimalPlusLookInformations = null;
         var houseInformation:HouseInformationsForGuild = null;
         var ghw:GuildHouseWrapper = null;
         var compttcw:uint = 0;
         var tcwrapper:TaxCollectorWrapper = null;
         var mapId:uint = 0;
         var lastName:String = null;
         var firstName:String = null;
         var info:TaxCollectorInformations = null;
         var isInFight:Boolean = false;
         var fightInfo:TaxCollectorFightersInformation = null;
         var tcw:TaxCollectorWrapper = null;
         var taxCollectorFightersInformation:TaxCollectorFightersInformation = null;
         var present:Boolean = false;
         var taxC:TaxCollectorWrapper = null;
         var perco:TaxCollectorWrapper = null;
         var taxCollector:TaxCollectorWrapper = null;
         var ggimsg:GuildGetInformationsMessage = null;
         var percoo:TaxCollectorWrapper = null;
         var ally:* = undefined;
         var text:String = null;
         var tchrmsg:TaxCollectorHireRequestMessage = null;
         switch(true)
         {
            case msg is GuildMembershipMessage:
               gmmsg = msg as GuildMembershipMessage;
               if(this._guild != null)
               {
                  this._guild.update(gmmsg.guildName,gmmsg.guildEmblem,gmmsg.memberRights);
               }
               else
               {
                  this._guild = GuildWrapper.create(gmmsg.guildName,gmmsg.guildEmblem,gmmsg.memberRights);
               }
               this._hasGuild = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembership);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,true);
               return true;
            case msg is FriendsListMessage && getQualifiedClassName(msg) == getQualifiedClassName(FriendsListMessage):
               flmsg = msg as FriendsListMessage;
               this._friendsList = new Array();
               for each(f in flmsg.friendsList)
               {
                  fw = new FriendWrapper(f);
                  this._friendsList.push(fw);
               }
               if(this._spouse)
               {
                  this._spouse = null;
                  KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseUpdated);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               return true;
            case msg is FriendsListWithSpouseMessage:
               this._friendsList = new Array();
               flwsmsg = msg as FriendsListWithSpouseMessage;
               sw = new SpouseWrapper(flwsmsg.spouse);
               this._spouse = sw;
               for each(f2 in flwsmsg.friendsList)
               {
                  fw2 = new FriendWrapper(f2);
                  this._friendsList.push(fw2);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseUpdated);
               return true;
            case msg is IgnoredListMessage:
               this._enemiesList = new Array();
               ilmsg = msg as IgnoredListMessage;
               for each(i in ilmsg.ignoredList)
               {
                  ew = new EnemyWrapper(i);
                  this._enemiesList.push(ew);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
               return true;
            case msg is OpenSocialAction:
               osa = msg as OpenSocialAction;
               KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial);
               return true;
            case msg is FriendsListRequestAction:
               flra = msg as FriendsListRequestAction;
               ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
               return true;
            case msg is EnemiesListRequestAction:
               elra = msg as EnemiesListRequestAction;
               ConnectionsHandler.getConnection().send(new IgnoredGetListMessage());
               return true;
            case msg is SpouseRequestAction:
               sra = msg as SpouseRequestAction;
               ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
               return true;
            case msg is AddFriendAction:
               afa = msg as AddFriendAction;
               if(afa.name.length < 3 || afa.name.length > 20)
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason,ChatFrame.RED_CHANNEL_ID);
               }
               else if(afa.name != PlayedCharacterManager.getInstance().infos.name)
               {
                  farmsg = new FriendAddRequestMessage();
                  farmsg.initFriendAddRequestMessage(afa.name);
                  ConnectionsHandler.getConnection().send(farmsg);
               }
               else
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric"));
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason,ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is FriendAddedMessage:
               famsg = msg as FriendAddedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendAdded,true);
               friendToAdd = new FriendWrapper(famsg.friendAdded);
               this._friendsList.push(friendToAdd);
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               return true;
            case msg is FriendAddFailureMessage:
               fafmsg = msg as FriendAddFailureMessage;
               switch(fafmsg.reason)
               {
                  case ListAddFailureEnum.LIST_ADD_FAILURE_UNKNOWN:
                     reason = I18n.getText(I18nProxy.getKeyId("ui.common.unknowReason"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_OVER_QUOTA:
                     reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureListFull"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_NOT_FOUND:
                     reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_EGOCENTRIC:
                     reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_IS_DOUBLE:
                     reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureAlreadyInList"));
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason,ChatFrame.RED_CHANNEL_ID);
               return true;
            case msg is AddEnemyAction:
               aea = msg as AddEnemyAction;
               if(aea.name.length < 3 || aea.name.length > 20)
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason,ChatFrame.RED_CHANNEL_ID);
               }
               else if(aea.name != PlayedCharacterManager.getInstance().infos.name)
               {
                  iarmsg = new IgnoredAddRequestMessage();
                  iarmsg.initIgnoredAddRequestMessage(aea.name);
                  ConnectionsHandler.getConnection().send(iarmsg);
               }
               else
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric"));
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason,ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is IgnoredAddedMessage:
               iamsg = msg as IgnoredAddedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemyAdded,true);
               enemyToAdd = new EnemyWrapper(iamsg.ignoreAdded);
               this._enemiesList.push(enemyToAdd);
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
               return true;
            case msg is IgnoredAddFailureMessage:
               iafmsg = msg as IgnoredAddFailureMessage;
               switch(iafmsg.reason)
               {
                  case ListAddFailureEnum.LIST_ADD_FAILURE_UNKNOWN:
                     reason2 = I18n.getText(I18nProxy.getKeyId("ui.common.unknowReason"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_OVER_QUOTA:
                     reason2 = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureListFull"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_NOT_FOUND:
                     reason2 = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_EGOCENTRIC:
                     reason2 = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric"));
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_IS_DOUBLE:
                     reason2 = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureAlreadyInList"));
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,reason2,ChatFrame.RED_CHANNEL_ID);
               return true;
            case msg is RemoveFriendAction:
               rfa = msg as RemoveFriendAction;
               fdrqmsg = new FriendDeleteRequestMessage();
               fdrqmsg.initFriendDeleteRequestMessage(rfa.name);
               ConnectionsHandler.getConnection().send(fdrqmsg);
               return true;
            case msg is FriendDeleteResultMessage:
               fdrmsg = msg as FriendDeleteResultMessage;
               output = I18n.getText(I18nProxy.getKeyId("ui.social.friend.delete"));
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendRemoved,fdrmsg.success);
               if(fdrmsg.success)
               {
                  for(fd in this._friendsList)
                  {
                     if(this._friendsList[fd].name == fdrmsg.name)
                     {
                        this._friendsList.splice(fd,1);
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,output,ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is FriendUpdateMessage:
               fumsg = msg as FriendUpdateMessage;
               friendToUpdate = new FriendWrapper(fumsg.friendUpdated);
               for each(frd in this._friendsList)
               {
                  if(frd.name == friendToUpdate.name)
                  {
                     frd = friendToUpdate;
                  }
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               return true;
            case msg is RemoveEnemyAction:
               rea = msg as RemoveEnemyAction;
               idrqmsg = new IgnoredDeleteRequestMessage();
               idrqmsg.initIgnoredDeleteRequestMessage(rea.name);
               ConnectionsHandler.getConnection().send(idrqmsg);
               return true;
            case msg is IgnoredDeleteResultMessage:
               idrmsg = msg as IgnoredDeleteResultMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemyRemoved,idrmsg.success);
               if(idrmsg.success)
               {
                  for(ed in this._enemiesList)
                  {
                     if(this._enemiesList[ed].name == idrmsg.name)
                     {
                        this._enemiesList.splice(ed,1);
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
               return true;
            case msg is AddIgnoredAction:
               aia = msg as AddIgnoredAction;
               for each(ignored in this._ignoredList)
               {
                  if(ignored.name == aia.name)
                  {
                     return true;
                  }
               }
               this._ignoredList.push(new IgnoredWrapper(aia.name));
               KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredAdded);
               return true;
            case msg is RemoveIgnoredAction:
               ria = msg as RemoveIgnoredAction;
               for(il in this._ignoredList)
               {
                  if(this._ignoredList[il].name == ria.name)
                  {
                     this._ignoredList.splice(il,1);
                  }
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredRemoved);
               return true;
            case msg is JoinFriendAction:
               jfa = msg as JoinFriendAction;
               fjrmsg = new FriendJoinRequestMessage();
               fjrmsg.initFriendJoinRequestMessage(jfa.name);
               ConnectionsHandler.getConnection().send(fjrmsg);
               return true;
            case msg is JoinSpouseAction:
               jsa = msg as JoinSpouseAction;
               ConnectionsHandler.getConnection().send(new FriendSpouseJoinRequestMessage());
               return true;
            case msg is FriendSpouseFollowAction:
               fsfa = msg as FriendSpouseFollowAction;
               fsfwcmsg = new FriendSpouseFollowWithCompassRequestMessage();
               fsfwcmsg.initFriendSpouseFollowWithCompassRequestMessage(fsfa.enable);
               ConnectionsHandler.getConnection().send(fsfwcmsg);
               return true;
            case msg is FriendWarningSetAction:
               fwsa = msg as FriendWarningSetAction;
               this._warnOnFrienConnec = fwsa.enable;
               fsocmsg = new FriendSetWarnOnConnectionMessage();
               fsocmsg.initFriendSetWarnOnConnectionMessage(fwsa.enable);
               ConnectionsHandler.getConnection().send(fsocmsg);
               return true;
            case msg is FriendOrGuildMemberWarningSetAction:
               fogmwsa = msg as FriendOrGuildMemberWarningSetAction;
               this._warnWhenFriendOrGuildMemberLvlUp = fogmwsa.enable;
               fswolgmsg = new FriendSetWarnOnLevelGainMessage();
               fswolgmsg.initFriendSetWarnOnLevelGainMessage(fogmwsa.enable);
               ConnectionsHandler.getConnection().send(fswolgmsg);
               return true;
            case msg is FriendWarnOnConnectionStateMessage:
               fwocsmsg = msg as FriendWarnOnConnectionStateMessage;
               this._warnOnFrienConnec = fwocsmsg.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendWarningState,fwocsmsg.enable);
               return true;
            case msg is FriendWarnOnLevelGainStateMessage:
               fwolgsmsg = msg as FriendWarnOnLevelGainStateMessage;
               this._warnWhenFriendOrGuildMemberLvlUp = fwolgsmsg.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendOrGuildMemberLevelUpWarningState,fwolgsmsg.enable);
               return true;
            case msg is PartyFollowStatusUpdateMessage:
               pfsumsg = msg as PartyFollowStatusUpdateMessage;
               if(this._spouse)
               {
                  if(Boolean(pfsumsg.success) && pfsumsg.followedId == this._spouse.id && !this._spouse.followSpouse)
                  {
                     KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseFollowStatusUpdated,true);
                     this._spouse.followSpouse = true;
                  }
                  if(Boolean(pfsumsg.success) && pfsumsg.followedId == 0 && Boolean(this._spouse.followSpouse))
                  {
                     KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseFollowStatusUpdated,false);
                     this._spouse.followSpouse = false;
                  }
               }
               if(pfsumsg.success)
               {
                  if(pfsumsg.followedId == 0)
                  {
                     PlayedCharacterManager.getInstance().isFollowingPlayer = false;
                  }
                  else
                  {
                     PlayedCharacterManager.getInstance().followingPlayerId = pfsumsg.followedId;
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.PartyFollowStatusUpdate,pfsumsg.followedId,pfsumsg.success);
               return true;
            case msg is GuildInformationsMembersMessage:
               gimmsg = msg as GuildInformationsMembersMessage;
               this._guildMembers = gimmsg.members;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               return true;
            case msg is GuildCreationStartedMessage:
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildCreationStarted);
               return true;
            case msg is GuildCreationResultMessage:
               gcrmsg = msg as GuildCreationResultMessage;
               switch(gcrmsg.result)
               {
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_ALREADY_IN_GUILD:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.alreadyInGuild"));
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_CANCEL:
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_EMBLEM_ALREADY_EXISTS:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.AlreadyUseEmblem"));
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_LEAVE:
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_NAME_ALREADY_EXISTS:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.AlreadyUseName"));
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_NAME_INVALID:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.invalidName"));
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_ERROR_REQUIREMENT_UNMET:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.requirementUnmet"));
                     break;
                  case GuildCreationResultEnum.GUILD_CREATE_OK:
                     this._hasGuild = true;
               }
               if(errorMessage)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,errorMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildCreationResult,gcrmsg.result);
               return true;
            case msg is GuildInvitedMessage:
               gimsg = msg as GuildInvitedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvited,gimsg.guildName,gimsg.recruterId,gimsg.recruterName);
               return true;
            case msg is GuildInvitationStateRecruterMessage:
               gisrermsg = msg as GuildInvitationStateRecruterMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvitationStateRecruter,gisrermsg.invitationState,gisrermsg.recrutedName);
               return true;
            case msg is GuildInvitationStateRecrutedMessage:
               gisredmsg = msg as GuildInvitationStateRecrutedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvitationStateRecruted,gisredmsg.invitationState);
               return true;
            case msg is GuildJoinedMessage:
               gjmsg = msg as GuildJoinedMessage;
               this._hasGuild = true;
               this._guild = GuildWrapper.create(gjmsg.guildName,gjmsg.guildEmblem,gjmsg.memberRights);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildJoined,gjmsg.guildEmblem,gjmsg.guildName,gjmsg.memberRights);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,true);
               joinMessage = I18n.getText(I18nProxy.getKeyId("ui.guild.JoinGuildMessage"),[gjmsg.guildName]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,joinMessage,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
            case msg is GuildUIOpenedMessage:
               guiomsg = msg as GuildUIOpenedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildUIOpened,guiomsg.type);
               return true;
            case msg is GuildInformationsGeneralMessage:
               gigmsg = msg as GuildInformationsGeneralMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsGeneral,gigmsg.enabled,gigmsg.expLevelFloor,gigmsg.experience,gigmsg.expNextLevelFloor,gigmsg.level);
               this._guild.level = gigmsg.level;
               return true;
            case msg is GuildInformationsMemberUpdateMessage:
               gimumsg = msg as GuildInformationsMemberUpdateMessage;
               nm = this._guildMembers.length;
               for(k = 0; k < nm; k++)
               {
                  member = this._guildMembers[k];
                  if(member.id == gimumsg.member.id)
                  {
                     this._guildMembers[k] = gimumsg.member;
                     if(member.id == PlayedCharacterManager.getInstance().id)
                     {
                        this.guild.memberRightsNumber = gimumsg.member.rights;
                     }
                     break;
                  }
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMemberUpdate,gimumsg.member);
               return true;
            case msg is GuildMemberLeavingMessage:
               gmlmsg = msg as GuildMemberLeavingMessage;
               comptgm = 0;
               for each(guildMember in this._guildMembers)
               {
                  if(gmlmsg.memberId == guildMember.id)
                  {
                     this._guildMembers.splice(comptgm,1);
                  }
                  comptgm++;
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMemberLeaving,gmlmsg.kicked,gmlmsg.memberId);
               return true;
            case msg is GuildLeftMessage:
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildLeft);
               this._hasGuild = false;
               this._guild = null;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,false);
               return true;
            case msg is GuildInfosUpgradeMessage:
               gipmsg = msg as GuildInfosUpgradeMessage;
               this._maxCollectorCount = gipmsg.maxTaxCollectorsCount;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInfosUpgrade,gipmsg.boostPoints,gipmsg.maxTaxCollectorsCount,gipmsg.spellId,gipmsg.spellLevel,gipmsg.taxCollectorDamagesBonuses,gipmsg.taxCollectorLifePoints,gipmsg.taxCollectorPods,gipmsg.taxCollectorProspecting,gipmsg.taxCollectorsCount,gipmsg.taxCollectorWisdom);
               return true;
            case msg is GuildFightPlayersHelpersJoinMessage:
               gfphjmsg = msg as GuildFightPlayersHelpersJoinMessage;
               this.addOrRemoveFighter(gfphjmsg.fightId,gfphjmsg.playerInfo,true,true);
               return true;
            case msg is GuildFightPlayersHelpersLeaveMessage:
               gfphlmsg = msg as GuildFightPlayersHelpersLeaveMessage;
               this.addOrRemoveFighter(gfphlmsg.fightId,gfphlmsg.playerId,true,false);
               return true;
            case msg is GuildFightPlayersEnemiesListMessage:
               gfpelmsg = msg as GuildFightPlayersEnemiesListMessage;
               for each(taxCollectorWrapper in this._taxCollectors)
               {
                  if(gfpelmsg.fightId == taxCollectorWrapper.uniqueId)
                  {
                     for each(enemy in gfpelmsg.playerInfo)
                     {
                        this.addOrRemoveFighter(gfpelmsg.fightId,enemy,false,true,false);
                     }
                     KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,gfpelmsg.fightId);
                     KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorUpdate,gfpelmsg.fightId);
                  }
               }
               return true;
            case msg is GuildFightPlayersEnemyRemoveMessage:
               gfpermsg = msg as GuildFightPlayersEnemyRemoveMessage;
               this.addOrRemoveFighter(gfpelmsg.fightId,gfpermsg.playerId,false,false);
               return true;
            case msg is GuildHousesInformationMessage:
               ghimsg = msg as GuildHousesInformationMessage;
               for each(houseInformation in ghimsg.HousesInformations)
               {
                  ghw = GuildHouseWrapper.create(houseInformation);
                  this._guildHouses.push(ghw);
               }
               this._guildHousesList = true;
               this._guildHousesListUpdate = false;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHousesUpdate);
               return true;
            case msg is TaxCollectorMovementMessage:
               tcmmsg = msg as TaxCollectorMovementMessage;
               infoText = "";
               taxCollectorName = TaxCollectorFirstname.getTaxCollectorFirstnameById(tcmmsg.basicInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(tcmmsg.basicInfos.lastNameId).name;
               positionX = String(WorldPoint.fromMapId(tcmmsg.basicInfos.mapId).x);
               positionY = String(WorldPoint.fromMapId(tcmmsg.basicInfos.mapId).y);
               worldPoint = positionX + "," + positionY;
               switch(tcmmsg.hireOrFire)
               {
                  case true:
                     infoText = I18n.getText(I18nProxy.getKeyId("ui.social.TaxCollectorAdded"),[taxCollectorName,worldPoint,tcmmsg.playerName]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,infoText,ChatChannelsMultiEnum.CHANNEL_GUILD);
                     break;
                  case false:
                     infoText = I18n.getText(I18nProxy.getKeyId("ui.social.TaxCollectorRemoved"),[taxCollectorName,worldPoint,tcmmsg.playerName]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,infoText,ChatChannelsMultiEnum.CHANNEL_GUILD);
               }
               return true;
            case msg is TaxCollectorAttackedMessage:
               tcamsg = msg as TaxCollectorAttackedMessage;
               this._taxCollectorListUpdate = false;
               taxCollectorN = TaxCollectorFirstname.getTaxCollectorFirstnameById(tcamsg.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(tcamsg.lastNameId).name;
               sentenceToDisplatch = I18n.getText(I18nProxy.getKeyId("ui.social.TaxCollectorAttacked"),[taxCollectorN,tcamsg.worldX + "," + tcamsg.worldY]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{hook,GuildUIOpened,3::" + sentenceToDisplatch + "}",ChatChannelsMultiEnum.CHANNEL_GUILD);
               return true;
            case msg is TaxCollectorAttackedResultMessage:
               tcarmsg = msg as TaxCollectorAttackedResultMessage;
               taxCName = TaxCollectorFirstname.getTaxCollectorFirstnameById(tcarmsg.basicInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(tcarmsg.basicInfos.lastNameId).name;
               worldPosX = WorldPoint.fromMapId(tcarmsg.basicInfos.mapId).x;
               worldPosY = WorldPoint.fromMapId(tcarmsg.basicInfos.mapId).y;
               if(tcarmsg.deadOrAlive)
               {
                  compttcw = 0;
                  for each(tcwrapper in this._taxCollectors)
                  {
                     mapId = CellIdConverter.coordToCellId(tcwrapper.mapWorldX,tcwrapper.mapWorldY);
                     lastName = TaxCollectorName.getTaxCollectorNameById(tcarmsg.basicInfos.lastNameId).name;
                     firstName = TaxCollectorFirstname.getTaxCollectorFirstnameById(tcarmsg.basicInfos.firstNameId).firstname;
                     if(mapId == tcarmsg.basicInfos.mapId && tcwrapper.firstName == firstName && tcwrapper.lastName == lastName)
                     {
                        this._taxCollectors.splice(compttcw,1);
                        KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorListUpdate);
                        this._taxCollectorListUpdate = true;
                     }
                     compttcw++;
                  }
                  sentenceToDisplatchResultAttack = I18n.getText(I18nProxy.getKeyId("ui.social.TaxCollectorDied"),[taxCName,worldPosX + "," + worldPosY]);
               }
               else
               {
                  sentenceToDisplatchResultAttack = I18n.getText(I18nProxy.getKeyId("ui.social.TaxCollectorSurvived"),[taxCName,worldPosX + "," + worldPosY]);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,sentenceToDisplatchResultAttack,ChatChannelsMultiEnum.CHANNEL_GUILD);
               return true;
            case msg is TaxCollectorErrorMessage:
               tcemsg = msg as TaxCollectorErrorMessage;
               errorTaxCollectorMessage = "";
               switch(tcemsg.reason)
               {
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_ALREADY_ONE:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.alreadyTaxCollectorOnMap"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_CANT_HIRE_HERE:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.cantHireTaxCollecotrHere"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_CANT_HIRE_YET:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.cantHireTaxcollectorTooTired"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_ERROR_UNKNOWN:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.unknownErrorTaxCollector"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_MAX_REACHED:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.cantHireMaxTaxCollector"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NO_RIGHTS:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.taxCollectorNoRights"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_ENOUGH_KAMAS:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.notEnougthRichToHireTaxCollector"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_FOUND:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.taxCollectorNotFound"));
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_OWNED:
                     errorTaxCollectorMessage = I18n.getText(I18nProxy.getKeyId("ui.social.notYourTaxcollector"));
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,errorTaxCollectorMessage,ChatFrame.RED_CHANNEL_ID);
               return true;
            case msg is TaxCollectorListMessage:
               tclmamsg = msg as TaxCollectorListMessage;
               this._taxCollectorHireCost = tclmamsg.taxCollectorHireCost;
               this._maxCollectorCount = tclmamsg.nbcollectorMax;
               for each(info in tclmamsg.informations)
               {
                  isInFight = false;
                  fightInfo = null;
                  for each(taxCollectorFightersInformation in tclmamsg.fightersInformations)
                  {
                     if(info is TaxCollectorInformationsInWaitForHelpState)
                     {
                        (info as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.timeLeftBeforeFight = (info as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.timeLeftBeforeFight * 100;
                     }
                     if(taxCollectorFightersInformation.collectorId == info.uniqueId)
                     {
                        isInFight = true;
                        fightInfo = taxCollectorFightersInformation;
                     }
                  }
                  tcw = TaxCollectorWrapper.create(info,fightInfo);
                  if(this._taxCollectors.indexOf(tcw) < 0)
                  {
                     present = false;
                     for each(taxC in this._taxCollectors)
                     {
                        if(taxC.uniqueId == info.uniqueId)
                        {
                           present = true;
                           this._taxCollectors.splice(this._taxCollectors.indexOf(taxC),1,tcw);
                           KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorUpdate,tcw.uniqueId);
                        }
                     }
                     if(!present)
                     {
                        this._taxCollectors.push(tcw);
                     }
                  }
               }
               this._taxCollectorList = true;
               this._taxCollectorListUpdate = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorListUpdate);
               return true;
            case msg is TaxCollectorMovementAddMessage:
               tcmamsg = msg as TaxCollectorMovementAddMessage;
               isUpdate = false;
               indexTcw = 0;
               comptTcwAdded = 0;
               for each(perco in this._taxCollectors)
               {
                  if(perco.uniqueId == tcmamsg.informations.uniqueId)
                  {
                     isUpdate = true;
                     perco.update(tcmamsg.informations,null);
                     if(perco.state == 1)
                     {
                        perco.missingTimeBeforeFight = (tcmamsg.informations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.timeLeftBeforeFight * 100;
                        this._taxCollectorFightListBegin[perco.uniqueId] = getTimer() + perco.missingTimeBeforeFight;
                        perco.waitTimeForPlacement = (tcmamsg.informations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.waitTimeForPlacement * 100;
                        perco.nbPositionPerTeam = (tcmamsg.informations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.nbPositionForDefensors;
                     }
                     KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorUpdate,perco.uniqueId);
                  }
               }
               if(!isUpdate)
               {
                  tcwadded = TaxCollectorWrapper.create(tcmamsg.informations,null);
                  this._taxCollectors.push(tcwadded);
                  this._taxCollectorListUpdate = true;
                  KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorListUpdate);
               }
               return true;
            case msg is TaxCollectorMovementRemoveMessage:
               tcmrmsg = msg as TaxCollectorMovementRemoveMessage;
               comptTax = 0;
               for each(taxCollector in this._taxCollectors)
               {
                  if(taxCollector.uniqueId == tcmrmsg.collectorId)
                  {
                     this._taxCollectors.splice(comptTax,1);
                  }
                  comptTax++;
               }
               this._taxCollectorListUpdate = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorListUpdate);
               return true;
            case msg is GuildInformationsPaddocksMessage:
               gifmsg = msg as GuildInformationsPaddocksMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsFarms,gifmsg.nbPaddockMax,gifmsg.paddocksInformations);
               return true;
            case msg is TaxCollectorDialogQuestionExtendedMessage:
               tcdqemsg = msg as TaxCollectorDialogQuestionExtendedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorDialogQuestionExtended,tcdqemsg.guildName,tcdqemsg.pods,tcdqemsg.prospecting,tcdqemsg.wisdom,tcdqemsg.taxCollectorsCount);
               return true;
            case msg is ContactLookMessage:
               clmsg = msg as ContactLookMessage;
               switch(clmsg.requestId)
               {
                  case 4:
                     KernelEventsManager.getInstance().processCallback(CraftHookList.JobCrafterContactLook,clmsg.playerId,clmsg.playerName,EntityLookAdapter.fromNetwork(clmsg.look));
               }
               return true;
            case msg is GuildGetInformationsAction:
               ggia = msg as GuildGetInformationsAction;
               askInformation = true;
               switch(ggia.infoType)
               {
                  case GuildInformationsTypeEnum.INFO_MEMBERS:
                     break;
                  case GuildInformationsTypeEnum.INFO_TAX_COLLECTOR:
                     if(this._taxCollectorList)
                     {
                        this.checkFightTaxCollectors();
                     }
                     break;
                  case GuildInformationsTypeEnum.INFO_HOUSES:
                     if(this._guildHousesList)
                     {
                        askInformation = false;
                        if(this._guildHousesListUpdate)
                        {
                           KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHousesUpdate);
                        }
                     }
               }
               if(askInformation)
               {
                  ggimsg = new GuildGetInformationsMessage();
                  ggimsg.initGuildGetInformationsMessage(ggia.infoType);
                  ConnectionsHandler.getConnection().send(ggimsg);
               }
               return true;
            case msg is GuildCreationValidAction:
               gcva = msg as GuildCreationValidAction;
               guildEmblem = new GuildEmblem();
               guildEmblem.symbolShape = gcva.upEmblemId;
               guildEmblem.symbolColor = gcva.upColorEmblem;
               guildEmblem.backgroundShape = gcva.backEmblemId;
               guildEmblem.backgroundColor = gcva.backColorEmblem;
               gcvmsg = new GuildCreationValidMessage();
               gcvmsg.initGuildCreationValidMessage(gcva.guildName,guildEmblem);
               ConnectionsHandler.getConnection().send(gcvmsg);
               return true;
            case msg is GuildInvitationAction:
               gia = msg as GuildInvitationAction;
               ginvitationmsg = new GuildInvitationMessage();
               ginvitationmsg.initGuildInvitationMessage(gia.targetId);
               ConnectionsHandler.getConnection().send(ginvitationmsg);
               return true;
            case msg is GuildInvitationByNameAction:
               gibna = msg as GuildInvitationByNameAction;
               gibnmsg = new GuildInvitationByNameMessage();
               gibnmsg.initGuildInvitationByNameMessage(gibna.target);
               ConnectionsHandler.getConnection().send(gibnmsg);
               return true;
            case msg is GuildInvitationAnswerAction:
               giaa = msg as GuildInvitationAnswerAction;
               giamsg = new GuildInvitationAnswerMessage();
               giamsg.initGuildInvitationAnswerMessage(giaa.accept);
               ConnectionsHandler.getConnection().send(giamsg);
               return true;
            case msg is GuildKickRequestAction:
               gkra = msg as GuildKickRequestAction;
               gkrmsg = new GuildKickRequestMessage();
               gkrmsg.initGuildKickRequestMessage(gkra.targetId);
               ConnectionsHandler.getConnection().send(gkrmsg);
               return true;
            case msg is GuildChangeMemberParametersAction:
               gcmpa = msg as GuildChangeMemberParametersAction;
               newRights = GuildWrapper.getRightsNumber(gcmpa.rights);
               gcmpmsg = new GuildChangeMemberParametersMessage();
               gcmpmsg.initGuildChangeMemberParametersMessage(gcmpa.memberId,gcmpa.rank,gcmpa.experienceGivenPercent,newRights);
               ConnectionsHandler.getConnection().send(gcmpmsg);
               return true;
            case msg is GuildSpellUpgradeRequestAction:
               gsura = msg as GuildSpellUpgradeRequestAction;
               gsurmsg = new GuildSpellUpgradeRequestMessage();
               gsurmsg.initGuildSpellUpgradeRequestMessage(gsura.spellId);
               ConnectionsHandler.getConnection().send(gsurmsg);
               return true;
            case msg is GuildCharacsUpgradeRequestAction:
               gcura = msg as GuildCharacsUpgradeRequestAction;
               gcurmsg = new GuildCharacsUpgradeRequestMessage();
               gcurmsg.initGuildCharacsUpgradeRequestMessage(gcura.charaTypeTarget);
               ConnectionsHandler.getConnection().send(gcurmsg);
               return true;
            case msg is GuildFarmTeleportRequestAction:
               gftra = msg as GuildFarmTeleportRequestAction;
               gftrmsg = new GuildPaddockTeleportRequestMessage();
               gftrmsg.initGuildPaddockTeleportRequestMessage(gftra.farmId);
               ConnectionsHandler.getConnection().send(gftrmsg);
               return true;
            case msg is GuildHouseTeleportRequestAction:
               ghtra = msg as GuildHouseTeleportRequestAction;
               ghtrmsg = new GuildHouseTeleportRequestMessage();
               ghtrmsg.initGuildHouseTeleportRequestMessage(ghtra.houseId);
               ConnectionsHandler.getConnection().send(ghtrmsg);
               return true;
            case msg is GuildFightJoinRequestAction:
               gfjra = msg as GuildFightJoinRequestAction;
               gfjrmsg = new GuildFightJoinRequestMessage();
               gfjrmsg.initGuildFightJoinRequestMessage(gfjra.taxCollectorId);
               ConnectionsHandler.getConnection().send(gfjrmsg);
               return true;
            case msg is GuildFightLeaveRequestAction:
               gflra = msg as GuildFightLeaveRequestAction;
               if(gflra.warning)
               {
                  for each(percoo in this._taxCollectors)
                  {
                     if(percoo.state == 1)
                     {
                        for each(ally in percoo.allyCharactersInformations)
                        {
                           if(ally.playerCharactersInformations.id == gflra.characterId)
                           {
                              text = I18n.getText(I18nProxy.getKeyId("ui.social.guild.autoFightLeave"));
                              KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
                              gflrmsg = new GuildFightLeaveRequestMessage();
                              gflrmsg.initGuildFightLeaveRequestMessage(percoo.uniqueId,gflra.characterId);
                              ConnectionsHandler.getConnection().send(gflrmsg);
                           }
                        }
                     }
                  }
               }
               else
               {
                  gflrmsg = new GuildFightLeaveRequestMessage();
                  gflrmsg.initGuildFightLeaveRequestMessage(gflra.taxCollectorId,gflra.characterId);
                  ConnectionsHandler.getConnection().send(gflrmsg);
               }
               return true;
            case msg is TaxCollectorHireRequestAction:
               tchra = msg as TaxCollectorHireRequestAction;
               if(this._taxCollectorHireCost <= PlayedCharacterManager.getInstance().characteristics.kamas)
               {
                  tchrmsg = new TaxCollectorHireRequestMessage();
                  tchrmsg.initTaxCollectorHireRequestMessage();
                  ConnectionsHandler.getConnection().send(tchrmsg);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getText(I18nProxy.getKeyId("ui.popup.not_enough_rich")),ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is TaxCollectorFireRequestAction:
               tcfra = msg as TaxCollectorFireRequestAction;
               tcfrmsg = new TaxCollectorFireRequestMessage();
               tcfrmsg.initTaxCollectorFireRequestMessage(tcfra.taxCollectorId);
               ConnectionsHandler.getConnection().send(tcfrmsg);
               return true;
            case msg is CharacterReportAction:
               cra = msg as CharacterReportAction;
               crm = new CharacterReportMessage();
               crm.initCharacterReportMessage(cra.reportedId,cra.reason);
               ConnectionsHandler.getConnection().send(crm);
               return true;
            case msg is ChatReportAction:
               chra = msg as ChatReportAction;
               cmr = new ChatMessageReportMessage();
               chatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
               timeStamp = chatFrame.getTimestampServerByRealTimestamp(chra.timestamp);
               cmr.initChatMessageReportMessage(chra.name,chra.message,timeStamp,chra.fingerprint,chra.reason);
               ConnectionsHandler.getConnection().send(cmr);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function isIgnored(name:String) : Boolean
      {
         var loser:IgnoredWrapper = null;
         for each(loser in this._ignoredList)
         {
            if(loser.name.toLowerCase() == name.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public function isFriend(playerName:String) : Boolean
      {
         var fw:FriendWrapper = null;
         var n:int = this._friendsList.length;
         for(var i:int = 0; i < n; i++)
         {
            fw = this._friendsList[i];
            if(fw.playerName == playerName)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isEnemy(playerName:String) : Boolean
      {
         var ew:EnemyWrapper = null;
         var n:int = this._enemiesList.length;
         for(var i:int = 0; i < n; i++)
         {
            ew = this._enemiesList[i];
            if(ew.playerName == playerName)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addOrRemoveFighter(pFightId:int, pPlayerInfo:*, ally:Boolean, addFighter:Boolean, pDispatchHook:Boolean = true) : void
      {
         var taxCollectorWrapper:TaxCollectorWrapper = null;
         var comptAlly:uint = 0;
         var allyFighter:TaxCollectorFightersWrapper = null;
         var comptEnemy:uint = 0;
         var EnemyFighter:TaxCollectorFightersWrapper = null;
         for each(taxCollectorWrapper in this._taxCollectors)
         {
            if(pFightId == taxCollectorWrapper.uniqueId)
            {
               switch(ally)
               {
                  case true:
                     switch(addFighter)
                     {
                        case true:
                           if(taxCollectorWrapper.allyCharactersInformations == null)
                           {
                              taxCollectorWrapper.allyCharactersInformations = new Vector.<TaxCollectorFightersWrapper>();
                           }
                           taxCollectorWrapper.allyCharactersInformations.push(TaxCollectorFightersWrapper.create(0,pPlayerInfo));
                           if(pDispatchHook)
                           {
                              KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightAlliesListUpdate,pFightId);
                           }
                           break;
                        case false:
                           comptAlly = 0;
                           for each(allyFighter in taxCollectorWrapper.allyCharactersInformations)
                           {
                              if(allyFighter.playerCharactersInformations.id == pPlayerInfo)
                              {
                                 taxCollectorWrapper.allyCharactersInformations.splice(comptAlly,1);
                                 if(pDispatchHook)
                                 {
                                    KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightAlliesListUpdate,pFightId);
                                 }
                              }
                              comptAlly++;
                           }
                     }
                     continue;
                  case false:
                     switch(addFighter)
                     {
                        case true:
                           if(taxCollectorWrapper.enemyCharactersInformations == null)
                           {
                              taxCollectorWrapper.enemyCharactersInformations = new Vector.<TaxCollectorFightersWrapper>();
                           }
                           taxCollectorWrapper.enemyCharactersInformations.push(TaxCollectorFightersWrapper.create(1,pPlayerInfo));
                           if(pDispatchHook)
                           {
                              KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,pFightId);
                           }
                           break;
                        case false:
                           comptEnemy = 0;
                           for each(EnemyFighter in taxCollectorWrapper.allyCharactersInformations)
                           {
                              if(EnemyFighter.playerCharactersInformations.id == pPlayerInfo)
                              {
                                 taxCollectorWrapper.allyCharactersInformations.splice(comptEnemy,1);
                                 if(pDispatchHook)
                                 {
                                    KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,pFightId);
                                 }
                              }
                              comptEnemy++;
                           }
                     }
                     continue;
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
      }
      
      private function checkFightTaxCollectors() : void
      {
         var taxCollector:TaxCollectorWrapper = null;
         for each(taxCollector in this._taxCollectors)
         {
            if(taxCollector.state == 1)
            {
               taxCollector.missingTimeBeforeFight = this._taxCollectorFightListBegin[taxCollector.uniqueId] - getTimer();
               if(this._taxCollectorFightListBegin[taxCollector.uniqueId] <= 0)
               {
                  taxCollector.state = 2;
                  KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorUpdate,taxCollector.uniqueId);
               }
            }
         }
      }
   }
}
