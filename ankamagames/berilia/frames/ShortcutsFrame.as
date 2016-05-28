package com.ankamagames.berilia.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import flash.text.TextField;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.berilia.Berilia;
   import flash.system.IME;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   
   public class ShortcutsFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ShortcutsFrame));
      
      public static var shiftKey:Boolean = false;
      
      public static var ctrlKey:Boolean = false;
      
      public static var altKey:Boolean = false;
       
      public function ShortcutsFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function process(msg:Message) : Boolean
      {
         var kdmsg:KeyboardKeyDownMessage = null;
         var kumsg:KeyboardKeyUpMessage = null;
         var sShortcut:String = null;
         var imeActive:* = false;
         var bind:Bind = null;
         var shortcut:Bind = null;
         var tf:TextField = null;
         switch(true)
         {
            case msg is KeyboardKeyDownMessage:
               kdmsg = KeyboardKeyDownMessage(msg);
               shiftKey = kdmsg.keyboardEvent.shiftKey;
               ctrlKey = kdmsg.keyboardEvent.ctrlKey;
               altKey = kdmsg.keyboardEvent.altKey;
               return false;
            case msg is KeyboardKeyUpMessage:
               kumsg = KeyboardKeyUpMessage(msg);
               sShortcut = BindsManager.getInstance().getShortcutString(kumsg.keyboardEvent.keyCode,kumsg.keyboardEvent.charCode);
               shiftKey = kumsg.keyboardEvent.shiftKey;
               ctrlKey = kumsg.keyboardEvent.ctrlKey;
               altKey = kumsg.keyboardEvent.altKey;
               if(FocusHandler.getInstance().getFocus() is TextField && Boolean(Berilia.getInstance().useIME) && Boolean(IME.enabled))
               {
                  tf = FocusHandler.getInstance().getFocus() as TextField;
                  if(tf.parent is Input)
                  {
                     imeActive = tf.text != Input(tf.parent).restricted_namespace::lastTextOnInput;
                     if(!imeActive && Boolean(Input(tf.parent).restricted_namespace::imeActive))
                     {
                        Input(tf.parent).restricted_namespace::imeActive = false;
                        imeActive = true;
                     }
                     else
                     {
                        Input(tf.parent).restricted_namespace::imeActive = imeActive;
                     }
                  }
               }
               if(sShortcut == null || Boolean(imeActive))
               {
                  return true;
               }
               bind = new Bind(sShortcut,"",kumsg.keyboardEvent.altKey,kumsg.keyboardEvent.ctrlKey,kumsg.keyboardEvent.shiftKey);
               shortcut = BindsManager.getInstance().getBind(bind);
               if(BindsManager.getInstance().canBind(bind))
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.KeyboardShortcut,bind,kumsg.keyboardEvent.keyCode);
               }
               if(shortcut != null)
               {
                  if(!Shortcut.getShortcutByName(shortcut.targetedShortcut) || !Shortcut.getShortcutByName(shortcut.targetedShortcut).textfieldEnabled && StageShareManager.stage.focus is TextField)
                  {
                     break;
                  }
                  BindsManager.getInstance().processCallback(shortcut,shortcut.targetedShortcut);
               }
               return false;
         }
         return false;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
