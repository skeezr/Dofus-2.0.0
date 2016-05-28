package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.interfaces.Secure;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   
   public class MapElement implements Secure
   {
      
      public static var _elementRef:Dictionary = new Dictionary(true);
       
      private var _id:String;
      
      public var x:int;
      
      public var y:int;
      
      public var layer:String;
      
      public function MapElement(id:String, x:int, y:int, layer:String)
      {
         super();
         this.x = x;
         this.y = y;
         this.layer = layer;
         _elementRef[id] = this;
         this._id = id;
      }
      
      public static function getElementById(id:String) : MapElement
      {
         return _elementRef[id];
      }
      
      public static function removeElementById(id:String) : void
      {
         if(_elementRef[id])
         {
            _elementRef[id].remove();
         }
         delete _elementRef[id];
      }
      
      public static function removeAllElements() : void
      {
         _elementRef = new Dictionary(true);
      }
      
      restricted_namespace function get object() : *
      {
         return this;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function remove() : void
      {
         delete _elementRef[this._id];
      }
   }
}
