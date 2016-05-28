package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.misc.utils.LoadingScreen;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.ApiActionList;
   import com.ankamagames.dofus.misc.lists.ApiChatActionList;
   import com.ankamagames.dofus.misc.lists.ApiCraftActionList;
   import com.ankamagames.dofus.misc.lists.ApiSocialActionList;
   import com.ankamagames.dofus.misc.lists.ApiRolePlayActionList;
   import com.ankamagames.dofus.misc.lists.ApiExchangeActionList;
   import com.ankamagames.dofus.misc.lists.ApiMountActionList;
   import com.ankamagames.dofus.misc.lists.ApiLivingObjectActionList;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.DateApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.TestApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofus.uiApi.ExchangeApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.datacenter.communication.SmileyItem;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.internalDatacenter.communication.ThinkBubble;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantWithGuildInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.datacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMountInformations;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockBuyableInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockAbandonnedInformations;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockPrivateInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.FighterTooltipInformation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSpellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowEntityManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowRecipeManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowPlayerMenuManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkMapPosition;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSendHookManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.LangFileLoadedMessage;
   import com.ankamagames.jerakine.messages.LangAllFilesLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.PanicMessages;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.ClassicSoundManager;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.jerakine.data.I18nUpdater;
   import flash.events.Event;
   import com.ankamagames.jerakine.types.events.FileEvent;
   import com.ankamagames.jerakine.types.events.LangFileEvent;
   import com.ankamagames.jerakine.data.GameDataUpdater;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleExecErrorMessage;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.managers.EmbedFontManager;
   import com.ankamagames.dofus.logic.common.frames.QueueFrame;
   import com.ankamagames.dofus.logic.game.common.frames.DebugFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.dofus.misc.I18nProxyConfig;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   
   public class InitializationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InitializationFrame));
       
      private var _aFiles:Array;
      
      private var _aLoadedFiles:Array;
      
      private var _aModuleInit:Array;
      
      private var _loadingScreen:LoadingScreen;
      
      private var _percentPerModule:Number = 0;
      
      private var _modPercents:Array;
      
      public function InitializationFrame()
      {
         this._modPercents = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         var foo:Boolean = false;
         this._aModuleInit = new Array();
         this._aModuleInit["config"] = false;
         this._aModuleInit["langFiles"] = false;
         this._aModuleInit["font"] = false;
         this._aModuleInit["i18n"] = false;
         this._aModuleInit["gameData"] = false;
         this._aModuleInit["modules"] = false;
         this._aModuleInit["uiXmlParsing"] = false;
         for each(foo in this._aModuleInit)
         {
            this._percentPerModule++;
         }
         this._percentPerModule = 100 / this._percentPerModule;
         LangManager.getInstance().loadFile("config.xml");
         HookList.AuthenticationTicket;
         TriggerHookList.CreaturesMode;
         CraftHookList.DoNothing;
         ApiActionList.AuthorizedCommand;
         ApiChatActionList.ChannelEnabling;
         ApiCraftActionList.JobCrafterDirectoryDefineSettings;
         ApiSocialActionList.FriendsListRequest;
         ApiRolePlayActionList.PlayerFightFriendlyAnswer;
         ApiExchangeActionList.DoNothing;
         ApiMountActionList.MountFeedRequest;
         ApiLivingObjectActionList.LivingObjectChangeSkinRequest;
         ApiBinder.addApi("Ui",UiApi);
         ApiBinder.addApi("System",SystemApi);
         ApiBinder.addApi("Data",DataApi);
         ApiBinder.addApi("Time",DateApi);
         ApiBinder.addApi("Tooltip",TooltipApi);
         ApiBinder.addApi("ContextMenu",ContextMenuApi);
         ApiBinder.addApi("Test",TestApi);
         ApiBinder.addApi("Jobs",JobsApi);
         ApiBinder.addApi("Storage",StorageApi);
         ApiBinder.addApi("Util",UtilApi);
         ApiBinder.addApi("Exchange",ExchangeApi);
         ApiBinder.addApi("Config",ConfigApi);
         ApiBinder.addApi("Binds",BindsApi);
         ApiBinder.addApi("Chat",ChatApi);
         ApiBinder.addApi("Sound",SoundApi);
         ApiBinder.addApi("Fight",FightApi);
         ApiBinder.addApi("PlayedCharacter",PlayedCharacterApi);
         ApiBinder.addApi("Social",SocialApi);
         ApiBinder.addApi("Roleplay",RoleplayApi);
         ApiBinder.addApi("Map",MapApi);
         ApiBinder.addApi("Quest",QuestApi);
         ApiBinder.addApi("Alignment",AlignmentApi);
         ApiBinder.addApi("Inventory",InventoryApi);
         ApiBinder.addApi("Document",DocumentApi);
         ApiBinder.addApi("Mount",MountApi);
         ApiBinder.addApi("Party",PartyApi);
         ApiBinder.addApi("Highlight",HighlightApi);
         TooltipsFactory.registerAssoc(String,"text");
         TooltipsFactory.registerAssoc(SpellWrapper,"spell");
         TooltipsFactory.registerAssoc(ItemWrapper,"item");
         TooltipsFactory.registerAssoc(SmileyItem,"smiley");
         TooltipsFactory.registerAssoc(ChatBubble,"chatBubble");
         TooltipsFactory.registerAssoc(ThinkBubble,"thinkBubble");
         TooltipsFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
         TooltipsFactory.registerAssoc(GameRolePlayMutantInformations,"player");
         TooltipsFactory.registerAssoc(CharacterTooltipInformation,"player");
         TooltipsFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
         TooltipsFactory.registerAssoc(GameRolePlayGroupMonsterInformations,"monsterGroup");
         TooltipsFactory.registerAssoc(GameRolePlayMerchantInformations,"merchant");
         TooltipsFactory.registerAssoc(GameRolePlayMerchantWithGuildInformations,"merchant");
         TooltipsFactory.registerAssoc(GroundObject,"groundObject");
         TooltipsFactory.registerAssoc(TaxCollectorTooltipInformation,"taxCollector");
         TooltipsFactory.registerAssoc(GameFightTaxCollectorInformations,"fightTaxCollector");
         TooltipsFactory.registerAssoc(EffectsWrapper,"effects");
         TooltipsFactory.registerAssoc(EffectsListWrapper,"effectsList");
         TooltipsFactory.registerAssoc(Vector.<String>,"texturesList");
         TooltipsFactory.registerAssoc(CraftSmileyItem,"craftSmiley");
         TooltipsFactory.registerAssoc(GameRolePlayPrismInformations,"prism");
         TooltipsFactory.registerAssoc(Object,"mount");
         TooltipsFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
         TooltipsFactory.registerAssoc(GameRolePlayMountInformations,"paddockMount");
         TooltipsFactory.registerAssoc(ChallengeWrapper,"challenge");
         TooltipsFactory.registerAssoc(PaddockInformations,"paddock");
         TooltipsFactory.registerAssoc(PaddockBuyableInformations,"paddock");
         TooltipsFactory.registerAssoc(PaddockAbandonnedInformations,"paddock");
         TooltipsFactory.registerAssoc(PaddockPrivateInformations,"paddock");
         TooltipsFactory.registerAssoc(FighterTooltipInformation,"fighter");
         TooltipsFactory.registerAssoc(GameFightCharacterInformations,"playerFighter");
         TooltipsFactory.registerAssoc(GameFightMonsterInformations,"monsterFighter");
         TooltipsFactory.registerAssoc(HouseWrapper,"house");
         MenusFactory.registerAssoc(GameRolePlayMerchantInformations,"humanVendor");
         MenusFactory.registerAssoc(GameRolePlayMerchantWithGuildInformations,"humanVendor");
         MenusFactory.registerAssoc(ItemWrapper,"item");
         MenusFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
         MenusFactory.registerAssoc(GameRolePlayMutantInformations,"mutant");
         MenusFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
         MenusFactory.registerAssoc(GameRolePlayTaxCollectorInformations,"taxCollector");
         MenusFactory.registerAssoc(GameRolePlayPrismInformations,"prism");
         MenusFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
         MenusFactory.registerAssoc(String,"player");
         HyperlinkFactory.registerProtocol("ui",HyperlinkDisplayArrowManager.showArrow);
         HyperlinkFactory.registerProtocol("spell",HyperlinkSpellManager.showSpell,HyperlinkSpellManager.getSpellName);
         HyperlinkFactory.registerProtocol("cell",HyperlinkShowCellManager.showCell);
         HyperlinkFactory.registerProtocol("entity",HyperlinkShowEntityManager.showEntity);
         HyperlinkFactory.registerProtocol("recipe",HyperlinkShowRecipeManager.showRecipe,HyperlinkShowRecipeManager.getRecipeName);
         HyperlinkFactory.registerProtocol("player",HyperlinkShowPlayerMenuManager.showPlayerMenu,HyperlinkShowPlayerMenuManager.getPlayerName);
         HyperlinkFactory.registerProtocol("item",HyperlinkItemManager.showItem,HyperlinkItemManager.getItemName);
         HyperlinkFactory.registerProtocol("map",HyperlinkMapPosition.showPosition,HyperlinkMapPosition.getText);
         HyperlinkFactory.registerProtocol("chatitem",HyperlinkItemManager.showChatItem);
         HyperlinkFactory.registerProtocol("hook",HyperlinkSendHookManager.sendHook);
         HyperlinkFactory.registerProtocol("npc",HyperlinkShowNpcManager.showNpc);
         HyperlinkFactory.registerProtocol("monster",HyperlinkShowMonsterManager.showMonster);
         this._loadingScreen = new LoadingScreen();
         Dofus.getInstance().addChild(this._loadingScreen);
         FpsControler.Init();
         FPS.getInstance().watchSprite("Sprites dofus",StageShareManager.stage,false);
         FPS.getInstance().watchMouse("Sprites souris",StageShareManager.stage,false);
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var langMsg:LangFileLoadedMessage = null;
         var langAllMsg:LangAllFilesLoadedMessage = null;
         var mrlfm:ModuleRessourceLoadFailedMessage = null;
         var i:uint = 0;
         var lastLang:String = null;
         var resetLang:* = false;
         switch(true)
         {
            case msg is LangFileLoadedMessage:
               langMsg = LangFileLoadedMessage(msg);
               if(!langMsg.success)
               {
                  if(langMsg.file.indexOf("i18n") > -1)
                  {
                     this._loadingScreen.log("Unabled to load i18n file " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.I18N_LOADING_FAILED,[LangManager.getInstance().getEntry("config.lang.current")]);
                  }
                  else if(langMsg.file.indexOf("config") > -1)
                  {
                     this._loadingScreen.log("Unabled to load main config file : " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.CONFIG_LOADING_FAILED);
                  }
                  else
                  {
                     this._loadingScreen.log("Unabled to load  " + langMsg.file,LoadingScreen.ERROR);
                  }
               }
               if(this._loadingScreen)
               {
                  this._loadingScreen.log(langMsg.file + " loaded.",LoadingScreen.INFO);
               }
               break;
            case msg is LangAllFilesLoadedMessage:
               langAllMsg = LangAllFilesLoadedMessage(msg);
               switch(langAllMsg.file)
               {
                  case "file://config.xml":
                     if(!langAllMsg.success)
                     {
                        throw new BeriliaError("Impossible de charger " + langAllMsg.file);
                     }
                     Kernel.getInstance().postInit();
                     this._aFiles = new Array();
                     this._aLoadedFiles = new Array();
                     this._aFiles.push(LangManager.getInstance().getEntry("config.ui.asset.fontsList"));
                     for(i = 0; i < this._aFiles.length; i++)
                     {
                        FontManager.getInstance().loadFile(this._aFiles[i]);
                     }
                     this._aModuleInit["config"] = true;
                     this.setModulePercent("config",100);
                     this._loadingScreen.value = this._loadingScreen.value + this._percentPerModule;
                     KernelEventsManager.getInstance().processCallback(HookList.ConfigStart);
                     if(SoundManager.getInstance().manager is ClassicSoundManager)
                     {
                        this.initTubul();
                     }
                     else
                     {
                        Berilia.getInstance().addUIListener(SoundManager.getInstance().manager);
                        TiphonEventsManager.addListener(SoundManager.getInstance().manager,"Sound");
                     }
                     this.checkInit();
                     break;
                  default:
                     this._aLoadedFiles.push(langAllMsg.file);
                     this._aModuleInit["langFiles"] = this._aLoadedFiles.length == this._aFiles.length;
                     if(this._aModuleInit["langFiles"])
                     {
                        this.setModulePercent("langFiles",100);
                        this.initFonts();
                        I18nUpdater.getInstance().addEventListener(Event.COMPLETE,this.onI18nReady);
                        I18nUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        I18nUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onI18nPartialDataReady);
                        GameDataUpdater.getInstance().addEventListener(Event.COMPLETE,this.onGameDataReady);
                        GameDataUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        GameDataUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onGameDataPartialDataReady);
                        lastLang = StoreDataManager.getInstance().getData(Constants.DATASTORE_COMPUTER_OPTIONS,"lastLang");
                        resetLang = lastLang != LangManager.getInstance().getEntry("config.lang.current");
                        if(resetLang)
                        {
                           UiRenderManager.getInstance().clearCache();
                        }
                        I18nUpdater.getInstance().init(new Uri(LangManager.getInstance().getEntry("config.data.path.i18n.list")),resetLang);
                        GameDataUpdater.getInstance().init(new Uri(LangManager.getInstance().getEntry("config.data.path.common.list")));
                     }
                     this.checkInit();
               }
               break;
            case msg is AllModulesLoadedMessage:
               this._aModuleInit["modules"] = true;
               this._loadingScreen.log("Launch main modules scripts",LoadingScreen.IMPORTANT);
               this.setModulePercent("modules",100);
               this.checkInit();
               break;
            case msg is ModuleLoadedMessage:
               this.setModulePercent("modules",this._percentPerModule * 1 / UiModuleManager.getInstance().moduleCount,true);
               this._loadingScreen.log(ModuleLoadedMessage(msg).moduleName + " script loaded",LoadingScreen.IMPORTANT);
               break;
            case msg is UiXmlParsedMessage:
               this._loadingScreen.log("Preparsing " + UiXmlParsedMessage(msg).url,LoadingScreen.INFO);
               this.setModulePercent("uiXmlParsing",this._percentPerModule * 1 / UiModuleManager.getInstance().unparsedXmlCount,true);
               break;
            case msg is AllUiXmlParsedMessage:
               this._aModuleInit["uiXmlParsing"] = true;
               this.setModulePercent("uiXmlParsing",100);
               this.checkInit();
               break;
            case msg is ModuleExecErrorMessage:
               this._loadingScreen.log("Error while executing " + ModuleExecErrorMessage(msg).moduleName + "\'s main script :\n" + ModuleExecErrorMessage(msg).stackTrace,LoadingScreen.ERROR);
               break;
            case msg is ModuleRessourceLoadFailedMessage:
               mrlfm = msg as ModuleRessourceLoadFailedMessage;
               this._loadingScreen.log("Module " + mrlfm.moduleName + " : Cannot load " + mrlfm.uri,!!mrlfm.isImportant?uint(LoadingScreen.ERROR):uint(LoadingScreen.WARNING));
         }
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._loadingScreen.parent.removeChild(this._loadingScreen);
         this._loadingScreen = null;
         EmbedFontManager.getInstance().removeEventListener(Event.COMPLETE,this.onFontsManagerInit);
         return true;
      }
      
      private function initTubul() : void
      {
      }
      
      private function checkInit() : void
      {
         var reste:uint = 0;
         var key:* = null;
         var start:Boolean = true;
         for(key in this._aModuleInit)
         {
            start = Boolean(start) && Boolean(this._aModuleInit[key]);
            if(!this._aModuleInit[key])
            {
               reste++;
            }
         }
         if(reste == 2)
         {
            UiModuleManager.getInstance().init(Constants.COMMON_GAME_MODULE.concat(Constants.PRE_GAME_MODULE),true);
         }
         if(start)
         {
            _log.info("Initialization frame end");
            Constants.EVENT_MODE = LangManager.getInstance().getEntry("config.eventMode") == "true";
            Constants.CHARACTER_CREATION_ALLOWED = LangManager.getInstance().getEntry("config.characterCreationAllowed") == "true";
            Kernel.getWorker().removeFrame(this);
            Kernel.getWorker().addFrame(new AuthentificationFrame());
            Kernel.getWorker().addFrame(new QueueFrame());
            Kernel.getWorker().addFrame(new DebugFrame());
         }
      }
      
      private function initFonts() : void
      {
         EmbedFontManager.getInstance().addEventListener(Event.COMPLETE,this.onFontsManagerInit);
         var fontList:Array = FontManager.getInstance().getFontsList();
         EmbedFontManager.getInstance().initialize(fontList);
      }
      
      private function setModulePercent(moduleName:String, prc:Number, add:Boolean = false) : void
      {
         var p:Number = NaN;
         var id:uint = 0;
         if(!this._modPercents[moduleName])
         {
            this._modPercents[moduleName] = 0;
         }
         if(add)
         {
            this._modPercents[moduleName] = this._modPercents[moduleName] + prc;
         }
         else
         {
            this._modPercents[moduleName] = prc;
         }
         var totalPrc:Number = 0;
         for each(p in this._modPercents)
         {
            totalPrc = totalPrc + p / 100 * this._percentPerModule;
         }
         id = Dofus.getInstance().instanceId;
         if(this._modPercents[moduleName] == 100)
         {
            this._loadingScreen.log(moduleName + " initialized",LoadingScreen.IMPORTANT);
         }
         this._loadingScreen.value = totalPrc;
      }
      
      private function onFontsManagerInit(e:Event) : void
      {
         this._aModuleInit["font"] = true;
         this.setModulePercent("font",100);
         this.checkInit();
      }
      
      private function onI18nReady(e:Event) : void
      {
         this._aModuleInit["i18n"] = true;
         this.setModulePercent("i18n",100);
         I18n.init();
         StoreDataManager.getInstance().setData(Constants.DATASTORE_COMPUTER_OPTIONS,"lastLang",LangManager.getInstance().getEntry("config.lang.current"));
         this.checkInit();
      }
      
      private function onGameDataReady(e:Event) : void
      {
         GameData.init();
         I18nProxyConfig.init();
         this._aModuleInit["gameData"] = true;
         this.setModulePercent("gameData",100);
         this.checkInit();
      }
      
      private function onGameDataPartialDataReady(e:LangFileEvent) : void
      {
         if(!this._loadingScreen)
         {
            this._loadingScreen = new LoadingScreen();
            Dofus.getInstance().addChild(this._loadingScreen);
         }
         this._loadingScreen.log("[GameData] " + FileUtils.getFileName(e.url) + " parsed",LoadingScreen.INFO);
         this.setModulePercent("gameData",this._percentPerModule * 1 / GameDataUpdater.getInstance().files.length,true);
         KernelEventsManager.getInstance().processCallback(HookList.LangFileLoaded,e.url,true);
      }
      
      private function onI18nPartialDataReady(e:LangFileEvent) : void
      {
         this._loadingScreen.log("[i18n] " + FileUtils.getFileName(e.url) + " parsed",LoadingScreen.INFO);
         this.setModulePercent("i18n",this._percentPerModule * 1 / I18nUpdater.getInstance().files.length,true);
         KernelEventsManager.getInstance().processCallback(HookList.LangFileLoaded,e.url,true);
      }
      
      private function onDataFileError(e:FileEvent) : void
      {
         this._loadingScreen.log("Unabled to load  " + e.file,LoadingScreen.ERROR);
      }
   }
}
