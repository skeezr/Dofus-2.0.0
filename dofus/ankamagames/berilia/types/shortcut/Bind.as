package com.ankamagames.berilia.types.shortcut
{
   public class Bind
   {
       
      public var key:String;
      
      public var targetedShortcut:String;
      
      public var alt:Boolean;
      
      public var ctrl:Boolean;
      
      public var shift:Boolean;
      
      public function Bind(sKey:String = null, targetedShortcut:String = "", bAlt:Boolean = false, bCtrl:Boolean = false, bShift:Boolean = false)
      {
         super();
         if(sKey)
         {
            this.targetedShortcut = targetedShortcut;
            this.key = sKey;
            this.alt = bAlt;
            this.ctrl = bCtrl;
            this.shift = bShift;
         }
      }
      
      public function toString() : String
      {
         return (!!this.alt?"Alt+":"") + (!!this.ctrl?"Ctrl+":"") + (!!this.shift?"Shift+":"") + this.key.toLocaleUpperCase();
      }
      
      public function equals(s:Bind) : Boolean
      {
         return Boolean(s && s.key.toLocaleUpperCase() == this.key.toLocaleUpperCase() && s.alt == this.alt) && s.ctrl == this.ctrl && s.shift == this.shift;
      }
   }
}
