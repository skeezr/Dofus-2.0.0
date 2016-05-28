package com.ankamagames.jerakine.utils.misc
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class I18nProxy
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(I18nProxy));
      
      private static var _index:Object;
       
      public function I18nProxy()
      {
         super();
      }
      
      public static function init(index:Object) : void
      {
         _index = index;
      }
      
      public static function getKeyId(key:String) : uint
      {
         return _index[key];
      }
      
      public static function containKey(key:String) : Boolean
      {
         return Boolean(_index) && _index[key] != null;
      }
      
      public static function getKey(key:String, ... params) : String
      {
         return CallWithParameters.callR(I18n.getText,[getKeyId(key)].concat(params));
      }
   }
}
