package com.ankamagames.berilia.types.shortcut
{
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class Shortcut
   {
      
      private static var _shortcuts:Array = new Array();
      
      private static var _idCount:uint = 0;
       
      private var _name:String;
      
      private var _description:String;
      
      private var _textfieldEnabled:Boolean;
      
      private var _bindable:Boolean;
      
      private var _category:com.ankamagames.berilia.types.shortcut.ShortcutCategory;
      
      private var _unicID:uint;
      
      public var defaultBind:com.ankamagames.berilia.types.shortcut.Bind;
      
      public function Shortcut(name:String, textfieldEnabled:Boolean = false, description:String = null, category:com.ankamagames.berilia.types.shortcut.ShortcutCategory = null, bindable:Boolean = true)
      {
         super();
         if(_shortcuts[name])
         {
            throw new BeriliaError("Shortcut name [" + name + "] is already use");
         }
         _shortcuts[name] = this;
         this._name = name;
         this._description = description;
         this._textfieldEnabled = textfieldEnabled;
         this._category = category;
         this._unicID = _idCount++;
         this._bindable = bindable;
      }
      
      public static function reset() : void
      {
         _shortcuts = [];
         _idCount = 0;
      }
      
      public static function getShortcutByName(name:String) : Shortcut
      {
         return _shortcuts[name];
      }
      
      public static function getShortcuts() : Array
      {
         return _shortcuts;
      }
      
      public function get unicID() : uint
      {
         return this._unicID;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get textfieldEnabled() : Boolean
      {
         return this._textfieldEnabled;
      }
      
      public function get bindable() : Boolean
      {
         return this._bindable;
      }
      
      public function get category() : com.ankamagames.berilia.types.shortcut.ShortcutCategory
      {
         return this._category;
      }
   }
}
