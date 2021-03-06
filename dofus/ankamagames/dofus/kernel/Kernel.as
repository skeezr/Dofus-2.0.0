package com.ankamagames.dofus.kernel
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Worker;
   import flash.display.Sprite;
   import flash.text.TextField;
   import com.ankamagames.dofus.misc.utils.LoadingScreen;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.jerakine.types.enums.BuildTypeEnum;
   import com.ankamagames.dofus.misc.lists.GameDataList;
   import com.ankamagames.dofus.misc.lists.EnumList;
   import com.ankamagames.dofus.misc.lists.ApiList;
   import com.ankamagames.dofus.misc.lists.ApiActionList;
   import com.ankamagames.dofus.misc.lists.ApiRolePlayActionList;
   import com.ankamagames.dofus.misc.utils.DebugTarget;
   import flash.display.Stage;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.misc.ApplicationDomainShareManager;
   import flash.system.ApplicationDomain;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.dofus.network.Metadata;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.resources.protocols.impl.ModProtocol;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.network.SnifferServerConnection;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.Constants;
   import flash.system.fscommand;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.atouin.types.AtouinOptions;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.dofus.types.DofusOptions;
   import com.ankamagames.berilia.types.BeriliaOptions;
   import com.ankamagames.tiphon.types.TiphonOptions;
   import com.ankamagames.tubul.types.TubulOptions;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.connection.frames.InitializationFrame;
   import com.ankamagames.dofus.logic.common.frames.LoadingModuleFrame;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.logic.common.frames.LatencyFrame;
   import com.ankamagames.dofus.logic.common.frames.AuthorizedFrame;
   import com.ankamagames.dofus.logic.game.common.frames.DebugFrame;
   import com.ankamagames.berilia.frames.UIInteractionFrame;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.dofus.logic.common.frames.DisconnectionHandlerFrame;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.jerakine.newCache.impl.DisplayObjectCache;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class Kernel
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.kernel.Kernel));
      
      private static var _self:com.ankamagames.dofus.kernel.Kernel;
      
      private static var _worker:Worker = new Worker(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG);
      
      public static var beingInReconection:Boolean;
       
      protected var _gamedataClassList:GameDataList = null;
      
      protected var _enumList:EnumList = null;
      
      protected var _apiList:ApiList = null;
      
      protected var _apiActionList:ApiActionList = null;
      
      protected var _ApiRolePlayActionList:ApiRolePlayActionList = null;
      
      private var _include_DebugTarget:DebugTarget = null;
      
      public function Kernel()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("Kernel is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.kernel.Kernel
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.kernel.Kernel();
         }
         return _self;
      }
      
      public static function getWorker() : Worker
      {
         return _worker;
      }
      
      public static function panic(errorId:uint = 0, panicArgs:Array = null) : void
      {
         var blueScreen:Sprite = null;
         var errorTitle:TextField = null;
         var errorMsg:TextField = null;
         var ls:LoadingScreen = null;
         _worker.clear();
         ConnectionsHandler.closeConnection();
         if(Math.random() * 1000 > 999)
         {
            blueScreen = new Sprite();
            blueScreen.graphics.beginFill(6710886,0.9);
            blueScreen.graphics.drawRect(-2000,-2000,5000,5000);
            blueScreen.graphics.endFill();
            StageShareManager.stage.addChild(blueScreen);
            errorTitle = new TextField();
            errorTitle.selectable = false;
            errorTitle.defaultTextFormat = new TextFormat("Courier New",12,16777215,true,false,false,null,null,TextFormatAlign.CENTER);
            errorTitle.text = "DTC ERROR 0x" + errorId.toString(16).toUpperCase();
            errorTitle.width = StageShareManager.stage.stageWidth;
            errorTitle.y = StageShareManager.stage.stageHeight / 2 - errorTitle.textHeight / 2;
            StageShareManager.stage.addChild(errorTitle);
            errorMsg = new TextField();
            errorMsg.selectable = false;
            errorMsg.defaultTextFormat = new TextFormat("Courier New",11,16777215,false,false,false,null,null,TextFormatAlign.CENTER);
            errorMsg.text = "A fatal error has occured.\n" + PanicMessages.getMessage(errorId,panicArgs);
            errorMsg.width = StageShareManager.stage.stageWidth;
            errorMsg.height = errorMsg.textHeight + 10;
            errorMsg.y = StageShareManager.stage.stageHeight / 2 + errorTitle.textHeight / 2 + 10;
            StageShareManager.stage.addChild(errorMsg);
         }
         else
         {
            ls = new LoadingScreen();
            ls.useEmbedFont = false;
            ls.tip = "FATAL ERROR 0x" + errorId.toString(16).toUpperCase() + "\n" + "A fatal error has occured.";
            ls.log(PanicMessages.getMessage(errorId,panicArgs),LoadingScreen.ERROR);
            ls.value = -1;
            ls.showLog(false);
            Dofus.getInstance().addChild(ls);
         }
      }
      
      public function init(stage:Stage, rootClip:DisplayObject) : void
      {
         StageShareManager.stage = stage;
         StageShareManager.rootContainer = Dofus.getInstance();
         ApplicationDomainShareManager.currentApplicationDomain = ApplicationDomain.currentDomain;
         _worker.clear();
         HumanInputHandler.getInstance().handler = _worker;
         FpsControler.enterFrameDispatcher = EnterFrameDispatcher;
         this.addInitialFrames(true);
         _log.info("Using protocole #" + Metadata.PROTOCOL_BUILD + ", build on " + Metadata.PROTOCOL_DATE + " (visibility " + Metadata.PROTOCOL_VISIBILITY + ")");
      }
      
      public function postInit() : void
      {
         var buildType:int = 0;
         var configVersion:String = null;
         this.initCaches();
         XmlConfig.getInstance().init(LangManager.getInstance().getCategory("config"));
         if(XmlConfig.getInstance().getEntry("config.buildType"))
         {
            buildType = -1;
            configVersion = XmlConfig.getInstance().getEntry("config.buildType");
            switch(configVersion.toLowerCase())
            {
               case "debug":
                  buildType = BuildTypeEnum.DEBUG;
                  break;
               case "internal":
                  buildType = BuildTypeEnum.INTERNAL;
                  break;
               case "testing":
                  buildType = BuildTypeEnum.TESTING;
                  break;
               case "alpha":
                  buildType = BuildTypeEnum.ALPHA;
                  break;
               case "beta":
                  buildType = BuildTypeEnum.BETA;
                  break;
               case "release":
                  buildType = BuildTypeEnum.RELEASE;
            }
            if(buildType != -1 && buildType > -1)
            {
               BuildInfos.BUILD_TYPE = buildType;
            }
         }
         this.initOptions();
         Atouin.getInstance().showWorld(false);
         DataMapProvider.init(AnimatedCharacter);
         var pm:String = LangManager.getInstance().getEntry("config.mod.path");
         if(pm.substr(0,2) == "./")
         {
            pm = pm.substr(2);
         }
         ModProtocol.MODULE_ROOT_PATH = pm;
         Tiphon.getInstance().init(LangManager.getInstance().getEntry("config.gfx.path.skull"),LangManager.getInstance().getEntry("config.gfx.path.skin"),LangManager.getInstance().getEntry("config.gfx.path.fx"),LangManager.getInstance().getEntry("config.gfx.path.animIndex"));
         Tiphon.getInstance().addRasterizeAnimation("AnimCourse");
         Tiphon.getInstance().addRasterizeAnimation("AnimMarche");
         Tiphon.getInstance().addRasterizeAnimation("AnimStatique");
         var imeLang:Array = LangManager.getInstance().getStringEntry("config.lang.usingIME").split(",");
         if(imeLang.indexOf(LangManager.getInstance().getStringEntry("config.lang.current")) != -1)
         {
            Berilia.getInstance().useIME = true;
         }
         if(LangManager.getInstance().getBooleanEntry("config.connection.useSniffer"))
         {
            SnifferServerConnection.snifferHost = LangManager.getInstance().getEntry("config.connection.snifferHost");
            SnifferServerConnection.snifferPort = int(LangManager.getInstance().getEntry("config.connection.snifferPort"));
            ConnectionsHandler.useSniffer = true;
         }
      }
      
      public function reset(messagesToDispatchAfter:Array = null, autoRetry:Boolean = false, reloadData:Boolean = false) : void
      {
         var msg:Message = null;
         if(Constants.EVENT_MODE)
         {
            fscommand("quit");
         }
         if(!autoRetry)
         {
            AuthentificationManager.getInstance().destroy();
         }
         PlayedCharacterManager.getInstance().destroy();
         Berilia.getInstance().reset();
         Atouin.getInstance().reset();
         DofusEntities.reset();
         _worker.clear();
         SpeakingItemManager.getInstance().destroy();
         OptionManager.reset();
         this.initOptions();
         this.addInitialFrames(reloadData);
         com.ankamagames.dofus.kernel.Kernel.beingInReconection = false;
         if(messagesToDispatchAfter != null && messagesToDispatchAfter.length > 0)
         {
            for each(msg in messagesToDispatchAfter)
            {
               trace(msg);
               _worker.process(msg);
            }
         }
      }
      
      public function initOptions() : void
      {
         OptionManager.reset();
         var ao:AtouinOptions = new AtouinOptions(Dofus.getInstance().getWorldContainer(),com.ankamagames.dofus.kernel.Kernel.getWorker());
         ao.frustum = new Frustum(LangManager.getInstance().getIntEntry("config.atouin.frustum.marginLeft"),LangManager.getInstance().getIntEntry("config.atouin.frustum.marginTop"),LangManager.getInstance().getIntEntry("config.atouin.frustum.marginRight"),LangManager.getInstance().getIntEntry("config.atouin.frustum.marginBottom"));
         ao.mapsPath = LangManager.getInstance().getEntry("config.atouin.path.maps");
         ao.elementsIndexPath = LangManager.getInstance().getEntry("config.atouin.path.elements");
         ao.elementsPath = LangManager.getInstance().getEntry("config.gfx.path.cellElement");
         ao.particlesScriptsPath = LangManager.getInstance().getEntry("config.atouin.path.emitters");
         Atouin.getInstance().setDisplayOptions(ao);
         var dofusO:DofusOptions = new DofusOptions();
         Dofus.getInstance().setDisplayOptions(dofusO);
         var beriliaO:BeriliaOptions = new BeriliaOptions();
         Berilia.getInstance().setDisplayOptions(beriliaO);
         var tiphonO:TiphonOptions = new TiphonOptions();
         Tiphon.getInstance().setDisplayOptions(tiphonO);
         var tubulO:TubulOptions = new TubulOptions();
         SoundManager.getInstance().setDisplayOptions(tubulO);
      }
      
      private function addInitialFrames(firstLaunch:Boolean = false) : void
      {
         if(firstLaunch)
         {
            _worker.addFrame(new InitializationFrame());
         }
         else
         {
            _worker.addFrame(new LoadingModuleFrame(true));
            UiModuleManager.getInstance().reset();
            UiModuleManager.getInstance().init(Constants.COMMON_GAME_MODULE.concat(Constants.PRE_GAME_MODULE),true);
         }
         if(!_worker.contains(LatencyFrame))
         {
            _worker.addFrame(new LatencyFrame());
         }
         if(!_worker.contains(AuthorizedFrame))
         {
            _worker.addFrame(new AuthorizedFrame());
         }
         if(!_worker.contains(DebugFrame))
         {
            _worker.addFrame(new DebugFrame());
         }
         _worker.addFrame(new UIInteractionFrame());
         _worker.addFrame(new ShortcutsFrame());
         _worker.addFrame(new DisconnectionHandlerFrame());
      }
      
      private function initCaches() : void
      {
         UriCacheFactory.init(".swf",new DisplayObjectCache(100));
         UriCacheFactory.init(LangManager.getInstance().getStringEntry("config.gfx.path") + "items/bitmap",new Cache(100,new LruGarbageCollector()));
      }
   }
}
