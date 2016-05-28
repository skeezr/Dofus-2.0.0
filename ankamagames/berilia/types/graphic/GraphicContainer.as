package com.ankamagames.berilia.types.graphic
{
   import flash.display.Sprite;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.pools.Poolable;
   import com.ankamagames.jerakine.interfaces.ISecurizable;
   import com.ankamagames.jerakine.interfaces.IDragAndDropHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.filters.DropShadowFilter;
   import flash.display.Shape;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.berilia.Berilia;
   import flash.filters.BitmapFilterQuality;
   import com.ankamagames.berilia.api.SecureComponent;
   import flash.geom.ColorTransform;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.berilia.components.messages.ItemRollOutMessage;
   import com.ankamagames.berilia.components.messages.ItemRollOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.Event;
   import gs.TweenMax;
   import gs.easing.Strong;
   import flash.geom.Point;
   
   public class GraphicContainer extends Sprite implements UIComponent, IRectangle, Poolable, ISecurizable, IDragAndDropHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GraphicContainer));
       
      protected var __width:uint;
      
      protected var __widthReal:uint;
      
      protected var __height:uint;
      
      protected var __heightReal:uint;
      
      protected var __removed:Boolean;
      
      protected var _bgColor:int = -1;
      
      protected var _bgAlpha:Number = 1;
      
      protected var _borderColor:int = -1;
      
      public var minSize:com.ankamagames.berilia.types.graphic.GraphicSize;
      
      public var maxSize:com.ankamagames.berilia.types.graphic.GraphicSize;
      
      protected var _aStrata:Array;
      
      private var _scale:Number = 1.0;
      
      private var _sLinkedTo:String;
      
      private var _bDynamicPosition:Boolean;
      
      private var _bDisabled:Boolean;
      
      private var _bSoftDisabled:Boolean;
      
      private var _bGreyedOut:Boolean;
      
      private var _shadow:DropShadowFilter;
      
      private var _luminosity:Number = 1.0;
      
      private var _bgCornerRadius:uint = 0;
      
      private var _nMouseX:int;
      
      private var _nMouseY:int;
      
      private var _nStartWidth:int;
      
      private var _nStartHeight:int;
      
      private var _nLastWidth:int;
      
      private var _nLastHeight:int;
      
      private var _shResizeBorder:Shape;
      
      private var _bUseSimpleResize:Boolean = false;
      
      private var _uiRootContainer:com.ankamagames.berilia.types.graphic.UiRootContainer;
      
      private var _dropValidatorFunction:Function;
      
      private var _processDropFunction:Function;
      
      private var _removeDropSourceFunction:Function;
      
      private var _startSlideTime:int;
      
      private var _timeSlide:int;
      
      private var _slideBaseX:int;
      
      private var _slideBaseY:int;
      
      private var _slideWidth:int;
      
      private var _slideHeight:int;
      
      public function GraphicContainer()
      {
         super();
         this._aStrata = new Array();
         focusRect = false;
         this.mouseEnabled = false;
      }
      
      public function set dropValidator(dv:Function) : void
      {
         this._dropValidatorFunction = dv;
      }
      
      public function get dropValidator() : Function
      {
         return this._dropValidatorFunction;
      }
      
      public function set removeDropSource(rds:Function) : void
      {
         this._removeDropSourceFunction = rds;
      }
      
      public function get removeDropSource() : Function
      {
         return this._removeDropSourceFunction;
      }
      
      public function set processDrop(pd:Function) : void
      {
         this._processDropFunction = pd;
      }
      
      public function get processDrop() : Function
      {
         return this._processDropFunction;
      }
      
      public function focus() : void
      {
         FocusHandler.getInstance().setFocus(this);
      }
      
      private function returnFalseFunction(... args) : Boolean
      {
         return false;
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(nScale:Number) : void
      {
         this.__width = this.__widthReal * (1 - nScale);
         this.__height = this.__heightReal * (1 - nScale);
         scaleX = nScale;
         scaleY = nScale;
      }
      
      override public function set width(nW:Number) : void
      {
         if(nW < 1)
         {
            this.__width = 1;
         }
         else
         {
            this.__width = nW;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__widthReal = this.__width;
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = this.getUi();
         if(ui)
         {
            ui.updateLinkedUi();
         }
      }
      
      override public function set height(nH:Number) : void
      {
         if(nH < 1)
         {
            this.__height = 1;
         }
         else
         {
            this.__height = nH;
         }
         if(this._bgColor != -1)
         {
            this.bgColor = this._bgColor;
         }
         this.__heightReal = this.__height;
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = this.getUi();
         if(ui)
         {
            ui.updateLinkedUi();
         }
      }
      
      override public function get width() : Number
      {
         if(Boolean(isNaN(this.__width)) || !this.__width)
         {
            return this.getBounds(this).width * scaleX;
         }
         return this.__width * scaleX;
      }
      
      override public function get height() : Number
      {
         if(Boolean(isNaN(this.__height)) || !this.__height)
         {
            return this.getBounds(this).height * scaleY;
         }
         return this.__height * scaleY;
      }
      
      public function get contentWidth() : Number
      {
         return super.width;
      }
      
      public function get contentHeight() : Number
      {
         return super.height;
      }
      
      override public function set x(value:Number) : void
      {
         super.x = value;
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = this.getUi();
         if(ui)
         {
            if(Boolean(ui.getElementById(this.name)) && Boolean(ui.getElementById(this.name).location))
            {
               ui.getElementById(this.name).location.offsetXType = x;
            }
            ui.updateLinkedUi();
         }
      }
      
      override public function set y(value:Number) : void
      {
         super.y = value;
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = this.getUi();
         if(ui)
         {
            ui.updateLinkedUi();
         }
      }
      
      public function set bgColor(nColor:int) : void
      {
         this._bgColor = nColor;
         graphics.clear();
         if(this.bgColor == -1 || !this.width || !this.height)
         {
            return;
         }
         if(this._borderColor != -1)
         {
            graphics.lineStyle(1,this._borderColor);
         }
         graphics.beginFill(nColor,this._bgAlpha);
         if(!this._bgCornerRadius)
         {
            graphics.drawRect(0,0,this.width,this.height);
         }
         else
         {
            graphics.drawRoundRect(0,0,this.width,this.height,this._bgCornerRadius,this._bgCornerRadius);
         }
         graphics.endFill();
      }
      
      public function get bgColor() : int
      {
         return this._bgColor;
      }
      
      public function set bgAlpha(nAlpha:Number) : void
      {
         this._bgAlpha = nAlpha;
         this.bgColor = this.bgColor;
      }
      
      public function set borderColor(color:int) : void
      {
         this._borderColor = color;
         this.bgColor = this.bgColor;
      }
      
      public function set bgCornerRadius(value:uint) : void
      {
         this._bgCornerRadius = value;
         this.bgColor = this.bgColor;
      }
      
      public function get bgCornerRadius() : uint
      {
         return this._bgCornerRadius;
      }
      
      public function get bgAlpha() : Number
      {
         return this._bgAlpha;
      }
      
      public function set luminosity(nColor:Number) : void
      {
         this._luminosity = nColor;
      }
      
      public function get luminosity() : Number
      {
         return this._luminosity;
      }
      
      public function set linkedTo(sUiComponent:String) : void
      {
         this._sLinkedTo = sUiComponent;
      }
      
      public function get linkedTo() : String
      {
         return this._sLinkedTo;
      }
      
      public function set shadowColor(nColor:uint) : void
      {
         if(Berilia.getInstance().options.uiShadows)
         {
            this._shadow = new DropShadowFilter(3,90,nColor,1,10,10,0.61,BitmapFilterQuality.HIGH);
            filters = [this._shadow];
         }
      }
      
      public function getSecureObject() : *
      {
         return SecureComponent.getSecureComponent(this,!!this.getUi()?Boolean(this.getUi().uiModule.trusted):false);
      }
      
      public function setAdvancedGlow(nColor:uint, nAlpha:Number = 1, nBlurX:Number = 6.0, nBlurY:Number = 6.0, nStrength:Number = 2) : void
      {
      }
      
      public function clearFilters() : void
      {
         filters = [];
      }
      
      public function get shadowColor() : uint
      {
         return !!this._shadow?uint(this._shadow.color):uint(0);
      }
      
      public function getStrata(nStrata:uint) : Sprite
      {
         var nIndex:uint = 0;
         var i:uint = 0;
         if(this._aStrata[nStrata] != null)
         {
            return this._aStrata[nStrata];
         }
         this._aStrata[nStrata] = new Sprite();
         this._aStrata[nStrata].name = "strata_" + nStrata;
         this._aStrata[nStrata].mouseEnabled = false;
         nIndex = 0;
         for(i = 0; i < this._aStrata.length; i++)
         {
            if(this._aStrata[i] != null)
            {
               addChildAt(this._aStrata[i],nIndex++);
            }
         }
         return this._aStrata[nStrata];
      }
      
      public function set dynamicPosition(bool:Boolean) : void
      {
         this._bDynamicPosition = bool;
      }
      
      public function get dynamicPosition() : Boolean
      {
         return this._bDynamicPosition;
      }
      
      public function set disabled(bool:Boolean) : void
      {
         if(bool)
         {
            transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1);
            this.HandCursor = false;
            this.mouseEnabled = false;
            mouseChildren = false;
         }
         else
         {
            transform.colorTransform = new ColorTransform(1,1,1,1);
            this.HandCursor = true;
            this.mouseEnabled = true;
            mouseChildren = true;
         }
         this._bDisabled = bool;
      }
      
      public function get disabled() : Boolean
      {
         return this._bDisabled;
      }
      
      public function set softDisabled(bool:Boolean) : void
      {
         if(this._bSoftDisabled != bool)
         {
            if(bool)
            {
               transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1);
            }
            else
            {
               transform.colorTransform = new ColorTransform(1,1,1,1);
            }
         }
         this._bSoftDisabled = bool;
      }
      
      public function get softDisabled() : Boolean
      {
         return this._bSoftDisabled;
      }
      
      public function set greyedOut(bool:Boolean) : void
      {
         if(this._bGreyedOut != bool)
         {
            if(bool)
            {
               transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1);
            }
            else
            {
               transform.colorTransform = new ColorTransform(1,1,1,1);
            }
         }
         this._bGreyedOut = bool;
      }
      
      public function get greyedOut() : Boolean
      {
         return this._bGreyedOut;
      }
      
      public function get depths() : Array
      {
         var aDepth:Array = new Array();
         var doParent:GraphicContainer = this;
         while(doParent.getParent() != null)
         {
            aDepth.unshift(Sprite(doParent.parent).getChildIndex(doParent));
            doParent = doParent.getParent();
         }
         return aDepth;
      }
      
      public function set HandCursor(bValue:Boolean) : void
      {
         this.buttonMode = bValue;
         this.mouseChildren = !bValue;
      }
      
      override public function set mouseEnabled(v:Boolean) : void
      {
         var ctr:DisplayObjectContainer = null;
         super.mouseEnabled = v;
         for each(ctr in this._aStrata)
         {
            ctr.mouseEnabled = v;
         }
      }
      
      public function process(msg:Message) : Boolean
      {
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = null;
         var newMsg:MouseClickMessage = null;
         if(this._bSoftDisabled)
         {
            if(!(msg is ItemRollOutMessage || msg is ItemRollOverMessage || msg is MouseOverMessage || msg is MouseOutMessage))
            {
               return true;
            }
         }
         if(msg is MouseClickMessage && Boolean(this._sLinkedTo))
         {
            ui = this.getUi();
            if(ui != null)
            {
            }
            newMsg = new MouseClickMessage(ui.getElement(this._sLinkedTo),MouseClickMessage(msg).mouseEvent);
            ui.getElement(this._sLinkedTo).process(newMsg);
         }
         return false;
      }
      
      override public function stopDrag() : void
      {
         super.stopDrag();
         this.x = x;
         this.y = y;
      }
      
      public function getStageRect() : Rectangle
      {
         return this.getRect(stage);
      }
      
      public function remove() : void
      {
         this.__removed = true;
         var ui:com.ankamagames.berilia.types.graphic.UiRootContainer = this.getUi();
         if(ui)
         {
            ui.deleteId(name);
         }
         this.destroy(this);
         SecureComponent.restricted_namespace::destroy(this);
         if(Boolean(parent) && Boolean(parent.contains(this)))
         {
            parent.removeChild(this);
         }
      }
      
      public function addContent(child:GraphicContainer) : GraphicContainer
      {
         this.getStrata(0).addChild(child);
         return child;
      }
      
      public function getParent() : GraphicContainer
      {
         if(this.parent == null || this is com.ankamagames.berilia.types.graphic.UiRootContainer)
         {
            return null;
         }
         var doCurrent:DisplayObjectContainer = DisplayObjectContainer(this.parent);
         while(!(doCurrent is GraphicContainer))
         {
            doCurrent = DisplayObjectContainer(doCurrent.parent);
         }
         return GraphicContainer(doCurrent);
      }
      
      public function getUi() : com.ankamagames.berilia.types.graphic.UiRootContainer
      {
         if(this._uiRootContainer)
         {
            return this._uiRootContainer;
         }
         if(this.parent == null)
         {
            return null;
         }
         var doCurrent:Sprite = Sprite(this.parent);
         while(!(doCurrent is com.ankamagames.berilia.types.graphic.UiRootContainer) && doCurrent != null)
         {
            if(doCurrent.parent is Sprite)
            {
               doCurrent = Sprite(doCurrent.parent);
            }
            else
            {
               doCurrent = null;
            }
         }
         if(doCurrent == null)
         {
            return null;
         }
         this._uiRootContainer = UiRootContainer(doCurrent);
         return UiRootContainer(doCurrent);
      }
      
      public function get topParent() : DisplayObject
      {
         return this.getTopParent(this);
      }
      
      public function getTopParent(d:DisplayObject) : DisplayObject
      {
         if(d.parent != null)
         {
            return this.getTopParent(d.parent);
         }
         return d;
      }
      
      public function startResize() : void
      {
         this._nMouseX = StageShareManager.mouseX;
         this._nMouseY = StageShareManager.mouseY;
         this._nStartWidth = this.width;
         this._nStartHeight = this.height;
         if(this._bUseSimpleResize)
         {
            this._shResizeBorder = new Shape();
            addChild(this._shResizeBorder);
         }
         this.getUi().removeFromRenderList(name);
         EnterFrameDispatcher.addEventListener(this.onEnterFrame,"GraphicContainer");
      }
      
      public function onEnterFrame(e:Event) : void
      {
         var w:int = this._nStartWidth + StageShareManager.mouseX - this._nMouseX;
         var h:int = this._nStartHeight + StageShareManager.mouseY - this._nMouseY;
         if(this.minSize != null)
         {
            if(!isNaN(this.minSize.x) && w < this.minSize.x)
            {
               w = this.minSize.x;
            }
            if(!isNaN(this.minSize.y) && h < this.minSize.y)
            {
               h = this.minSize.y;
            }
         }
         if(this.maxSize != null)
         {
            if(!isNaN(this.maxSize.x) && w > this.maxSize.x)
            {
               w = this.maxSize.x;
            }
            if(!isNaN(this.maxSize.y) && h > this.maxSize.y)
            {
               h = this.maxSize.y;
            }
         }
         this.width = w;
         this.height = h;
         if(this._nLastWidth != this.width || this._nLastHeight != this.height)
         {
            if(this._bUseSimpleResize)
            {
               this._shResizeBorder.graphics.clear();
               this._shResizeBorder.graphics.beginFill(16777215,0.05);
               this._shResizeBorder.graphics.lineStyle(1,0,0.2);
               this._shResizeBorder.graphics.drawRect(0,0,this.width,this.height);
               this._shResizeBorder.graphics.endFill();
            }
            else
            {
               try
               {
                  this.getUi().render();
               }
               catch(err:Error)
               {
               }
            }
            this._nLastWidth = this.width;
            this._nLastHeight = this.height;
         }
      }
      
      public function endResize() : void
      {
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         if(this._bUseSimpleResize)
         {
            this.getUi().render();
            if(contains(this._shResizeBorder))
            {
               removeChild(this._shResizeBorder);
            }
         }
      }
      
      public function slide(endX:int, endY:int, time:int) : void
      {
         TweenMax.to(this,time / 1000,{
            "x":endX,
            "y":endY,
            "ease":Strong.easeOut
         });
      }
      
      override public function localToGlobal(point:Point) : Point
      {
         var target:DisplayObject = this;
         var coord:Point = point;
         while(Boolean(target) && Boolean(target.parent))
         {
            coord.x = coord.x + target.parent.x;
            coord.y = coord.y + target.parent.y;
            target = target.parent;
         }
         return coord;
      }
      
      protected function destroy(target:DisplayObjectContainer) : void
      {
         var item:DisplayObject = null;
         if(!target)
         {
            return;
         }
         var index:uint = 0;
         while(Boolean(target.numChildren) && index < target.numChildren)
         {
            item = target.getChildAt(index);
            if(!item)
            {
               index++;
            }
            else
            {
               if(item is GraphicContainer)
               {
                  (item as GraphicContainer).remove();
               }
               if(item is DisplayObjectContainer)
               {
                  this.destroy(item as DisplayObjectContainer);
               }
               if(target.contains(item))
               {
                  target.removeChild(item);
               }
               item = null;
            }
         }
      }
      
      public function free() : void
      {
         this.__width = 0;
         this.__widthReal = 0;
         this.__height = 0;
         this.__heightReal = 0;
         this.__removed = false;
         this._bgColor = -1;
         this._bgAlpha = 1;
         this.minSize = null;
         this.maxSize = null;
         this._scale = 1;
         this._sLinkedTo = null;
         this._bDisabled = false;
         this._shadow = null;
         this._luminosity = 1;
         this._bgCornerRadius = 0;
         this._nMouseX = 0;
         this._nMouseY = 0;
         this._nStartWidth = 0;
         this._nStartHeight = 0;
         this._nLastWidth = 0;
         this._nLastHeight = 0;
         this._shResizeBorder = null;
         this._bUseSimpleResize = false;
         this._uiRootContainer = null;
      }
   }
}
