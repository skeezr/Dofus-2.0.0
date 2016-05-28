package com.ankamagames.dofus.logic.connection.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessage;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessageWithServerIdMessage;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.jerakine.utils.crypto.MD5;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class AuthentificationManager implements IDestroyable
   {
      
      private static var _self:com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
       
      private var _key:String;
      
      private var _lva:LoginValidationAction;
      
      public var gameServerTicket:String;
      
      public function AuthentificationManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("AuthentificationManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.connection.managers.AuthentificationManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.connection.managers.AuthentificationManager();
         }
         return _self;
      }
      
      public function setConnectionKey(key:String) : void
      {
         this._key = key;
      }
      
      public function setValidationAction(lva:LoginValidationAction) : void
      {
         this._lva = lva;
      }
      
      public function get loginValidationAction() : LoginValidationAction
      {
         return this._lva;
      }
      
      public function getIdentificationMessage() : IdentificationMessage
      {
         var imsg:IdentificationMessage = new IdentificationMessage();
         imsg.initIdentificationMessage(imsg.version,this._lva.username,this._lva.password,this._lva.autoSelectServer);
         imsg.version.initVersion(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.revision,BuildInfos.BUILD_VERSION.buildType);
         return imsg;
      }
      
      public function getIdentificationMessageWithServerIdMessage() : IdentificationMessageWithServerIdMessage
      {
         var imwsimsg:IdentificationMessageWithServerIdMessage = new IdentificationMessageWithServerIdMessage();
         imwsimsg.initIdentificationMessageWithServerIdMessage(imwsimsg.version,this._lva.username,this._lva.password,this._lva.autoSelectServer,this._lva.serverId);
         imwsimsg.version.initVersion(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.revision,BuildInfos.BUILD_VERSION.buildType);
         return imwsimsg;
      }
      
      public function storeLastLoginUsed(login:String, pass:String = null) : void
      {
         StoreDataManager.getInstance().setData(Constants.DATASTORE_COMPUTER_OPTIONS,"RememberMeLogin",login);
         StoreDataManager.getInstance().setData(Constants.DATASTORE_COMPUTER_OPTIONS,"RememberMePass",pass);
      }
      
      public function retrieveLastLoginUsed() : String
      {
         return StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS,"RememberMeLogin","");
      }
      
      public function retrieveLastPassUsed() : String
      {
         return StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS,"RememberMePass","");
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function cipherString(pwd:String) : String
      {
         var md5:MD5 = new MD5();
         return md5.encrypt(md5.encrypt(pwd) + this._key);
      }
   }
}
