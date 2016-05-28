package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.notifications.Notification;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellType;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.NpcAction;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.guild.RankName;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.datacenter.communication.SmileyItem;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.dofus.internalDatacenter.items.LivingObjectSkinWrapper;
   import com.ankamagames.dofus.datacenter.abuse.AbuseReasons;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class DataApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function DataApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DataApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Trusted]
      public function getNotifications() : Array
      {
         return Notification.getNotifications();
      }
      
      [Trusted]
      public function getServer(id:int) : Server
      {
         return Server.getServerById(id);
      }
      
      [Trusted]
      public function getBreed(id:int) : Breed
      {
         return Breed.getBreedById(id);
      }
      
      [Trusted]
      public function getSpell(id:int) : Spell
      {
         return Spell.getSpellById(id);
      }
      
      [Untrusted]
      public function getSpellItem(id:uint, level:uint = 1) : SpellWrapper
      {
         var sw:SpellWrapper = SpellWrapper.create(0,id,level,false);
         return sw;
      }
      
      [Trusted]
      public function getSpellLevel(id:int) : SpellLevel
      {
         return SpellLevel.getLevelById(id);
      }
      
      [Trusted]
      public function getSpellType(id:int) : SpellType
      {
         return SpellType.getSpellTypeById(id);
      }
      
      [Trusted]
      public function getSpellState(id:int) : SpellState
      {
         return SpellState.getSpellStateById(id);
      }
      
      [Trusted]
      public function getChatChannel(id:int) : ChatChannel
      {
         return ChatChannel.getChannelById(id);
      }
      
      [Trusted]
      public function getAllChatChannels() : Array
      {
         return ChatChannel.getChannels();
      }
      
      [Trusted]
      public function getSubArea(id:int) : SubArea
      {
         return SubArea.getSubAreaById(id);
      }
      
      [Trusted]
      public function getSubAreaFromMap(mapId:int) : SubArea
      {
         return SubArea.getSubAreaByMapId(mapId);
      }
      
      [Trusted]
      public function getArea(id:int) : Area
      {
         return Area.getAreaById(id);
      }
      
      [Trusted]
      public function getWorldPoint(id:int) : WorldPoint
      {
         return WorldPoint.fromMapId(id);
      }
      
      [Trusted]
      public function getItem(id:int) : Item
      {
         return Item.getItemById(id);
      }
      
      [Trusted]
      public function getItemName(id:int) : String
      {
         return Item.getItemById(id).name;
      }
      
      [Trusted]
      public function getItemType(id:int) : String
      {
         return ItemType.getItemTypeById(id).name;
      }
      
      [Untrusted]
      public function getMonsterFromId(monsterId:uint) : Monster
      {
         return Monster.getMonsterById(monsterId);
      }
      
      [Untrusted]
      public function getNpc(npcId:uint) : Npc
      {
         return Npc.getNpcById(npcId);
      }
      
      [Untrusted]
      public function getNpcAction(actionId:uint) : NpcAction
      {
         return NpcAction.getNpcActionById(actionId);
      }
      
      [Untrusted]
      public function getAlignmentSide(sideId:uint) : AlignmentSide
      {
         return AlignmentSide.getAlignmentSideById(sideId);
      }
      
      [Untrusted]
      public function getRankName(rankId:uint) : RankName
      {
         return RankName.getRankNameById(rankId);
      }
      
      [Untrusted]
      public function getAllRankNames() : Array
      {
         return RankName.getRankNames();
      }
      
      [Untrusted]
      public function getItemWrapper(itemId:uint) : ItemWrapper
      {
         return ItemWrapper.create(0,0,itemId,0,null,false);
      }
      
      [Untrusted]
      public function getInfoMessage(infoMsgId:uint) : InfoMessage
      {
         return InfoMessage.getInfoMessageById(infoMsgId);
      }
      
      [Untrusted]
      public function getAllInfoMessages() : Array
      {
         return InfoMessage.getInfoMessages();
      }
      
      [Untrusted]
      public function getSmilies() : Array
      {
         var a:Array = new Array();
         for(var i:uint = 1; i < 31; i++)
         {
            a.push(new SmileyItem(i,i));
         }
         return a;
      }
      
      [Untrusted]
      public function getTaxCollectorName(id:uint) : TaxCollectorName
      {
         return TaxCollectorName.getTaxCollectorNameById(id);
      }
      
      [Untrusted]
      public function getTaxCollectorFirstname(id:uint) : TaxCollectorFirstname
      {
         return TaxCollectorFirstname.getTaxCollectorFirstnameById(id);
      }
      
      [Untrusted]
      public function getEmblems() : Array
      {
         var upEmblemTotal:uint = 104;
         var backEmblemTotal:uint = 17;
         var upEmblems:Array = new Array();
         var backEmblems:Array = new Array();
         for(var i:uint = 1; i <= upEmblemTotal; i++)
         {
            upEmblems.push(EmblemWrapper.create(i,EmblemWrapper.UP));
         }
         for(var j:uint = 1; j <= backEmblemTotal; j++)
         {
            if(j != 21)
            {
               backEmblems.push(EmblemWrapper.create(j,EmblemWrapper.BACK));
            }
         }
         var returnValue:Array = new Array(upEmblems,backEmblems);
         return returnValue;
      }
      
      [Untrusted]
      public function getQuest(questId:int) : Quest
      {
         return Quest.getQuestById(questId);
      }
      
      [Untrusted]
      public function getQuestObjective(questObjectiveId:int) : QuestObjective
      {
         return QuestObjective.getQuestObjectiveById(questObjectiveId);
      }
      
      [Untrusted]
      public function getQuestStep(questStepId:int) : QuestStep
      {
         return QuestStep.getQuestStepById(questStepId);
      }
      
      [Untrusted]
      public function getHouse(houseId:int) : House
      {
         return House.getGuildHouseById(houseId);
      }
      
      [Untrusted]
      public function getLivingObjectSkins(item:ItemWrapper) : Array
      {
         var array:Array = new Array();
         for(var i:int = 1; i <= item.livingObjectLevel; i++)
         {
            array.push(LivingObjectSkinWrapper.create(item.livingObjectCategory,item.livingObjectMood,i));
         }
         return array;
      }
      
      [Untrusted]
      public function getAbuseReasonName(abuseReasonId:uint) : AbuseReasons
      {
         return AbuseReasons.getReasonNameById(abuseReasonId);
      }
      
      [Untrusted]
      public function getAllAbuseReasons() : Array
      {
         return AbuseReasons.getReasonNames();
      }
      
      [Untrusted]
      public function getMapInfo(mapId:uint) : MapPosition
      {
         return MapPosition.getMapPositionById(mapId);
      }
   }
}
