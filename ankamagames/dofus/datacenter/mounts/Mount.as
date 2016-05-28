package com.ankamagames.dofus.datacenter.mounts
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Mount
   {
      
      public static var MODULE:String = "Mounts";
       
      public var id:uint;
      
      public var nameId:uint;
      
      public var look:String;
      
      public function Mount()
      {
         super();
      }
      
      public static function create(id:uint, nameId:uint, lookString:String) : Mount
      {
         var o:Mount = new Mount();
         o.id = id;
         o.nameId = nameId;
         o.look = lookString;
         return o;
      }
      
      public static function getMountById(id:uint) : Mount
      {
         return GameData.getObject(MODULE,id) as Mount;
      }
      
      public static function getMounts() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
