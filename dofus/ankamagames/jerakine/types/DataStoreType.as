package com.ankamagames.jerakine.types
{
   import com.ankamagames.jerakine.utils.errors.JerakineError;
   
   public class DataStoreType
   {
       
      private var _sCategory:String;
      
      private var _bPersistant:Boolean;
      
      private var _nLocation:uint;
      
      private var _nBind:uint;
      
      public function DataStoreType(sCategory:String, bPersistant:Boolean, nLocation:Number = NaN, nBind:Number = NaN)
      {
         super();
         this._sCategory = sCategory;
         this._bPersistant = bPersistant;
         if(bPersistant)
         {
            if(!isNaN(nLocation))
            {
               this._nLocation = nLocation;
               if(!isNaN(nBind))
               {
                  this._nBind = nBind;
               }
               else
               {
                  throw new JerakineError("When DataStoreType is a persistant data, arg \'nBind\' must be defined.");
               }
            }
            else
            {
               throw new JerakineError("When DataStoreType is a persistant data, arg \'nLocation\' must be defined.");
            }
         }
      }
      
      public function get category() : String
      {
         return this._sCategory;
      }
      
      public function get persistant() : Boolean
      {
         return this._bPersistant;
      }
      
      public function get location() : uint
      {
         return this._nLocation;
      }
      
      public function get bind() : uint
      {
         return this._nBind;
      }
   }
}
