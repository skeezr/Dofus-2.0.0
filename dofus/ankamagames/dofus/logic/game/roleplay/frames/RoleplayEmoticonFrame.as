package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmoteRemoveMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.EmotePlayRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayMassiveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenBeginMessage;
   import com.ankamagames.dofus.network.messages.game.character.stats.LifePointsRegenEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import flash.utils.setInterval;
   import flash.utils.clearInterval;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class RoleplayEmoticonFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayEmoticonFrame));
       
      private var _entitiesFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
      
      private var _movementFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
      
      private var _emotes:Array;
      
      private var _interval:Number;
      
      private var _bEmoteOn:Boolean = false;
      
      public function RoleplayEmoticonFrame(movementframe:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame)
      {
         super();
         this._movementFrame = movementframe;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get emotes() : Array
      {
         this._emotes.sort(Array.NUMERIC);
         return this._emotes;
      }
      
      public function set roleplayMovementFrame(pRoleplayMovementFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame) : void
      {
         this._movementFrame = pRoleplayMovementFrame;
      }
      
      public function pushed() : Boolean
      {
         this._emotes = new Array();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var elmsg:EmoteListMessage = null;
         var eamsg:EmoteAddMessage = null;
         var addText:String = null;
         var ermsg:EmoteRemoveMessage = null;
         var removeText:String = null;
         var epra:EmotePlayRequestAction = null;
         var epmsg:EmotePlayMessage = null;
         var entityInfo:GameContextActorInformations = null;
         var epmmsg:EmotePlayMassiveMessage = null;
         var epemsg:EmotePlayErrorMessage = null;
         var errorText:String = null;
         var lprbmsg:LifePointsRegenBeginMessage = null;
         var lpremsg:LifePointsRegenEndMessage = null;
         var id:* = undefined;
         var i:* = undefined;
         var ire:* = undefined;
         var eprmsg:EmotePlayRequestMessage = null;
         var playerEntity:IEntity = null;
         var anim:String = null;
         var instant:Boolean = false;
         var directions8:Boolean = false;
         var actor:* = undefined;
         var mEntityInfo:GameContextActorInformations = null;
         var mAnim:String = null;
         var mInstant:Boolean = false;
         var mDirections8:Boolean = false;
         var regenText:String = null;
         switch(true)
         {
            case msg is EmoteListMessage:
               elmsg = msg as EmoteListMessage;
               this._emotes = new Array();
               for each(id in elmsg.emoteIds)
               {
                  this._emotes.push(id);
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               return true;
            case msg is EmoteAddMessage:
               eamsg = msg as EmoteAddMessage;
               for(i in this._emotes)
               {
                  if(this._emotes[i] == eamsg.emoteId)
                  {
                     return true;
                  }
               }
               this._emotes.push(eamsg.emoteId);
               addText = I18n.getText(I18nProxy.getKeyId("ui.common.emoteAdded"),[Emoticon.getEmoticonById(eamsg.emoteId).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,addText,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               return true;
            case msg is EmoteRemoveMessage:
               ermsg = msg as EmoteRemoveMessage;
               for(ire in this._emotes)
               {
                  if(this._emotes[ire] == ermsg.emoteId)
                  {
                     this._emotes[ire] = null;
                     this._emotes.splice(ire,1);
                  }
               }
               removeText = I18n.getText(I18nProxy.getKeyId("ui.common.emoteRemoved"),[Emoticon.getEmoticonById(ermsg.emoteId).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,removeText,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteListUpdated);
               return true;
            case msg is EmotePlayRequestAction:
               epra = msg as EmotePlayRequestAction;
               if(PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
               {
                  eprmsg = new EmotePlayRequestMessage();
                  eprmsg.initEmotePlayRequestMessage(epra.emoteId);
                  playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if((playerEntity as IMovable).isMoving)
                  {
                     this._movementFrame.setFollowingMessage(eprmsg);
                     (playerEntity as IMovable).stop();
                  }
                  else
                  {
                     ConnectionsHandler.getConnection().send(eprmsg);
                  }
               }
               return true;
            case msg is EmotePlayMessage:
               epmsg = msg as EmotePlayMessage;
               this._bEmoteOn = true;
               this._entitiesFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame) as com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
               if(this._entitiesFrame == null)
               {
                  return true;
               }
               entityInfo = this._entitiesFrame.getEntityInfos(epmsg.actorId);
               if(epmsg.emoteId == 0)
               {
                  this._entitiesFrame.process(new GameRolePlaySetAnimationMessage(entityInfo,"AnimStatique"));
               }
               else if(entityInfo)
               {
                  if(Emoticon.getEmoticonById(epmsg.emoteId).aura)
                  {
                     _log.debug("on joue une aura :)");
                  }
                  else
                  {
                     anim = Emoticon.getEmoticonById(epmsg.emoteId).getAnimName(entityInfo.look);
                     instant = Emoticon.getEmoticonById(epmsg.emoteId).instant;
                     directions8 = Emoticon.getEmoticonById(epmsg.emoteId).eight_directions;
                     this._entitiesFrame.currentEmoticon = epmsg.emoteId;
                     this._entitiesFrame.process(new GameRolePlaySetAnimationMessage(entityInfo,anim,epmsg.duration,instant,directions8));
                  }
               }
               return true;
            case msg is EmotePlayMassiveMessage:
               epmmsg = msg as EmotePlayMassiveMessage;
               this._bEmoteOn = true;
               this._entitiesFrame = Kernel.getWorker().getFrame(com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame) as com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
               if(this._entitiesFrame == null)
               {
                  return true;
               }
               for each(actor in epmmsg.actorIds)
               {
                  mEntityInfo = this._entitiesFrame.getEntityInfos(actor);
                  if(epmmsg.emoteId == 0)
                  {
                     this._entitiesFrame.process(new GameRolePlaySetAnimationMessage(mEntityInfo,"AnimStatique"));
                  }
                  else
                  {
                     mAnim = Emoticon.getEmoticonById(epmmsg.emoteId).getAnimName(mEntityInfo.look);
                     mInstant = Emoticon.getEmoticonById(epmmsg.emoteId).instant;
                     mDirections8 = Emoticon.getEmoticonById(epmmsg.emoteId).eight_directions;
                     this._entitiesFrame.currentEmoticon = epmmsg.emoteId;
                     this._entitiesFrame.process(new GameRolePlaySetAnimationMessage(mEntityInfo,mAnim,epmmsg.duration,mInstant,mDirections8));
                  }
               }
               return true;
            case msg is EmotePlayErrorMessage:
               epemsg = msg as EmotePlayErrorMessage;
               errorText = I18n.getText(I18nProxy.getKeyId("ui.common.cantUseEmote"));
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,errorText,ChatFrame.RED_CHANNEL_ID);
               return true;
            case msg is LifePointsRegenBeginMessage:
               lprbmsg = msg as LifePointsRegenBeginMessage;
               this._interval = setInterval(this.interval,lprbmsg.regenRate * 100);
               return true;
            case msg is LifePointsRegenEndMessage:
               lpremsg = msg as LifePointsRegenEndMessage;
               if(this._bEmoteOn)
               {
                  if(lpremsg.lifePointsGained != 0)
                  {
                     regenText = I18n.getText(I18nProxy.getKeyId("ui.common.emoteRestoreLife"),[lpremsg.lifePointsGained]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,regenText,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
                  }
                  this._bEmoteOn = false;
               }
               clearInterval(this._interval);
               PlayedCharacterManager.getInstance().characteristics.lifePoints = lpremsg.lifePoints;
               PlayedCharacterManager.getInstance().characteristics.maxLifePoints = lpremsg.maxLifePoints;
               KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(this._interval)
         {
            clearInterval(this._interval);
         }
         return true;
      }
      
      public function interval() : void
      {
         if(PlayedCharacterManager.getInstance())
         {
            PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.lifePoints + 1;
            if(PlayedCharacterManager.getInstance().characteristics.lifePoints >= PlayedCharacterManager.getInstance().characteristics.maxLifePoints)
            {
               clearInterval(this._interval);
               PlayedCharacterManager.getInstance().characteristics.lifePoints = PlayedCharacterManager.getInstance().characteristics.maxLifePoints;
            }
            KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
         }
      }
   }
}
