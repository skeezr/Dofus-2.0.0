package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import flash.geom.Point;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.datacenter.items.Weapon;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFight;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class PlayedCharacterManager implements IDestroyable
   {
      
      private static var _self:com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager));
       
      private var _isPartyLeader:Boolean = false;
      
      private var _followingPlayerId:int = -1;
      
      private var _isFollowingPlayer:Boolean = false;
      
      public var infos:CharacterBaseInformations;
      
      public var restrictions:ActorRestrictionsInformations;
      
      public var characteristics:CharacterCharacteristicsInformations;
      
      public var spellsInventory:Array;
      
      public var inventory:Array;
      
      public var currentWeapon:Object;
      
      public var inventoryWeight:uint;
      
      public var inventoryWeightMax:uint;
      
      public var currentMap:WorldPoint;
      
      public var currentSubArea:SubArea;
      
      public var jobs:Array;
      
      public var isInExchange:Boolean = false;
      
      public var isInHisHouse:Boolean = false;
      
      public var isInHouse:Boolean = false;
      
      public var lastCoord:Point;
      
      public var isInParty:Boolean = false;
      
      public var state:uint;
      
      public var fightStates:Array;
      
      public var publicMode:Boolean = false;
      
      public var isRidding:Boolean = false;
      
      public var mount:Object;
      
      public var currentSummonedCreature:uint = 0;
      
      public var isFighting:Boolean = false;
      
      public var isSpectator:Boolean = false;
      
      public function PlayedCharacterManager()
      {
         this.lastCoord = new Point(0,0);
         super();
         if(_self != null)
         {
            throw new SingletonError("PlayedCharacterManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager();
         }
         return _self;
      }
      
      public function get id() : int
      {
         return this.infos.id;
      }
      
      public function get cantMinimize() : Boolean
      {
         return this.restrictions.cantMinimize;
      }
      
      public function get forceSlowWalk() : Boolean
      {
         return this.restrictions.forceSlowWalk;
      }
      
      public function get cantUseTaxCollector() : Boolean
      {
         return this.restrictions.cantUseTaxCollector;
      }
      
      public function get cantTrade() : Boolean
      {
         return this.restrictions.cantTrade;
      }
      
      public function get cantRun() : Boolean
      {
         return this.restrictions.cantRun;
      }
      
      public function get cantMove() : Boolean
      {
         return this.restrictions.cantMove;
      }
      
      public function get cantBeChallenged() : Boolean
      {
         return this.restrictions.cantBeChallenged;
      }
      
      public function get cantBeAttackedByMutant() : Boolean
      {
         return this.restrictions.cantBeAttackedByMutant;
      }
      
      public function get cantBeAggressed() : Boolean
      {
         return this.restrictions.cantBeAggressed;
      }
      
      public function get cantAttack() : Boolean
      {
         return this.restrictions.cantAttack;
      }
      
      public function get cantAgress() : Boolean
      {
         return this.restrictions.cantAggress;
      }
      
      public function get cantChallenge() : Boolean
      {
         return this.restrictions.cantChallenge;
      }
      
      public function get cantExchange() : Boolean
      {
         return this.restrictions.cantExchange;
      }
      
      public function get cantChat() : Boolean
      {
         return this.restrictions.cantChat;
      }
      
      public function get cantBeMerchant() : Boolean
      {
         return this.restrictions.cantBeMerchant;
      }
      
      public function get cantUseObject() : Boolean
      {
         return this.restrictions.cantUseObject;
      }
      
      public function get cantUseInteractiveObject() : Boolean
      {
         return this.restrictions.cantUseInteractive;
      }
      
      public function get cantSpeakToNpc() : Boolean
      {
         return this.restrictions.cantSpeakToNPC;
      }
      
      public function get cantChangeZone() : Boolean
      {
         return this.restrictions.cantChangeZone;
      }
      
      public function get cantAttackMonster() : Boolean
      {
         return this.restrictions.cantAttackMonster;
      }
      
      public function get cantWalkInEightDirections() : Boolean
      {
         return this.restrictions.cantWalk8Directions;
      }
      
      public function set isPartyLeader(b:Boolean) : void
      {
         if(!this.isInParty)
         {
            this._isPartyLeader = false;
         }
         else
         {
            this._isPartyLeader = b;
         }
      }
      
      public function get isPartyLeader() : Boolean
      {
         return this._isPartyLeader;
      }
      
      public function get artworkId() : uint
      {
         return this.infos.entityLook.bonesId == 1?uint(this.infos.entityLook.skins[0]):uint(this.infos.entityLook.bonesId);
      }
      
      public function get followingPlayerId() : int
      {
         if(!this.isFollowingPlayer)
         {
            return -1;
         }
         return this._followingPlayerId;
      }
      
      public function set followingPlayerId(pPlayerId:int) : void
      {
         this.isFollowingPlayer = true;
         this._followingPlayerId = pPlayerId;
      }
      
      public function get isFollowingPlayer() : Boolean
      {
         return this._isFollowingPlayer;
      }
      
      public function set isFollowingPlayer(pFollow:Boolean) : void
      {
         if(pFollow)
         {
            this._isFollowingPlayer = true;
         }
         else
         {
            this._isFollowingPlayer = false;
            this._followingPlayerId = -1;
         }
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function get tiphonEntityLook() : TiphonEntityLook
      {
         return EntityLookAdapter.fromNetwork(this.infos.entityLook);
      }
      
      public function resetSummonedCreature() : void
      {
         this.currentSummonedCreature = 0;
      }
      
      public function addSummonedCreature() : void
      {
         this.currentSummonedCreature = this.currentSummonedCreature + 1;
      }
      
      public function removeSummonedCreature() : void
      {
         this.currentSummonedCreature = this.currentSummonedCreature - 1;
      }
      
      private function getMaxSummonedCreature() : uint
      {
         return this.characteristics.summonableCreaturesBoost.base + this.characteristics.summonableCreaturesBoost.objectsAndMountBonus + this.characteristics.summonableCreaturesBoost.alignGiftBonus + this.characteristics.summonableCreaturesBoost.contextModif;
      }
      
      private function getCurrentSummonedCreature() : uint
      {
         return this.currentSummonedCreature;
      }
      
      private function canSummon() : Boolean
      {
         return this.getMaxSummonedCreature() >= this.getCurrentSummonedCreature() + 1;
      }
      
      public function canCastThisSpell(spellId:uint, lvl:uint) : Boolean
      {
         var apCost:uint = 0;
         var state:* = undefined;
         var stateRequired:* = undefined;
         var weapon:Weapon = null;
         var currentState:SpellState = null;
         var entityListCastSpell:Object = null;
         var spellCastInFight:SpellCastInFight = null;
         var spell:Spell = Spell.getSpellById(spellId);
         var spellLevel:SpellLevel = spell.getSpellLevel(lvl);
         if(spellLevel == null)
         {
            return false;
         }
         var currentPA:uint = this.characteristics.actionPointsCurrent;
         if(spellId == 0 && this.currentWeapon != null)
         {
            weapon = Item.getItemById(this.currentWeapon.objectGID) as Weapon;
            apCost = weapon.apCost;
         }
         else
         {
            apCost = spellLevel.apCost;
         }
         if(apCost > currentPA)
         {
            return false;
         }
         for each(state in this.fightStates)
         {
            currentState = SpellState.getSpellStateById(state);
            if(Boolean(currentState.preventsFight) && spellId == 0)
            {
               return false;
            }
            if(Boolean(spellLevel.statesForbidden) && spellLevel.statesForbidden.indexOf(state) != -1)
            {
               return false;
            }
            if(currentState.preventsSpellCast)
            {
               if(spellLevel.statesRequired)
               {
                  if(spellLevel.statesRequired.indexOf(state) == -1)
                  {
                     return false;
                  }
                  continue;
               }
               return false;
            }
         }
         for each(stateRequired in spellLevel.statesRequired)
         {
            if(!this.fightStates || Boolean(this.fightStates) && Boolean(this.fightStates.indexOf(stateRequired) == -1))
            {
               return false;
            }
         }
         if(Boolean(spellLevel.canSummon) && !this.canSummon())
         {
            return false;
         }
         var fightBattleFrame:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(fightBattleFrame != null)
         {
            for each(entityListCastSpell in fightBattleFrame.entitiesListCastSpell)
            {
               if(entityListCastSpell.entityId == this.id)
               {
                  for each(spellCastInFight in entityListCastSpell.spellCastInFight)
                  {
                     if(spellCastInFight.spellId == spellId)
                     {
                        if(spellCastInFight.nextCast > 0)
                        {
                           return false;
                        }
                        if(spellCastInFight.numberOfCastLeft <= 0)
                        {
                           return false;
                        }
                     }
                  }
               }
            }
            return true;
         }
         return true;
      }
      
      public function levelDiff(targetLevel:uint) : int
      {
         var diff:int = 0;
         var playerLevel:int = this.infos.level;
         var type:int = 1;
         if(targetLevel < playerLevel)
         {
            type = -1;
         }
         if(Math.abs(targetLevel - playerLevel) > 20)
         {
            diff = 1 * type;
         }
         else if(targetLevel < playerLevel)
         {
            if(targetLevel / playerLevel < 1.2)
            {
               diff = 0;
            }
            else
            {
               diff = 1 * type;
            }
         }
         else if(playerLevel / targetLevel < 1.2)
         {
            diff = 0;
         }
         else
         {
            diff = 1 * type;
         }
         return diff;
      }
   }
}
