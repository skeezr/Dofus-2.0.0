package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.Uri;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TextArea extends Label implements FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TextArea));
       
      private var _sbScrollBar:com.ankamagames.berilia.components.ScrollBar;
      
      private var _bFinalized:Boolean;
      
      private var _nScrollPos:int = 5;
      
      private var _bHideScroll:Boolean = false;
      
      protected var ___width:uint;
      
      public function TextArea()
      {
         super();
         this._sbScrollBar = new com.ankamagames.berilia.components.ScrollBar();
         this._sbScrollBar.min = 1;
         this._sbScrollBar.max = 1;
         this._sbScrollBar.step = 1;
         this._sbScrollBar.addEventListener(Event.CHANGE,this.onScroll);
         _tText.addEventListener(MouseEvent.MOUSE_WHEEL,this.onTextWheel);
         addChild(this._sbScrollBar);
         _tText.wordWrap = true;
         _tText.multiline = true;
         _tText.mouseEnabled = true;
      }
      
      public function set scrollCss(sUrl:Uri) : void
      {
         this._sbScrollBar.css = sUrl;
      }
      
      public function get scrollCss() : Uri
      {
         return this._sbScrollBar.css;
      }
      
      override public function set width(nW:Number) : void
      {
         this.___width = nW;
         super.width = nW;
         this.updateScrollBarPos();
      }
      
      override public function get width() : Number
      {
         return this.___width;
      }
      
      override public function set height(nH:Number) : void
      {
         if(nH != super.height || nH != this._sbScrollBar.height)
         {
            super.height = nH;
            this._sbScrollBar.height = nH;
            if(this._bFinalized)
            {
               this.updateScrollBar();
            }
         }
      }
      
      override public function set text(sValue:String) : void
      {
         super.text = sValue;
         if(this._bFinalized)
         {
            this.updateScrollBar();
         }
      }
      
      public function set scrollPos(nValue:int) : void
      {
         this._nScrollPos = nValue;
      }
      
      override public function set css(sValue:Uri) : void
      {
         super.css = sValue;
      }
      
      override public function set scrollV(nVal:int) : void
      {
         super.scrollV = nVal;
         if(this._bFinalized)
         {
            this.updateScrollBar();
         }
      }
      
      override public function get scrollV() : int
      {
         return super.scrollV;
      }
      
      override public function get finalized() : Boolean
      {
         return this._bFinalized;
      }
      
      override public function set finalized(b:Boolean) : void
      {
         this._bFinalized = b;
      }
      
      public function get hideScroll() : Boolean
      {
         return this._bHideScroll;
      }
      
      public function set hideScroll(hideScroll:Boolean) : void
      {
         this._bHideScroll = hideScroll;
      }
      
      override public function appendText(sTxt:String, style:String = null) : void
      {
         super.appendText(sTxt,style);
         if(this._bFinalized)
         {
            this.updateScrollBar();
         }
      }
      
      override public function finalize() : void
      {
         this._sbScrollBar.finalize();
         this.updateScrollBarPos();
         this.updateScrollBar();
         this._bFinalized = true;
         getUi().iAmFinalized(this);
      }
      
      override public function free() : void
      {
         super.free();
         this._bFinalized = false;
         this._nScrollPos = 5;
         this.___width = 0;
         this._sbScrollBar.min = 1;
         this._sbScrollBar.max = 1;
         this._sbScrollBar.step = 1;
         _tText.wordWrap = true;
         _tText.multiline = true;
      }
      
      override public function remove() : void
      {
         if(this._sbScrollBar)
         {
            this._sbScrollBar.removeEventListener(Event.CHANGE,this.onScroll);
            this._sbScrollBar.remove();
         }
         this._sbScrollBar = null;
         _tText.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onTextWheel);
         super.remove();
      }
      
      private function updateScrollBar() : void
      {
         if(_tText.textHeight < height)
         {
            this._sbScrollBar.disabled = true;
            if(this._bHideScroll)
            {
               this._sbScrollBar.visible = false;
            }
         }
         else
         {
            this._sbScrollBar.visible = true;
            this._sbScrollBar.disabled = false;
            this._sbScrollBar.max = _tText.maxScrollV;
            this._sbScrollBar.value = _tText.scrollV;
         }
      }
      
      private function updateScrollBarPos() : void
      {
         if(this._nScrollPos >= 0)
         {
            this._sbScrollBar.x = this.width - this._sbScrollBar.width;
            _tText.width = this.width - this._sbScrollBar.width - this._nScrollPos;
            _tText.x = 0;
         }
         else
         {
            this._sbScrollBar.x = 0;
            _tText.width = this.width - this._sbScrollBar.width + this._nScrollPos;
            _tText.x = this._sbScrollBar.width - this._nScrollPos;
         }
      }
      
      private function onTextWheel(e:MouseEvent) : void
      {
         this._sbScrollBar.onWheel(e);
      }
      
      private function onScroll(e:Event) : void
      {
         _tText.scrollV = this._sbScrollBar.value;
      }
   }
}
