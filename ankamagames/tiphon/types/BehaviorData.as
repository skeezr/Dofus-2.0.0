package com.ankamagames.tiphon.types
{
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public class BehaviorData
   {
       
      private var _animation:String;
      
      private var _direction:uint;
      
      private var _animationStartValue:String;
      
      private var _directionStartValue:uint;
      
      private var _parent:TiphonSprite;
      
      public var lock:Boolean = false;
      
      public function BehaviorData(animation:String, direction:uint, parent:TiphonSprite)
      {
         super();
         this._animation = animation;
         this._direction = direction;
         this._animationStartValue = animation;
         this._directionStartValue = direction;
         this._parent = parent;
      }
      
      public function get animation() : String
      {
         return this._animation;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function set animation(v:String) : void
      {
         if(!this.lock)
         {
            this._animation = v;
         }
      }
      
      public function set direction(v:uint) : void
      {
         if(!this.lock)
         {
            this._direction = v;
         }
      }
      
      public function get animationStartValue() : String
      {
         return this._animationStartValue;
      }
      
      public function get directionStartValue() : uint
      {
         return this._directionStartValue;
      }
      
      public function get parent() : TiphonSprite
      {
         return this._parent;
      }
   }
}
