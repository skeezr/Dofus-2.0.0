package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.shortcut.Bind;
   
   [InstanciedApi]
   public class BindsApi
   {
       
      private var _module:UiModule;
      
      public function BindsApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Trusted]
      public function getBindList() : Array
      {
         return BindsManager.getInstance().binds;
      }
      
      [Trusted]
      public function getShortcut() : Array
      {
         var s:Shortcut = null;
         var copy:Array = new Array();
         var ss:Array = Shortcut.getShortcuts();
         for each(s in ss)
         {
            if(s.bindable)
            {
               copy.push(s);
            }
         }
         return copy;
      }
      
      [Trusted]
      public function getShortcutBind(shortcutName:String) : Bind
      {
         return BindsManager.getInstance().getBindFromShortcut(shortcutName);
      }
      
      [Trusted]
      public function setShortcutBind(targetedShorcut:String, key:String, alt:Boolean, ctrl:Boolean, shift:Boolean) : void
      {
         BindsManager.getInstance().addBind(new Bind(key,targetedShorcut,alt,ctrl,shift));
      }
      
      [Trusted]
      public function removeShortcutBind(targetedBind:String) : void
      {
         BindsManager.getInstance().removeBind(BindsManager.getInstance().getBindFromShortcut(targetedBind));
      }
      
      [Trusted]
      public function resetAllBinds() : void
      {
         BindsManager.getInstance().reset();
      }
      
      [Trusted]
      public function avaibleKeyboard() : Array
      {
         return BindsManager.getInstance().avaibleKeyboard.concat();
      }
      
      [Trusted]
      public function changeKeyboard(locale:String) : void
      {
         BindsManager.getInstance().changeKeyboard(locale,true);
      }
      
      [Trusted]
      public function getCurrentLocale() : String
      {
         return BindsManager.getInstance().currentLocale;
      }
      
      [Trusted]
      public function bindIsRegister(bind:Bind) : Boolean
      {
         return BindsManager.getInstance().isRegister(bind);
      }
      
      [Trusted]
      public function bindIsPermanent(bind:Bind) : Boolean
      {
         return BindsManager.getInstance().isPermanent(bind);
      }
      
      [Trusted]
      public function getRegisteredBind(bind:Bind) : Bind
      {
         return BindsManager.getInstance().getRegisteredBind(bind);
      }
      
      [Trusted]
      public function getShortcutByName(name:String) : Shortcut
      {
         return Shortcut.getShortcutByName(name);
      }
   }
}
