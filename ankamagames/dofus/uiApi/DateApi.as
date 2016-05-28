package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.types.enums.LanguageEnum;
   import com.ankamagames.dofus.datacenter.misc.Month;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class DateApi
   {
       
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      private var _hooks:Array;
      
      private var _bTextInit:Boolean = false;
      
      private var _nameYears:String;
      
      private var _nameMonths:String;
      
      private var _nameDays:String;
      
      private var _nameHours:String;
      
      private var _nameMinutes:String;
      
      private var _nameAnd:String;
      
      public function DateApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DateApi));
         this._hooks = new Array();
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getTimestamp() : Number
      {
         var date:Date = new Date();
         return date.getTime() + TimeManager.getInstance().serverTimeLag;
      }
      
      [Untrusted]
      public function getTimestampInMs(time:Number) : Number
      {
         return time * 1000;
      }
      
      [Untrusted]
      public function getClock(time:Number = 0) : String
      {
         var date:Date = null;
         var date0:Date = null;
         if(time == 0)
         {
            date0 = new Date();
            date = new Date(date0.getTime() + TimeManager.getInstance().serverTimeLag);
         }
         else
         {
            date = new Date(time);
         }
         var nhour:Number = date.getUTCHours();
         var nminute:Number = date.getUTCMinutes();
         var hour:String = nhour >= 10?nhour.toString():"0" + nhour;
         var minute:String = nminute >= 10?nminute.toString():"0" + nminute;
         return hour + ":" + minute;
      }
      
      [Untrusted]
      public function getDate(time:Number, lang:String = "FR") : String
      {
         var sDate:String = null;
         var date:Date = new Date(time);
         var nday:Number = date.getDate();
         var nmonth:Number = date.getMonth();
         var nyear:Number = date.getFullYear();
         var day:String = nday > 9?nday.toString():"0" + nday;
         var month:String = nmonth > 9?nmonth.toString():"0" + nmonth;
         switch(lang)
         {
            case LanguageEnum.LANG_FR:
               sDate = day + "/" + month + "/" + nyear;
               break;
            case LanguageEnum.LANG_EN:
               sDate = month + "/" + day + "/" + nyear;
               break;
            default:
               sDate = month + "/" + day + "/" + nyear;
         }
         return sDate;
      }
      
      [Untrusted]
      public function getDofusDate(time:Number = 0) : String
      {
         var date:Date = null;
         var sDate:String = null;
         if(time != 0)
         {
            date = new Date(time);
         }
         else
         {
            date = new Date();
         }
         var nday:Number = date.getDate();
         var nmonth:Number = date.getMonth();
         var nyear:Number = date.getFullYear() + TimeManager.getInstance().dofusTimeYearLag;
         var day:String = nday.toString();
         var year:String = nyear.toString();
         var month:String = Month.getMonthById(nmonth).name;
         sDate = day + " " + month + " " + year;
         return sDate;
      }
      
      [Untrusted]
      public function getDurationTimeSinceEpoch(pTime:Number = 0) : Number
      {
         var date:Date = new Date();
         var dateTime:Number = date.getTime() / 1000;
         var timezoneOffset:Number = TimeManager.getInstance().timezoneOffset / 1000;
         var serverTimeLag:Number = TimeManager.getInstance().serverTimeLag / 1000;
         return Math.floor(dateTime - pTime + timezoneOffset - serverTimeLag);
      }
      
      [Untrusted]
      public function getDuration(time:Number) : String
      {
         var result:String = null;
         if(!this._bTextInit)
         {
            this.initText();
         }
         var date:Date = new Date(time);
         var nminute:Number = date.getUTCMinutes();
         var nhour:Number = date.getUTCHours();
         var nday:Number = date.getUTCDate() - 1;
         var nmonth:Number = date.getUTCMonth();
         var nyear:Number = date.getUTCFullYear() - 1970;
         var minute:String = nminute > 1?nminute + " " + PatternDecoder.combine(this._nameMinutes,"f",false):nminute + " " + PatternDecoder.combine(this._nameMinutes,"f",true);
         var hour:String = nhour > 1?nhour + " " + PatternDecoder.combine(this._nameHours,"f",false):nhour + " " + PatternDecoder.combine(this._nameHours,"f",true);
         var day:String = nday > 1?nday + " " + PatternDecoder.combine(this._nameDays,"f",false):nday + " " + PatternDecoder.combine(this._nameDays,"f",true);
         var month:String = nmonth + " " + this._nameMonths;
         var year:String = nyear > 1?nyear + " " + PatternDecoder.combine(this._nameYears,"f",false):nyear + " " + PatternDecoder.combine(this._nameMinutes,"f",true);
         if(nyear == 0)
         {
            if(nmonth == 0)
            {
               if(nday == 0)
               {
                  if(nhour == 0)
                  {
                     result = minute;
                  }
                  else
                  {
                     result = hour + " " + this._nameAnd + " " + minute;
                  }
               }
               else
               {
                  result = day + " " + this._nameAnd + " " + hour;
               }
            }
            else
            {
               result = month + " " + this._nameAnd + " " + day;
            }
         }
         else
         {
            result = year + " " + this._nameAnd + " " + month;
         }
         return result;
      }
      
      private function initText() : void
      {
         this._nameYears = I18n.getText(I18nProxy.getKeyId("ui.time.years"));
         this._nameMonths = I18n.getText(I18nProxy.getKeyId("ui.time.months"));
         this._nameDays = I18n.getText(I18nProxy.getKeyId("ui.time.days"));
         this._nameHours = I18n.getText(I18nProxy.getKeyId("ui.time.hours"));
         this._nameMinutes = I18n.getText(I18nProxy.getKeyId("ui.time.minutes"));
         this._nameAnd = I18n.getText(I18nProxy.getKeyId("ui.common.and")).toLowerCase();
         this._bTextInit = true;
      }
   }
}
