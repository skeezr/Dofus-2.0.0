package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class UIEventManager
   {
      
      private static var _self:com.ankamagames.berilia.managers.UIEventManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.berilia.managers.UIEventManager));
       
      private var _dInstanceIndex:Dictionary;
      
      public function UIEventManager()
      {
         this._dInstanceIndex = new Dictionary(true);
         super();
         if(_self != null)
         {
            throw new BeriliaError("UIEventManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.UIEventManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.berilia.managers.UIEventManager();
         }
         return _self;
      }
      
      public function get instances() : Dictionary
      {
         return this._dInstanceIndex;
      }
      
      public function registerInstance(ie:InstanceEvent) : void
      {
         this._dInstanceIndex[ie.instance] = ie;
      }
      
      public function isRegisteredInstance(target:DisplayObject, msg:* = null) : Boolean
      {
         return Boolean(this._dInstanceIndex[target]) && Boolean(this._dInstanceIndex[target].events[getQualifiedClassName(msg)]);
      }
      
      public function removeInstance(instance:*) : void
      {
         delete this._dInstanceIndex[instance];
      }
   }
}
