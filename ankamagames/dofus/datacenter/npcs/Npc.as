package com.ankamagames.dofus.datacenter.npcs
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Npc
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Npc));
      
      private static const MODULE:String = "Npcs";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var dialogMessages:Vector.<Object>;
      
      public var dialogReplies:Vector.<Object>;
      
      public var actions:Vector.<uint>;
      
      public function Npc()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, dialogMessages:Vector.<Object>, dialogReplies:Vector.<Object>, actions:Vector.<uint>) : Npc
      {
         var o:Npc = new Npc();
         o.id = id;
         o.nameId = nameId;
         o.dialogMessages = dialogMessages;
         o.dialogReplies = dialogReplies;
         o.actions = actions;
         return o;
      }
      
      public static function getNpcById(id:int) : Npc
      {
         return GameData.getObject(MODULE,id) as Npc;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
