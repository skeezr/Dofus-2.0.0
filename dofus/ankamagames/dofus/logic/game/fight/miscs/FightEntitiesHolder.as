package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.dofus.logic.game.common.misc.IEntityLocalizer;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   
   public class FightEntitiesHolder implements IEntityLocalizer
   {
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
       
      private var _holdedEntities:Array;
      
      public function FightEntitiesHolder()
      {
         this._holdedEntities = [];
         super();
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder();
            DofusEntities.registerLocalizer(_self);
         }
         return _self;
      }
      
      public function getEntity(entityId:int) : IEntity
      {
         return this._holdedEntities[entityId];
      }
      
      public function holdEntity(entity:IEntity) : void
      {
         this._holdedEntities[entity.id] = entity;
      }
      
      public function unholdEntity(entityId:int) : void
      {
         delete this._holdedEntities[entityId];
      }
      
      public function getEntities() : Array
      {
         return this._holdedEntities;
      }
      
      public function unregistered() : void
      {
         _self = null;
      }
   }
}
