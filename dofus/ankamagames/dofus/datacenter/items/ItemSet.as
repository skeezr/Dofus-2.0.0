package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ItemSet
   {
      
      private static const MODULE:String = "ItemSets";
       
      public var id:uint;
      
      public var items:Vector.<uint>;
      
      public var nameId:uint;
      
      public function ItemSet()
      {
         super();
      }
      
      public static function create(id:uint, nameId:uint, items:Vector.<uint>) : ItemSet
      {
         var o:ItemSet = new ItemSet();
         o.id = id;
         o.nameId = nameId;
         o.items = items;
         return o;
      }
      
      public static function getItemSetById(id:uint) : ItemSet
      {
         return GameData.getObject(MODULE,id) as ItemSet;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
