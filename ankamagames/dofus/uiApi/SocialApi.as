package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.utils.misc.CopyObject;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class SocialApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _socialFrame:SocialFrame;
      
      public function SocialApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(SocialApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      public function get socialFrame() : SocialFrame
      {
         if(!this._socialFrame)
         {
            this._socialFrame = Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
         }
         return this._socialFrame;
      }
      
      [Untrusted]
      public function getFriendsList() : Array
      {
         var friend:* = undefined;
         var fl:Array = new Array();
         for each(friend in this.socialFrame.friendsList)
         {
            fl.push(friend);
         }
         return fl;
      }
      
      [Untrusted]
      public function isFriend(playerName:String) : Boolean
      {
         var friend:* = undefined;
         for each(friend in this.socialFrame.friendsList)
         {
            if(friend.playerName == playerName)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getEnemiesList() : Array
      {
         var enemy:* = undefined;
         var people:Object = null;
         var el:Array = new Array();
         for each(enemy in this.socialFrame.enemiesList)
         {
            people = CopyObject.copyObject(enemy);
            el.push(enemy);
         }
         return el;
      }
      
      [Untrusted]
      public function isEnemy(playerName:String) : Boolean
      {
         var enemy:* = undefined;
         for each(enemy in this.socialFrame.enemiesList)
         {
            if(enemy.playerName == playerName)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getIgnoredList() : Array
      {
         var ignored:* = undefined;
         var people:Object = null;
         var il:Array = new Array();
         for each(ignored in this.socialFrame.ignoredList)
         {
            people = CopyObject.copyObject(ignored);
            il.push(ignored);
         }
         return il;
      }
      
      [Untrusted]
      public function isIgnored(name:String) : Boolean
      {
         return this.socialFrame.isIgnored(name);
      }
      
      [Untrusted]
      public function getWarnOnFriendConnec() : Boolean
      {
         return this.socialFrame.warnFriendConnec;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this.socialFrame.warnWhenFriendOrGuildMemberLvlUp;
      }
      
      [Untrusted]
      public function getSpouse() : SpouseWrapper
      {
         return this.socialFrame.spouse;
      }
      
      [Untrusted]
      public function hasGuild() : Boolean
      {
         return this.socialFrame.hasGuild;
      }
      
      [Untrusted]
      public function getGuild() : Object
      {
         return this.socialFrame.guild;
      }
      
      [Untrusted]
      public function getGuildRights() : Array
      {
         return GuildWrapper.guildRights;
      }
      
      [Untrusted]
      public function hasGuildRight(pPlayerId:uint, pRightId:String) : Boolean
      {
         var member:GuildMember = null;
         var temporaryWrapper:GuildWrapper = null;
         if(!this.socialFrame.hasGuild)
         {
            return false;
         }
         if(pPlayerId == PlayedCharacterManager.getInstance().id)
         {
            return this.socialFrame.guild.hasRight(pRightId);
         }
         for each(member in this.socialFrame.guildmembers)
         {
            if(member.id == pPlayerId)
            {
               temporaryWrapper = GuildWrapper.create("",null,member.rights);
               return temporaryWrapper.hasRight(pRightId);
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getMaxCollectorCount() : uint
      {
         return this.socialFrame.maxCollectorCount;
      }
      
      [Untrusted]
      public function getTaxCollectorHireCost() : uint
      {
         return this.socialFrame.taxCollectorHireCost;
      }
      
      [Untrusted]
      public function getTaxCollectors() : Object
      {
         return this.socialFrame.taxCollectors;
      }
      
      [Untrusted]
      public function getTaxCollectorByFightId(pFightId:uint) : Object
      {
         var tcw:TaxCollectorWrapper = null;
         var taxCollectors:Array = this.socialFrame.taxCollectors;
         for each(tcw in taxCollectors)
         {
            if(tcw.uniqueId == pFightId)
            {
               return tcw;
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getGuildHouses() : Object
      {
         return this.socialFrame.guildHouses;
      }
      
      [Untrusted]
      public function isPlayerDefender(pPlayerId:uint, pTaxCollectorId:int) : Boolean
      {
         var taxCollector:TaxCollectorWrapper = null;
         var defender:TaxCollectorFightersWrapper = null;
         for each(taxCollector in this.socialFrame.taxCollectors)
         {
            if(taxCollector.uniqueId == pTaxCollectorId)
            {
               for each(defender in taxCollector.allyCharactersInformations)
               {
                  if(defender.playerCharactersInformations.id == pPlayerId)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      [Untrusted]
      public function addIgnoredPlayer(playerName:String) : void
      {
         this.socialFrame.ignoredList.push(new IgnoredWrapper(playerName));
         KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredAdded);
      }
      
      [Untrusted]
      public function removeIgnoredPlayer(playerName:String) : void
      {
         var iw:IgnoredWrapper = null;
         for(var i:int = 0; i < this.socialFrame.ignoredList.length; i++)
         {
            iw = this.socialFrame.ignoredList[i];
            if(iw.name == playerName)
            {
               this.socialFrame.ignoredList.splice(i,1);
               KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredRemoved);
            }
         }
      }
      
      [Trusted]
      public function getChatSentence(timestamp:Number, fingerprint:String) : BasicChatSentence
      {
         var channel:Array = null;
         var sentence:BasicChatSentence = null;
         var found:Boolean = false;
         var se:BasicChatSentence = null;
         var chatFrame:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         for each(channel in chatFrame.getMessages())
         {
            for each(sentence in channel)
            {
               if(sentence.fingerprint == fingerprint && sentence.timestamp == timestamp)
               {
                  se = sentence;
                  found = true;
                  break;
               }
            }
            if(found)
            {
               break;
            }
         }
         return se;
      }
   }
}
