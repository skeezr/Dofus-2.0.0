package com.ankamagames.berilia.types.event
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   
   public class InstanceEvent
   {
       
      private var _doInstance:DisplayObject;
      
      private var _aEvent:Array;
      
      private var _oCallback:Object;
      
      public function InstanceEvent(doInstance:DisplayObject, oCallback:Object)
      {
         super();
         this._doInstance = doInstance;
         this._aEvent = new Array();
         this._oCallback = oCallback;
         if(doInstance is InteractiveObject)
         {
            InteractiveObject(doInstance).mouseEnabled = true;
         }
      }
      
      public function get instance() : DisplayObject
      {
         return this._doInstance;
      }
      
      public function get events() : Array
      {
         return this._aEvent;
      }
      
      public function get haveEvent() : Boolean
      {
         return this._aEvent.length != 0;
      }
      
      public function push(sEventName:String) : void
      {
         this._aEvent[sEventName] = true;
      }
      
      public function get callbackObject() : Object
      {
         return this._oCallback;
      }
      
      public function set callbackObject(o:Object) : void
      {
         this._oCallback = o;
      }
   }
}
