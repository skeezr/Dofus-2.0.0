package com.ankamagames.dofus.logic.game.approach.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.logic.common.frames.LoadingModuleFrame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedSuccessMessage;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketAcceptedMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterCreationAction;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterCreationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterCreationResultMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterDeletionAction;
   import com.ankamagames.dofus.network.messages.game.character.deletion.CharacterDeletionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.deletion.CharacterDeletionErrorMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterNameSuggestionRequestAction;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionFailureMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayWithRecolorRequestAction;
   import com.ankamagames.dofus.network.messages.game.character.replay.CharacterReplayWithRecolorRequestMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayWithRenameRequestAction;
   import com.ankamagames.dofus.network.messages.game.character.replay.CharacterReplayWithRenameRequestMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterRecolorSelectionAction;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectionWithRecolorMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterRenameSelectionAction;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectionWithRenameMessage;
   import com.ankamagames.dofus.network.messages.security.ClientKeyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateRequestMessage;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicTimeMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListWithModificationsMessage;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterToRecolorInformation;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterHardcoreInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsExecuteMessage;
   import com.ankamagames.dofus.network.messages.game.character.replay.CharacterReplayRequestMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterSelectionAction;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterFirstSelectionMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectionMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsListMessage;
   import com.ankamagames.dofus.network.types.game.startup.StartupActionAddObject;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.approach.actions.GiftAssignRequestAction;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsObjetAttributionMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionFinishedMessage;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.lists.HookList;
   import flash.utils.setTimeout;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.utils.crypto.MD5;
   import com.ankamagames.dofus.network.enums.CharacterDeletionErrorEnum;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceReadyMessage;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.frames.AlignmentFrame;
   import com.ankamagames.dofus.logic.game.common.frames.LivingObjectFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PrismFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ContextChangeFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonUiFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HouseFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.dofus.network.messages.game.approach.HelloGameMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListErrorMessage;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.jerakine.messages.ConnectionResumedMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListRequestMessage;
   
   public class GameServerApproachFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GameServerApproachFrame));
       
      private var _charactersList:Array;
      
      private var _charactersToRecolorList:Array;
      
      private var _charactersToRenameList:Array;
      
      private var _giftList:Array;
      
      private var _kernel:KernelEventsManager;
      
      private var _gmaf:LoadingModuleFrame;
      
      private var _waitingMessages:Vector.<Message>;
      
      private var _cssmsg:CharacterSelectedSuccessMessage;
      
      private var _requestedCharacterId:uint;
      
      private var commonMod:Object;
      
      public function GameServerApproachFrame()
      {
         this._charactersList = new Array();
         this._charactersToRecolorList = new Array();
         this._charactersToRenameList = new Array();
         this._giftList = new Array();
         this._kernel = KernelEventsManager.getInstance();
         this.commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var perso:* = undefined;
         var atmsg:AuthenticationTicketMessage = null;
         var atamsg:AuthenticationTicketAcceptedMessage = null;
         var clmsg:CharactersListMessage = null;
         var o:Object = null;
         var cca:CharacterCreationAction = null;
         var ccmsg:CharacterCreationRequestMessage = null;
         var colors:Vector.<int> = null;
         var ccrmsg:CharacterCreationResultMessage = null;
         var cda:CharacterDeletionAction = null;
         var cdrmsg:CharacterDeletionRequestMessage = null;
         var cdemsg:CharacterDeletionErrorMessage = null;
         var reason:String = null;
         var cnsra:CharacterNameSuggestionRequestAction = null;
         var cnsrmsg:CharacterNameSuggestionRequestMessage = null;
         var cnssmsg:CharacterNameSuggestionSuccessMessage = null;
         var cnsfmsg:CharacterNameSuggestionFailureMessage = null;
         var crra:CharacterReplayRequestAction = null;
         var characterId:uint = 0;
         var crwrra:CharacterReplayWithRecolorRequestAction = null;
         var recolors:Vector.<int> = null;
         var crwrrmsg:CharacterReplayWithRecolorRequestMessage = null;
         var crwrnra:CharacterReplayWithRenameRequestAction = null;
         var crwrnrmsg:CharacterReplayWithRenameRequestMessage = null;
         var crsa:CharacterRecolorSelectionAction = null;
         var cswrmsg:CharacterSelectionWithRecolorMessage = null;
         var crnsa:CharacterRenameSelectionAction = null;
         var cswrnmsg:CharacterSelectionWithRenameMessage = null;
         var cssmsg:CharacterSelectedSuccessMessage = null;
         var flashKeyMsg:ClientKeyMessage = null;
         var gccrmsg:GameContextCreateRequestMessage = null;
         var soundApi:SoundApi = null;
         var csemsg:CharacterSelectedErrorMessage = null;
         var btmsg:BasicTimeMessage = null;
         var date:Date = null;
         var clwrmsg:CharactersListWithModificationsMessage = null;
         var ctri:CharacterToRecolorInformation = null;
         var ctrid:uint = 0;
         var chi:CharacterHardcoreInformations = null;
         var cbi:CharacterBaseInformations = null;
         var saem:StartupActionsExecuteMessage = null;
         var c:* = undefined;
         var charToColor2:Object = null;
         var charToRename:Object = null;
         var crrmsg:CharacterReplayRequestMessage = null;
         var color:* = undefined;
         var charToColor:* = undefined;
         var charToRename2:Object = null;
         var csa:CharacterSelectionAction = null;
         var firstSelection:Boolean = false;
         var cfsmsg:CharacterFirstSelectionMessage = null;
         var csmsg:CharacterSelectionMessage = null;
         var salm:StartupActionsListMessage = null;
         var gift:StartupActionAddObject = null;
         var _pUri:Uri = null;
         var _descUri:Uri = null;
         var _items:Array = null;
         var item:Object = null;
         var oj:Object = null;
         var iw:ItemWrapper = null;
         var gar:GiftAssignRequestAction = null;
         var sao:StartupActionsObjetAttributionMessage = null;
         var safm:StartupActionFinishedMessage = null;
         switch(true)
         {
            case msg is HelloGameMessage:
               atmsg = new AuthenticationTicketMessage();
               atmsg.initAuthenticationTicketMessage(AuthentificationManager.getInstance().gameServerTicket,LangManager.getInstance().getEntry("config.lang.current"));
               ConnectionsHandler.getConnection().send(atmsg);
               this._kernel.processCallback(HookList.AuthenticationTicket);
               return true;
            case msg is AuthenticationTicketAcceptedMessage:
               atamsg = msg as AuthenticationTicketAcceptedMessage;
               setTimeout(this.requestCharactersList,500);
               this._kernel.processCallback(HookList.ConnectionStart);
               return true;
            case msg is CharactersListMessage:
               clmsg = msg as CharactersListMessage;
               if(msg is CharactersListWithModificationsMessage)
               {
                  clwrmsg = msg as CharactersListWithModificationsMessage;
                  for each(ctri in clwrmsg.charactersToRecolor)
                  {
                     this._charactersToRecolorList[ctri.id] = {
                        "id":ctri.id,
                        "colors":ctri.colors
                     };
                  }
                  for each(ctrid in clwrmsg.charactersToRename)
                  {
                     this._charactersToRenameList.push(ctrid);
                  }
               }
               this._charactersList = new Array();
               if(PlayerManager.getInstance().server.gameTypeId == 1)
               {
                  for each(chi in clmsg.characters)
                  {
                     o = {
                        "id":chi.id,
                        "name":chi.name,
                        "level":chi.level,
                        "entityLook":EntityLookAdapter.fromNetwork(chi.entityLook),
                        "breed":chi.breed,
                        "sex":chi.sex,
                        "deathState":chi.deathState,
                        "deathCount":chi.deathCount
                     };
                     _log.debug(" - [" + chi.id + "] " + chi.name + " (Lv " + chi.level + ") - " + o.entityLook);
                     this._charactersList.push(o);
                  }
               }
               else
               {
                  for each(cbi in clmsg.characters)
                  {
                     o = {
                        "id":cbi.id,
                        "name":cbi.name,
                        "level":cbi.level,
                        "entityLook":EntityLookAdapter.fromNetwork(cbi.entityLook),
                        "breed":cbi.breed,
                        "sex":cbi.sex
                     };
                     _log.debug(" - [" + cbi.id + "] " + cbi.name + " (Lv " + cbi.level + ") - " + o.entityLook);
                     this._charactersList.push(o);
                  }
               }
               this._kernel.processCallback(HookList.TutorielAvailable,clmsg.tutorielAvailable);
               if(this._charactersList.length)
               {
                  if(clmsg.hasStartupActions)
                  {
                     saem = new StartupActionsExecuteMessage();
                     saem.initStartupActionsExecuteMessage();
                     ConnectionsHandler.getConnection().send(saem);
                  }
                  else if(!Berilia.getInstance().getUi("characterSelection"))
                  {
                     this._kernel.processCallback(HookList.CharacterSelectionStart,this._charactersList);
                  }
                  else
                  {
                     this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
                  }
               }
               else
               {
                  this._kernel.processCallback(HookList.CharacterCreationStart);
                  this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
               }
               return true;
            case msg is CharactersListErrorMessage:
               _log.error("Characters list error.");
               this.commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.common.error")),I18n.getText(I18nProxy.getKeyId("ui.connexion.charactersListError")),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               return false;
            case msg is CharacterCreationAction:
               cca = msg as CharacterCreationAction;
               ccmsg = new CharacterCreationRequestMessage();
               colors = new Vector.<int>();
               for each(c in cca.colors)
               {
                  colors.push(c);
               }
               while(colors.length < 6)
               {
                  colors.push(-1);
               }
               ccmsg.initCharacterCreationRequestMessage(cca.name,cca.breed,cca.sex,colors);
               ConnectionsHandler.getConnection().send(ccmsg);
               return true;
            case msg is CharacterCreationResultMessage:
               ccrmsg = msg as CharacterCreationResultMessage;
               this._kernel.processCallback(HookList.CharacterCreationResult,ccrmsg.result);
               return true;
            case msg is CharacterDeletionAction:
               cda = msg as CharacterDeletionAction;
               cdrmsg = new CharacterDeletionRequestMessage();
               cdrmsg.initCharacterDeletionRequestMessage(cda.id,MD5.hex_md5(cda.id + "~" + cda.answer));
               ConnectionsHandler.getConnection().send(cdrmsg);
               return true;
            case msg is CharacterDeletionErrorMessage:
               cdemsg = msg as CharacterDeletionErrorMessage;
               reason = "";
               if(cdemsg.reason == CharacterDeletionErrorEnum.DEL_ERR_TOO_MANY_CHAR_DELETION)
               {
                  reason = "TooManyDeletion";
               }
               if(cdemsg.reason == CharacterDeletionErrorEnum.DEL_ERR_BAD_SECRET_ANSWER)
               {
                  reason = "WrongAnswer";
               }
               this._kernel.processCallback(HookList.CharacterDeletionError,reason);
               return true;
            case msg is CharacterNameSuggestionRequestAction:
               cnsra = msg as CharacterNameSuggestionRequestAction;
               cnsrmsg = new CharacterNameSuggestionRequestMessage();
               cnsrmsg.initCharacterNameSuggestionRequestMessage();
               ConnectionsHandler.getConnection().send(cnsrmsg);
               return true;
            case msg is CharacterNameSuggestionSuccessMessage:
               cnssmsg = msg as CharacterNameSuggestionSuccessMessage;
               this._kernel.processCallback(HookList.CharacterNameSuggestioned,cnssmsg.suggestion);
               return true;
            case msg is CharacterNameSuggestionFailureMessage:
               cnsfmsg = msg as CharacterNameSuggestionFailureMessage;
               _log.error("Generation de nom impossible !");
               return true;
            case msg is CharacterReplayRequestAction:
               crra = msg as CharacterReplayRequestAction;
               characterId = crra.characterId;
               _log.debug("perso selectionné " + characterId);
               if(this._charactersToRecolorList[characterId])
               {
                  for each(perso in this._charactersList)
                  {
                     if(perso.id == characterId)
                     {
                        charToColor2 = perso;
                     }
                  }
                  this._kernel.processCallback(HookList.CharacterCreationStart,new Array("recolor",charToColor2,this._charactersToRecolorList[characterId].colors));
               }
               else if(this._charactersToRenameList.indexOf(characterId) != -1)
               {
                  for each(perso in this._charactersList)
                  {
                     if(perso.id == characterId)
                     {
                        charToRename = perso;
                     }
                  }
                  this._kernel.processCallback(HookList.CharacterCreationStart,new Array("rename",charToRename));
               }
               else
               {
                  crrmsg = new CharacterReplayRequestMessage();
                  crrmsg.initCharacterReplayRequestMessage(characterId);
                  ConnectionsHandler.pause();
                  this._gmaf = new LoadingModuleFrame();
                  Kernel.getWorker().addFrame(this._gmaf);
                  UiModuleManager.getInstance().reset();
                  UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE,false);
                  ConnectionsHandler.getConnection().send(crrmsg);
               }
               return true;
            case msg is CharacterReplayWithRecolorRequestAction:
               crwrra = msg as CharacterReplayWithRecolorRequestAction;
               characterId = crwrra.characterId;
               recolors = new Vector.<int>();
               for each(color in crwrra.characterColors)
               {
                  recolors.push(color);
               }
               crwrrmsg = new CharacterReplayWithRecolorRequestMessage();
               crwrrmsg.initCharacterReplayWithRecolorRequestMessage(characterId,recolors);
               ConnectionsHandler.pause();
               this._gmaf = new LoadingModuleFrame();
               Kernel.getWorker().addFrame(this._gmaf);
               UiModuleManager.getInstance().reset();
               UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE,false);
               ConnectionsHandler.getConnection().send(crwrrmsg);
               return true;
            case msg is CharacterReplayWithRenameRequestAction:
               crwrnra = msg as CharacterReplayWithRenameRequestAction;
               crwrnrmsg = new CharacterReplayWithRenameRequestMessage();
               crwrnrmsg.initCharacterReplayWithRenameRequestMessage(crwrnra.characterId,crwrnra.characterName);
               ConnectionsHandler.pause();
               this._gmaf = new LoadingModuleFrame();
               Kernel.getWorker().addFrame(this._gmaf);
               UiModuleManager.getInstance().reset();
               UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE,false);
               ConnectionsHandler.getConnection().send(crwrnrmsg);
               return true;
            case msg is CharacterSelectedForceMessage:
               Kernel.beingInReconection = true;
               characterId = CharacterSelectedForceMessage(msg).id;
               _log.debug("perso selectionné de force " + characterId);
               ConnectionsHandler.getConnection().send(new CharacterSelectedForceReadyMessage());
               return true;
            case msg is CharacterSelectionAction:
               characterId = msg is CharacterSelectionAction?uint(CharacterSelectionAction(msg).characterId):uint(CharacterSelectedForceMessage(msg).id);
               this._requestedCharacterId = characterId;
               _log.debug("perso selectionné " + characterId);
               if(this._charactersToRecolorList[characterId])
               {
                  for each(perso in this._charactersList)
                  {
                     if(perso.id == characterId)
                     {
                        charToColor = perso;
                     }
                  }
                  this._kernel.processCallback(HookList.CharacterCreationStart,new Array("recolor",charToColor,this._charactersToRecolorList[characterId].colors));
               }
               else if(this._charactersToRenameList.indexOf(characterId) != -1)
               {
                  for each(perso in this._charactersList)
                  {
                     if(perso.id == characterId)
                     {
                        charToRename2 = perso;
                     }
                  }
                  this._kernel.processCallback(HookList.CharacterCreationStart,new Array("rename",charToRename2));
               }
               else
               {
                  csa = msg as CharacterSelectionAction;
                  firstSelection = Boolean(csa) && Boolean(csa.btutoriel);
                  if(firstSelection)
                  {
                     cfsmsg = new CharacterFirstSelectionMessage();
                     cfsmsg.initCharacterFirstSelectionMessage(characterId,true);
                  }
                  else
                  {
                     csmsg = new CharacterSelectionMessage();
                     if(msg is CharacterSelectionAction)
                     {
                        csmsg.initCharacterSelectionMessage(characterId);
                     }
                  }
                  if(firstSelection)
                  {
                     ConnectionsHandler.getConnection().send(cfsmsg);
                  }
                  else if(msg is CharacterSelectionAction)
                  {
                     ConnectionsHandler.getConnection().send(csmsg);
                  }
               }
               return true;
            case msg is CharacterRecolorSelectionAction:
               crsa = msg as CharacterRecolorSelectionAction;
               _log.debug("perso selectionné " + crsa.characterId);
               recolors = new Vector.<int>();
               for each(color in crsa.characterColors)
               {
                  recolors.push(color);
               }
               cswrmsg = new CharacterSelectionWithRecolorMessage();
               cswrmsg.initCharacterSelectionWithRecolorMessage(crsa.characterId,recolors);
               ConnectionsHandler.getConnection().send(cswrmsg);
               return true;
            case msg is CharacterRenameSelectionAction:
               crnsa = msg as CharacterRenameSelectionAction;
               _log.debug("perso selectionné " + crnsa.characterId);
               cswrnmsg = new CharacterSelectionWithRenameMessage();
               cswrnmsg.initCharacterSelectionWithRenameMessage(crnsa.characterId,crnsa.characterName);
               ConnectionsHandler.getConnection().send(cswrnmsg);
               return true;
            case msg is CharacterSelectedSuccessMessage:
               cssmsg = msg as CharacterSelectedSuccessMessage;
               Berilia.getInstance().unloadUi("CharacterHeader");
               Berilia.getInstance().unloadUi("characterSelection");
               Berilia.getInstance().unloadUi("characterCreation");
               Berilia.getInstance().unloadUi("tutorialSelection");
               Berilia.getInstance().unloadUi("giftMenu");
               ConnectionsHandler.pause();
               if(this._gmaf == null)
               {
                  this._gmaf = new LoadingModuleFrame();
                  Kernel.getWorker().addFrame(this._gmaf);
               }
               PlayedCharacterManager.getInstance().infos = cssmsg.infos;
               Kernel.getWorker().pauseNetworkProcess();
               this._cssmsg = cssmsg;
               UiModuleManager.getInstance().reset();
               UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE,false);
               return true;
            case msg is AllModulesLoadedMessage:
               Kernel.getWorker().removeFrame(this._gmaf);
               Kernel.getWorker().addFrame(new AlignmentFrame());
               Kernel.getWorker().addFrame(new LivingObjectFrame());
               Kernel.getWorker().addFrame(new PrismFrame());
               Kernel.getWorker().addFrame(new PlayedCharacterUpdatesFrame());
               Kernel.getWorker().addFrame(new SocialFrame());
               Kernel.getWorker().addFrame(new SpellInventoryManagementFrame());
               Kernel.getWorker().addFrame(new InventoryManagementFrame());
               Kernel.getWorker().addFrame(new ContextChangeFrame());
               Kernel.getWorker().addFrame(new CommonUiFrame());
               Kernel.getWorker().addFrame(new ChatFrame());
               Kernel.getWorker().addFrame(new JobsFrame());
               Kernel.getWorker().addFrame(new MountFrame());
               Kernel.getWorker().addFrame(new HouseFrame());
               Kernel.getWorker().addFrame(new RoleplayEmoticonFrame(Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame));
               Kernel.getWorker().addFrame(new QuestFrame());
               Kernel.getWorker().resumeNetworkProcess();
               ConnectionsHandler.resume();
               if(Kernel.beingInReconection)
               {
                  ConnectionsHandler.getConnection().send(new CharacterSelectedForceReadyMessage());
               }
               flashKeyMsg = new ClientKeyMessage();
               flashKeyMsg.initClientKeyMessage(InterClientManager.getInstance().flashKey);
               ConnectionsHandler.getConnection().send(flashKeyMsg);
               _log.debug("masquage header frame");
               Berilia.getInstance().unloadUi("CharacterHeader");
               Berilia.getInstance().unloadUi("characterSelection");
               Berilia.getInstance().unloadUi("characterCreation");
               Berilia.getInstance().unloadUi("tutorialSelection");
               Berilia.getInstance().unloadUi("giftMenu");
               if(this._cssmsg != null)
               {
                  PlayedCharacterManager.getInstance().infos = this._cssmsg.infos;
                  _log.warn("Character selected : " + this._cssmsg.infos.name + " (Lv " + this._cssmsg.infos.level + ")");
               }
               Kernel.getWorker().removeFrame(this);
               this._kernel.processCallback(HookList.GameStart);
               gccrmsg = new GameContextCreateRequestMessage();
               ConnectionsHandler.getConnection().send(gccrmsg);
               soundApi = new SoundApi();
               soundApi.stopIntroMusic();
               return true;
            case msg is ConnectionResumedMessage:
               return true;
            case msg is CharacterSelectedErrorMessage:
               csemsg = msg as CharacterSelectedErrorMessage;
               _log.error("Impossible de selectionner ce personnage");
               this._kernel.processCallback(HookList.CharacterImpossibleSelection,this._requestedCharacterId);
               return true;
            case msg is BasicTimeMessage:
               btmsg = msg as BasicTimeMessage;
               date = new Date();
               TimeManager.getInstance().serverTimeLag = (btmsg.timestamp + btmsg.timezoneOffset) * 1000 - date.getTime();
               TimeManager.getInstance().timezoneOffset = btmsg.timezoneOffset * 1000;
               TimeManager.getInstance().dofusTimeYearLag = -1370;
               return true;
            case msg is StartupActionsListMessage:
               salm = msg as StartupActionsListMessage;
               for each(gift in salm.actions)
               {
                  _pUri = new Uri(XmlConfig.getInstance().getEntry("config.gift.assets") + gift.pictureUrl);
                  _descUri = new Uri(XmlConfig.getInstance().getEntry("config.gift.assets") + gift.descUrl);
                  _items = new Array();
                  for each(item in gift.items)
                  {
                     iw = ItemWrapper.create(0,0,item.objectGID,1,item.effects,false);
                     _items.push(iw);
                  }
                  oj = {
                     "uid":gift.uid,
                     "title":gift.title,
                     "text":gift.text,
                     "descUrl":_descUri,
                     "pictureUrl":_pUri,
                     "items":_items
                  };
                  this._giftList.push(oj);
               }
               if(this._giftList.length)
               {
                  this._kernel.processCallback(HookList.GiftList,this._giftList,this._charactersList);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this);
                  _log.error("Empty Gift List Received");
               }
               return true;
            case msg is GiftAssignRequestAction:
               gar = msg as GiftAssignRequestAction;
               if(gar.characterId == 0 && gar.giftId == this._giftList[0].uid)
               {
                  if(!Berilia.getInstance().getUi("characterSelection"))
                  {
                     this._kernel.processCallback(HookList.CharacterSelectionStart,this._charactersList);
                  }
               }
               sao = new StartupActionsObjetAttributionMessage();
               sao.initStartupActionsObjetAttributionMessage(gar.giftId,gar.characterId);
               ConnectionsHandler.getConnection().send(sao);
               return true;
            case msg is StartupActionFinishedMessage:
               safm = msg as StartupActionFinishedMessage;
               KernelEventsManager.getInstance().processCallback(HookList.GiftAssigned,safm.actionId);
               if(safm.actionId == this._giftList[0].uid)
               {
                  if(!Berilia.getInstance().getUi("characterSelection"))
                  {
                     this._kernel.processCallback(HookList.CharacterSelectionStart,this._charactersList);
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function requestCharactersList() : void
      {
         var clrmsg:CharactersListRequestMessage = new CharactersListRequestMessage();
         ConnectionsHandler.getConnection().send(clrmsg);
      }
   }
}
