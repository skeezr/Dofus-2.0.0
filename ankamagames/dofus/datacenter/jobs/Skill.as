package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   
   public class Skill
   {
      
      private static const MODULE:String = "Skills";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var parentJobId:int;
      
      public var isForgemagus:Boolean;
      
      public var modifiableItemType:int;
      
      public var gatheredRessourceItem:int;
      
      public var craftableItemIds:Vector.<int>;
      
      public var interactiveId:int;
      
      public var useAnimation:String;
      
      public var isRepair:Boolean;
      
      public function Skill()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, parentJobId:int, isForgemagus:Boolean, isRepair:Boolean, modifiableItemType:int, gatheredRessourceItem:int, craftableItemIds:Vector.<int>, interactiveId:int, useAnimation:String) : Skill
      {
         var o:Skill = new Skill();
         o.id = id;
         o.nameId = nameId;
         o.parentJobId = parentJobId;
         o.isForgemagus = isForgemagus;
         o.isRepair = isRepair;
         o.modifiableItemType = modifiableItemType;
         o.gatheredRessourceItem = gatheredRessourceItem;
         o.craftableItemIds = craftableItemIds;
         o.interactiveId = interactiveId;
         o.useAnimation = useAnimation;
         return o;
      }
      
      public static function getSkillById(id:int) : Skill
      {
         return GameData.getObject(MODULE,id) as Skill;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get parentJob() : Job
      {
         return Job.getJobById(this.parentJobId);
      }
      
      public function get interactive() : Interactive
      {
         return Interactive.getInteractiveById(this.interactiveId);
      }
   }
}
