package com.ankamagames.dofus.datacenter.interactives
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Interactive
   {
      
      private static const MODULE:String = "Interactives";
       
      public var id:int;
      
      public var nameId:uint;
      
      public function Interactive()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint) : Interactive
      {
         var o:Interactive = new Interactive();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public static function getInteractiveById(id:int) : Interactive
      {
         return GameData.getObject(MODULE,id) as Interactive;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
