package com.ankamagames.jerakine.handlers
{
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import flash.display.InteractiveObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class FocusHandler
   {
      
      private static var _self:com.ankamagames.jerakine.handlers.FocusHandler;
      
      private static var _currentFocus:WeakReference;
       
      public function FocusHandler()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("FocusHandler constructor should not be called directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.handlers.FocusHandler
      {
         if(_self == null)
         {
            _self = new com.ankamagames.jerakine.handlers.FocusHandler();
         }
         return _self;
      }
      
      public function setFocus(target:InteractiveObject) : void
      {
         _currentFocus = new WeakReference(target);
      }
      
      public function getFocus() : InteractiveObject
      {
         return !!_currentFocus?_currentFocus.object as InteractiveObject:null;
      }
      
      public function hasFocus(io:InteractiveObject) : Boolean
      {
         return _currentFocus.object == io;
      }
   }
}
