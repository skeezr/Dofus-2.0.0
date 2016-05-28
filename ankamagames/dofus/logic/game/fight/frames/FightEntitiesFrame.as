package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.FightEntityDispositionInformations;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightHumanReadyStateMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntitiesDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleDematerializationAction;
   import flash.utils.clearTimeout;
   
   public class FightEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
      
      private static const TEAM_CIRCLE_CLIP:Class = FightEntitiesFrame_TEAM_CIRCLE_CLIP;
      
      private static const SWORDS_CLIP:Class = FightEntitiesFrame_SWORDS_CLIP;
      
      private static const TEAM_CIRCLE_COLOR_1:uint = 255;
      
      private static const TEAM_CIRCLE_COLOR_2:uint = 16711680;
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
       
      private var _entitiesDematerialization:Boolean = false;
      
      private var _showCellStart:Number = 0;
      
      private var arrowId:uint;
      
      public function FightEntitiesFrame()
      {
         super();
         _self = this;
      }
      
      public static function getCurrentInstance() : com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame
      {
         return _self;
      }
      
      override public function pushed() : Boolean
      {
         return super.pushed();
      }
      
      override public function addOrUpdateActor(infos:GameContextActorInformations) : AnimatedCharacter
      {
         var i:* = null;
         var fedi:FightEntityDispositionInformations = null;
         var carryingEntity:IEntity = null;
         var carriedEntity:IEntity = null;
         var step:FightCarryCharacterStep = null;
         var res:AnimatedCharacter = super.addOrUpdateActor(infos);
         if(infos.disposition is FightEntityDispositionInformations)
         {
            fedi = infos.disposition as FightEntityDispositionInformations;
            if(fedi.carryingCharacterId)
            {
               carryingEntity = DofusEntities.getEntity(fedi.carryingCharacterId);
               carriedEntity = DofusEntities.getEntity(infos.contextualId);
               if(Boolean(carryingEntity) && Boolean(carriedEntity))
               {
                  if(!(carryingEntity is TiphonSprite && carriedEntity is TiphonSprite && TiphonSprite(carriedEntity).parentSprite == carryingEntity))
                  {
                     step = new FightCarryCharacterStep(fedi.carryingCharacterId,infos.contextualId);
                     step.start();
                  }
               }
            }
         }
         var str:String = "";
         for(i in _entities)
         {
            str = str + ((!!str.length?", ":"") + i);
         }
         _log.debug("RegisteredEntities : " + str);
         return res;
      }
      
      override public function process(msg:Message) : Boolean
      {
         var gfsfmsg:GameFightShowFighterMessage = null;
         var fighterId:int = 0;
         var gfhrsmsg:GameFightHumanReadyStateMessage = null;
         var ac2:AnimatedCharacter = null;
         var gedmsg:GameEntityDispositionMessage = null;
         var gedsmsg:GameEntitiesDispositionMessage = null;
         var gcrelmsg:GameContextRefreshEntityLookMessage = null;
         var entity:AnimatedCharacter = null;
         var scmsg:ShowCellMessage = null;
         var name:String = null;
         var text:String = null;
         var ac:AnimatedCharacter = null;
         var circle:Sprite = null;
         var colorTransform:ColorTransform = null;
         var swords:Sprite = null;
         var disposition:IdentifiedEntityDispositionInformations = null;
         var ent:* = undefined;
         var entit:* = undefined;
         switch(true)
         {
            case msg is GameFightShowFighterMessage:
               gfsfmsg = msg as GameFightShowFighterMessage;
               fighterId = gfsfmsg.informations.contextualId;
               if(gfsfmsg.informations.alive)
               {
                  ac = this.addOrUpdateActor(gfsfmsg.informations);
                  if(Kernel.getWorker().contains(FightBattleFrame))
                  {
                     circle = new TEAM_CIRCLE_CLIP() as Sprite;
                     colorTransform = new ColorTransform();
                     if(gfsfmsg.informations.teamId == TeamEnum.TEAM_DEFENDER)
                     {
                        colorTransform.color = TEAM_CIRCLE_COLOR_1;
                     }
                     else
                     {
                        colorTransform.color = TEAM_CIRCLE_COLOR_2;
                     }
                     circle.transform.colorTransform = colorTransform;
                     ac.addBackground("teamCircle",circle);
                  }
                  if(this._entitiesDematerialization)
                  {
                     ac.showOnlyBackground(true);
                  }
               }
               else
               {
                  if(_entities[fighterId])
                  {
                     hideActor(fighterId);
                  }
                  registerActor(gfsfmsg.informations);
               }
               return true;
            case msg is GameFightHumanReadyStateMessage:
               gfhrsmsg = msg as GameFightHumanReadyStateMessage;
               ac2 = this.addOrUpdateActor(getEntityInfos(gfhrsmsg.characterId) as GameFightFighterInformations);
               if(gfhrsmsg.isReady)
               {
                  swords = new SWORDS_CLIP() as Sprite;
                  ac2.addBackground("readySwords",swords);
               }
               else
               {
                  ac2.removeBackground("readySwords");
               }
               return true;
            case msg is GameEntityDispositionMessage:
               gedmsg = msg as GameEntityDispositionMessage;
               if(gedmsg.disposition.id == PlayedCharacterManager.getInstance().infos.id)
               {
                  SoundManager.getInstance().manager.playUISound(UISoundEnum.FIGHT_POSITION);
               }
               updateActorDisposition(gedmsg.disposition.id,gedmsg.disposition);
               KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,gedmsg.disposition.id,gedmsg.disposition.cellId,gedmsg.disposition.direction);
               return true;
            case msg is GameEntitiesDispositionMessage:
               gedsmsg = msg as GameEntitiesDispositionMessage;
               for each(disposition in gedsmsg.dispositions)
               {
                  updateActorDisposition(disposition.id,disposition);
               }
               return true;
            case msg is GameContextRefreshEntityLookMessage:
               gcrelmsg = msg as GameContextRefreshEntityLookMessage;
               updateActorLook(gcrelmsg.id,gcrelmsg.look);
               return true;
            case msg is ToggleDematerializationAction:
               if(this._entitiesDematerialization)
               {
                  for each(ent in _entities)
                  {
                     _log.debug("reaffichage de l\'entité " + ent.contextualId);
                     if(ent is GameContextActorInformations)
                     {
                        entity = DofusEntities.getEntity((ent as GameContextActorInformations).contextualId) as AnimatedCharacter;
                        if(entity != null)
                        {
                           entity.showOnlyBackground(false);
                        }
                     }
                  }
                  this._entitiesDematerialization = false;
               }
               else
               {
                  for each(entit in _entities)
                  {
                     _log.debug("disparition de l\'entité " + entit.contextualId);
                     if(entit is GameContextActorInformations)
                     {
                        entity = DofusEntities.getEntity((entit as GameContextActorInformations).contextualId) as AnimatedCharacter;
                        if(entity != null)
                        {
                           entity.showOnlyBackground(true);
                        }
                     }
                  }
                  this._entitiesDematerialization = true;
               }
               return true;
            case msg is RemoveEntityAction:
               removeActor(RemoveEntityAction(msg).actorId);
               return true;
            case msg is ShowCellMessage:
               scmsg = msg as ShowCellMessage;
               HyperlinkShowCellManager.showCell(scmsg.cellId);
               name = FightContextFrame.getInstance().getFighterName(scmsg.sourceId);
               text = I18n.getText(I18nProxy.getKeyId("ui.fight.showCell"),[name,scmsg.cellId]);
               _log.debug("showcell : " + text);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
            default:
               return false;
         }
      }
      
      override public function pulled() : Boolean
      {
         return super.pulled();
      }
      
      private function onTimeOut() : void
      {
         clearTimeout(this._showCellStart);
         removeActor(this.arrowId);
         this._showCellStart = 0;
      }
      
      public function removeSwords() : void
      {
         var ent:* = undefined;
         var ac:AnimatedCharacter = null;
         for each(ent in _entities)
         {
            ac = this.addOrUpdateActor(ent);
            ac.removeBackground("readySwords");
         }
      }
   }
}
