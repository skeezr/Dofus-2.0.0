package com.ankamagames.atouin.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import flash.display.Sprite;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.types.enums.InteractionsEnum;
   import flash.events.Event;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.atouin.Atouin;
   
   public class EntitiesManager
   {
      
      private static const RANDOM_ENTITIES_ID_START:uint = 1000000;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.managers.EntitiesManager));
      
      private static var _self:com.ankamagames.atouin.managers.EntitiesManager;
       
      private var _entities:Array;
      
      private var _currentRandomEntity:uint = 1000000;
      
      public function EntitiesManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : MobilesManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         this._entities = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public static function getInstance() : com.ankamagames.atouin.managers.EntitiesManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.managers.EntitiesManager();
         }
         return _self;
      }
      
      public function addAnimatedEntity(entityID:int, entity:IEntity, strata:uint) : void
      {
         if(this._entities[entityID] != null)
         {
            _log.warn("Entity overwriting! Entity " + entityID + " has been replaced.");
         }
         this._entities[entityID] = entity;
         if(entity is IDisplayable)
         {
            EntitiesDisplayManager.getInstance().displayEntity(entity as IDisplayable,entity.position,strata);
         }
         if(entity is IInteractive)
         {
            this.registerInteractions(IInteractive(entity),true);
            Sprite(entity).buttonMode = IInteractive(entity).useHandCursor;
         }
      }
      
      public function getEntity(entityID:int) : IEntity
      {
         return this._entities[entityID];
      }
      
      public function getEntityID(entity:IEntity) : int
      {
         var i:* = null;
         for(i in this._entities)
         {
            if(entity === this._entities[i])
            {
               return parseInt(i);
            }
         }
         return 0;
      }
      
      public function removeEntity(entityID:int) : void
      {
         if(this._entities[entityID])
         {
            if(this._entities[entityID] is IDisplayable)
            {
               EntitiesDisplayManager.getInstance().removeEntity(this._entities[entityID] as IDisplayable);
            }
            if(this._entities[entityID] is IInteractive)
            {
               this.registerInteractions(IInteractive(this._entities[entityID]),false);
            }
            if(this._entities[entityID] is IMovable && Boolean(IMovable(this._entities[entityID]).isMoving))
            {
               IMovable(this._entities[entityID]).stop(true);
            }
            delete this._entities[entityID];
         }
      }
      
      public function clearEntities() : void
      {
         var id:* = null;
         for(id in this._entities)
         {
            if(this._entities[id] is IDisplayable)
            {
               IDisplayable(this._entities[id]).remove();
            }
         }
      }
      
      public function get entities() : Array
      {
         return this._entities;
      }
      
      public function getFreeEntityId() : int
      {
         while(true)
         {
            if(this._entities[++this._currentRandomEntity] == null)
            {
               break;
            }
            this._currentRandomEntity++;
         }
         return this._currentRandomEntity;
      }
      
      private function registerInteractions(entity:IInteractive, register:Boolean) : void
      {
         var index:uint = 0;
         var interactions:uint = entity.enabledInteractions;
         while(interactions > 0)
         {
            this.registerInteraction(entity,1 << index++,register);
            interactions = interactions >> 1;
         }
      }
      
      public function registerInteraction(entity:IInteractive, interactionType:uint, enabled:Boolean) : void
      {
         var event:String = null;
         var events:Array = InteractionsEnum.getEvents(interactionType);
         for each(event in events)
         {
            if(Boolean(enabled) && !entity.hasEventListener(event))
            {
               entity.addEventListener(event,this.onInteraction,false,0,true);
            }
            else if(!enabled && Boolean(entity.hasEventListener(event)))
            {
               entity.removeEventListener(event,this.onInteraction,false);
            }
         }
      }
      
      public function getEntityOnCell(cellId:uint, oClass:* = null) : IEntity
      {
         var e:IEntity = null;
         var i:uint = 0;
         var useFilter:* = oClass != null;
         var isMultiFilter:Boolean = Boolean(useFilter) && oClass is Array;
         for each(e in this._entities)
         {
            if(Boolean(e) && e.position.cellId == cellId)
            {
               if(!isMultiFilter)
               {
                  if(!useFilter || !isMultiFilter && e is oClass)
                  {
                     return e;
                  }
               }
               else
               {
                  for(i = 0; i < (oClass as Array).length; i++)
                  {
                     if(e is oClass[i])
                     {
                        return e;
                     }
                  }
               }
               continue;
            }
         }
         return null;
      }
      
      public function getEntitiesOnCell(cellId:uint, oClass:* = null) : Array
      {
         var e:IEntity = null;
         var i:uint = 0;
         var useFilter:* = oClass != null;
         var isMultiFilter:Boolean = Boolean(useFilter) && oClass is Array;
         var result:Array = [];
         for each(e in this._entities)
         {
            if(Boolean(e) && e.position.cellId == cellId)
            {
               if(!isMultiFilter)
               {
                  if(!useFilter || !isMultiFilter && e is oClass)
                  {
                     result.push(e);
                  }
               }
               else
               {
                  for(i = 0; i < (oClass as Array).length; i++)
                  {
                     if(e is oClass[i])
                     {
                        result.push(e);
                     }
                  }
               }
               continue;
            }
         }
         return result;
      }
      
      private function onInteraction(e:Event) : void
      {
         var entity:IInteractive = IInteractive(e.target);
         entity.handler.process(new InteractionsEnum.getMessage(e.type)(entity));
      }
      
      private function onPropertyChanged(e:PropertyChangeEvent) : void
      {
         var ent:IEntity = null;
         if(e.propertyName == "transparentOverlayMode")
         {
            for each(ent in this._entities)
            {
               if(ent is IDisplayable)
               {
                  EntitiesDisplayManager.getInstance().refreshAlphaEntity(ent as IDisplayable,ent.position);
               }
            }
         }
      }
   }
}
