package com.ankamagames.berilia.components
{
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import flash.events.Event;
   import flash.text.TextFieldType;
   
   public class Input extends Label
   {
       
      private var _nMaxChars:uint;
      
      private var _bPassword:Boolean = false;
      
      private var _sRestrictChars:String;
      
      restricted_namespace var imeActive:Boolean;
      
      restricted_namespace var lastTextOnInput:String;
      
      public function Input()
      {
         super();
         _tText.selectable = true;
         _tText.type = TextFieldType.INPUT;
         _tText.restrict = this._sRestrictChars;
         _tText.maxChars = this._nMaxChars;
         _tText.mouseEnabled = true;
         _autoResize = false;
         if(Berilia.getInstance().useIME)
         {
            _tText.addEventListener(Event.CHANGE,this.onTextChange);
         }
      }
      
      public function get maxChars() : uint
      {
         return this._nMaxChars;
      }
      
      public function set maxChars(nValue:uint) : void
      {
         this._nMaxChars = nValue;
         _tText.maxChars = this._nMaxChars;
      }
      
      public function get password() : Boolean
      {
         return this._bPassword;
      }
      
      public function set password(bValue:Boolean) : void
      {
         this._bPassword = bValue;
         if(this._bPassword)
         {
            _tText.displayAsPassword = true;
         }
      }
      
      public function get restrictChars() : String
      {
         return this._sRestrictChars;
      }
      
      public function set restrictChars(sValue:String) : void
      {
         this._sRestrictChars = sValue;
         _tText.restrict = this._sRestrictChars;
      }
      
      public function get haveFocus() : Boolean
      {
         return Berilia.getInstance().docMain.stage.focus == _tText;
      }
      
      override public function set text(sValue:String) : void
      {
         super.text = sValue;
         this.onTextChange(null);
      }
      
      override public function focus() : void
      {
         Berilia.getInstance().docMain.stage.focus = _tText;
         FocusHandler.getInstance().setFocus(_tText);
      }
      
      public function blur() : void
      {
         Berilia.getInstance().docMain.stage.focus = null;
         FocusHandler.getInstance().setFocus(null);
      }
      
      override public function process(msg:Message) : Boolean
      {
         if(msg is MouseClickMessage && MouseClickMessage(msg).target == this)
         {
            this.focus();
         }
         return super.process(msg);
      }
      
      private function onTextChange(e:Event) : void
      {
         restricted_namespace::lastTextOnInput = _tText.text;
      }
   }
}
