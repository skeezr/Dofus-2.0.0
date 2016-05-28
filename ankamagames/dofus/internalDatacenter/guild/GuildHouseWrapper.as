package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsForGuild;
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.jerakine.managers.LangManager;
   
   public class GuildHouseWrapper
   {
       
      public var houseId:int;
      
      public var houseName:String;
      
      public var description:String;
      
      public var ownerName:String;
      
      public var skillListIds:Vector.<int>;
      
      public var worldX:int;
      
      public var worldY:int;
      
      public var guildshareParams:uint;
      
      private var _arrayShareParams:Array;
      
      public function GuildHouseWrapper()
      {
         this._arrayShareParams = new Array(this.visibleGuildBrief,this.doorSignGuild,this.doorSignOthers,this.allowDoorGuild,this.forbiDoorOthers,this.allowChestOthers,this.forbidChestOthers,this.teleport,this.respawn);
         super();
      }
      
      public static function create(pHouseInformationsForGuild:HouseInformationsForGuild) : GuildHouseWrapper
      {
         var item:GuildHouseWrapper = new GuildHouseWrapper();
         item.houseId = pHouseInformationsForGuild.houseId;
         item.houseName = House.getGuildHouseById(item.houseId).name;
         item.description = House.getGuildHouseById(item.houseId).description;
         item.ownerName = pHouseInformationsForGuild.ownerName;
         item.skillListIds = pHouseInformationsForGuild.skillListIds;
         item.worldX = pHouseInformationsForGuild.worldX;
         item.worldY = pHouseInformationsForGuild.worldY;
         item.guildshareParams = pHouseInformationsForGuild.guildshareParams;
         return item;
      }
      
      public function get visibleGuildBrief() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 0);
      }
      
      public function get doorSignGuild() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 1);
      }
      
      public function get doorSignOthers() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 2);
      }
      
      public function get allowDoorGuild() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 3);
      }
      
      public function get forbiDoorOthers() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 4);
      }
      
      public function get allowChestOthers() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 5);
      }
      
      public function get forbidChestOthers() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 6);
      }
      
      public function get teleport() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 7);
      }
      
      public function get respawn() : Boolean
      {
         return Boolean(1 & this.guildshareParams >> 8);
      }
      
      public function get skillListString() : Vector.<String>
      {
         var id:int = 0;
         var sls:Vector.<String> = new Vector.<String>();
         for each(id in this.skillListIds)
         {
            sls.push(I18n.getText(Skill.getSkillById(id).nameId));
         }
         return sls;
      }
      
      public function get guildshareString() : Vector.<String>
      {
         var gss:Vector.<String> = new Vector.<String>();
         var bit:uint = 1;
         for(var id:uint = 0; id <= 8; id++)
         {
            if(this._arrayShareParams[id])
            {
               gss.push(LangManager.getInstance().getEntry("guildHouse.Right" + bit));
            }
            bit = bit * 2;
         }
         return gss;
      }
      
      public function update(pHouseInformationsForGuild:HouseInformationsForGuild) : void
      {
         this.houseId = pHouseInformationsForGuild.houseId;
         this.houseName = House.getGuildHouseById(this.houseId).name;
         this.description = House.getGuildHouseById(this.houseId).description;
         this.ownerName = pHouseInformationsForGuild.ownerName;
         this.skillListIds = pHouseInformationsForGuild.skillListIds;
         this.worldX = pHouseInformationsForGuild.worldX;
         this.worldY = pHouseInformationsForGuild.worldY;
         this.guildshareParams = pHouseInformationsForGuild.guildshareParams;
      }
   }
}
