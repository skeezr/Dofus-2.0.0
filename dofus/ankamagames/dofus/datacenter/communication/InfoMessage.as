package com.ankamagames.dofus.datacenter.communication
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class InfoMessage
   {
      
      private static const MODULE:String = "InfoMessages";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(InfoMessage));
       
      public var typeId:uint;
      
      public var messageId:uint;
      
      public var textId:uint;
      
      public function InfoMessage()
      {
         super();
      }
      
      public static function getInfoMessageById(id:uint) : InfoMessage
      {
         var t:* = GameData.getObject(MODULE,id);
         var tt:* = GameData.getObject(MODULE,id) as InfoMessage;
         return GameData.getObject(MODULE,id) as InfoMessage;
      }
      
      public static function getInfoMessages() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(typeId:uint, messageId:uint, textId:uint) : InfoMessage
      {
         var o:InfoMessage = new InfoMessage();
         o.typeId = typeId;
         o.messageId = messageId;
         o.textId = textId;
         return o;
      }
      
      public function get text() : String
      {
         return I18n.getText(this.textId);
      }
   }
}
