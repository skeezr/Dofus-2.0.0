package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HumanVendorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpectatorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.BidHouseManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PrismFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockPrivateInformations;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcGenericActionRequestAction;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRequestOnTaxCollectorAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnTaxCollectorMessage;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.GameRolePlayTaxCollectorFightRequestAction;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GameRolePlayTaxCollectorFightRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.InteractiveElementActivationAction;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogCreationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectFoundWhileRecoltingMessage;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightRequestMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightFriendlyAnswerAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnsweredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayFightRequestCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyRequestedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayFreeSoulRequestMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.LeaveDialogRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayAggressionMessage;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangePlayerRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerMultiCraftRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.craft.JobAllowMultiCraftRequestSetAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobAllowMultiCraftRequestSetMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobAllowMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgetUIMessage;
   import com.ankamagames.dofus.network.messages.game.guild.ChallengeFightJoinRefusedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ValidateSpellForgetAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.ValidateSpellForgetMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellForgottenMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftInformationObjectMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.DocumentReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.visual.GameRolePlaySpellAnimMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplaySpellCastProvider;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobMultiCraftAvailableSkillsMessage;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.MouseEvent;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.StorageModList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.enums.ExchangeErrorEnum;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.network.enums.FighterRefusedReasonEnum;
   import com.ankamagames.dofus.network.enums.CraftResultEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockPropertiesMessage;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.script.ScriptExec;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.dofus.logic.game.common.actions.PivotCharacterAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeRequestOnShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeStartAsVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShowVendorTaxAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.GameRolePlayFreeSoulRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.LeaveBidHouseAction;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.utils.display.AngleToOrientation;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationRequestMessage;
   
   public class RoleplayContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayContextFrame));
       
      private var _entitiesFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
      
      private var _worldFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame;
      
      private var _interactivesFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame;
      
      private var _npcDialogFrame:com.ankamagames.dofus.logic.game.roleplay.frames.NpcDialogFrame;
      
      private var _emoticonFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame;
      
      private var _exchangeManagementFrame:ExchangeManagementFrame;
      
      private var _humanVendorManagementFrame:HumanVendorManagementFrame;
      
      private var _spectatorManagementFrame:SpectatorManagementFrame;
      
      private var _partyManagementFrame:PartyManagementFrame;
      
      private var _bidHouseManagementFrame:BidHouseManagementFrame;
      
      private var _prismFrame:PrismFrame;
      
      private var _craftFrame:CraftFrame;
      
      private var _commonExchangeFrame:CommonExchangeManagementFrame;
      
      private var _movementFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
      
      private var _currentWaitingFightId:uint;
      
      private var _crafterId:uint;
      
      private var _customerID:uint;
      
      private var _playersMultiCraftSkill:Array;
      
      private var _currentPaddock:PaddockInformations;
      
      private var _playerEntity:AnimatedCharacter;
      
      public function RoleplayContextFrame()
      {
         super();
      }
      
      public function get crafterId() : uint
      {
         return this._crafterId;
      }
      
      public function get customerID() : uint
      {
         return this._customerID;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get entitiesFrame() : com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      public function get hasWorldInteraction() : Boolean
      {
         return Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame);
      }
      
      public function get commonExchangeFrame() : CommonExchangeManagementFrame
      {
         return this._commonExchangeFrame;
      }
      
      public function get hasGuildedPaddock() : Boolean
      {
         return Boolean(this._currentPaddock) && this._currentPaddock is PaddockPrivateInformations;
      }
      
      public function get currentPaddock() : PaddockInformations
      {
         return this._currentPaddock;
      }
      
      public function pushed() : Boolean
      {
         (Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame) as PlayedCharacterUpdatesFrame).roleplayContextFrame = this;
         this._entitiesFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame();
         this._movementFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame();
         this._worldFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame(this,this._movementFrame);
         this._npcDialogFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.NpcDialogFrame();
         this._interactivesFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame(this);
         this._exchangeManagementFrame = new ExchangeManagementFrame(this,this._movementFrame);
         this._spectatorManagementFrame = new SpectatorManagementFrame(this);
         this._partyManagementFrame = new PartyManagementFrame(this);
         this._bidHouseManagementFrame = new BidHouseManagementFrame();
         this._craftFrame = new CraftFrame(this);
         this._humanVendorManagementFrame = new HumanVendorManagementFrame(this,this._movementFrame);
         Kernel.getWorker().addFrame(this._spectatorManagementFrame);
         Kernel.getWorker().addFrame(this._partyManagementFrame);
         this._prismFrame = Kernel.getWorker().getFrame(PrismFrame) as PrismFrame;
         this._prismFrame.pushRoleplay();
         if(!Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame))
         {
            this._emoticonFrame = new com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame(this._movementFrame);
            Kernel.getWorker().addFrame(this._emoticonFrame);
         }
         else
         {
            this._emoticonFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame) as com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame;
         }
         this._emoticonFrame.roleplayMovementFrame = this._movementFrame;
         this._playersMultiCraftSkill = new Array();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var mcmsg:CurrentMapMessage = null;
         var wp:WorldPoint = null;
         var commonMod:Object = null;
         var cwiamsg:ChangeWorldInteractionAction = null;
         var bidHouseSwitch:Boolean = false;
         var ngara:NpcGenericActionRequestAction = null;
         var playerEntity:IEntity = null;
         var ngarmsg:NpcGenericActionRequestMessage = null;
         var erotca:ExchangeRequestOnTaxCollectorAction = null;
         var erotcmsg:ExchangeRequestOnTaxCollectorMessage = null;
         var playerEntity4:IEntity = null;
         var grptcfra:GameRolePlayTaxCollectorFightRequestAction = null;
         var grptcfrmsg:GameRolePlayTaxCollectorFightRequestMessage = null;
         var ieaa:InteractiveElementActivationAction = null;
         var ieamsg:InteractiveElementActivationMessage = null;
         var ndcmsg:NpcDialogCreationMessage = null;
         var entityNpcLike:Object = null;
         var esonmsg:ExchangeStartOkNpcShopMessage = null;
         var esmsg:ExchangeStartedMessage = null;
         var bidHouseSwitching:Boolean = false;
         var ofwrm:ObjectFoundWhileRecoltingMessage = null;
         var itemFound:Item = null;
         var playerId:uint = 0;
         var craftSmileyItem:CraftSmileyItem = null;
         var quantity:uint = 0;
         var itemName:String = null;
         var ressourceName:String = null;
         var message:String = null;
         var pfra:PlayerFightRequestAction = null;
         var gppfrm:GameRolePlayPlayerFightRequestMessage = null;
         var playerEntity2:IEntity = null;
         var pffaa:PlayerFightFriendlyAnswerAction = null;
         var grppffam2:GameRolePlayPlayerFightFriendlyAnswerMessage = null;
         var grppffam:GameRolePlayPlayerFightFriendlyAnsweredMessage = null;
         var grpfrcm:GameRolePlayFightRequestCanceledMessage = null;
         var grppffrm:GameRolePlayPlayerFightFriendlyRequestedMessage = null;
         var grpfsrmmsg:GameRolePlayFreeSoulRequestMessage = null;
         var ldrbidHousemsg:LeaveDialogRequestMessage = null;
         var ldra:LeaveDialogRequestAction = null;
         var ldrmsg:LeaveDialogRequestMessage = null;
         var ermsg:ExchangeErrorMessage = null;
         var errorMessage:String = null;
         var date:Date = null;
         var time:Number = NaN;
         var grpamsg:GameRolePlayAggressionMessage = null;
         var epra:ExchangePlayerRequestAction = null;
         var eprmsg:ExchangePlayerRequestMessage = null;
         var epmcra:ExchangePlayerMultiCraftRequestAction = null;
         var epmcrmsg:ExchangePlayerMultiCraftRequestMessage = null;
         var jamcrsa:JobAllowMultiCraftRequestSetAction = null;
         var jamcrsmsg:JobAllowMultiCraftRequestSetMessage = null;
         var jamcrmsg:JobAllowMultiCraftRequestMessage = null;
         var messId:uint = 0;
         var sfuimsg:SpellForgetUIMessage = null;
         var cfjrmsg:ChallengeFightJoinRefusedMessage = null;
         var vsfa:ValidateSpellForgetAction = null;
         var vsfmsg:ValidateSpellForgetMessage = null;
         var sfmsg:SpellForgottenMessage = null;
         var ecrmsg:ExchangeCraftResultMessage = null;
         var messageId:uint = 0;
         var eciomsg:ExchangeCraftInformationObjectMessage = null;
         var csi:CraftSmileyItem = null;
         var drbm:DocumentReadingBeginMessage = null;
         var grpsamsg:GameRolePlaySpellAnimMessage = null;
         var spellLuncher:RoleplaySpellCastProvider = null;
         var scriptUri:Uri = null;
         var scriptRunner:SpellFxRunner = null;
         var npcEntity:GameRolePlayNpcInformations = null;
         var ponyEntity:GameRolePlayTaxCollectorInformations = null;
         var absoluteBounds:IRectangle = null;
         var gcai:GameContextActorInformations = null;
         var jmcasm:JobMultiCraftAvailableSkillsMessage = null;
         var mcefp:MultiCraftEnableForPlayer = null;
         var alreadyIn:Boolean = false;
         var compt:uint = 0;
         var index:uint = 0;
         var mcefplayer:MultiCraftEnableForPlayer = null;
         var item:Item = null;
         var iconId:uint = 0;
         var absBounds:IRectangle = null;
         switch(true)
         {
            case msg is CurrentMapMessage:
               mcmsg = msg as CurrentMapMessage;
               if(Boolean(this._entitiesFrame) && Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame)))
               {
                  Kernel.getWorker().removeFrame(this._entitiesFrame);
               }
               if(Boolean(this._worldFrame) && Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame)))
               {
                  Kernel.getWorker().removeFrame(this._worldFrame);
               }
               if(Boolean(this._interactivesFrame) && Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame)))
               {
                  Kernel.getWorker().removeFrame(this._interactivesFrame);
               }
               if(Boolean(this._movementFrame) && Boolean(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame)))
               {
                  Kernel.getWorker().removeFrame(this._movementFrame);
               }
               wp = WorldPoint.fromMapId(mcmsg.mapId);
               Atouin.getInstance().initPreDisplay(wp);
               Atouin.getInstance().clearEntities();
               Atouin.getInstance().display(wp);
               PlayedCharacterManager.getInstance().currentMap = wp;
               TooltipManager.hideAll();
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               commonMod.closeAllMenu();
               this._currentPaddock = null;
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,mcmsg.mapId);
               return true;
            case msg is MapsLoadingCompleteMessage:
               Kernel.getWorker().addFrame(this._entitiesFrame);
               KernelEventsManager.getInstance().processCallback(HookList.MapsLoadingComplete,MapsLoadingCompleteMessage(msg).mapPoint);
               Kernel.getWorker().addFrame(this._worldFrame);
               Kernel.getWorker().addFrame(this._interactivesFrame);
               Kernel.getWorker().addFrame(this._movementFrame);
               SoundManager.getInstance().manager.setSubArea(MapsLoadingCompleteMessage(msg).mapData);
               return true;
            case msg is ChangeWorldInteractionAction:
               cwiamsg = msg as ChangeWorldInteractionAction;
               bidHouseSwitch = false;
               if(Boolean(Kernel.getWorker().contains(BidHouseManagementFrame)) && Boolean(this._bidHouseManagementFrame.switching))
               {
                  bidHouseSwitch = true;
               }
               if(cwiamsg.enabled)
               {
                  if(!Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame) && !bidHouseSwitch)
                  {
                     _log.info("Enabling interaction with the roleplay world.");
                     Kernel.getWorker().addFrame(this._worldFrame);
                  }
               }
               else if(Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayWorldFrame))
               {
                  _log.info("Disabling interaction with the roleplay world.");
                  Kernel.getWorker().removeFrame(this._worldFrame);
               }
               return true;
            case msg is NpcGenericActionRequestAction:
               ngara = msg as NpcGenericActionRequestAction;
               playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               ngarmsg = new NpcGenericActionRequestMessage();
               ngarmsg.initNpcGenericActionRequestMessage(ngara.npcId,ngara.actionId);
               if((playerEntity as IMovable).isMoving)
               {
                  (playerEntity as IMovable).stop();
                  this._movementFrame.setFollowingMessage(ngarmsg);
               }
               else
               {
                  ConnectionsHandler.getConnection().send(ngarmsg);
               }
               return true;
            case msg is ExchangeRequestOnTaxCollectorAction:
               erotca = msg as ExchangeRequestOnTaxCollectorAction;
               erotcmsg = new ExchangeRequestOnTaxCollectorMessage();
               erotcmsg.initExchangeRequestOnTaxCollectorMessage(erotca.taxCollectorId);
               playerEntity4 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if((playerEntity4 as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(erotcmsg);
                  (playerEntity4 as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(erotcmsg);
               }
               return true;
            case msg is GameRolePlayTaxCollectorFightRequestAction:
               grptcfra = msg as GameRolePlayTaxCollectorFightRequestAction;
               grptcfrmsg = new GameRolePlayTaxCollectorFightRequestMessage();
               grptcfrmsg.initGameRolePlayTaxCollectorFightRequestMessage(grptcfra.taxCollectorId);
               ConnectionsHandler.getConnection().send(grptcfrmsg);
               return true;
            case msg is InteractiveElementActivationAction:
               ieaa = msg as InteractiveElementActivationAction;
               ieamsg = new InteractiveElementActivationMessage(ieaa.interactiveElement,ieaa.position,ieaa.skillId);
               Kernel.getWorker().process(ieamsg);
               return true;
            case msg is PivotCharacterAction:
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
               this._playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id) as AnimatedCharacter;
               StageShareManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
               StageShareManager.stage.addEventListener(MouseEvent.CLICK,this.onClickOrientation);
               return true;
            case msg is NpcGenericActionFailureMessage:
               KernelEventsManager.getInstance().processCallback(HookList.NpcDialogCreationFailure);
               return true;
            case msg is NpcDialogCreationMessage:
               ndcmsg = msg as NpcDialogCreationMessage;
               entityNpcLike = this._entitiesFrame.getEntityInfos(ndcmsg.npcId);
               if(!Kernel.getWorker().contains(com.ankamagames.dofus.logic.game.roleplay.frames.NpcDialogFrame))
               {
                  Kernel.getWorker().addFrame(this._npcDialogFrame);
               }
               if(entityNpcLike is GameRolePlayNpcInformations)
               {
                  npcEntity = entityNpcLike as GameRolePlayNpcInformations;
                  KernelEventsManager.getInstance().processCallback(HookList.NpcDialogCreation,ndcmsg.mapId,npcEntity.npcId,EntityLookAdapter.fromNetwork(npcEntity.look));
               }
               else if(entityNpcLike is GameRolePlayTaxCollectorInformations)
               {
                  ponyEntity = entityNpcLike as GameRolePlayTaxCollectorInformations;
                  KernelEventsManager.getInstance().processCallback(HookList.PonyDialogCreation,ndcmsg.mapId,ponyEntity.firstNameId,ponyEntity.lastNameId,EntityLookAdapter.fromNetwork(ponyEntity.look));
               }
               return true;
            case msg is GameContextDestroyMessage:
               TooltipManager.hide();
               Kernel.getWorker().removeFrame(this);
               return true;
            case msg is ExchangeStartedBidBuyerMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_BUY);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.BID_HOUSE_MOD);
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidBuyerMessage(msg as ExchangeStartedBidBuyerMessage);
               return true;
            case msg is ExchangeStartedBidSellerMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_SELL);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.BID_HOUSE_MOD);
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidSellerMessage(msg as ExchangeStartedBidSellerMessage);
               return true;
            case msg is ExchangeRequestOnShopStockAction:
            case msg is ExchangeStartAsVendorRequestAction:
            case msg is ExchangeShowVendorTaxAction:
            case msg is ExchangeOnHumanVendorRequestAction:
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
                  this._humanVendorManagementFrame.process(msg);
               }
               return true;
            case msg is ExchangeRequestedTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.PLAYER_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeRequestedTradeMessage(msg as ExchangeRequestedTradeMessage);
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.EXCHANGE_MOD);
               return true;
            case msg is ExchangeStartOkNpcTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkNpcTradeMessage(msg as ExchangeStartOkNpcTradeMessage);
               }
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.EXCHANGE_NPC_MOD);
               return true;
            case msg is ExchangeStartOkNpcShopMessage:
               esonmsg = msg as ExchangeStartOkNpcShopMessage;
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_SHOP);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               this._exchangeManagementFrame.process(msg);
               return true;
            case msg is ExchangeStartedMessage:
               esmsg = msg as ExchangeStartedMessage;
               switch(esmsg.exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                     this.addCraftFrame();
                     break;
                  case ExchangeTypeEnum.BIDHOUSE_BUY:
                  case ExchangeTypeEnum.BIDHOUSE_SELL:
                  case ExchangeTypeEnum.PLAYER_TRADE:
               }
               this.addCommonExchangeFrame(esmsg.exchangeType);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               this._exchangeManagementFrame.process(msg);
               return true;
            case msg is ExchangeLeaveMessage:
               PlayedCharacterManager.getInstance().isInExchange = false;
               bidHouseSwitching = false;
               if(Boolean(Kernel.getWorker().contains(BidHouseManagementFrame)) && Boolean(this._bidHouseManagementFrame.switching))
               {
                  bidHouseSwitching = true;
               }
               if(Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().removeFrame(this._exchangeManagementFrame);
               }
               if(Boolean(Kernel.getWorker().contains(CommonExchangeManagementFrame)) && !bidHouseSwitching)
               {
                  Kernel.getWorker().removeFrame(this._commonExchangeFrame);
               }
               if(Boolean(Kernel.getWorker().contains(BidHouseManagementFrame)) && !bidHouseSwitching)
               {
                  Kernel.getWorker().removeFrame(this._bidHouseManagementFrame);
               }
               if(Kernel.getWorker().contains(CraftFrame))
               {
                  Kernel.getWorker().removeFrame(this._craftFrame);
               }
               if(Boolean(Kernel.getWorker().contains(HumanVendorManagementFrame)) && !bidHouseSwitching)
               {
                  Kernel.getWorker().removeFrame(this._humanVendorManagementFrame);
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave,(msg as ExchangeLeaveMessage).success);
               KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageModChanged,StorageModList.BAG_MOD);
               return true;
            case msg is ExchangeOkMultiCraftMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeOkMultiCraftMessage(msg as ExchangeOkMultiCraftMessage);
               return true;
            case msg is ExchangeStartOkCraftWithInformationMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeStartOkCraftWithInformationMessage(msg as ExchangeStartOkCraftWithInformationMessage);
               return true;
            case msg is ObjectFoundWhileRecoltingMessage:
               ofwrm = msg as ObjectFoundWhileRecoltingMessage;
               itemFound = Item.getItemById(ofwrm.genericId);
               playerId = PlayedCharacterManager.getInstance().id;
               craftSmileyItem = new CraftSmileyItem(playerId,itemFound.iconId,2);
               if(DofusEntities.getEntity(playerId) as IDisplayable)
               {
                  absoluteBounds = (DofusEntities.getEntity(playerId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(craftSmileyItem,absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + playerId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               }
               quantity = ofwrm.quantity;
               itemName = !!ofwrm.genericId?Item.getItemById(ofwrm.genericId).name:I18n.getText(I18nProxy.getKeyId("ui.common.kamas"));
               ressourceName = Item.getItemById(ofwrm.ressourceGenericId).name;
               message = I18n.getText(I18nProxy.getKeyId("ui.common.itemFound"),[quantity,itemName,ressourceName]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,message,ChatActivableChannelsEnum.CHANNEL_GLOBAL);
               return true;
            case msg is PlayerFightRequestAction:
               pfra = PlayerFightRequestAction(msg);
               gppfrm = new GameRolePlayPlayerFightRequestMessage();
               gppfrm.initGameRolePlayPlayerFightRequestMessage(pfra.targetedPlayerId,pfra.firendly);
               playerEntity2 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if((playerEntity2 as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(pfra);
                  (playerEntity2 as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(gppfrm);
               }
               return true;
            case msg is PlayerFightFriendlyAnswerAction:
               pffaa = PlayerFightFriendlyAnswerAction(msg);
               grppffam2 = new GameRolePlayPlayerFightFriendlyAnswerMessage();
               grppffam2.initGameRolePlayPlayerFightFriendlyAnswerMessage(this._currentWaitingFightId,pffaa.accept);
               grppffam2.accept = pffaa.accept;
               grppffam2.fightId = this._currentWaitingFightId;
               ConnectionsHandler.getConnection().send(grppffam2);
               return true;
            case msg is GameRolePlayPlayerFightFriendlyAnsweredMessage:
               grppffam = msg as GameRolePlayPlayerFightFriendlyAnsweredMessage;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,grppffam.accept);
               return true;
            case msg is GameRolePlayFightRequestCanceledMessage:
               grpfrcm = msg as GameRolePlayFightRequestCanceledMessage;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,false);
               return true;
            case msg is GameRolePlayPlayerFightFriendlyRequestedMessage:
               grppffrm = msg as GameRolePlayPlayerFightFriendlyRequestedMessage;
               this._currentWaitingFightId = grppffrm.fightId;
               if(grppffrm.sourceId != PlayedCharacterManager.getInstance().infos.id)
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyRequested,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(grppffrm.sourceId)).name);
               }
               else
               {
                  gcai = this._entitiesFrame.getEntityInfos(grppffrm.targetId);
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightRequestSent,GameRolePlayNamedActorInformations(gcai).name,true);
               }
               return true;
            case msg is GameRolePlayFreeSoulRequestAction:
               grpfsrmmsg = new GameRolePlayFreeSoulRequestMessage();
               ConnectionsHandler.getConnection().send(grpfsrmmsg);
               return true;
            case msg is LeaveBidHouseAction:
               ldrbidHousemsg = new LeaveDialogRequestMessage();
               ldrbidHousemsg.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(ldrbidHousemsg);
               return true;
            case msg is LeaveDialogRequestAction:
               ldra = msg as LeaveDialogRequestAction;
               ldrmsg = new LeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(ldrmsg);
               return true;
            case msg is LeaveDialogMessage:
               Kernel.getWorker().removeFrame(this._npcDialogFrame);
               KernelEventsManager.getInstance().processCallback(HookList.LeaveDialog);
               return true;
            case msg is ExchangeErrorMessage:
               ermsg = msg as ExchangeErrorMessage;
               switch(ermsg.errorType)
               {
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OCCUPIED:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeCharacterOccupied"));
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_TOOL_TOO_FAR:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.craft.notNearCraftTable"));
                     break;
                  case ExchangeErrorEnum.REQUEST_IMPOSSIBLE:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchange"));
                     break;
                  case ExchangeErrorEnum.BID_SEARCH_ERROR:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeBIDSearchError"));
                     break;
                  case ExchangeErrorEnum.BUY_ERROR:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeBuyError"));
                     break;
                  case ExchangeErrorEnum.MOUNT_PADDOCK_ERROR:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeMountPaddockError"));
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_JOB_NOT_EQUIPED:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeCharacterJobNotEquiped"));
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_NOT_SUSCRIBER:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeCharacterNotSuscriber"));
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OVERLOADED:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeCharacterOverloaded"));
                     break;
                  case ExchangeErrorEnum.SELL_ERROR:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchangeSellError"));
                     break;
                  default:
                     errorMessage = I18n.getText(I18nProxy.getKeyId("ui.exchange.cantExchange"));
               }
               date = new Date();
               time = date.getTime() + TimeManager.getInstance().serverTimeLag;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,errorMessage,ChatActivableChannelsEnum.CHANNEL_GLOBAL,time);
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeError,ermsg.errorType);
               return true;
            case msg is GameRolePlayAggressionMessage:
               grpamsg = msg as GameRolePlayAggressionMessage;
               message = I18n.getText(I18nProxy.getKeyId("ui.pvp.aAttackB"),[GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(grpamsg.attackerId)).name,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(grpamsg.defenderId)).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,message,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               playerId = PlayedCharacterManager.getInstance().infos.id;
               if(playerId == grpamsg.attackerId)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESS);
               }
               else if(playerId == grpamsg.defenderId)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESSED);
               }
               return true;
            case msg is ExchangePlayerRequestAction:
               epra = msg as ExchangePlayerRequestAction;
               eprmsg = new ExchangePlayerRequestMessage();
               eprmsg.initExchangePlayerRequestMessage(epra.exchangeType,epra.target);
               ConnectionsHandler.getConnection().send(eprmsg);
               return true;
            case msg is ExchangePlayerMultiCraftRequestAction:
               epmcra = msg as ExchangePlayerMultiCraftRequestAction;
               switch(epmcra.exchangeType)
               {
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                     this._customerID = epmcra.target;
                     this._crafterId = PlayedCharacterManager.getInstance().infos.id;
                     break;
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                     this._crafterId = epmcra.target;
                     this._customerID = PlayedCharacterManager.getInstance().infos.id;
               }
               epmcrmsg = new ExchangePlayerMultiCraftRequestMessage();
               epmcrmsg.initExchangePlayerMultiCraftRequestMessage(epmcra.exchangeType,epmcra.target,epmcra.skillId);
               ConnectionsHandler.getConnection().send(epmcrmsg);
               return true;
            case msg is JobAllowMultiCraftRequestSetAction:
               jamcrsa = msg as JobAllowMultiCraftRequestSetAction;
               jamcrsmsg = new JobAllowMultiCraftRequestSetMessage();
               jamcrsmsg.initJobAllowMultiCraftRequestSetMessage(jamcrsa.isPublic);
               ConnectionsHandler.getConnection().send(jamcrsmsg);
               return true;
            case msg is JobAllowMultiCraftRequestMessage:
               jamcrmsg = msg as JobAllowMultiCraftRequestMessage;
               messId = (msg as JobAllowMultiCraftRequestMessage).getMessageId();
               switch(messId)
               {
                  case JobAllowMultiCraftRequestMessage.protocolId:
                     break;
                  case JobMultiCraftAvailableSkillsMessage.protocolId:
                     jmcasm = msg as JobMultiCraftAvailableSkillsMessage;
                     if(jmcasm.enabled)
                     {
                        mcefp = new MultiCraftEnableForPlayer();
                        mcefp.playerId = jmcasm.playerId;
                        mcefp.skills = jmcasm.skills;
                        alreadyIn = false;
                        compt = 0;
                        index = 0;
                        for each(mcefplayer in this._playersMultiCraftSkill)
                        {
                           if(mcefplayer.playerId == mcefp.playerId)
                           {
                              alreadyIn = true;
                              mcefplayer.skills = jmcasm.skills;
                           }
                        }
                        if(!alreadyIn)
                        {
                           this._playersMultiCraftSkill.push(mcefp);
                        }
                     }
               }
               PlayedCharacterManager.getInstance().publicMode = jamcrmsg.enabled;
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobAllowMultiCraftRequest,jamcrmsg.enabled);
               return true;
            case msg is SpellForgetUIMessage:
               sfuimsg = msg as SpellForgetUIMessage;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.SpellForgetUI,sfuimsg.open);
               return true;
            case msg is ChallengeFightJoinRefusedMessage:
               cfjrmsg = msg as ChallengeFightJoinRefusedMessage;
               switch(cfjrmsg.reason)
               {
                  case FighterRefusedReasonEnum.CHALLENGE_FULL:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.challengeFull"));
                     break;
                  case FighterRefusedReasonEnum.TEAM_FULL:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.teamFull"));
                     break;
                  case FighterRefusedReasonEnum.WRONG_ALIGNMENT:
                     message = I18n.getText(I18nProxy.getKeyId("ui.wrongAlignment"));
                     break;
                  case FighterRefusedReasonEnum.WRONG_GUILD:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.wrongGuild"));
                     break;
                  case FighterRefusedReasonEnum.TOO_LATE:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.tooLate"));
                     break;
                  case FighterRefusedReasonEnum.MUTANT_REFUSED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.mutantRefused"));
                     break;
                  case FighterRefusedReasonEnum.WRONG_MAP:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.wrongMap"));
                     break;
                  case FighterRefusedReasonEnum.JUST_RESPAWNED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.justRespawned"));
                     break;
                  case FighterRefusedReasonEnum.IM_OCCUPIED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.imOccupied"));
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_OCCUPIED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.opponentOccupied"));
                     break;
                  case FighterRefusedReasonEnum.MULTIACCOUNT_NOT_ALLOWED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.onlyOneAllowedAccount"));
                     break;
                  case FighterRefusedReasonEnum.INSUFFICIENT_RIGHTS:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.insufficientRights"));
                     break;
                  case FighterRefusedReasonEnum.MEMBER_ACCOUNT_NEEDED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.memberAccountNeeded"));
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_NOT_MEMBER:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.opponentNotMember"));
                     break;
                  case FighterRefusedReasonEnum.TEAM_LIMITED_BY_MAINCHARACTER:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.teamLimitedByMainCharacter"));
                     break;
                  case FighterRefusedReasonEnum.GHOST_REFUSED:
                     message = I18n.getText(I18nProxy.getKeyId("ui.fight.ghostRefused"));
                     break;
                  default:
                     return true;
               }
               if(message != null)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,message,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               }
               return true;
            case msg is ValidateSpellForgetAction:
               vsfa = msg as ValidateSpellForgetAction;
               vsfmsg = new ValidateSpellForgetMessage();
               vsfmsg.initValidateSpellForgetMessage(vsfa.spellId);
               _log.debug("ValidateSpellForgetAction " + vsfa.spellId);
               ConnectionsHandler.getConnection().send(vsfmsg);
               return true;
            case msg is SpellForgottenMessage:
               sfmsg = msg as SpellForgottenMessage;
               _log.debug("SpellForgottenMessage " + sfmsg.boostPoint + "   " + sfmsg.spellsId);
               return true;
            case msg is ExchangeCraftResultMessage:
               ecrmsg = msg as ExchangeCraftResultMessage;
               messageId = ecrmsg.getMessageId();
               if(messageId != ExchangeCraftInformationObjectMessage.protocolId)
               {
                  return false;
               }
               eciomsg = msg as ExchangeCraftInformationObjectMessage;
               switch(eciomsg.craftResult)
               {
                  case CraftResultEnum.CRAFT_SUCCESS:
                  case CraftResultEnum.CRAFT_FAILED:
                     item = Item.getItemById(eciomsg.objectGenericId);
                     iconId = item.iconId;
                     csi = new CraftSmileyItem(eciomsg.playerId,iconId,eciomsg.craftResult);
                     break;
                  case CraftResultEnum.CRAFT_IMPOSSIBLE:
                     csi = new CraftSmileyItem(eciomsg.playerId,-1,eciomsg.craftResult);
               }
               if(DofusEntities.getEntity(eciomsg.playerId) as IDisplayable)
               {
                  absBounds = (DofusEntities.getEntity(eciomsg.playerId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(csi,absBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + eciomsg.playerId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               }
               return true;
            case msg is DocumentReadingBeginMessage:
               drbm = msg as DocumentReadingBeginMessage;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.DocumentReadingBegin,drbm.documentId);
               return true;
            case msg is PaddockPropertiesMessage:
               this._currentPaddock = PaddockPropertiesMessage(msg).properties;
               break;
            case msg is GameRolePlaySpellAnimMessage:
               grpsamsg = msg as GameRolePlaySpellAnimMessage;
               spellLuncher = new RoleplaySpellCastProvider();
               spellLuncher.castingSpell.casterId = PlayedCharacterManager.getInstance().id;
               spellLuncher.castingSpell.spell = Spell.getSpellById(grpsamsg.spellId);
               spellLuncher.castingSpell.spellRank = spellLuncher.castingSpell.spell.getSpellLevel(grpsamsg.spellLevel);
               spellLuncher.castingSpell.targetedCell = MapPoint.fromCellId(grpsamsg.targetCellId);
               scriptUri = new Uri(XmlConfig.getInstance().getEntry("config.script.spellFx") + spellLuncher.castingSpell.spell.scriptId + ".dx");
               scriptRunner = new SpellFxRunner(spellLuncher);
               ScriptExec.exec(scriptUri,scriptRunner,false,new Callback(this.executeSpellBuffer,null,true,true,spellLuncher),new Callback(this.executeSpellBuffer,null,true,false,spellLuncher));
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         var prismFrame:PrismFrame = Kernel.getWorker().getFrame(PrismFrame) as PrismFrame;
         prismFrame.pullRoleplay();
         Kernel.getWorker().removeFrame(this._entitiesFrame);
         this._worldFrame.destroy();
         Kernel.getWorker().removeFrame(this._worldFrame);
         Kernel.getWorker().removeFrame(this._movementFrame);
         Kernel.getWorker().removeFrame(this._interactivesFrame);
         return true;
      }
      
      public function getActorName(actorId:int) : String
      {
         var actorInfos:GameRolePlayActorInformations = null;
         var tcInfos:GameRolePlayTaxCollectorInformations = null;
         actorInfos = this.getActorInfos(actorId);
         if(!actorInfos)
         {
            return "Unknown Actor";
         }
         switch(true)
         {
            case actorInfos is GameRolePlayNamedActorInformations:
               return (actorInfos as GameRolePlayNamedActorInformations).name;
            case actorInfos is GameRolePlayTaxCollectorInformations:
               tcInfos = actorInfos as GameRolePlayTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(tcInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(tcInfos.lastNameId).name;
            case actorInfos is GameRolePlayNpcInformations:
               return Npc.getNpcById((actorInfos as GameRolePlayNpcInformations).npcId).name;
            case actorInfos is GameRolePlayGroupMonsterInformations:
            case actorInfos is GameRolePlayPrismInformations:
               _log.error("Fail: getActorName called with an actorId corresponding to a monsters group or a prism (" + actorInfos + ").");
               return "<error: cannot get a name>";
            default:
               return "Unknown Actor Type";
         }
      }
      
      private function getActorInfos(actorId:int) : GameRolePlayActorInformations
      {
         return this.entitiesFrame.getEntityInfos(actorId) as GameRolePlayActorInformations;
      }
      
      private function executeSpellBuffer(callback:Function, hadScript:Boolean, scriptSuccess:Boolean = false, castProvider:RoleplaySpellCastProvider = null) : void
      {
         var step:ISequencable = null;
         var ss:SerialSequencer = new SerialSequencer();
         for each(step in castProvider.stepsBuffer)
         {
            ss.addStep(step);
         }
         ss.start();
      }
      
      private function addCraftFrame() : void
      {
         if(!Kernel.getWorker().contains(CraftFrame))
         {
            Kernel.getWorker().addFrame(this._craftFrame);
         }
         if(!Kernel.getWorker().contains(ExchangeManagementFrame))
         {
            Kernel.getWorker().addFrame(this._exchangeManagementFrame);
         }
      }
      
      private function addCommonExchangeFrame(pExchangeType:uint) : void
      {
         if(!Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            this._commonExchangeFrame = new CommonExchangeManagementFrame(this,pExchangeType);
            Kernel.getWorker().addFrame(this._commonExchangeFrame);
         }
      }
      
      private function onListenOrientation(e:MouseEvent) : void
      {
         var difY:Number = StageShareManager.mouseY - this._playerEntity.y;
         var difX:Number = StageShareManager.mouseX - this._playerEntity.x;
         var orientation:uint = AngleToOrientation.angleToOrientation(Math.atan2(difY,difX));
         var animation:String = this._playerEntity.getAnimation();
         if(animation.indexOf("AnimStatique") != -1 || Boolean(Emoticon.getEmoticonById(this._entitiesFrame.currentEmoticon).eight_directions))
         {
            this._playerEntity.setDirection(orientation);
         }
         else if(orientation % 2 == 0)
         {
            this._playerEntity.setDirection(orientation + 1);
         }
         else
         {
            this._playerEntity.setDirection(orientation);
         }
      }
      
      private function onClickOrientation(e:MouseEvent) : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
         StageShareManager.stage.removeEventListener(MouseEvent.CLICK,this.onClickOrientation);
         var animation:String = this._playerEntity.getAnimation();
         var gmcormsg:GameMapChangeOrientationRequestMessage = new GameMapChangeOrientationRequestMessage();
         gmcormsg.initGameMapChangeOrientationRequestMessage(this._playerEntity.getDirection());
         ConnectionsHandler.getConnection().send(gmcormsg);
      }
      
      public function getMulitCraftSkills(pPlayerId:uint) : Vector.<uint>
      {
         var mcefp:MultiCraftEnableForPlayer = null;
         for each(mcefp in this._playersMultiCraftSkill)
         {
            if(mcefp.playerId == pPlayerId)
            {
               return mcefp.skills;
            }
         }
         return null;
      }
   }
}

class MultiCraftEnableForPlayer
{
    
   public var playerId:uint;
   
   public var skills:Vector.<uint>;
   
   function MultiCraftEnableForPlayer()
   {
      super();
   }
}
