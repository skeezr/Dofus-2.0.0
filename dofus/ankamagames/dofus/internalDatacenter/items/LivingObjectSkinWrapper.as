package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.datacenter.livingObjects.LivingObjectSkinJntMood;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public class LivingObjectSkinWrapper implements ISlotData
   {
       
      private var _category:int;
      
      private var _mood:int;
      
      private var _skin:int;
      
      private var _uri:Uri;
      
      private var _pngMode:Boolean;
      
      public function LivingObjectSkinWrapper()
      {
         super();
      }
      
      public static function create(category:int, mood:int, skin:int) : LivingObjectSkinWrapper
      {
         var skinWrapper:LivingObjectSkinWrapper = new LivingObjectSkinWrapper();
         skinWrapper._category = category;
         skinWrapper._mood = mood;
         skinWrapper._skin = skin;
         return skinWrapper;
      }
      
      public function get iconUri() : Uri
      {
         return this.getIconUri(true);
      }
      
      public function get fullSizeIconUri() : Uri
      {
         return this.getIconUri(false);
      }
      
      public function get category() : int
      {
         return this._category;
      }
      
      public function get mood() : int
      {
         return this._mood;
      }
      
      public function get skin() : int
      {
         return this._skin;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      public function getIconUri(pngMode:Boolean = true) : Uri
      {
         var iconId:int = 0;
         var update:Boolean = false;
         if(this._uri)
         {
            if(pngMode != this._pngMode)
            {
               update = true;
            }
         }
         else
         {
            update = true;
         }
         if(update)
         {
            iconId = LivingObjectSkinJntMood.getLivingObjectSkin(this._category,this._mood,this._skin);
            if(pngMode)
            {
               this._pngMode = true;
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat(iconId).concat(".png"));
            }
            else
            {
               this._pngMode = false;
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.vector").concat(iconId).concat(".swf"));
            }
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
      
      public function addHolder(h:ISlotDataHolder) : void
      {
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
      }
   }
}
