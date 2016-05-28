package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ItemType
   {
      
      private static const MODULE:String = "ItemTypes";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var superTypeId:uint;
      
      public var plural:Boolean;
      
      public var gender:uint;
      
      public var zoneSize:uint;
      
      public var zoneShape:uint;
      
      public var needUseConfirm:Boolean;
      
      public function ItemType()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, superTypeId:uint, plural:Boolean, gender:uint, zoneSize:uint, zoneShape:uint, needUseConfirm:Boolean) : ItemType
      {
         var o:ItemType = new ItemType();
         o.id = id;
         o.nameId = nameId;
         o.superTypeId = superTypeId;
         o.plural = plural;
         o.gender = gender;
         o.zoneSize = zoneSize;
         o.zoneShape = zoneShape;
         o.needUseConfirm = needUseConfirm;
         return o;
      }
      
      public static function getItemTypeById(id:uint) : ItemType
      {
         return GameData.getObject(MODULE,id) as ItemType;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
