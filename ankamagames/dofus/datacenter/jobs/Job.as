package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Job
   {
      
      private static const MODULE:String = "Jobs";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var specializationOfId:int;
      
      public var iconId:int;
      
      public var toolIds:Vector.<int>;
      
      private var _tools:Vector.<Item>;
      
      public function Job()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, specializationOfId:int, iconId:int, toolIds:Vector.<int>) : Job
      {
         var o:Job = new Job();
         o.id = id;
         o.nameId = nameId;
         o.specializationOfId = specializationOfId;
         o.iconId = iconId;
         o.toolIds = toolIds;
         return o;
      }
      
      public static function getJobById(id:int) : Job
      {
         return GameData.getObject(MODULE,id) as Job;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get specializationOf() : Job
      {
         if(this.specializationOfId != 0)
         {
            return Job.getJobById(this.specializationOfId);
         }
         return null;
      }
      
      public function get tools() : Vector.<Item>
      {
         var toolsCount:uint = 0;
         var i:uint = 0;
         if(this._tools == null)
         {
            toolsCount = this.toolIds.length;
            this._tools = new Vector.<Item>(toolsCount,true);
            for(i = 0; i < toolsCount; i++)
            {
               this._tools[i] = Item.getItemById(this.toolIds[i]);
            }
         }
         return this._tools;
      }
   }
}
