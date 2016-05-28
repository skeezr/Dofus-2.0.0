package com.ankamagames.dofus.datacenter.notifications
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Notification
   {
      
      private static const MODULE:String = "Notifications";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Notification));
       
      public var id:int;
      
      public var titleId:uint;
      
      public var messageId:uint;
      
      public var iconId:int;
      
      public var typeId:int;
      
      public var trigger:String;
      
      public function Notification()
      {
         super();
      }
      
      public static function getNotificationById(id:int) : Notification
      {
         return GameData.getObject(MODULE,id) as Notification;
      }
      
      public static function getNotifications() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, typeId:int, iconId:int, titleId:uint, messageId:uint, trigger:String) : Notification
      {
         trace(id);
         var o:Notification = new Notification();
         o.id = id;
         o.typeId = typeId;
         o.iconId = iconId;
         o.titleId = titleId;
         o.messageId = messageId;
         o.trigger = trigger;
         return o;
      }
      
      public function get title() : String
      {
         return I18n.getText(this.titleId);
      }
      
      public function get message() : String
      {
         return I18n.getText(this.messageId);
      }
   }
}
