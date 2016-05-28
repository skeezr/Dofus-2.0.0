package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import flash.geom.Point;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.types.data.PlayerSetInfo;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   
   public class PlayedCharacterApi
   {
       
      public function PlayedCharacterApi()
      {
         super();
      }
      
      [Untrusted]
      public static function characteristics() : Object
      {
         return PlayedCharacterManager.getInstance().characteristics;
      }
      
      [Untrusted]
      public static function getPlayedCharacterInfo() : Object
      {
         var i:CharacterBaseInformations = PlayedCharacterManager.getInstance().infos;
         var o:Object = new Object();
         o.id = i.id;
         o.breed = i.breed;
         o.level = i.level;
         o.sex = i.sex;
         o.name = i.name;
         o.entityLook = EntityLookAdapter.fromNetwork(i.entityLook);
         return o;
      }
      
      [Untrusted]
      public static function getInventory() : Array
      {
         return PlayedCharacterManager.getInstance().inventory;
      }
      
      [Untrusted]
      public static function getSpellInventory() : Array
      {
         return PlayedCharacterManager.getInstance().spellsInventory;
      }
      
      [Untrusted]
      public static function getJobs() : Array
      {
         return PlayedCharacterManager.getInstance().jobs;
      }
      
      [Untrusted]
      public static function getMount() : Object
      {
         return PlayedCharacterManager.getInstance().mount;
      }
      
      [Untrusted]
      public static function inventoryWeight() : uint
      {
         return PlayedCharacterManager.getInstance().inventoryWeight;
      }
      
      [Untrusted]
      public static function inventoryWeightMax() : uint
      {
         return PlayedCharacterManager.getInstance().inventoryWeightMax;
      }
      
      [Untrusted]
      public static function isInHouse() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHouse;
      }
      
      [Untrusted]
      public static function getLastCoord() : Point
      {
         return PlayedCharacterManager.getInstance().lastCoord;
      }
      
      [Untrusted]
      public static function isInExchange() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInExchange;
      }
      
      [Untrusted]
      public static function isInFight() : Boolean
      {
         return Kernel.getWorker().getFrame(FightContextFrame) != null;
      }
      
      [Untrusted]
      public static function isInPreFight() : Boolean
      {
         return Kernel.getWorker().getFrame(FightPreparationFrame) != null;
      }
      
      [Untrusted]
      public static function isInParty() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInParty;
      }
      
      [Untrusted]
      public static function isPartyLeader() : Boolean
      {
         return PlayedCharacterManager.getInstance().isPartyLeader;
      }
      
      [Untrusted]
      public static function isRidding() : Boolean
      {
         return PlayedCharacterManager.getInstance().isRidding;
      }
      
      [Untrusted]
      public static function id() : uint
      {
         return PlayedCharacterManager.getInstance().id;
      }
      
      [Untrusted]
      public static function restrictions() : ActorRestrictionsInformations
      {
         return PlayedCharacterManager.getInstance().restrictions;
      }
      
      [Untrusted]
      public static function publicMode() : Boolean
      {
         return PlayedCharacterManager.getInstance().publicMode;
      }
      
      [Untrusted]
      public static function artworkId() : int
      {
         return PlayedCharacterManager.getInstance().artworkId;
      }
      
      [Untrusted]
      public static function getAlignmentSide() : int
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentSide;
      }
      
      [Untrusted]
      public static function getAlignmentValue() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentValue;
      }
      
      [Untrusted]
      public static function getAlignmentGrade() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.alignmentInfos.alignmentGrade;
      }
      
      [Untrusted]
      public static function getMaxSummonedCreature() : uint
      {
         return PlayedCharacterManager.getInstance().characteristics.summonableCreaturesBoost.base + PlayedCharacterManager.getInstance().characteristics.summonableCreaturesBoost.objectsAndMountBonus + PlayedCharacterManager.getInstance().characteristics.summonableCreaturesBoost.alignGiftBonus + PlayedCharacterManager.getInstance().characteristics.summonableCreaturesBoost.contextModif;
      }
      
      [Untrusted]
      public static function getCurrentSummonedCreature() : uint
      {
         return PlayedCharacterManager.getInstance().currentSummonedCreature;
      }
      
      [Untrusted]
      public static function canSummon() : Boolean
      {
         return getMaxSummonedCreature() >= getCurrentSummonedCreature() + 1;
      }
      
      [Untrusted]
      public static function canCastThisSpell(spellId:uint, lvl:uint) : Boolean
      {
         return PlayedCharacterManager.getInstance().canCastThisSpell(spellId,lvl);
      }
      
      [Untrusted]
      public static function isInHisHouse() : Boolean
      {
         return PlayedCharacterManager.getInstance().isInHisHouse;
      }
      
      [Untrusted]
      public static function currentMap() : WorldPoint
      {
         return PlayedCharacterManager.getInstance().currentMap;
      }
      
      [Untrusted]
      public static function currentSubArea() : SubArea
      {
         return PlayedCharacterManager.getInstance().currentSubArea;
      }
      
      [Untrusted]
      public static function state() : uint
      {
         return PlayedCharacterManager.getInstance().state;
      }
      
      [Untrusted]
      public static function isAlive() : Boolean
      {
         return PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING;
      }
      
      [Untrusted]
      public static function isFollowingPlayer() : Boolean
      {
         return PlayedCharacterManager.getInstance().isFollowingPlayer;
      }
      
      [Untrusted]
      public static function getFollowingPlayerId() : int
      {
         return PlayedCharacterManager.getInstance().followingPlayerId;
      }
      
      [Untrusted]
      public static function getPlayerSet(objectUID:uint) : PlayerSetInfo
      {
         return PlayedCharacterUpdatesFrame(Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame)).getPlayerSet(objectUID);
      }
      
      [Untrusted]
      public static function getWeapon() : ItemWrapper
      {
         var item:ItemWrapper = null;
         var inventory:Array = PlayedCharacterManager.getInstance().inventory;
         var nb:int = inventory.length;
         for(var i:int = 0; i < nb; i++)
         {
            item = inventory[i];
            if(item.position == 1)
            {
               return item;
            }
         }
         return null;
      }
      
      [Untrusted]
      public static function knowSpell(pSpellId:uint) : int
      {
         var obtentionSpellLevel:uint = 0;
         var playerSpellLevel:uint = 0;
         var sp:SpellWrapper = null;
         var disable:Boolean = false;
         var spellWrapper:SpellWrapper = null;
         var spellIDLevelZero:uint = 0;
         var spellLevelZero:SpellLevel = null;
         var spell:Spell = Spell.getSpellById(pSpellId);
         var spellLevel:SpellLevel = SpellLevel.getLevelById(pSpellId);
         if(pSpellId == 0)
         {
            obtentionSpellLevel = 0;
         }
         else
         {
            spellIDLevelZero = spell.spellLevels[0];
            spellLevelZero = SpellLevel.getLevelById(spellIDLevelZero);
            obtentionSpellLevel = spellLevelZero.minPlayerLevel;
         }
         var spellInv:Array = getSpellInventory();
         for each(sp in spellInv)
         {
            if(sp.spellId == pSpellId)
            {
               playerSpellLevel = sp.spellLevel;
            }
         }
         disable = true;
         for each(spellWrapper in spellInv)
         {
            if(spellWrapper.spellId == pSpellId)
            {
               disable = false;
            }
         }
         if(disable)
         {
            return -1;
         }
         return playerSpellLevel;
      }
   }
}
