package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class XmlConfig
   {
      
      private static var _self:com.ankamagames.jerakine.data.XmlConfig;
       
      private var _constants:Array;
      
      public function XmlConfig()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.data.XmlConfig
      {
         if(!_self)
         {
            _self = new com.ankamagames.jerakine.data.XmlConfig();
         }
         return _self;
      }
      
      public function init(constants:Array) : void
      {
         this._constants = constants;
      }
      
      public function getEntry(name:String) : *
      {
         return this._constants[name];
      }
      
      public function setEntry(sKey:String, sValue:*) : void
      {
         this._constants[sKey] = sValue;
      }
   }
}
