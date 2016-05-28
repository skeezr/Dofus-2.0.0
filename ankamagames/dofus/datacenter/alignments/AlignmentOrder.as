package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentOrder
   {
      
      private static const MODULE:String = "AlignmentOrder";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentOrder));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var sideId:uint;
      
      public function AlignmentOrder()
      {
         super();
      }
      
      public static function getAlignmentOrderById(id:int) : AlignmentOrder
      {
         return GameData.getObject(MODULE,id) as AlignmentOrder;
      }
      
      public static function getAlignmentOrders() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, nameId:uint, sideId:uint) : AlignmentOrder
      {
         var o:AlignmentOrder = new AlignmentOrder();
         o.id = id;
         o.nameId = nameId;
         o.sideId = sideId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
