package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class ParamsDecoder
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ParamsDecoder));
       
      public function ParamsDecoder()
      {
         super();
      }
      
      public static function applyParams(txt:String, params:Array) : String
      {
         var c:String = null;
         var lectureType:Boolean = false;
         var lectureId:Boolean = false;
         var type:String = "";
         var id:String = "";
         var s:String = "";
         for(var i:uint = 0; i < txt.length; i++)
         {
            c = txt.charAt(i);
            if(c == "$")
            {
               lectureType = true;
            }
            else if(c == "%")
            {
               lectureType = false;
               lectureId = true;
            }
            if(lectureType)
            {
               type = type + c;
            }
            else if(lectureId)
            {
               if(c >= "0" && c <= "9" || c == "%")
               {
                  id = id + c;
                  if(i + 1 == txt.length)
                  {
                     lectureId = false;
                     s = s + processReplace(type,id,params);
                     type = "";
                     id = "";
                  }
               }
               else
               {
                  lectureId = false;
                  s = s + processReplace(type,id,params);
                  s = s + c;
                  type = "";
                  id = "";
               }
            }
            else
            {
               s = s + c;
            }
         }
         return s;
      }
      
      private static function processReplace(type:String, id:String, params:Array) : String
      {
         var nid:int = 0;
         var item:Item = null;
         var itemType:ItemType = null;
         var job:Job = null;
         var quest:Quest = null;
         var spell:Spell = null;
         var spellState:SpellState = null;
         var area:Area = null;
         var subArea:SubArea = null;
         var emote:Emoticon = null;
         var monster:Monster = null;
         var monsterRace:MonsterRace = null;
         var monsterSuperRace:MonsterSuperRace = null;
         var challenge:Challenge = null;
         var alignmentSide:AlignmentSide = null;
         var newString:String = "";
         nid = int(Number(id.substr(1))) - 1;
         if(type == "")
         {
            newString = params[nid];
         }
         else
         {
            switch(type)
            {
               case "$item":
                  item = Item.getItemById(params[nid]);
                  if(item)
                  {
                     newString = item.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$itemType":
                  itemType = ItemType.getItemTypeById(params[nid]);
                  if(itemType)
                  {
                     newString = itemType.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$job":
                  job = Job.getJobById(params[nid]);
                  if(job)
                  {
                     newString = job.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$quest":
                  quest = Quest.getQuestById(params[nid]);
                  if(quest)
                  {
                     newString = quest.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$spell":
                  spell = Spell.getSpellById(params[nid]);
                  if(spell)
                  {
                     newString = spell.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$spellState":
                  spellState = SpellState.getSpellStateById(params[nid]);
                  if(spellState)
                  {
                     newString = spellState.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$area":
                  area = Area.getAreaById(params[nid]);
                  if(area)
                  {
                     newString = area.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$subarea":
                  subArea = SubArea.getSubAreaById(params[nid]);
                  if(subArea)
                  {
                     newString = subArea.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$emote":
                  emote = Emoticon.getEmoticonById(params[nid]);
                  if(emote)
                  {
                     newString = emote.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$monster":
                  monster = Monster.getMonsterById(params[nid]);
                  if(monster)
                  {
                     newString = monster.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$monsterRace":
                  monsterRace = MonsterRace.getMonsterRaceById(params[nid]);
                  if(monsterRace)
                  {
                     newString = monsterRace.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$monsterSuperRace":
                  monsterSuperRace = MonsterSuperRace.getMonsterSuperRaceById(params[nid]);
                  if(monsterSuperRace)
                  {
                     newString = monsterSuperRace.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$challenge":
                  challenge = Challenge.getChallengeById(params[nid]);
                  if(challenge)
                  {
                     newString = challenge.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               case "$alignment":
                  alignmentSide = AlignmentSide.getAlignmentSideById(params[nid]);
                  if(alignmentSide)
                  {
                     newString = alignmentSide.name;
                  }
                  else
                  {
                     _log.error(type + " " + params[nid] + " introuvable");
                     newString = "";
                  }
                  break;
               default:
                  trace("Error ! The parameter type (" + type + ") is unknown.");
            }
         }
         return newString;
      }
   }
}
