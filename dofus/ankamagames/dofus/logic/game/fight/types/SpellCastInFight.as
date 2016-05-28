package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   
   public class SpellCastInFight
   {
       
      private var _minCastInterval:uint;
      
      private var _maxCastPerTurn:int;
      
      private var _spellId:uint;
      
      private var _nextCast:uint;
      
      private var _numberOfCastLeft:int;
      
      private var _casterId:int;
      
      private var _spellWrapper:SpellWrapper;
      
      public function SpellCastInFight(casterId:int, pSpellId:uint, pMinCastInterval:uint, pMaxCastPerTurn:int = -1)
      {
         super();
         this._casterId = casterId;
         this._spellId = pSpellId;
         this._minCastInterval = pMinCastInterval;
         this._maxCastPerTurn = pMaxCastPerTurn;
         this._nextCast = pMinCastInterval;
         this._numberOfCastLeft = pMaxCastPerTurn - 1;
         this._spellWrapper = SpellWrapper.getSpellWrapperById(this._spellId,this._casterId);
         if(this._spellWrapper)
         {
            this._spellWrapper.actualCooldown = this._nextCast;
         }
      }
      
      public function get minCastInterval() : uint
      {
         return this._minCastInterval;
      }
      
      public function get maxCastPerTurn() : int
      {
         return this._maxCastPerTurn;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
      
      public function get nextCast() : int
      {
         return this._nextCast;
      }
      
      public function get numberOfCastLeft() : int
      {
         return this._numberOfCastLeft;
      }
      
      public function get casterId() : int
      {
         return this._casterId;
      }
      
      public function update(pNextCast:uint, pNumberOfCastLeft:int = -1) : void
      {
         this._nextCast = pNextCast;
         this._numberOfCastLeft = pNumberOfCastLeft;
         if(this._spellWrapper)
         {
            this._spellWrapper.actualCooldown = this._nextCast;
         }
      }
   }
}
