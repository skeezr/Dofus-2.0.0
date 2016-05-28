package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.datacenter.servers.ServerCommunity;
   import com.ankamagames.dofus.datacenter.servers.ServerGameType;
   import com.ankamagames.dofus.datacenter.servers.ServerPopulation;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.notifications.Notification;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellType;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.MapReference;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.datacenter.items.Weapon;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.items.ItemSet;
   import com.ankamagames.dofus.datacenter.misc.Month;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.NpcAction;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentEffect;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentOrder;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRank;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRankJntGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentTitle;
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.datacenter.common.BasicActionInfo;
   import com.ankamagames.dofus.datacenter.communication.SmileyItem;
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.dofus.datacenter.guild.RankName;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.interactives.MapInteractive;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestObjectiveType;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestReward;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardEmote;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardExperience;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardItem;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardJob;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardKamas;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardSpell;
   import com.ankamagames.dofus.datacenter.quest.rewards.QuestRewardType;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveBringItemToNpc;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveBringSoulToNpc;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveDiscoverMap;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveDiscoverSubArea;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveDuelSpecificPlayer;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveFightMonster;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveFreeForm;
   import com.ankamagames.dofus.datacenter.quest.objectives.QuestObjectiveGoToNpc;
   import com.ankamagames.dofus.datacenter.mounts.Mount;
   import com.ankamagames.dofus.datacenter.mounts.MountBehavior;
   import com.ankamagames.dofus.datacenter.documents.Document;
   import com.ankamagames.dofus.datacenter.misc.Appearance;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemsTrigger;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemText;
   import com.ankamagames.dofus.datacenter.livingObjects.LivingObjectSkinJntMood;
   import com.ankamagames.dofus.datacenter.abuse.AbuseReasons;
   import com.ankamagames.dofus.datacenter.misc.Tips;
   
   public class GameDataList
   {
      
      protected static const server:Server = null;
      
      protected static const serverCommunity:ServerCommunity = null;
      
      protected static const serverGameType:ServerGameType = null;
      
      protected static const serverPopulation:ServerPopulation = null;
      
      protected static const monster:Monster = null;
      
      protected static const monsterGrade:MonsterGrade = null;
      
      protected static const monsterRace:MonsterRace = null;
      
      protected static const monsterSuperRace:MonsterSuperRace = null;
      
      protected static const notification:Notification = null;
      
      protected static const spell:Spell = null;
      
      protected static const effect:Effect = null;
      
      protected static const effectInstance:EffectInstance = null;
      
      protected static const spellLevel:SpellLevel = null;
      
      protected static const spellType:SpellType = null;
      
      protected static const spellState:SpellState = null;
      
      protected static const breed:Breed = null;
      
      protected static const superArea:SuperArea = null;
      
      protected static const area:Area = null;
      
      protected static const wolrdMap:WorldMap = null;
      
      protected static const subArea:SubArea = null;
      
      protected static const hint:Hint = null;
      
      protected static const mapPosition:MapPosition = null;
      
      protected static const mapReference:MapReference = null;
      
      protected static const item:Item = null;
      
      protected static const chatChannel:ChatChannel = null;
      
      protected static const weapon:Weapon = null;
      
      protected static const job:Job = null;
      
      protected static const skill:Skill = null;
      
      protected static const recipe:Recipe = null;
      
      protected static const itemSet:ItemSet = null;
      
      protected static const month:Month = null;
      
      protected static const npc:Npc = null;
      
      protected static const npcAction:NpcAction = null;
      
      protected static const infoMessage:InfoMessage = null;
      
      protected static const taxCollectorFirstname:TaxCollectorFirstname = null;
      
      protected static const taxCollectorName:TaxCollectorName = null;
      
      protected static const challenge:Challenge = null;
      
      protected static const alignmentBalance:AlignmentBalance = null;
      
      protected static const alignmentEffect:AlignmentEffect = null;
      
      protected static const alignmentGift:AlignmentGift = null;
      
      protected static const alignmentOrder:AlignmentOrder = null;
      
      protected static const alignmentRank:AlignmentRank = null;
      
      protected static const alignmentRankJntGift:AlignmentRankJntGift = null;
      
      protected static const alignmentSide:AlignmentSide = null;
      
      protected static const alignmentTitle:AlignmentTitle = null;
      
      protected static const ambientSound:AmbientSound = null;
      
      protected static const basicActionInfo:BasicActionInfo = null;
      
      protected static const smileyItem:SmileyItem = null;
      
      protected static const house:House = null;
      
      protected static const rankName:RankName = null;
      
      protected static const interactive:Interactive = null;
      
      protected static const mapInteractive:MapInteractive = null;
      
      protected static const itemType:ItemType = null;
      
      protected static const emoticon:Emoticon = null;
      
      protected static const quest:Quest = null;
      
      protected static const questStep:QuestStep = null;
      
      protected static const questObjective:QuestObjective = null;
      
      protected static const questObjectiveType:QuestObjectiveType = null;
      
      protected static const questReward:QuestReward = null;
      
      protected static const questRewardEmote:QuestRewardEmote = null;
      
      protected static const questRewardExperience:QuestRewardExperience = null;
      
      protected static const questRewardItem:QuestRewardItem = null;
      
      protected static const questRewardJob:QuestRewardJob = null;
      
      protected static const questRewardKamas:QuestRewardKamas = null;
      
      protected static const questRewardSpell:QuestRewardSpell = null;
      
      protected static const questRewardType:QuestRewardType = null;
      
      protected static const questObjectiveBringItemToNpc:QuestObjectiveBringItemToNpc = null;
      
      protected static const questObjectiveBringSoulToNpc:QuestObjectiveBringSoulToNpc = null;
      
      protected static const questObjectiveDiscoverMap:QuestObjectiveDiscoverMap = null;
      
      protected static const questObjectiveDiscoverSubArea:QuestObjectiveDiscoverSubArea = null;
      
      protected static const questObjectiveDuelSpecificPlayer:QuestObjectiveDuelSpecificPlayer = null;
      
      protected static const questObjectiveFightMonster:QuestObjectiveFightMonster = null;
      
      protected static const questObjectiveFreeForm:QuestObjectiveFreeForm = null;
      
      protected static const questObjectiveGoToNpc:QuestObjectiveGoToNpc = null;
      
      protected static const mount:Mount = null;
      
      protected static const mountBehavior:MountBehavior = null;
      
      protected static const document:Document = null;
      
      protected static const appearance:Appearance = null;
      
      protected static const speakingItemsTrigger:SpeakingItemsTrigger = null;
      
      protected static const speakingItemText:SpeakingItemText = null;
      
      protected static const livingObjectSkinJntMood:LivingObjectSkinJntMood = null;
      
      protected static const abuseReasons:AbuseReasons = null;
      
      protected static const tips:Tips = null;
       
      public function GameDataList()
      {
         super();
      }
   }
}
