package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class PlayerManager implements IDestroyable
   {
      
      private static var _self:com.ankamagames.dofus.logic.common.managers.PlayerManager;
       
      public var communityId:uint;
      
      public var server:Server;
      
      public var hasRights:Boolean;
      
      public var nickname:String;
      
      public var remainingSubscriptionTime:Number;
      
      public var secretQuestion:String;
      
      public function PlayerManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("PlayerManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.common.managers.PlayerManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.common.managers.PlayerManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
   }
}
