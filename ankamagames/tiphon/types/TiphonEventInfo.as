package com.ankamagames.tiphon.types
{
   public class TiphonEventInfo
   {
       
      public var type:String;
      
      private var _label:String;
      
      private var _sprite;
      
      private var _params:String;
      
      private var _animationType:String;
      
      private var _direction:int = -1;
      
      public function TiphonEventInfo(pType:String, pParams:String = "")
      {
         super();
         this.type = pType;
         this._params = pParams;
      }
      
      public function set label(pLabel:String) : void
      {
         this._label = pLabel;
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function get sprite() : *
      {
         return this._sprite;
      }
      
      public function get params() : String
      {
         return this._params;
      }
      
      public function get animationType() : String
      {
         if(this._animationType == null)
         {
            return "undefined";
         }
         return this._animationType;
      }
      
      public function get direction() : int
      {
         return this._direction;
      }
      
      public function get animationName() : String
      {
         return this._animationType + "_" + this._direction;
      }
      
      public function set animationName(pAnimationName:String) : void
      {
         this._animationType = pAnimationName.split("_")[0];
         this._direction = pAnimationName.split("_")[1];
         if(this._direction == 3)
         {
            this._direction = 1;
         }
         if(this._direction == 7)
         {
            this._direction = 5;
         }
      }
      
      public function duplicate() : TiphonEventInfo
      {
         return new TiphonEventInfo(this.type,this._params);
      }
   }
}
