package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class ApiAction
   {
      
      private static var _apiActionNameList:Array = new Array();
       
      private var _trusted:Boolean;
      
      private var _name:String;
      
      private var _actionClass:Class;
      
      public function ApiAction(name:String, actionClass:Class, trusted:Boolean)
      {
         super();
         if(!_apiActionNameList)
         {
            _apiActionNameList = new Array();
         }
         if(_apiActionNameList[name])
         {
            throw new BeriliaError("ApiAction name (" + name + ") aleardy used, please rename it.");
         }
         _apiActionNameList[name] = this;
         this._name = name;
         this._actionClass = actionClass;
         this._trusted = trusted;
      }
      
      public static function getApiActionByName(name:String) : ApiAction
      {
         return _apiActionNameList[name];
      }
      
      public static function getApiActionsList() : Array
      {
         return _apiActionNameList;
      }
      
      public function get trusted() : Boolean
      {
         return this._trusted;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get actionClass() : Class
      {
         return this._actionClass;
      }
   }
}
