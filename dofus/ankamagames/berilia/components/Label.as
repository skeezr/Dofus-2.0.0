package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.text.TextField;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.types.data.ExtendedStyleSheet;
   import flash.text.TextFormat;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import flash.text.TextFieldAutoSize;
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.jerakine.types.Callback;
   import flash.text.TextFieldType;
   import flash.filters.DropShadowFilter;
   import flash.text.GridFitType;
   import com.ankamagames.jerakine.managers.FontManager;
   import flash.text.AntiAliasType;
   import flash.text.TextLineMetrics;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import flash.events.MouseEvent;
   import com.ankamagames.berilia.Berilia;
   import flash.display.Sprite;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.messages.Message;
   
   public class Label extends GraphicContainer implements UIComponent, IRectangle, FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Label));
       
      private var _finalized:Boolean;
      
      protected var _tText:TextField;
      
      private var _cssApplied:Boolean = false;
      
      protected var _sText:String = "";
      
      protected var _sType:String = "default";
      
      protected var _sCssUrl:Uri;
      
      protected var _nWidth:uint = 100;
      
      protected var _nHeight:uint = 20;
      
      protected var _bHtmlAllowed:Boolean = true;
      
      protected var _sAntialiasType:String = "normal";
      
      protected var _bFixedWidth:Boolean = true;
      
      protected var _hyperlinkEnabled:Boolean = false;
      
      protected var _bFixedHeight:Boolean = true;
      
      protected var _aStyleObj:Array;
      
      protected var _ssSheet:ExtendedStyleSheet;
      
      protected var _tfFormatter:TextFormat;
      
      protected var _useEmbedFonts:Boolean = true;
      
      protected var _nPaddingLeft:int = 0;
      
      protected var _nTextIndent:int = 0;
      
      protected var _bDisabled:Boolean;
      
      protected var _nTextHeight:int;
      
      protected var _sVerticalAlign:String = "none";
      
      protected var _useExtendWidth:Boolean = false;
      
      protected var _autoResize:Boolean = true;
      
      protected var _useStyleSheet:Boolean = false;
      
      protected var _useCustomFormat:Boolean = false;
      
      private var _useTooltipExtension:Boolean = true;
      
      private var _textFieldTooltipExtension:TextField;
      
      private var _textTooltipExtensionColor:uint;
      
      protected var _sCssClass:String;
      
      public function Label()
      {
         super();
         this._aStyleObj = new Array();
         this.createTextField();
         this._tText.type = TextFieldType.DYNAMIC;
         this._tText.selectable = false;
         this._tText.mouseEnabled = false;
      }
      
      public function get text() : String
      {
         return this._tText.text;
      }
      
      public function set text(sValue:String) : void
      {
         if(sValue == null)
         {
            sValue = "";
         }
         this._sText = sValue;
         if(this._bHtmlAllowed)
         {
            if(this._useStyleSheet)
            {
               this._tText.styleSheet = null;
            }
            this._tText.htmlText = sValue;
            if(!this._useCustomFormat)
            {
               if(this._sCssUrl != null && !this._cssApplied)
               {
                  this.applyCSS(this._sCssUrl);
                  this._cssApplied = true;
               }
               else
               {
                  this.updateCss();
                  if(_bgColor != -1)
                  {
                     bgColor = _bgColor;
                  }
               }
            }
         }
         else
         {
            this._tText.text = sValue;
         }
         this._tText.selectable;
         if(!this._sCssClass)
         {
            this.cssClass = "p";
         }
         if(this._hyperlinkEnabled)
         {
            HyperlinkFactory.createHyperlink(this._tText,this._useStyleSheet);
         }
         this.resizeText();
      }
      
      public function get hyperlinkEnabled() : Boolean
      {
         return this._hyperlinkEnabled;
      }
      
      public function set hyperlinkEnabled(bValue:Boolean) : void
      {
         this._hyperlinkEnabled = bValue;
      }
      
      public function get useStyleSheet() : Boolean
      {
         return this._useStyleSheet;
      }
      
      public function set useStyleSheet(bValue:Boolean) : void
      {
         this._useStyleSheet = bValue;
      }
      
      public function get useCustomFormat() : Boolean
      {
         return this._useCustomFormat;
      }
      
      public function set useCustomFormat(bValue:Boolean) : void
      {
         this._useCustomFormat = bValue;
      }
      
      public function get autoResize() : Boolean
      {
         return this._autoResize;
      }
      
      public function set autoResize(bValue:Boolean) : void
      {
         this._autoResize = bValue;
      }
      
      public function set caretIndex(pos:int) : void
      {
         var lastPos:int = 0;
         if(pos == -1)
         {
            lastPos = this._tText.text.length;
            this._tText.setSelection(lastPos,lastPos);
         }
         else
         {
            this._tText.setSelection(pos,pos);
         }
      }
      
      public function get type() : String
      {
         return this._sType;
      }
      
      public function set type(sValue:String) : void
      {
         this._sType = sValue;
      }
      
      public function get css() : Uri
      {
         return this._sCssUrl;
      }
      
      public function set css(sFile:Uri) : void
      {
         this._cssApplied = false;
         this.applyCSS(sFile);
      }
      
      public function set cssClass(c:String) : void
      {
         this._sCssClass = c == ""?"p":c;
         this.bindCss();
      }
      
      public function get cssClass() : String
      {
         return this._sCssClass;
      }
      
      public function get antialias() : String
      {
         return this._sAntialiasType;
      }
      
      public function set antialias(s:String) : void
      {
         this._sAntialiasType = s;
         this._tText.antiAliasType = this._sAntialiasType;
      }
      
      public function get thickness() : int
      {
         return this._tText.thickness;
      }
      
      public function set thickness(value:int) : void
      {
         this._tText.thickness = value;
      }
      
      override public function get width() : Number
      {
         return Boolean(this._useExtendWidth) && this._tText.numLines < 2?Number(this._tText.textWidth + 7):Number(this._nWidth);
      }
      
      override public function set width(nValue:Number) : void
      {
         this._nWidth = nValue;
         this._tText.width = this._nWidth;
         if(_bgColor != -1)
         {
            bgColor = _bgColor;
         }
         if(!this._bFixedHeight)
         {
            this.bindCss();
         }
      }
      
      override public function get height() : Number
      {
         return this._nHeight;
      }
      
      override public function set height(nValue:Number) : void
      {
         var valMin:Number = NaN;
         if(!this._tText.multiline)
         {
            valMin = this._tText.textHeight;
            if(nValue < valMin)
            {
               nValue = valMin;
            }
         }
         this._nHeight = nValue;
         this._tText.height = this._nHeight;
         if(_bgColor != -1)
         {
            bgColor = _bgColor;
         }
         this.updateAlign();
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(value:Boolean) : void
      {
         this._finalized = value;
      }
      
      public function get html() : Boolean
      {
         return this._bHtmlAllowed;
      }
      
      public function set html(bValue:Boolean) : void
      {
         this._bHtmlAllowed = bValue;
      }
      
      public function set wordWrap(bWordWrap:Boolean) : void
      {
         this._tText.wordWrap = bWordWrap;
      }
      
      public function get wordWrap() : Boolean
      {
         return this._tText.wordWrap;
      }
      
      public function set multiline(bMultiline:Boolean) : void
      {
         this._tText.multiline = bMultiline;
      }
      
      public function get multiline() : Boolean
      {
         return this._tText.multiline;
      }
      
      public function get border() : Boolean
      {
         return this._tText.border;
      }
      
      public function set border(bValue:Boolean) : void
      {
         this._tText.border = bValue;
      }
      
      public function get fixedWidth() : Boolean
      {
         return this._bFixedWidth;
      }
      
      public function set fixedWidth(bValue:Boolean) : void
      {
         this._bFixedWidth = bValue;
         if(this._bFixedWidth)
         {
            this._tText.autoSize = TextFieldAutoSize.NONE;
         }
         else
         {
            this._tText.autoSize = TextFieldAutoSize.LEFT;
         }
      }
      
      public function get useExtendWidth() : Boolean
      {
         return this._useExtendWidth;
      }
      
      public function set useExtendWidth(v:Boolean) : void
      {
         this._useExtendWidth = v;
      }
      
      public function get fixedHeight() : Boolean
      {
         return this._bFixedHeight;
      }
      
      public function set fixedHeight(bValue:Boolean) : void
      {
         this._bFixedHeight = bValue;
         this._tText.wordWrap = !this._bFixedHeight;
      }
      
      override public function set borderColor(nColor:int) : void
      {
         if(nColor == -1)
         {
            this._tText.border = false;
         }
         else
         {
            this._tText.border = true;
            this._tText.borderColor = nColor;
         }
      }
      
      public function set selectable(bValue:Boolean) : void
      {
         this._tText.selectable = bValue;
      }
      
      public function get length() : uint
      {
         return this._tText.length;
      }
      
      public function set scrollV(nVal:int) : void
      {
         this._tText.scrollV = nVal;
      }
      
      public function get scrollV() : int
      {
         return this._tText.scrollV;
      }
      
      public function get maxScrollV() : int
      {
         return this._tText.maxScrollV;
      }
      
      public function get textfield() : TextField
      {
         return this._tText;
      }
      
      public function get useEmbedFonts() : Boolean
      {
         return this._useEmbedFonts;
      }
      
      public function set useEmbedFonts(b:Boolean) : void
      {
         this._useEmbedFonts = b;
      }
      
      override public function set disabled(bool:Boolean) : void
      {
         if(bool)
         {
            HandCursor = false;
            mouseEnabled = false;
            this._tText.mouseEnabled = false;
         }
         else
         {
            HandCursor = true;
            mouseEnabled = true;
            this._tText.mouseEnabled = true;
         }
         this._bDisabled = bool;
      }
      
      public function get verticalAlign() : String
      {
         return this._sVerticalAlign;
      }
      
      public function set verticalAlign(s:String) : void
      {
         this._sVerticalAlign = s;
         this.updateAlign();
      }
      
      public function get textFormat() : TextFormat
      {
         return this._tfFormatter;
      }
      
      public function set textFormat(tf:TextFormat) : void
      {
         this._tfFormatter = tf;
         this._tText.setTextFormat(this._tfFormatter);
      }
      
      public function set restrict(restrictTo:String) : void
      {
         this._tText.restrict = restrictTo;
      }
      
      public function get restrict() : String
      {
         return this._tText.restrict;
      }
      
      public function set colorText(color:uint) : void
      {
         if(!this._tfFormatter)
         {
            _log.error("Error. Try to change the size before formatter was initialized.");
            return;
         }
         this._tfFormatter.color = color;
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
      }
      
      public function setCssColor(color:String, style:String = null) : void
      {
         this.changeCssClassColor(color,style);
      }
      
      public function setCssSize(size:uint, style:String = null) : void
      {
         this.changeCssClassSize(size,style);
      }
      
      public function applyCSS(sFile:Uri) : void
      {
         if(sFile == null)
         {
            return;
         }
         if(sFile == this._sCssUrl && Boolean(this._tfFormatter))
         {
            this.updateCss();
         }
         else
         {
            this._sCssUrl = sFile;
            CssManager.getInstance().askCss(sFile.uri,new Callback(this.bindCss));
         }
      }
      
      public function setBorderColor(nColor:int) : void
      {
         this._tText.borderColor = nColor;
      }
      
      override public function remove() : void
      {
         super.remove();
         if(Boolean(this._tText) && Boolean(contains(this._tText)))
         {
            removeChild(this._tText);
         }
      }
      
      override public function free() : void
      {
         super.free();
         this._sType = "default";
         this._nWidth = 100;
         this._nHeight = 20;
         this._bHtmlAllowed = true;
         this._sAntialiasType = "normal";
         this._bFixedWidth = true;
         this._bFixedHeight = true;
         this._ssSheet = null;
         this._useEmbedFonts = true;
         this._nPaddingLeft = 0;
         this._nTextIndent = 0;
         this._bDisabled = false;
         this._nTextHeight = 0;
         this._sVerticalAlign = "none";
         this._useExtendWidth = false;
         this._sCssClass = null;
         this._tText.type = TextFieldType.DYNAMIC;
         this._tText.selectable = false;
      }
      
      private function createTextField() : void
      {
         this._tText = new TextField();
         addChild(this._tText);
      }
      
      private function changeCssClassColor(color:String, style:String = null) : void
      {
         var i:* = undefined;
         if(style)
         {
            this._aStyleObj[style].color = color;
         }
         else
         {
            for each(i in this._aStyleObj)
            {
               i.color = color;
            }
         }
      }
      
      private function changeCssClassSize(size:uint, style:String = null) : void
      {
         var i:* = undefined;
         if(style)
         {
            this._aStyleObj[style].fontSize = size + "px";
         }
         else
         {
            for each(i in this._aStyleObj)
            {
               i.fontSize = size + "px";
            }
         }
      }
      
      public function appendText(sTxt:String, style:String = null) : void
      {
         var _tfFormatter2:TextFormat = null;
         var beginIndexAppend:uint = this._tText.text.length;
         if(this._hyperlinkEnabled)
         {
            sTxt = HyperlinkFactory.decode(sTxt);
         }
         this._tText.htmlText = this._tText.htmlText + sTxt;
         this._tText.filters = new Array();
         var endIndexAppend:uint = this._tText.text.length;
         if(Boolean(style) && Boolean(this._aStyleObj[style]))
         {
            _tfFormatter2 = this._ssSheet.transform(this._aStyleObj[style]);
            if(beginIndexAppend < endIndexAppend)
            {
               this._tText.setTextFormat(_tfFormatter2,beginIndexAppend,endIndexAppend);
               this._tText.defaultTextFormat = _tfFormatter2;
            }
         }
      }
      
      private function bindCss() : void
      {
         var styleToDisplay:String = null;
         var s:String = null;
         var sc:uint = 0;
         var ss:uint = 0;
         var fontClass:String = null;
         var font:String = null;
         if(!this._sCssUrl)
         {
            return;
         }
         var oldCss:ExtendedStyleSheet = this._ssSheet;
         this._ssSheet = CssManager.getInstance().getCss(this._sCssUrl.uri);
         if(!this._ssSheet)
         {
            return;
         }
         for each(s in this._ssSheet.styleNames)
         {
            if(!styleToDisplay || s == this._sCssClass || this._sCssClass != styleToDisplay && s == "p")
            {
               styleToDisplay = s;
            }
            if(this._ssSheet != oldCss || !this._aStyleObj[s])
            {
               this._aStyleObj[s] = this._ssSheet.getStyle(s);
            }
         }
         if(Boolean(this._aStyleObj[styleToDisplay]["shadowSize"]) || Boolean(this._aStyleObj[styleToDisplay]["shadowColor"]))
         {
            sc = !!this._aStyleObj[styleToDisplay]["shadowColor"]?uint(parseInt(this._aStyleObj[styleToDisplay]["shadowColor"].substr(1))):uint(0);
            ss = !!this._aStyleObj[styleToDisplay]["shadowSize"]?uint(parseInt(this._aStyleObj[styleToDisplay]["shadowSize"])):uint(5);
            this._tText.filters = [new DropShadowFilter(0,0,sc,0.5,ss,ss,3)];
         }
         if(this._aStyleObj[styleToDisplay]["useEmbedFonts"])
         {
            this._useEmbedFonts = this._aStyleObj[styleToDisplay]["useEmbedFonts"] == "true";
         }
         if(this._aStyleObj[styleToDisplay]["paddingLeft"])
         {
            this._nPaddingLeft = parseInt(this._aStyleObj[styleToDisplay]["paddingLeft"]);
         }
         if(this._aStyleObj[styleToDisplay]["verticalHeight"])
         {
            this._nTextHeight = parseInt(this._aStyleObj[styleToDisplay]["verticalHeight"]);
         }
         if(this._aStyleObj[styleToDisplay]["verticalAlign"])
         {
            this.verticalAlign = this._aStyleObj[styleToDisplay]["verticalAlign"];
         }
         if(this._aStyleObj[styleToDisplay]["thickness"])
         {
            this._tText.thickness = this._aStyleObj[styleToDisplay]["thickness"];
         }
         this._tText.gridFitType = GridFitType.PIXEL;
         this._tText.htmlText = !!this._sText?this._sText:this.text;
         this._tfFormatter = this._ssSheet.transform(this._aStyleObj[styleToDisplay]);
         if(this._aStyleObj[styleToDisplay]["leading"])
         {
            this._tfFormatter.leading = this._aStyleObj[styleToDisplay]["leading"];
         }
         if(this._aStyleObj[styleToDisplay]["letterSpacing"])
         {
            this._tfFormatter.letterSpacing = parseFloat(this._aStyleObj[styleToDisplay]["letterSpacing"]);
         }
         if(this._aStyleObj[styleToDisplay]["kerning"])
         {
            this._tfFormatter.kerning = this._aStyleObj[styleToDisplay]["kerning"] == "true";
         }
         this._tfFormatter.indent = this._nTextIndent;
         this._tfFormatter.leftMargin = this._nPaddingLeft;
         if(this._useEmbedFonts)
         {
            fontClass = FontManager.getInstance().getFontClassName(this._tfFormatter.font);
            if(fontClass)
            {
               this._tfFormatter.size = Math.round(int(this._tfFormatter.size) * FontManager.getInstance().getSizeMultipicator(this._tfFormatter.font));
               this._tfFormatter.font = fontClass;
               this._tText.defaultTextFormat.font = fontClass;
               this._tText.embedFonts = true;
               if(this._tfFormatter.size > 12 && !this._bFixedWidth)
               {
                  this._tText.antiAliasType = AntiAliasType.NORMAL;
               }
               else
               {
                  this._tText.antiAliasType = AntiAliasType.ADVANCED;
               }
            }
            else if(this._tfFormatter)
            {
               _log.warn("System font [" + this._tfFormatter.font + "] used (in " + (!!getUi()?getUi().name:"unknow") + ", from " + this._sCssUrl.uri + ")");
            }
            else
            {
               _log.fatal("Erreur de formattage.");
            }
         }
         else
         {
            font = FontManager.getInstance().getRealFontName(this._tfFormatter.font);
            this._tfFormatter.font = font != ""?font:this._tfFormatter.font;
            this._tText.embedFonts = false;
         }
         this._tfFormatter.bold = false;
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
         if(this._hyperlinkEnabled)
         {
            HyperlinkFactory.createHyperlink(this._tText);
         }
         if(this._nTextHeight)
         {
            this._tText.height = this._nTextHeight;
            this._tText.y = this._tText.y + (this._nHeight / 2 - this._tText.height / 2);
         }
         else if(!this._bFixedHeight)
         {
            this._tText.height = this._tText.textHeight + 5;
            this._nHeight = this._tText.height;
         }
         else
         {
            this._tText.height = this._nHeight;
         }
         if(this._useExtendWidth)
         {
            this._tText.width = this._tText.textWidth + 7;
            this._nWidth = this._tText.width;
         }
         if(_bgColor != -1)
         {
            bgColor = _bgColor;
         }
         this.updateAlign();
         if(Boolean(this._useExtendWidth) && Boolean(getUi()))
         {
            getUi().render();
         }
      }
      
      public function updateCss() : void
      {
         if(!this._tfFormatter)
         {
            return;
         }
         this._tText.setTextFormat(this._tfFormatter);
         this._tText.defaultTextFormat = this._tfFormatter;
         if(!this._bFixedHeight)
         {
            this._tText.height = this._tText.textHeight + 5;
            this._nHeight = this._tText.height;
         }
         else
         {
            this._tText.height = this._nHeight;
         }
         if(this._useExtendWidth)
         {
            this._tText.width = this._tText.textWidth + 7;
            this._nWidth = this._tText.width;
         }
         if(_bgColor != -1)
         {
            bgColor = _bgColor;
         }
         this.updateAlign();
         if(Boolean(this._useExtendWidth) && Boolean(getUi()))
         {
            getUi().render();
         }
      }
      
      public function fullSize(width:int) : void
      {
         this._nWidth = width;
         this._tText.width = width;
         var tHeight:uint = this._tText.textHeight + 5;
         this._tText.height = tHeight;
         this._nHeight = tHeight;
      }
      
      public function fullWidth() : void
      {
         this._nWidth = int(this._tText.textWidth + 5);
         this._tText.width = this._nWidth;
      }
      
      private function updateAlign() : void
      {
         if(!this._tText.textHeight)
         {
            return;
         }
         var lm:TextLineMetrics = this._tText.getLineMetrics(0);
         var h:uint = lm.height;
         switch(this._sVerticalAlign.toUpperCase())
         {
            case "CENTER":
               this._tText.height = h;
               this._tText.y = (this.height - this._tText.height) / 2 - lm.descent + lm.leading;
               break;
            case "BOTTOM":
               this._tText.height = this.height;
               this._tText.y = this.height - h;
               break;
            case "TOP":
               this._tText.height = h;
               this._tText.y = 0;
         }
      }
      
      private function addTooltipExtension(textInfo:TextFormat) : void
      {
         this._textFieldTooltipExtension = new TextField();
         this._textFieldTooltipExtension.selectable = false;
         this._textFieldTooltipExtension.height = 1;
         this._textFieldTooltipExtension.width = 1;
         this._textFieldTooltipExtension.embedFonts = this._tText.embedFonts;
         this._textFieldTooltipExtension.autoSize = TextFieldAutoSize.LEFT;
         this._textFieldTooltipExtension.text = "...";
         this._textFieldTooltipExtension.defaultTextFormat = textInfo;
         this._textFieldTooltipExtension.setTextFormat(textInfo);
         addChild(this._textFieldTooltipExtension);
         this._textTooltipExtensionColor = uint(textInfo.color);
         this._textFieldTooltipExtension.textColor = this._textTooltipExtensionColor;
         var w:int = this._textFieldTooltipExtension.width + 2;
         this._tText.width = this._tText.width - w;
         __width = this._tText.width;
         this._textFieldTooltipExtension.x = this._tText.width - 2;
         this._textFieldTooltipExtension.y = this._tText.y;
         this._tText.height = this._tText.height + 5;
         __height = this._tText.height;
         var target:DisplayObjectContainer = this;
         for(var i:int = 0; i < 4; i++)
         {
            if(target is ButtonContainer)
            {
               (target as ButtonContainer).mouseChildren = true;
               break;
            }
            target = target.parent;
            if(!target)
            {
               break;
            }
         }
         this._textFieldTooltipExtension.addEventListener(MouseEvent.ROLL_OVER,this.onTooltipExtensionOver,false,0,true);
         this._textFieldTooltipExtension.addEventListener(MouseEvent.ROLL_OUT,this.onTooltipExtensionOut,false,0,true);
      }
      
      private function onTooltipExtensionOver(e:MouseEvent) : void
      {
         var docMain:Sprite = Berilia.getInstance().docMain;
         TooltipManager.show(this._tText.text,this._textFieldTooltipExtension.getRect(docMain),UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"TextExtension",LocationEnum.POINT_TOP,LocationEnum.POINT_BOTTOM,20,true,null,UiApi.api_namespace::defaultTooltipUiScript);
         this._textFieldTooltipExtension.textColor = 16765814;
      }
      
      private function onTooltipExtensionOut(e:MouseEvent) : void
      {
         TooltipManager.hide("TextExtension");
         this._textFieldTooltipExtension.textColor = this._textTooltipExtensionColor;
      }
      
      private function resizeText() : void
      {
         var currentSize:int = 0;
         var sizeMin:int = 0;
         var needTooltipExtension:Boolean = false;
         var currentTextFieldWidth:int = 0;
         var textWidth:Number = NaN;
         if(this._textFieldTooltipExtension)
         {
            removeChild(this._textFieldTooltipExtension);
            this._tText.width = this._tText.width + int(this._textFieldTooltipExtension.width + 2);
            __width = this._tText.width;
            this._textFieldTooltipExtension.removeEventListener(MouseEvent.ROLL_OVER,this.onTooltipExtensionOver);
            this._textFieldTooltipExtension.removeEventListener(MouseEvent.ROLL_OUT,this.onTooltipExtensionOut);
            this._textFieldTooltipExtension = null;
         }
         if(Boolean(this._autoResize) && !this._tText.multiline && this._tText.autoSize == "none" && Boolean(this._tfFormatter))
         {
            currentSize = int(this._tfFormatter.size);
            sizeMin = currentSize * 0.7;
            if(sizeMin < 12)
            {
               sizeMin = 12;
            }
            needTooltipExtension = false;
            currentTextFieldWidth = this._tText.width;
            while(true)
            {
               textWidth = this._tText.textWidth;
               if(textWidth > currentTextFieldWidth)
               {
                  currentSize--;
                  if(currentSize < sizeMin)
                  {
                     if(this._useTooltipExtension)
                     {
                        needTooltipExtension = true;
                     }
                     else
                     {
                        _log.warn("Attention : Ce texte est beaucoup trop long pour entrer dans ce TextField (Texte : " + this._tText.text + ")");
                     }
                     break;
                  }
                  this._tfFormatter.size = currentSize;
                  this._tText.setTextFormat(this._tfFormatter);
                  continue;
               }
               break;
            }
            if(needTooltipExtension)
            {
               this.addTooltipExtension(this._tfFormatter);
            }
         }
      }
      
      public function finalize() : void
      {
         this.resizeText();
         this._finalized = true;
         var ui:UiRootContainer = getUi();
         if(ui)
         {
            ui.iAmFinalized(this);
         }
      }
      
      override public function process(msg:Message) : Boolean
      {
         super.process(msg);
         return false;
      }
   }
}
