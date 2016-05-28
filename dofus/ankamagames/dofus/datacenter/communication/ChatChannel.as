package com.ankamagames.dofus.datacenter.communication
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ChatChannel
   {
      
      private static const MODULE:String = "ChatChannels";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ChatChannel));
       
      public var id:uint;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public var shortcut:String;
      
      public var isPrivate:Boolean;
      
      public var allowObjects:Boolean;
      
      public function ChatChannel()
      {
         super();
      }
      
      public static function create(id:uint, nameId:uint, descriptionId:uint, shortcut:String, isPrivate:Boolean = false, allowObjects:Boolean = false) : ChatChannel
      {
         var cc:ChatChannel = new ChatChannel();
         cc.id = id;
         cc.nameId = nameId;
         cc.descriptionId = descriptionId;
         cc.shortcut = shortcut;
         cc.isPrivate = isPrivate;
         cc.allowObjects = allowObjects;
         return cc;
      }
      
      public static function getChannelById(id:int) : ChatChannel
      {
         return GameData.getObject(MODULE,id) as ChatChannel;
      }
      
      public static function getChannels() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
