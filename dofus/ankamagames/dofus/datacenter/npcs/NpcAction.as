package com.ankamagames.dofus.datacenter.npcs
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class NpcAction
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(NpcAction));
      
      private static const MODULE:String = "NpcActions";
       
      public var id:int;
      
      public var nameId:uint;
      
      public function NpcAction()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint) : NpcAction
      {
         var o:NpcAction = new NpcAction();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public static function getNpcActionById(id:int) : NpcAction
      {
         return GameData.getObject(MODULE,id) as NpcAction;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
