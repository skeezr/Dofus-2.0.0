package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.system.LoaderContext;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   import com.ankamagames.dofus.network.messages.connection.HelloConnectMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedForBadVersionMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRegistrationMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameAcceptedMessage;
   import com.ankamagames.dofus.logic.connection.actions.NicknameChoiceRequestAction;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameChoiceRequestMessage;
   import com.ankamagames.dofus.network.messages.game.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AlreadyConnectedMessage;
   import com.ankamagames.dofus.logic.game.approach.actions.SubscribersGiftListRequestAction;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.logic.game.approach.actions.NewsLoginRequestAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.frames.ChangeCharacterFrame;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.dofus.internalDatacenter.connection.SubscriberGift;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   
   public class AuthentificationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationFrame));
       
      private var _loader:IResourceLoader;
      
      private var _contextLoader:LoaderContext;
      
      private var _dispatchModuleHook:Boolean;
      
      public function AuthentificationFrame(dispatchModuleHook:Boolean = true)
      {
         super();
         this._dispatchModuleHook = dispatchModuleHook;
         this._contextLoader = new LoaderContext();
         this._contextLoader.checkPolicyFile = true;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         if(this._dispatchModuleHook)
         {
            KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart);
         }
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var lva:LoginValidationAction = null;
         var scfMsg:ServerConnectionFailedMessage = null;
         var hcmsg:HelloConnectMessage = null;
         var ismsg:IdentificationSuccessMessage = null;
         var ifmsg:IdentificationFailedMessage = null;
         var iffbvmsg:IdentificationFailedForBadVersionMessage = null;
         var nrmsg:NicknameRegistrationMessage = null;
         var nrfmsg:NicknameRefusedMessage = null;
         var namsg:NicknameAcceptedMessage = null;
         var ncra:NicknameChoiceRequestAction = null;
         var ncrmsg:NicknameChoiceRequestMessage = null;
         var smdmsg:SystemMessageDisplayMessage = null;
         var commonMod:Object = null;
         var a:Array = null;
         var textId:uint = 0;
         var acmsg:AlreadyConnectedMessage = null;
         var sglra:SubscribersGiftListRequestAction = null;
         var uri:Uri = null;
         var lang:String = null;
         var nlra:NewsLoginRequestAction = null;
         var uri2:Uri = null;
         var lang2:String = null;
         var i:* = undefined;
         switch(true)
         {
            case msg is LoginValidationAction:
               lva = LoginValidationAction(msg);
               AuthentificationManager.getInstance().setValidationAction(lva);
               ConnectionsHandler.connectToLoginServer();
               return true;
            case msg is ServerConnectionFailedMessage:
               scfMsg = ServerConnectionFailedMessage(msg);
               PlayerManager.getInstance().destroy();
               KernelEventsManager.getInstance().processCallback(HookList.ServerConnectionFailed);
               return true;
            case msg is HelloConnectMessage:
               hcmsg = HelloConnectMessage(msg);
               AuthentificationManager.getInstance().setConnectionKey(hcmsg.key);
               if(AuthentificationManager.getInstance().loginValidationAction.serverId)
               {
                  ConnectionsHandler.getConnection().send(AuthentificationManager.getInstance().getIdentificationMessageWithServerIdMessage());
               }
               else
               {
                  ConnectionsHandler.getConnection().send(AuthentificationManager.getInstance().getIdentificationMessage());
               }
               return true;
            case msg is IdentificationSuccessMessage:
               ismsg = IdentificationSuccessMessage(msg);
               PlayerManager.getInstance().communityId = ismsg.communityId;
               PlayerManager.getInstance().hasRights = ismsg.hasRights;
               PlayerManager.getInstance().nickname = ismsg.nickname;
               PlayerManager.getInstance().remainingSubscriptionTime = ismsg.remainingSubscriptionTime;
               PlayerManager.getInstance().secretQuestion = ismsg.secretQuestion;
               Kernel.getWorker().removeFrame(this);
               Kernel.getWorker().addFrame(new ChangeCharacterFrame());
               Kernel.getWorker().addFrame(new ServerSelectionFrame());
               return true;
            case msg is IdentificationFailedMessage:
               ifmsg = IdentificationFailedMessage(msg);
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,ifmsg.reason);
               return true;
            case msg is IdentificationFailedForBadVersionMessage:
               iffbvmsg = IdentificationFailedForBadVersionMessage(msg);
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedForBadVersion,iffbvmsg.reason,iffbvmsg.requiredVersion);
               return true;
            case msg is NicknameRegistrationMessage:
               nrmsg = NicknameRegistrationMessage(msg);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRegistration);
               return true;
            case msg is NicknameRefusedMessage:
               nrfmsg = NicknameRefusedMessage(msg);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRefused,nrfmsg.reason);
               return true;
            case msg is NicknameAcceptedMessage:
               namsg = NicknameAcceptedMessage(msg);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameAccepted);
               return true;
            case msg is NicknameChoiceRequestAction:
               ncra = NicknameChoiceRequestAction(msg);
               ncrmsg = new NicknameChoiceRequestMessage();
               ncrmsg.initNicknameChoiceRequestMessage(ncra.nickname);
               ConnectionsHandler.getConnection().send(ncrmsg);
               return true;
            case msg is SystemMessageDisplayMessage:
               smdmsg = msg as SystemMessageDisplayMessage;
               commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               a = new Array();
               for each(i in smdmsg.parameters)
               {
                  a.push(i);
               }
               if(InfoMessage.getInfoMessageById(40000 + smdmsg.msgId).textId)
               {
                  textId = InfoMessage.getInfoMessageById(40000 + smdmsg.msgId).textId;
               }
               else
               {
                  _log.error("Information message " + (40000 + smdmsg.msgId) + " cannot be found.");
                  textId = InfoMessage.getInfoMessageById(207).textId;
                  a = new Array();
                  a.push(smdmsg.msgId);
               }
               commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.warning")),I18n.getText(textId,a),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               SoundManager.getInstance().manager.removeAllSounds();
               return true;
            case msg is AlreadyConnectedMessage:
               acmsg = AlreadyConnectedMessage(msg);
               commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.warning")),I18n.getText(I18nProxy.getKeyId("ui.connection.disconnectAccount")),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
               return true;
            case msg is SubscribersGiftListRequestAction:
               sglra = SubscribersGiftListRequestAction(msg);
               lang = XmlConfig.getInstance().getEntry("config.lang.current");
               if(lang == "de" || lang == "en" || lang == "es" || lang == "pt" || lang == "fr" || lang == "uk")
               {
                  uri = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_" + lang + ".xml");
               }
               else
               {
                  uri = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_en.xml");
               }
               uri.loaderContext = this._contextLoader;
               this._loader.load(uri);
               return true;
            case msg is NewsLoginRequestAction:
               nlra = NewsLoginRequestAction(msg);
               lang2 = XmlConfig.getInstance().getEntry("config.lang.current");
               if(lang2 == "de" || lang2 == "en" || lang2 == "es" || lang2 == "pt" || lang2 == "fr" || lang2 == "uk")
               {
                  uri2 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_" + lang2 + ".xml");
               }
               else
               {
                  uri2 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_en.xml");
               }
               uri2.loaderContext = this._contextLoader;
               this._loader.load(uri2);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         Berilia.getInstance().unloadUi("Login");
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         return true;
      }
      
      private function onLoad(e:ResourceLoadedEvent) : void
      {
         var gift:XML = null;
         var subGift:SubscriberGift = null;
         var text:String = null;
         var link:String = null;
         var id:uint = 0;
         var news:XML = null;
         var subGiftList:Array = new Array();
         var xml:XML = e.resource;
         var xmlString:String = xml.toXMLString();
         if(xmlString.substring(1,17) == "subscribersGifts")
         {
            for each(gift in xml..gift)
            {
               subGift = new SubscriberGift(gift.@id,gift.description,gift.uri,gift.link);
               subGiftList.push(subGift);
            }
            KernelEventsManager.getInstance().processCallback(HookList.SubscribersList,subGiftList);
         }
         else if(xmlString.substring(1,9) == "newsList")
         {
            id = 0;
            for each(news in xml..news)
            {
               if(news.@id > id)
               {
                  text = news.text;
                  link = news.link;
                  id = news.@id;
               }
            }
            KernelEventsManager.getInstance().processCallback(HookList.NewsLogin,text,link);
         }
      }
      
      private function onLoadError(e:ResourceErrorEvent) : void
      {
         _log.error("Cannot load xml " + e.uri + "(" + e.errorMsg + ")");
      }
   }
}
