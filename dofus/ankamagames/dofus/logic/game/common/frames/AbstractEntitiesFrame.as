package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import flash.geom.Point;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.jerakine.managers.OptionManager;
   
   public class AbstractEntitiesFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractEntitiesFrame));
       
      protected var _entities:Dictionary;
      
      protected var _creaturesMode:Boolean = false;
      
      protected var _creaturesLimit:uint;
      
      protected var _humanNumber:uint = 0;
      
      public function AbstractEntitiesFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         this._entities = new Dictionary();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         throw new AbstractMethodCallError();
      }
      
      public function pulled() : Boolean
      {
         this._entities = null;
         Atouin.getInstance().clearEntities();
         return true;
      }
      
      public function getEntityInfos(entityId:int) : GameContextActorInformations
      {
         if(!this._entities)
         {
            return null;
         }
         return this._entities[entityId];
      }
      
      public function getEntitiesIdsList() : Vector.<int>
      {
         var gcai:GameContextActorInformations = null;
         var entitiesList:Vector.<int> = new Vector.<int>(0,false);
         for each(gcai in this._entities)
         {
            entitiesList.push(gcai.contextualId);
         }
         return entitiesList;
      }
      
      public function getEntitiesDictionnary() : Dictionary
      {
         return this._entities;
      }
      
      public function registerActor(infos:GameContextActorInformations) : void
      {
         this._entities[infos.contextualId] = infos;
      }
      
      public function addOrUpdateActor(infos:GameContextActorInformations) : AnimatedCharacter
      {
         var newLook:TiphonEntityLook = null;
         var characterEntity:AnimatedCharacter = DofusEntities.getEntity(infos.contextualId) as AnimatedCharacter;
         var justCreated:Boolean = true;
         if(!(infos is GameRolePlayNpcInformations) && infos is GameRolePlayHumanoidInformations)
         {
            newLook = this.getLook(infos.look);
         }
         else
         {
            newLook = EntityLookAdapter.fromNetwork(infos.look);
         }
         if(characterEntity == null)
         {
            characterEntity = new AnimatedCharacter(infos.contextualId,newLook);
         }
         else
         {
            justCreated = false;
            this._humanNumber--;
            this.updateActorLook(infos.contextualId,infos.look);
         }
         if(Boolean(characterEntity.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER)) && Boolean(characterEntity.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length))
         {
            characterEntity.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         if(Boolean(characterEntity.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET)) && Boolean(characterEntity.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length))
         {
            characterEntity.setSubEntityBehaviour(1,new AnimStatiqueSubEntityBehavior());
         }
         if(infos.disposition.cellId != -1)
         {
            characterEntity.position = MapPoint.fromCellId(infos.disposition.cellId);
         }
         if(justCreated)
         {
            characterEntity.setDirection(infos.disposition.direction);
            characterEntity.display(PlacementStrataEnums.STRATA_PLAYER);
         }
         this._entities[infos.contextualId] = infos;
         if(PlayedCharacterManager.getInstance().id == characterEntity.id)
         {
            SoundManager.getInstance().manager.setSoundSourcePosition(characterEntity.id,new Point(characterEntity.x,characterEntity.y));
         }
         return characterEntity;
      }
      
      protected function updateActorLook(actorId:int, newLook:EntityLook) : void
      {
         var tel:TiphonEntityLook = null;
         if(this._entities[actorId])
         {
            (this._entities[actorId] as GameContextActorInformations).look = newLook;
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + actorId + ") in informations.");
         }
         var ac:AnimatedCharacter = DofusEntities.getEntity(actorId) as AnimatedCharacter;
         if(ac)
         {
            if(!(this._entities[actorId] is GameRolePlayNpcInformations) && this._entities[actorId] is GameRolePlayHumanoidInformations)
            {
               tel = this.getLook(newLook);
            }
            else
            {
               tel = EntityLookAdapter.fromNetwork(newLook);
            }
            ac.look.updateFrom(tel);
            if(this._creaturesMode)
            {
               ac.setAnimation("AnimStatique");
            }
            else
            {
               ac.setAnimation(ac.getAnimation());
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + actorId + ") in the game world.");
         }
         if(actorId == PlayedCharacterManager.getInstance().id)
         {
            PlayedCharacterManager.getInstance().infos.entityLook = newLook;
            KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,tel);
         }
      }
      
      protected function updateActorDisposition(actorId:int, newDisposition:EntityDispositionInformations) : void
      {
         if(this._entities[actorId])
         {
            (this._entities[actorId] as GameContextActorInformations).disposition = newDisposition;
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + actorId + ") in informations.");
         }
         var actor:IEntity = DofusEntities.getEntity(actorId);
         if(actor)
         {
            if(actor is IMovable)
            {
               IMovable(actor).jump(MapPoint.fromCellId(newDisposition.cellId));
            }
            if(actor is IAnimated)
            {
               IAnimated(actor).setDirection(newDisposition.direction);
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + actorId + ") in the game world.");
         }
      }
      
      protected function updateActorOrientation(actorId:int, newOrientation:uint) : void
      {
         if(this._entities[actorId])
         {
            (this._entities[actorId] as GameContextActorInformations).disposition.direction = newOrientation;
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + actorId + ") in informations.");
         }
         var ac:AnimatedCharacter = DofusEntities.getEntity(actorId) as AnimatedCharacter;
         if(ac)
         {
            ac.setDirection(newOrientation);
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + actorId + ") in the game world.");
         }
      }
      
      protected function hideActor(actorId:int) : void
      {
         var disp:IDisplayable = DofusEntities.getEntity(actorId) as IDisplayable;
         if(disp)
         {
            disp.remove();
         }
         else
         {
            _log.warn("Cannot remove an unknown actor (" + actorId + ").");
         }
      }
      
      protected function removeActor(actorId:int) : void
      {
         var id:* = undefined;
         this.hideActor(actorId);
         this.updateCreaturesLimit();
         var oldCreaturesMode:Boolean = this._creaturesMode;
         this._humanNumber--;
         if(this._creaturesLimit < 50 && this._humanNumber >= this._creaturesLimit)
         {
            this._creaturesMode = true;
         }
         else
         {
            this._creaturesMode = false;
         }
         delete this._entities[actorId];
         if(oldCreaturesMode != this._creaturesMode)
         {
            for(id in this._entities)
            {
               this.updateActorLook(id,(this._entities[id] as GameContextActorInformations).look);
            }
         }
      }
      
      protected function getLook(look:EntityLook) : TiphonEntityLook
      {
         var breedId:uint = 0;
         var sub:TiphonEntityLook = null;
         var oldLook:TiphonEntityLook = EntityLookAdapter.fromNetwork(look);
         var newLook:TiphonEntityLook = oldLook;
         if(this._creaturesMode)
         {
            breedId = 0;
            if(oldLook.getBone() == 1)
            {
               switch(oldLook.skins[0])
               {
                  case 10:
                  case 11:
                     breedId = 1;
                     break;
                  case 20:
                  case 21:
                     breedId = 2;
                     break;
                  case 30:
                  case 31:
                     breedId = 3;
                     break;
                  case 40:
                  case 41:
                     breedId = 4;
                     break;
                  case 50:
                  case 51:
                     breedId = 5;
                     break;
                  case 60:
                  case 61:
                     breedId = 6;
                     break;
                  case 70:
                  case 71:
                     breedId = 7;
                     break;
                  case 80:
                  case 81:
                     breedId = 8;
                     break;
                  case 90:
                  case 91:
                     breedId = 9;
                     break;
                  case 100:
                  case 101:
                     breedId = 10;
                     break;
                  case 110:
                  case 111:
                     breedId = 11;
                     break;
                  case 120:
                  case 121:
                     breedId = 12;
               }
            }
            else if(oldLook.getBone() == 639)
            {
               sub = oldLook.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
               if(Boolean(sub) && sub.getBone() == 2)
               {
                  switch(sub.skins[0])
                  {
                     case 10:
                     case 11:
                        breedId = 1;
                        break;
                     case 20:
                     case 21:
                        breedId = 2;
                        break;
                     case 30:
                     case 31:
                        breedId = 3;
                        break;
                     case 40:
                     case 41:
                        breedId = 4;
                        break;
                     case 50:
                     case 51:
                        breedId = 5;
                        break;
                     case 60:
                     case 61:
                        breedId = 6;
                        break;
                     case 70:
                     case 71:
                        breedId = 7;
                        break;
                     case 80:
                     case 81:
                        breedId = 8;
                        break;
                     case 90:
                     case 91:
                        breedId = 9;
                        break;
                     case 100:
                     case 101:
                        breedId = 10;
                        break;
                     case 110:
                     case 111:
                        breedId = 11;
                        break;
                     case 120:
                     case 121:
                        breedId = 12;
                  }
               }
            }
            if(breedId == 0)
            {
               return oldLook;
            }
            newLook.setBone(Breed.getBreedById(breedId).creatureBonesId);
            newLook.setScales(0.9,0.9);
         }
         else if(!OptionManager.getOptionManager("tiphon").aura)
         {
            newLook.removeSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND);
         }
         return newLook;
      }
      
      protected function updateCreaturesLimit() : void
      {
         var vingtpourcent:Number = NaN;
         this._creaturesLimit = OptionManager.getOptionManager("tiphon").creaturesMode;
         if(this._creaturesMode)
         {
            vingtpourcent = this._creaturesLimit * 20 / 100;
            this._creaturesLimit = Math.ceil(this._creaturesLimit - vingtpourcent);
         }
      }
   }
}
