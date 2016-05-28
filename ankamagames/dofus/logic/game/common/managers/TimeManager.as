package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class TimeManager implements IDestroyable
   {
      
      private static var _self:com.ankamagames.dofus.logic.game.common.managers.TimeManager;
       
      public var serverTimeLag:Number;
      
      public var timezoneOffset:Number;
      
      public var dofusTimeYearLag:int;
      
      public function TimeManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("TimeManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.common.managers.TimeManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.game.common.managers.TimeManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
   }
}
