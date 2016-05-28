package com.ankamagames.jerakine.handlers.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.display.DisplayObject;
   
   public class HumanInputMessage implements Message
   {
       
      protected var _target:InteractiveObject;
      
      protected var _nativeEvent:Event;
      
      private var _canceled:Boolean;
      
      private var _actions:Array;
      
      public var bubbling:Boolean;
      
      public function HumanInputMessage(target:InteractiveObject, nativeEvent:Event)
      {
         super();
         this._target = target;
         this._nativeEvent = nativeEvent;
      }
      
      public function get target() : DisplayObject
      {
         return this._target;
      }
      
      public function get canceled() : Boolean
      {
         return this._canceled;
      }
      
      public function set canceled(value:Boolean) : void
      {
         if(this.bubbling)
         {
            throw new InvalidCancelError("Can\'t cancel a bubbling message.");
         }
         if(Boolean(this._canceled) && !value)
         {
            throw new InvalidCancelError("Can\'t uncancel a canceled message.");
         }
         this._canceled = value;
      }
      
      public function get actions() : Array
      {
         return this._actions;
      }
      
      public function addAction(action:Action) : void
      {
         if(this._actions == null)
         {
            this._actions = new Array();
         }
         this._actions.push(action);
      }
   }
}
