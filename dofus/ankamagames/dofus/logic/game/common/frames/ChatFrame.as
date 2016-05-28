package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.misc.options.ChatOptions;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.console.ChatConsoleInstructionRegistrar;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.BasicWhoIsRequestAction;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatTextOutputAction;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerWithObjectMessage;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerCopyWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerCopyMessage;
   import com.ankamagames.dofus.network.messages.game.basic.TextInformationMessage;
   import com.ankamagames.jerakine.console.ConsoleOutputMessage;
   import com.ankamagames.dofus.logic.game.fight.messages.TextActionInformationMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatErrorMessage;
   import com.ankamagames.dofus.logic.game.common.actions.chat.SaveMessageAction;
   import com.ankamagames.dofus.network.messages.game.chat.smiley.ChatSmileyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.chat.smiley.ChatSmileyMessage;
   import com.ankamagames.dofus.datacenter.communication.SmileyItem;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.dofus.network.messages.game.chat.channel.ChannelEnablingChangeMessage;
   import com.ankamagames.dofus.network.messages.game.chat.channel.ChannelEnablingMessage;
   import com.ankamagames.dofus.logic.game.common.actions.chat.TabsUpdateAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatCommandAction;
   import com.ankamagames.dofus.network.messages.game.chat.channel.EnabledChannelsMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicTimeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectErrorMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsNoMatchMessage;
   import com.ankamagames.dofus.logic.game.common.actions.chat.LivingObjectMessageRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectMessageRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectMessageMessage;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemText;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatLoadedAction;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationByServerMessage;
   import com.ankamagames.dofus.datacenter.notifications.Notification;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientPrivateWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientPrivateMessage;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.internalDatacenter.communication.ThinkBubble;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.jerakine.console.UnhandledConsoleInstructionError;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.network.enums.TextInformationTypeEnum;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.common.actions.chat.FightOutputAction;
   import com.ankamagames.dofus.network.enums.ChatErrorEnum;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatSmileyRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChannelEnablingAction;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.network.enums.ObjectErrorEnum;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithRecipient;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithSource;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatInformationSentence;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   
   public class ChatFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ChatFrame));
      
      public static const RED_CHANNEL_ID:uint = 666;
       
      private var _aChannels:Array;
      
      private var _aDisallowedChannels:Array;
      
      private var _aMessagesByChannel:Array;
      
      private var _msgUId:uint = 0;
      
      private var _maxMessagesStored:uint = 100;
      
      private var _maxCmdHistoryIndex:uint = 100;
      
      private var _aHistory:Array;
      
      private var _nHistoryIndex:int = 0;
      
      private var _aHistoryPrivate:Array;
      
      private var _nHistoryPrivateIndex:int = 0;
      
      private var _smileysOpened:Boolean = false;
      
      private var _options:ChatOptions;
      
      private var _socialFrame:com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
      
      public function ChatFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         var i:* = undefined;
         var tab:* = undefined;
         this._options = new ChatOptions();
         this.setDisplayOptions(this._options);
         this._aChannels = ChatChannel.getChannels();
         this._aDisallowedChannels = new Array();
         this._aMessagesByChannel = new Array();
         for(i in this._aChannels)
         {
            this._aMessagesByChannel[this._aChannels[i].id] = new Array();
         }
         this._aMessagesByChannel[RED_CHANNEL_ID] = new Array();
         this._socialFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.common.frames.SocialFrame) as com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
         ConsolesManager.registerConsole("chat",new ConsoleHandler(Kernel.getWorker(),false),new ChatConsoleInstructionRegistrar());
         for each(tab in OptionManager.getOptionManager("chat").channelTabs)
         {
            _log.debug("tabs : " + tab);
         }
         return true;
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function get disallowedChannels() : Array
      {
         return this._aDisallowedChannels;
      }
      
      public function process(msg:Message) : Boolean
      {
         var bwira:BasicWhoIsRequestAction = null;
         var bwirmsg:BasicWhoIsRequestMessage = null;
         var ch:uint = 0;
         var ctoa:ChatTextOutputAction = null;
         var content:String = null;
         var pattern:RegExp = null;
         var charTempL:String = null;
         var charTempR:String = null;
         var scwomsg:ChatServerWithObjectMessage = null;
         var numItem:int = 0;
         var listItem:Vector.<ItemWrapper> = null;
         var csmsg:ChatServerMessage = null;
         var thinking:Boolean = false;
         var cscwomsg:ChatServerCopyWithObjectMessage = null;
         var cscmsg:ChatServerCopyMessage = null;
         var timsg:TextInformationMessage = null;
         var param:Array = null;
         var msgContent:String = null;
         var textId:uint = 0;
         var params:Array = null;
         var timestampf:Number = NaN;
         var comsg:ConsoleOutputMessage = null;
         var consoleTimestamp:Number = NaN;
         var taimsg:TextActionInformationMessage = null;
         var paramTaimsg:Array = null;
         var channel2:uint = 0;
         var timestamp2:Number = NaN;
         var cemsg:ChatErrorMessage = null;
         var timestampErr:Number = NaN;
         var contentErr:String = null;
         var sma:SaveMessageAction = null;
         var csrmsg:ChatSmileyRequestMessage = null;
         var scmsg:ChatSmileyMessage = null;
         var smileyItem:SmileyItem = null;
         var smileyEntity:IDisplayable = null;
         var cecmsg:ChannelEnablingChangeMessage = null;
         var cebmsg:ChannelEnablingMessage = null;
         var tua:TabsUpdateAction = null;
         var cca:ChatCommandAction = null;
         var ecmsg:EnabledChannelsMessage = null;
         var btmsg:BasicTimeMessage = null;
         var date:Date = null;
         var oemsg:ObjectErrorMessage = null;
         var objectErrorText:String = null;
         var bwimsg:BasicWhoIsMessage = null;
         var areaName:String = null;
         var text:String = null;
         var bwnmmsg:BasicWhoIsNoMatchMessage = null;
         var lomra:LivingObjectMessageRequestAction = null;
         var lomrmsg:LivingObjectMessageRequestMessage = null;
         var lommsg:LivingObjectMessageMessage = null;
         var speakingItemText:SpeakingItemText = null;
         var cla:ChatLoadedAction = null;
         var nbsmsg:NotificationByServerMessage = null;
         var a:Array = null;
         var notification:Notification = null;
         var title:String = null;
         var charas:CharacterCharacteristicsInformations = null;
         var infos:CharacterBaseInformations = null;
         var variables:Array = null;
         var variable:String = null;
         var sf:com.ankamagames.dofus.logic.game.common.frames.SocialFrame = null;
         var guilde:String = null;
         var leftIndex:int = 0;
         var rightIndex:int = 0;
         var leftBlock:String = null;
         var rightBlock:String = null;
         var middleBlock:String = null;
         var replace:Boolean = false;
         var mapInfo:Array = null;
         var posX:Number = NaN;
         var posY:Number = NaN;
         var objects:Vector.<ObjectItem> = null;
         var nb:int = 0;
         var o:int = 0;
         var ccmwomsg:ChatClientMultiWithObjectMessage = null;
         var itemWrapper:ItemWrapper = null;
         var objectItem:ObjectItem = null;
         var ccmmsg:ChatClientMultiMessage = null;
         var ccpwomsg:ChatClientPrivateWithObjectMessage = null;
         var ccpmsg:ChatClientPrivateMessage = null;
         var i:int = 0;
         var oi:ObjectItem = null;
         var sapi:SoundApi = null;
         var contentCsmsg:String = null;
         var speakerEntity:IDisplayable = null;
         var thinkBubble:ThinkBubble = null;
         var bubble:ChatBubble = null;
         var iTimsg:* = undefined;
         var channel:uint = 0;
         var timestamp:Number = NaN;
         var iTaimsg:* = undefined;
         var chanId:* = undefined;
         var parameter:String = null;
         switch(true)
         {
            case msg is BasicWhoIsRequestAction:
               bwira = msg as BasicWhoIsRequestAction;
               bwirmsg = new BasicWhoIsRequestMessage();
               bwirmsg.initBasicWhoIsRequestMessage(bwira.playerName);
               ConnectionsHandler.getConnection().send(bwirmsg);
               return true;
            case msg is ChatTextOutputAction:
               ch = ChatTextOutputAction(msg).channel;
               ctoa = msg as ChatTextOutputAction;
               content = ctoa.content;
               if(content.length > 256)
               {
                  _log.error("Too long message has been truncated before sending.");
                  content = content.substr(0,255);
               }
               pattern = /%[a-z]+%/;
               if(content.match(pattern) != null)
               {
                  charas = PlayedCharacterManager.getInstance().characteristics;
                  infos = PlayedCharacterManager.getInstance().infos;
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.experience")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),int((charas.experience - charas.experienceLevelFloor) / (charas.experienceNextLevelFloor - charas.experienceLevelFloor) * 100) + "%");
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.level")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),infos.level);
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.life")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),charas.lifePoints);
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.maxlife")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),charas.maxLifePoints);
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.lifepercent")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),int(charas.lifePoints / charas.maxLifePoints * 100) + "%");
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.myself")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),infos.name);
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.stats")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),I18n.getText(I18nProxy.getKeyId("ui.chat.variable.statsresult"),new Array(charas.vitality.base,charas.wisdom.base,charas.strength.base,charas.intelligence.base,charas.chance.base,charas.agility.base,charas.initiative.base,charas.actionPoints.base,charas.movementPoints.base)));
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.area")).split(",");
                  for each(variable in variables)
                  {
                     if(PlayedCharacterManager.getInstance().currentSubArea != null)
                     {
                        content = content.replace(new RegExp(variable,"g"),PlayedCharacterManager.getInstance().currentSubArea.area.name);
                     }
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.subarea")).split(",");
                  for each(variable in variables)
                  {
                     if(PlayedCharacterManager.getInstance().currentSubArea != null)
                     {
                        content = content.replace(new RegExp(variable,"g"),PlayedCharacterManager.getInstance().currentSubArea.name);
                     }
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.position")).split(",");
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),"[" + MapDisplayManager.getInstance().currentMapPoint.x + "," + MapDisplayManager.getInstance().currentMapPoint.y + "]");
                  }
                  variables = I18n.getText(I18nProxy.getKeyId("ui.chat.variable.guild")).split(",");
                  sf = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.common.frames.SocialFrame) as com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
                  guilde = sf.guild == null?I18n.getText(I18nProxy.getKeyId("ui.chat.variable.guilderror")):sf.guild.guildName;
                  for each(variable in variables)
                  {
                     content = content.replace(new RegExp(variable,"g"),guilde);
                  }
               }
               charTempL = String.fromCharCode(2);
               charTempR = String.fromCharCode(3);
               while(true)
               {
                  leftIndex = content.indexOf("[");
                  if(leftIndex == -1)
                  {
                     break;
                  }
                  rightIndex = content.indexOf("]");
                  if(rightIndex == -1)
                  {
                     break;
                  }
                  leftBlock = content.substring(0,leftIndex);
                  rightBlock = content.substring(rightIndex + 1);
                  middleBlock = content.substring(leftIndex + 1,rightIndex);
                  replace = true;
                  mapInfo = middleBlock.split(",");
                  if(mapInfo.length == 2)
                  {
                     posX = Number(mapInfo[0]);
                     posY = Number(mapInfo[1]);
                     if(!isNaN(posX) && !isNaN(posY))
                     {
                        replace = false;
                        content = leftBlock + "{map," + int(posX) + "," + int(posY) + "}" + rightBlock;
                     }
                  }
                  if(replace)
                  {
                     content = leftBlock + charTempL + middleBlock + charTempR + rightBlock;
                  }
               }
               content = content.split(charTempL).join("[").split(charTempR).join("]");
               if(!this._aChannels[ch].isPrivate)
               {
                  if(ctoa.objects)
                  {
                     objects = new Vector.<ObjectItem>();
                     nb = ctoa.objects.length;
                     for(o = 0; o < nb; o++)
                     {
                        itemWrapper = BoxingUnBoxing.unbox(ctoa.objects[o]);
                        objectItem = new ObjectItem();
                        objectItem.initObjectItem(itemWrapper.position,itemWrapper.objectGID,itemWrapper.effectsList,itemWrapper.objectUID,itemWrapper.quantity);
                        objects.push(objectItem);
                     }
                     ccmwomsg = new ChatClientMultiWithObjectMessage();
                     ccmwomsg.initChatClientMultiWithObjectMessage(content,ch,objects);
                     ConnectionsHandler.getConnection().send(ccmwomsg);
                  }
                  else
                  {
                     ccmmsg = new ChatClientMultiMessage();
                     ccmmsg.initChatClientMultiMessage(content,ch);
                     ConnectionsHandler.getConnection().send(ccmmsg);
                  }
               }
               else if(ctoa.objects)
               {
                  objects = new Vector.<ObjectItem>();
                  nb = ctoa.objects.length;
                  for(o = 0; o < nb; o++)
                  {
                     itemWrapper = BoxingUnBoxing.unbox(ctoa.objects[o]);
                     objectItem = new ObjectItem();
                     objectItem.initObjectItem(itemWrapper.position,itemWrapper.objectGID,itemWrapper.effectsList,itemWrapper.objectUID,itemWrapper.quantity);
                     objects.push(objectItem);
                  }
                  ccpwomsg = new ChatClientPrivateWithObjectMessage();
                  ccpwomsg.initChatClientPrivateWithObjectMessage(content,ctoa.receiverName,objects);
                  ConnectionsHandler.getConnection().send(ccpwomsg);
               }
               else
               {
                  ccpmsg = new ChatClientPrivateMessage();
                  ccpmsg.initChatClientPrivateMessage(content,ctoa.receiverName);
                  ConnectionsHandler.getConnection().send(ccpmsg);
               }
               return true;
            case msg is ChatServerWithObjectMessage:
               scwomsg = msg as ChatServerWithObjectMessage;
               if(this._socialFrame.isIgnored(scwomsg.senderName))
               {
                  return true;
               }
               numItem = scwomsg.objects.length;
               listItem = new Vector.<ItemWrapper>(numItem);
               for(i = 0; i < numItem; i++)
               {
                  oi = scwomsg.objects[i];
                  listItem[i] = ItemWrapper.create(oi.position,oi.objectUID,oi.objectGID,oi.quantity,oi.effects);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatServerWithObject,scwomsg.channel,scwomsg.senderId,scwomsg.senderName,scwomsg.content,this.getRealTimestamp(scwomsg.timestamp),scwomsg.fingerprint,listItem);
               this.saveMessage(scwomsg.channel,scwomsg.content,this.getRealTimestamp(scwomsg.timestamp),scwomsg.fingerprint,scwomsg.senderId,scwomsg.senderName,listItem);
               return true;
            case msg is ChatServerMessage:
               csmsg = msg as ChatServerMessage;
               if(this._socialFrame.isIgnored(csmsg.senderName))
               {
                  return true;
               }
               if(csmsg.content.substr(0,6).toLowerCase() == "/think")
               {
                  thinking = true;
               }
               else if(csmsg.content.charAt(0) == "*" && csmsg.content.charAt(csmsg.content.length - 1) == "*")
               {
                  thinking = true;
                  csmsg.content = "/think " + csmsg.content.substr(1,csmsg.content.length - 2);
               }
               if(csmsg.channel == ChatChannelsMultiEnum.CHANNEL_GUILD)
               {
                  sapi = new SoundApi();
                  if(sapi.playSoundForGuildMessage())
                  {
                     SoundManager.getInstance().manager.playUISound(UISoundEnum.GUILD_CHAT_MESSAGE);
                  }
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatServer,csmsg.channel,csmsg.senderId,csmsg.senderName,csmsg.content,this.getRealTimestamp(csmsg.timestamp),csmsg.fingerprint);
               this.saveMessage(csmsg.channel,csmsg.content,this.getRealTimestamp(csmsg.timestamp),csmsg.fingerprint,csmsg.senderId,csmsg.senderName);
               if(Boolean(Kernel.getWorker().contains(FightBattleFrame)) || csmsg.content.substr(0,3).toLowerCase() == "/me")
               {
                  return true;
               }
               if(csmsg.channel == ChatChannelsMultiEnum.CHANNEL_GLOBAL)
               {
                  contentCsmsg = StringUtils.cleanString(!!thinking?csmsg.content.substr(7):csmsg.content);
                  speakerEntity = DofusEntities.getEntity(csmsg.senderId) as IDisplayable;
                  if(speakerEntity == null)
                  {
                     return true;
                  }
                  if(speakerEntity is AnimatedCharacter)
                  {
                     if((speakerEntity as AnimatedCharacter).isMoving)
                     {
                        return true;
                     }
                  }
                  if(thinking)
                  {
                     thinkBubble = new ThinkBubble(contentCsmsg);
                  }
                  else
                  {
                     bubble = new ChatBubble(contentCsmsg);
                  }
                  TooltipManager.show(!!thinking?thinkBubble:bubble,speakerEntity.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"msg" + csmsg.senderId,LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               }
               return true;
            case msg is ChatServerCopyWithObjectMessage:
               cscwomsg = msg as ChatServerCopyWithObjectMessage;
               numItem = cscwomsg.objects.length;
               listItem = new Vector.<ItemWrapper>(numItem);
               for(i = 0; i < numItem; i++)
               {
                  oi = cscwomsg.objects[i];
                  listItem[i] = ItemWrapper.create(oi.position,oi.objectUID,oi.objectGID,oi.quantity,oi.effects);
               }
               this.saveMessage(cscwomsg.channel,cscwomsg.content,this.getRealTimestamp(cscwomsg.timestamp),cscwomsg.fingerprint,0,"",listItem,cscwomsg.receiverName,cscwomsg.receiverId);
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatServerCopyWithObject,cscwomsg.channel,cscwomsg.receiverName,cscwomsg.content,this.getRealTimestamp(cscwomsg.timestamp),cscwomsg.fingerprint,cscwomsg.receiverId,listItem);
               return true;
            case msg is ChatServerCopyMessage:
               cscmsg = msg as ChatServerCopyMessage;
               this.saveMessage(cscmsg.channel,cscmsg.content,this.getRealTimestamp(cscmsg.timestamp),cscmsg.fingerprint,0,"",null,cscmsg.receiverName,cscmsg.receiverId);
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatServerCopy,cscmsg.channel,cscmsg.receiverName,cscmsg.content,this.getRealTimestamp(cscmsg.timestamp),cscmsg.fingerprint,cscmsg.receiverId);
               return true;
            case msg is TextInformationMessage:
               timsg = msg as TextInformationMessage;
               param = new Array();
               for each(iTimsg in timsg.parameters)
               {
                  param.push(iTimsg);
               }
               params = new Array();
               if(InfoMessage.getInfoMessageById(timsg.msgType * 10000 + timsg.msgId))
               {
                  textId = InfoMessage.getInfoMessageById(timsg.msgType * 10000 + timsg.msgId).textId;
                  if(param != null)
                  {
                     if(Boolean(param[0]) && param[0].indexOf("~") != -1)
                     {
                        params = param[0].split("~");
                     }
                     else
                     {
                        params = param;
                     }
                  }
               }
               else
               {
                  _log.error("Information message " + (timsg.msgType * 10000 + timsg.msgId) + " cannot be found.");
                  if(timsg.msgType == TextInformationTypeEnum.TEXT_INFORMATION_ERROR)
                  {
                     textId = InfoMessage.getInfoMessageById(10231).textId;
                  }
                  else
                  {
                     textId = InfoMessage.getInfoMessageById(207).textId;
                  }
                  params.push(timsg.msgId);
               }
               msgContent = I18n.getText(textId);
               if(msgContent)
               {
                  msgContent = ParamsDecoder.applyParams(msgContent,params);
                  timestamp = this.getTimestamp();
                  if(timsg.msgType == TextInformationTypeEnum.TEXT_INFORMATION_ERROR)
                  {
                     channel = RED_CHANNEL_ID;
                  }
                  else if(timsg.msgType == TextInformationTypeEnum.TEXT_INFORMATION_MESSAGE)
                  {
                     channel = ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO;
                  }
                  else if(timsg.msgType == TextInformationTypeEnum.TEXT_INFORMATION_PVP)
                  {
                     channel = ChatActivableChannelsEnum.CHANNEL_ALIGN;
                  }
                  this.saveMessage(channel,msgContent,timestamp);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,msgContent,channel,timestamp,false);
               }
               else
               {
                  _log.error("There\'s no message for id " + (timsg.msgType * 10000 + timsg.msgId));
               }
               return true;
            case msg is FightOutputAction:
               timestampf = this.getTimestamp();
               this.saveMessage(FightOutputAction(msg).channel,FightOutputAction(msg).content,timestampf);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,FightOutputAction(msg).content,FightOutputAction(msg).channel,timestampf,false);
               return true;
            case msg is ConsoleOutputMessage:
               comsg = msg as ConsoleOutputMessage;
               if(comsg.consoleId != "chat")
               {
                  return false;
               }
               consoleTimestamp = this.getTimestamp();
               this.saveMessage(ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,comsg.text,consoleTimestamp);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,comsg.text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,consoleTimestamp,false);
               return true;
            case msg is TextActionInformationMessage:
               taimsg = msg as TextActionInformationMessage;
               paramTaimsg = new Array();
               for each(iTaimsg in taimsg.params)
               {
                  paramTaimsg.push(iTaimsg);
               }
               channel2 = ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG;
               timestamp2 = this.getTimestamp();
               this.saveMessage(channel2,"",timestamp2,"",0,"",null,"",0,taimsg.textKey,paramTaimsg);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextActionInformation,taimsg.textKey,params,channel2,timestamp2,false);
               return true;
            case msg is ChatErrorMessage:
               cemsg = msg as ChatErrorMessage;
               timestampErr = this.getTimestamp();
               _log.fatal("process " + msg + "   " + cemsg.reason);
               switch(cemsg.reason)
               {
                  case ChatErrorEnum.CHAT_ERROR_INTERIOR_MONOLOGUE:
                  case ChatErrorEnum.CHAT_ERROR_INVALID_MAP:
                  case ChatErrorEnum.CHAT_ERROR_NO_GUILD:
                  case ChatErrorEnum.CHAT_ERROR_NO_PARTY:
                  case ChatErrorEnum.CHAT_ERROR_RECEIVER_NOT_FOUND:
                     contentErr = I18n.getText(I18nProxy.getKeyId("ui.chat.error." + cemsg.reason));
                     break;
                  case ChatErrorEnum.CHAT_ERROR_ALIGN:
                  default:
                     contentErr = I18n.getText(I18nProxy.getKeyId("ui.chat.error.0"));
               }
               _log.fatal("contentErr : " + contentErr);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,contentErr,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,timestampErr);
               return true;
            case msg is SaveMessageAction:
               sma = SaveMessageAction(msg);
               this.saveMessage(sma.channel,sma.content,sma.timestamp);
               return true;
            case msg is ChatSmileyRequestAction:
               csrmsg = new ChatSmileyRequestMessage();
               csrmsg.initChatSmileyRequestMessage(ChatSmileyRequestAction(msg).id);
               ConnectionsHandler.getConnection().send(csrmsg);
               return true;
            case msg is ChatSmileyMessage:
               scmsg = msg as ChatSmileyMessage;
               smileyItem = new SmileyItem();
               smileyItem.smileyId = scmsg.smileyId;
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatSmiley,scmsg.smileyId,scmsg.entityId);
               smileyEntity = DofusEntities.getEntity(scmsg.entityId) as IDisplayable;
               if(smileyEntity == null)
               {
                  return true;
               }
               if(smileyEntity is AnimatedCharacter)
               {
                  if((smileyEntity as AnimatedCharacter).isMoving)
                  {
                     return true;
                  }
               }
               TooltipManager.show(smileyItem,smileyEntity.absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"smiley" + scmsg.entityId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               return true;
            case msg is ChannelEnablingChangeMessage:
               cecmsg = msg as ChannelEnablingChangeMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChannelEnablingChange,cecmsg.channel,cecmsg.enable);
               return true;
            case msg is ChannelEnablingAction:
               cebmsg = new ChannelEnablingMessage();
               cebmsg.initChannelEnablingMessage(ChannelEnablingAction(msg).channel,ChannelEnablingAction(msg).enable);
               ConnectionsHandler.getConnection().send(cebmsg);
               return true;
            case msg is TabsUpdateAction:
               tua = msg as TabsUpdateAction;
               if(tua.tabs)
               {
                  OptionManager.getOptionManager("chat").channelTabs = tua.tabs;
               }
               if(tua.tabsNames)
               {
                  OptionManager.getOptionManager("chat").tabsNames = tua.tabsNames;
               }
               return true;
            case msg is ChatCommandAction:
               cca = msg as ChatCommandAction;
               try
               {
                  ConsolesManager.getConsole("chat").process(ConsolesManager.getMessage(cca.command));
               }
               catch(ucie:UnhandledConsoleInstructionError)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,ucie.message,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               }
               return true;
            case msg is EnabledChannelsMessage:
               ecmsg = msg as EnabledChannelsMessage;
               for each(chanId in ecmsg.disallowed)
               {
                  this._aDisallowedChannels.push(chanId);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.EnabledChannels,ecmsg.channels);
               return true;
            case msg is BasicTimeMessage:
               btmsg = msg as BasicTimeMessage;
               date = new Date();
               TimeManager.getInstance().serverTimeLag = (btmsg.timestamp + btmsg.timezoneOffset) * 1000 - date.getTime();
               TimeManager.getInstance().timezoneOffset = btmsg.timezoneOffset * 1000;
               TimeManager.getInstance().dofusTimeYearLag = -1370;
               return true;
            case msg is ObjectErrorMessage:
               oemsg = msg as ObjectErrorMessage;
               switch(oemsg.reason)
               {
                  case ObjectErrorEnum.INVENTORY_FULL:
                     objectErrorText = I18n.getText(I18nProxy.getKeyId("ui.objectError.InventoryFull"));
                     break;
                  case ObjectErrorEnum.CANNOT_EQUIP_TWICE:
                     objectErrorText = I18n.getText(I18nProxy.getKeyId("ui.objectError.CannotEquipTwice"));
                     break;
                  case ObjectErrorEnum.NOT_TRADABLE:
                     break;
                  case ObjectErrorEnum.CANNOT_DROP:
                     objectErrorText = I18n.getText(I18nProxy.getKeyId("ui.objectError.CannotDrop"));
                     break;
                  case ObjectErrorEnum.CANNOT_DROP_NO_PLACE:
                     objectErrorText = I18n.getText(I18nProxy.getKeyId("ui.objectError.CannotDropNoPlace"));
                     break;
                  case ObjectErrorEnum.CANNOT_DESTROY:
                     break;
                  case ObjectErrorEnum.LEVEL_TOO_LOW:
                     objectErrorText = I18n.getText(I18nProxy.getKeyId("ui.objectError.levelTooLow"));
                     break;
                  case ObjectErrorEnum.LIVING_OBJECT_REFUSED_FOOD:
               }
               if(objectErrorText)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,objectErrorText,RED_CHANNEL_ID,this.getTimestamp());
               }
               else
               {
                  _log.error("Texte d\'erreur objet " + oemsg.reason + " manquant");
               }
               return true;
            case msg is BasicWhoIsMessage:
               bwimsg = msg as BasicWhoIsMessage;
               if(bwimsg.areaId != -1)
               {
                  areaName = Area.getAreaById(bwimsg.areaId).name;
               }
               else
               {
                  areaName = I18n.getText(I18nProxy.getKeyId("ui.common.unknowArea"));
               }
               text = I18n.getText(I18nProxy.getKeyId("ui.common.whois"),[bwimsg.characterName,bwimsg.accountNickname,areaName]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
            case msg is BasicWhoIsNoMatchMessage:
               bwnmmsg = msg as BasicWhoIsNoMatchMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getText(I18nProxy.getKeyId("ui.common.playerdoesntexist"),[bwnmmsg.search]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
            case msg is LivingObjectMessageRequestAction:
               lomra = msg as LivingObjectMessageRequestAction;
               lomrmsg = new LivingObjectMessageRequestMessage();
               lomrmsg.initLivingObjectMessageRequestMessage(lomra.msgId,null,lomra.livingObjectUID);
               ConnectionsHandler.getConnection().send(lomrmsg);
               return true;
            case msg is LivingObjectMessageMessage:
               lommsg = msg as LivingObjectMessageMessage;
               speakingItemText = SpeakingItemText.getSpeakingItemTextById(lommsg.msgId);
               KernelEventsManager.getInstance().processCallback(ChatHookList.LivingObjectMessage,lommsg.owner,speakingItemText.textString,lommsg.timeStamp);
               return true;
            case msg is ChatLoadedAction:
               cla = msg as ChatLoadedAction;
               SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_ON_CONNECT);
               return true;
            case msg is NotificationByServerMessage:
               nbsmsg = msg as NotificationByServerMessage;
               a = new Array();
               for each(parameter in nbsmsg.parameters)
               {
                  a.push(param);
               }
               notification = Notification.getNotificationById(nbsmsg.id);
               title = I18n.getText(notification.titleId);
               text = I18n.getText(notification.messageId,a);
               KernelEventsManager.getInstance().processCallback(ChatHookList.Notification,title,text);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function getRedId() : uint
      {
         return RED_CHANNEL_ID;
      }
      
      public function getMessages() : Array
      {
         return this._aMessagesByChannel;
      }
      
      public function get options() : ChatOptions
      {
         return this._options;
      }
      
      public function setDisplayOptions(opt:ChatOptions) : void
      {
         this._options = opt;
      }
      
      private function saveMessage(channel:int = 0, content:String = "", timestamp:Number = 0, fingerprint:String = "", senderId:uint = 0, senderName:String = "", objects:Vector.<ItemWrapper> = null, receiverName:String = "", receiverId:uint = 0, textKey:uint = 0, params:Array = null) : void
      {
         var sentence:Object = null;
         if(receiverName != "")
         {
            sentence = new ChatSentenceWithRecipient(this._msgUId,content,channel,timestamp,fingerprint,senderId,senderName,receiverName,receiverId,objects);
         }
         else if(senderName != "")
         {
            sentence = new ChatSentenceWithSource(this._msgUId,content,channel,timestamp,fingerprint,senderId,senderName,objects);
         }
         else if(textKey != 0)
         {
            sentence = new ChatInformationSentence(this._msgUId,content,channel,timestamp,fingerprint,textKey,params);
         }
         else
         {
            sentence = new BasicChatSentence(this._msgUId,content,channel,timestamp,fingerprint);
         }
         this._aMessagesByChannel[channel].push(sentence);
         if(this._aMessagesByChannel[channel].length > this._maxMessagesStored)
         {
            this._aMessagesByChannel[channel].shift();
         }
         this._msgUId++;
         KernelEventsManager.getInstance().processCallback(ChatHookList.NewMessage,channel);
      }
      
      private function getTimestamp() : Number
      {
         var date:Date = new Date();
         var time:Number = date.getTime() + TimeManager.getInstance().serverTimeLag;
         return time;
      }
      
      private function getRealTimestamp(time:Number) : Number
      {
         return time * 1000 + TimeManager.getInstance().timezoneOffset;
      }
      
      public function getTimestampServerByRealTimestamp(realTimeStamp:Number) : Number
      {
         return (realTimeStamp - TimeManager.getInstance().timezoneOffset) / 1000;
      }
   }
}
