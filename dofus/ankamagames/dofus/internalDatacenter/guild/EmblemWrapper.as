package com.ankamagames.dofus.internalDatacenter.guild
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public class EmblemWrapper extends Proxy implements ISlotData
   {
      
      private static var _cache:Array = new Array();
      
      public static const UP:uint = 1;
      
      public static const BACK:uint = 2;
       
      private var _uri:Uri;
      
      private var _color:uint;
      
      private var _type:uint;
      
      public var idEmblem:uint;
      
      public function EmblemWrapper()
      {
         super();
      }
      
      public static function create(pIdEmblem:uint, pType:uint, pColor:uint = 0, useCache:Boolean = false) : EmblemWrapper
      {
         var emblem:EmblemWrapper = null;
         var path:String = null;
         if(!_cache[pIdEmblem] || !useCache)
         {
            emblem = new EmblemWrapper();
            emblem.idEmblem = pIdEmblem;
            if(useCache)
            {
               _cache[pIdEmblem] = emblem;
            }
         }
         else
         {
            emblem = _cache[pIdEmblem];
         }
         emblem._type = pType;
         switch(pType)
         {
            case UP:
               path = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.up");
               break;
            case BACK:
               path = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.back");
         }
         emblem._uri = new Uri(path + pIdEmblem + ".png");
         emblem._color = pColor;
         return emblem;
      }
      
      public static function getEmblemFromId(emblemId:uint) : EmblemWrapper
      {
         return _cache[emblemId];
      }
      
      public function get iconUri() : Uri
      {
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
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
      
      public function get type() : uint
      {
         return this._type;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      public function update(pIdEmblem:uint, pType:uint, pColor:uint = 0) : void
      {
         var path:String = null;
         this.idEmblem = pIdEmblem;
         this._type = pType;
         switch(pType)
         {
            case UP:
               path = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.up");
               break;
            case BACK:
               path = XmlConfig.getInstance().getEntry("config.gfx.path.emblem_icons.back");
         }
         this._uri = new Uri(path + pIdEmblem + ".png");
         this._color = pColor;
      }
      
      public function addHolder(h:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
      }
   }
}
