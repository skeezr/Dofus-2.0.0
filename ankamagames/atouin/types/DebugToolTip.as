package com.ankamagames.atouin.types
{
   import flash.display.Sprite;
   import flash.display.Shape;
   import flash.text.TextField;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   
   public class DebugToolTip extends Sprite
   {
      
      private static var _self:com.ankamagames.atouin.types.DebugToolTip;
       
      private var _shape:Shape;
      
      private var _textfield:TextField;
      
      public function DebugToolTip()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         mouseEnabled = false;
         mouseChildren = false;
         this._shape = new Shape();
         var f:DropShadowFilter = new DropShadowFilter(0,45,4473924,0.5,4,4,1,1);
         filters = [f];
         addChild(this._shape);
         this._textfield = new TextField();
         this._textfield.autoSize = TextFieldAutoSize.LEFT;
         addChild(this._textfield);
      }
      
      public static function getInstance() : com.ankamagames.atouin.types.DebugToolTip
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.types.DebugToolTip();
         }
         return _self;
      }
      
      public function set text(s:String) : void
      {
         this._textfield.text = s;
         this._shape.x = this._textfield.x - 4;
         this._shape.y = this._textfield.y - 4;
         this._shape.graphics.clear();
         this._shape.graphics.beginFill(16777215,0.7);
         this._shape.graphics.drawRect(0,0,this._textfield.textWidth + 8,this._textfield.textHeight + 8);
      }
   }
}
