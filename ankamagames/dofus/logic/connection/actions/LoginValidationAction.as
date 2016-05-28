package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LoginValidationAction implements Action
   {
       
      private var _username:String;
      
      private var _password:String;
      
      private var _autoSelectServer:Boolean;
      
      private var _serverId:uint;
      
      public function LoginValidationAction()
      {
         super();
      }
      
      public static function create(username:String, password:String, autoSelectServer:Boolean, serverId:uint = 0) : LoginValidationAction
      {
         var a:LoginValidationAction = new LoginValidationAction();
         a._password = password;
         a._username = username;
         a._autoSelectServer = autoSelectServer;
         a._serverId = serverId;
         return a;
      }
      
      public function get username() : String
      {
         return this._username;
      }
      
      public function get password() : String
      {
         return this._password;
      }
      
      public function get autoSelectServer() : Boolean
      {
         return this._autoSelectServer;
      }
      
      public function get serverId() : uint
      {
         return this._serverId;
      }
   }
}
