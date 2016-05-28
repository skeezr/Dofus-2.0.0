package com.ankamagames.dofus.internalDatacenter.communication
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public class EmoteWrapper extends Proxy implements ISlotData
   {
      
      private static var _cache:Array = new Array();
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmoteWrapper));
       
      private var _uri:Uri;
      
      public var position:uint;
      
      public var id:uint = 0;
      
      public var gfxId:int;
      
      public function EmoteWrapper()
      {
         super();
      }
      
      public static function create(position:uint, emoteID:uint, useCache:Boolean = true) : EmoteWrapper
      {
         var emote:EmoteWrapper = new EmoteWrapper();
         if(!_cache[emoteID] || !useCache)
         {
            emote = new EmoteWrapper();
            emote.id = emoteID;
            if(useCache)
            {
               _cache[emoteID] = emote;
            }
         }
         else
         {
            emote = _cache[emoteID];
         }
         emote.id = emoteID;
         emote.gfxId = emoteID;
         emote.position = position;
         return emote;
      }
      
      public static function getEmoteWrapperById(id:uint) : EmoteWrapper
      {
         return _cache[id];
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".swf"));
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".swf"));
         }
         return this._uri;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get emote() : Emoticon
      {
         return Emoticon.getEmoticonById(this.id);
      }
      
      public function get emoteId() : uint
      {
         return this.id;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var l:* = undefined;
         var r:* = undefined;
         if(isAttribute(name))
         {
            return this[name];
         }
         l = this.emote;
         _log.debug("emote : " + l);
         if(!l)
         {
            r = "";
         }
         try
         {
            return l[name];
         }
         catch(e:Error)
         {
            return "Error_on_item_" + name;
         }
      }
      
      public function addHolder(h:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
      }
      
      public function getIconUri(pngMode:Boolean = true) : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".swf"));
         }
         return this._uri;
      }
      
      public function toString() : String
      {
         return "EmoteWrapper " + this.id;
      }
   }
}
