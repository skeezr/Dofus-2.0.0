package com.ankamagames.dofus.datacenter.misc
{
   import com.ankamagames.jerakine.data.GameData;
   
   public class Appearance
   {
      
      public static const MODULE:String = "Appearances";
       
      public var id:uint;
      
      public var type:uint;
      
      public var data:String;
      
      public function Appearance()
      {
         super();
      }
      
      public static function create(id:uint, type:uint, data:String) : Appearance
      {
         var o:Appearance = new Appearance();
         o.id = id;
         o.type = type;
         o.data = data;
         return o;
      }
      
      public static function getAppearanceById(id:uint) : Appearance
      {
         return GameData.getObject(MODULE,id) as Appearance;
      }
   }
}
