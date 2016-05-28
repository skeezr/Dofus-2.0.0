package com.ankamagames.dofus.internalDatacenter.guild
{
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   
   public class GuildWrapper
   {
      
      public static const IS_BOSS:String = "isBoss";
      
      public static const MANAGE_GUILD_BOOSTS:String = "manageGuildBoosts";
      
      public static const MANAGE_RIGHTS:String = "manageRights";
      
      public static const INVITE_NEW_MEMBERS:String = "inviteNewMembers";
      
      public static const BAN_MEMBERS:String = "banMembers";
      
      public static const MANAGE_XP_CONTRIBUTION:String = "manageXPContribution";
      
      public static const MANAGE_RANKS:String = "manageRanks";
      
      public static const HIRE_TAX_COLLECTOR:String = "hireTaxCollector";
      
      public static const MANAGE_MY_XP_CONTRIBUTION:String = "manageMyXpContribution";
      
      public static const COLLECT:String = "collect";
      
      public static const USE_FARMS:String = "useFarms";
      
      public static const ORGANIZE_FARMS:String = "organizeFarms";
      
      public static const TAKE_OTHERS_RIDES_IN_FARM:String = "takeOthersRidesInFarm";
      
      public static const guildRights:Array = new Array(IS_BOSS,MANAGE_GUILD_BOOSTS,MANAGE_RIGHTS,INVITE_NEW_MEMBERS,BAN_MEMBERS,MANAGE_XP_CONTRIBUTION,MANAGE_RANKS,HIRE_TAX_COLLECTOR,MANAGE_MY_XP_CONTRIBUTION,COLLECT,USE_FARMS,ORGANIZE_FARMS,TAKE_OTHERS_RIDES_IN_FARM);
      
      public static var _rightDictionnary:Dictionary = new Dictionary();
       
      public var guildName:String;
      
      public var upEmblem:com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
      
      public var backEmblem:com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
      
      public var level:uint = 0;
      
      private var _memberRightsNumber:Number;
      
      public function GuildWrapper()
      {
         super();
      }
      
      public static function create(pGuildName:String, pGuildEmblem:GuildEmblem, pMemberRights:Number) : GuildWrapper
      {
         var item:GuildWrapper = null;
         item = new GuildWrapper();
         item.initDictionary();
         item.guildName = pGuildName;
         item._memberRightsNumber = pMemberRights;
         if(pGuildEmblem != null)
         {
            item.upEmblem = com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.create(pGuildEmblem.symbolShape,com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.UP,pGuildEmblem.symbolColor);
            item.backEmblem = com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.create(pGuildEmblem.backgroundShape,com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.BACK,pGuildEmblem.backgroundColor);
         }
         return item;
      }
      
      public static function getRightsNumber(pRightsIDs:Array) : Number
      {
         var right:String = null;
         var wantToSet:Boolean = false;
         var pRight:String = null;
         var rightNumber:Number = 0;
         for each(right in guildRights)
         {
            wantToSet = false;
            for each(pRight in pRightsIDs)
            {
               if(pRight == right)
               {
                  rightNumber = rightNumber | 1 << _rightDictionnary[pRight];
               }
            }
         }
         return rightNumber;
      }
      
      public function set memberRightsNumber(value:Number) : void
      {
         this._memberRightsNumber = value;
      }
      
      public function get memberRightsNumber() : Number
      {
         return this._memberRightsNumber;
      }
      
      public function get memberRights() : Vector.<Boolean>
      {
         var rights:Vector.<Boolean> = new Vector.<Boolean>();
         rights.push(this.isBoss);
         rights.push(this.manageGuildBoosts);
         rights.push(this.manageRights);
         rights.push(this.inviteNewMembers);
         rights.push(this.banMembers);
         rights.push(this.manageXPContribution);
         rights.push(this.manageRanks);
         rights.push(this.manageMyXpContribution);
         rights.push(this.hireTaxCollector);
         rights.push(this.collect);
         rights.push(this.useFarms);
         rights.push(this.organizeFarms);
         rights.push(this.takeOthersRidesInFarm);
         return rights;
      }
      
      public function get isBoss() : Boolean
      {
         return Boolean(1 & this._memberRightsNumber >> 0);
      }
      
      public function get manageGuildBoosts() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 1)) || Boolean(this.isBoss);
      }
      
      public function get manageRights() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 2)) || Boolean(this.isBoss);
      }
      
      public function get inviteNewMembers() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 3)) || Boolean(this.isBoss);
      }
      
      public function get banMembers() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 4)) || Boolean(this.isBoss);
      }
      
      public function get manageXPContribution() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 5)) || Boolean(this.isBoss);
      }
      
      public function get manageRanks() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 6)) || Boolean(this.isBoss);
      }
      
      public function get manageMyXpContribution() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 7)) || Boolean(this.isBoss);
      }
      
      public function get hireTaxCollector() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 8)) || Boolean(this.isBoss);
      }
      
      public function get collect() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 9)) || Boolean(this.isBoss);
      }
      
      public function get useFarms() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 12)) || Boolean(this.isBoss);
      }
      
      public function get organizeFarms() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 13)) || Boolean(this.isBoss);
      }
      
      public function get takeOthersRidesInFarm() : Boolean
      {
         return Boolean(Boolean(1 & this._memberRightsNumber >> 14)) || Boolean(this.isBoss);
      }
      
      public function update(pGuildName:String, pGuildEmblem:GuildEmblem, pMemberRights:Number) : void
      {
         this.guildName = pGuildName;
         this._memberRightsNumber = pMemberRights;
         this.upEmblem.update(pGuildEmblem.symbolShape,com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.UP,pGuildEmblem.symbolColor);
         this.backEmblem.update(pGuildEmblem.backgroundShape,com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper.BACK,pGuildEmblem.backgroundColor);
      }
      
      public function hasRight(pRightId:String) : Boolean
      {
         var returnValue:Boolean = false;
         switch(pRightId)
         {
            case IS_BOSS:
               returnValue = this.isBoss;
               break;
            case MANAGE_GUILD_BOOSTS:
               returnValue = this.manageGuildBoosts;
               break;
            case MANAGE_RIGHTS:
               returnValue = this.manageRights;
               break;
            case INVITE_NEW_MEMBERS:
               returnValue = this.inviteNewMembers;
               break;
            case BAN_MEMBERS:
               returnValue = this.banMembers;
               break;
            case MANAGE_XP_CONTRIBUTION:
               returnValue = this.manageXPContribution;
               break;
            case MANAGE_RANKS:
               returnValue = this.manageRanks;
               break;
            case MANAGE_MY_XP_CONTRIBUTION:
               returnValue = this.manageMyXpContribution;
               break;
            case HIRE_TAX_COLLECTOR:
               returnValue = this.hireTaxCollector;
               break;
            case COLLECT:
               returnValue = this.collect;
               break;
            case USE_FARMS:
               returnValue = this.useFarms;
               break;
            case ORGANIZE_FARMS:
               returnValue = this.organizeFarms;
               break;
            case TAKE_OTHERS_RIDES_IN_FARM:
               returnValue = this.takeOthersRidesInFarm;
         }
         return returnValue;
      }
      
      private function initDictionary() : void
      {
         _rightDictionnary[IS_BOSS] = 0;
         _rightDictionnary[MANAGE_GUILD_BOOSTS] = 1;
         _rightDictionnary[MANAGE_RIGHTS] = 2;
         _rightDictionnary[INVITE_NEW_MEMBERS] = 3;
         _rightDictionnary[BAN_MEMBERS] = 4;
         _rightDictionnary[MANAGE_XP_CONTRIBUTION] = 5;
         _rightDictionnary[MANAGE_RANKS] = 6;
         _rightDictionnary[MANAGE_MY_XP_CONTRIBUTION] = 7;
         _rightDictionnary[HIRE_TAX_COLLECTOR] = 8;
         _rightDictionnary[COLLECT] = 9;
         _rightDictionnary[USE_FARMS] = 12;
         _rightDictionnary[ORGANIZE_FARMS] = 13;
         _rightDictionnary[TAKE_OTHERS_RIDES_IN_FARM] = 14;
      }
   }
}
