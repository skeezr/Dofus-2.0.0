package com.ankamagames.dofus.datacenter.mounts
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class MountBehavior
   {
      
      public static const MODULE:String = "MountBehaviors";
       
      public var id:uint;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public function MountBehavior()
      {
         super();
      }
      
      public static function create(id:uint, nameId:uint, descriptionId:uint) : MountBehavior
      {
         var o:MountBehavior = new MountBehavior();
         o.id = id;
         o.nameId = nameId;
         o.descriptionId = descriptionId;
         return o;
      }
      
      public static function getMountBehaviorById(id:uint) : MountBehavior
      {
         return GameData.getObject(MODULE,id) as MountBehavior;
      }
      
      public static function getMountBehaviors() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
   }
}
