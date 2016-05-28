package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.common.actions.ChangeCharacterAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.actions.ChangeServerAction;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.logic.common.actions.QuitGameAction;
   
   public class ChangeCharacterFrame implements Frame
   {
       
      public function ChangeCharacterFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var cca:ChangeCharacterAction = null;
         var lvacca:LoginValidationAction = null;
         var lvaccaNew:LoginValidationAction = null;
         var lvacha:LoginValidationAction = null;
         var lvachaNew:LoginValidationAction = null;
         switch(true)
         {
            case msg is ChangeCharacterAction:
               cca = msg as ChangeCharacterAction;
               lvacca = AuthentificationManager.getInstance().loginValidationAction;
               lvaccaNew = LoginValidationAction.create(lvacca.username,lvacca.password,true,cca.serverId);
               AuthentificationManager.getInstance().setValidationAction(lvaccaNew);
               SoundManager.getInstance().manager.removeAllSounds();
               ConnectionsHandler.closeConnection();
               Kernel.getInstance().reset(null,true);
               return true;
            case msg is ChangeServerAction:
               lvacha = AuthentificationManager.getInstance().loginValidationAction;
               lvachaNew = LoginValidationAction.create(lvacha.username,lvacha.password,false);
               AuthentificationManager.getInstance().setValidationAction(lvachaNew);
               ConnectionsHandler.closeConnection();
               Kernel.getInstance().reset(null,true);
               return true;
            case msg is ResetGameAction:
               SoundManager.getInstance().manager.removeAllSounds();
               ConnectionsHandler.closeConnection();
               Kernel.getInstance().reset();
               return true;
            case msg is QuitGameAction:
               Dofus.getInstance().quit();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
