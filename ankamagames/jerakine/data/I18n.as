package com.ankamagames.jerakine.data
{
   public class I18n extends AbstractDataManager
   {
      
      private static var _self:com.ankamagames.jerakine.data.I18n;
       
      public function I18n()
      {
         super();
      }
      
      public static function init() : void
      {
         if(_self)
         {
            return;
         }
         _self = new com.ankamagames.jerakine.data.I18n();
         _self.init(1000,uint.MAX_VALUE,"i18n");
      }
      
      public static function getText(id:*, params:Array = null, replace:String = "%") : String
      {
         var txt:String = null;
         if(DataUpdateManager.SQL_MODE)
         {
            txt = SQLiteHandler.getInstance().getObject("i18n",id) as String;
         }
         else
         {
            txt = _self.getObject(id) as String;
         }
         if(!params || !params.length)
         {
            return txt;
         }
         if(!txt)
         {
            return "!i18n_" + id;
         }
         var prc:Array = new Array();
         for(var i:uint = 1; i <= params.length; i++)
         {
            txt = txt.replace(replace + i,params[i - 1]);
         }
         return txt;
      }
   }
}
