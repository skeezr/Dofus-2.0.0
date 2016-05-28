package com.ankamagames.dofus.datacenter.misc
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Tips
   {
      
      private static const MODULE:String = "Tips";
       
      public var id:int;
      
      public var descId:uint;
      
      public function Tips()
      {
         super();
      }
      
      public static function getTipsById(id:int) : Tips
      {
         return GameData.getObject(MODULE,id) as Tips;
      }
      
      public static function getAllTips() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, descId:uint) : Tips
      {
         var o:Tips = new Tips();
         o.id = id;
         o.descId = descId;
         return o;
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descId);
      }
   }
}
