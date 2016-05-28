package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.text.TextField;
   import flash.display.MovieClip;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.events.Event;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.managers.FontManager;
   import flash.text.TextFormat;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.system.Capabilities;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.jerakine.types.enums.BuildTypeEnum;
   import flash.events.MouseEvent;
   import flash.display.SimpleButton;
   
   public class LoadingScreen extends UiRootContainer implements FinalizableUIComponent
   {
      
      public static const INFO:uint = 0;
      
      public static const IMPORTANT:uint = 1;
      
      public static const ERROR:uint = 2;
      
      public static const WARNING:uint = 3;
       
      private var _loader:IResourceLoader;
      
      private var _logTf:TextField;
      
      private var _value:Number = 0;
      
      private var _levelColor:Array;
      
      private var _background:Class;
      
      private var _bandeau_haut:Class;
      
      private var _bandeau_bas:Class;
      
      private var _foreground:Class;
      
      private var _logoFr:Class;
      
      private var _logoJp:Class;
      
      private var _dofusProgress:Class;
      
      private var _tipsBackground:Class;
      
      private var _btnLog:Class;
      
      private var _btnContinue:Class;
      
      private var _progressClip:MovieClip;
      
      private var _backgroundBitmap:Bitmap;
      
      private var _foregroundBitmap:Bitmap;
      
      private var _tipsBackgroundBitmap:DisplayObject;
      
      private var _tipsTextField:TextField;
      
      private var _btnContinueClip:DisplayObject;
      
      private var _continueCallBack:Function;
      
      public function LoadingScreen()
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._levelColor = new Array(8158332,9216860,11556943,16737792);
         this._background = LoadingScreen__background;
         this._bandeau_haut = LoadingScreen__bandeau_haut;
         this._bandeau_bas = LoadingScreen__bandeau_bas;
         this._foreground = LoadingScreen__foreground;
         this._logoFr = LoadingScreen__logoFr;
         this._logoJp = LoadingScreen__logoJp;
         this._dofusProgress = LoadingScreen__dofusProgress;
         this._tipsBackground = LoadingScreen__tipsBackground;
         this._btnLog = LoadingScreen__btnLog;
         this._btnContinue = LoadingScreen__btnContinue;
         super(null,null);
         this._logTf = new TextField();
         this._logTf.width = 800;
         this._logTf.height = 500;
         this._logTf.x = 10;
         this._logTf.y = 300;
         var font:String = !!FontManager.initialized?FontManager.getInstance().getFontClassName("Verdana"):"Verdana";
         this._logTf.setTextFormat(new TextFormat(font));
         this._logTf.defaultTextFormat = new TextFormat(font);
         this._logTf.multiline = true;
         addChild(this._logTf);
         this._logTf.visible = false;
         this._backgroundBitmap = addChild(new this._background()) as Bitmap;
         this._backgroundBitmap.smoothing = true;
         addChild(new this._bandeau_haut());
         this._foregroundBitmap = addChild(new this._foreground()) as Bitmap;
         this._foregroundBitmap.smoothing = true;
         var bandeauBas:Bitmap = new this._bandeau_bas();
         bandeauBas.y = StageShareManager.startHeight - bandeauBas.height;
         bandeauBas.smoothing = true;
         addChild(bandeauBas);
         this._tipsBackgroundBitmap = new this._tipsBackground();
         this._tipsBackgroundBitmap.x = 89;
         this._tipsBackgroundBitmap.y = 933;
         addChild(this._tipsBackgroundBitmap);
         this._tipsBackgroundBitmap.visible = false;
         this._tipsTextField = new TextField();
         this._tipsTextField.x = this._tipsBackgroundBitmap.x + 10;
         this._tipsTextField.y = this._tipsBackgroundBitmap.y + 10;
         this._tipsTextField.width = this._tipsBackgroundBitmap.width - 20;
         this._tipsTextField.height = this._tipsBackgroundBitmap.height;
         this._tipsTextField.defaultTextFormat = new TextFormat(font,14,10066329,null,null,null,null,null,"center");
         this._tipsTextField.embedFonts = true;
         this._tipsTextField.selectable = false;
         this._tipsTextField.visible = false;
         this._tipsTextField.multiline = true;
         this._tipsTextField.wordWrap = true;
         addChild(this._tipsTextField);
         var logo:Bitmap = Capabilities.language == "ja"?new this._logoJp():new this._logoFr();
         logo.x = 8;
         logo.y = 8;
         logo.smoothing = true;
         addChild(logo);
         this._progressClip = new this._dofusProgress();
         this._progressClip.x = 608;
         this._progressClip.y = 821;
         this._progressClip.scaleX = this._progressClip.scaleY = 0.5;
         addChild(this._progressClip);
         var buildsInfo:TextField = new TextField();
         buildsInfo.appendText("Dofus " + BuildInfos.BUILD_VERSION + "\n");
         buildsInfo.appendText("Revision " + BuildInfos.BUILD_REVISION + "\n");
         buildsInfo.appendText("Mode " + BuildTypeEnum.getTypeName(BuildInfos.BUILD_TYPE) + "\n");
         buildsInfo.appendText(BuildInfos.BUILD_DATE + "\n");
         buildsInfo.height = 200;
         buildsInfo.width = 300;
         buildsInfo.selectable = false;
         buildsInfo.setTextFormat(new TextFormat(font,null,null,null,null,null,null,null,"right"));
         buildsInfo.textColor = 7829367;
         buildsInfo.y = 5;
         buildsInfo.x = StageShareManager.startWidth - buildsInfo.width;
         addChild(buildsInfo);
         var btnLog:DisplayObject = new this._btnLog();
         btnLog.x = 5;
         btnLog.y = StageShareManager.startHeight - btnLog.height - 5;
         btnLog.addEventListener(MouseEvent.CLICK,this.onLogClick);
         addChild(btnLog);
         this._btnContinueClip = new this._btnContinue() as SimpleButton;
         this._btnContinueClip.x = this._progressClip.x + (this._progressClip.width - this._btnContinueClip.width) / 2;
         this._btnContinueClip.y = this._progressClip.y + this._progressClip.height + 30;
         this._btnContinueClip.addEventListener(MouseEvent.CLICK,this.onContinueClick);
         this._btnContinueClip.visible = false;
         addChild(this._btnContinueClip);
         graphics.beginFill(0);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG)
         {
            this.showLog(true);
         }
         iAmFinalized(this);
      }
      
      public function get finalized() : Boolean
      {
         return true;
      }
      
      public function set finalized(b:Boolean) : void
      {
      }
      
      public function set value(v:Number) : void
      {
         this._value = v;
         this._progressClip.gotoAndStop(Math.round(v) + 2);
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function finalize() : void
      {
      }
      
      public function log(text:String, level:uint) : void
      {
         var tc:ColorTransform = null;
         if(level == ERROR)
         {
            tc = new ColorTransform();
            tc.color = 16711680;
            this._progressClip.transform.colorTransform = tc;
            this.showLog(true);
         }
         this._logTf.htmlText = "<p><font color=\"#" + uint(this._levelColor[level]).toString(16) + "\">" + text + "</font></p>" + this._logTf.htmlText;
      }
      
      public function showLog(b:Boolean) : void
      {
         this._foregroundBitmap.visible = !b;
         this._backgroundBitmap.visible = !b;
         this._logTf.visible = b;
      }
      
      public function hideTips() : void
      {
         this._tipsTextField.visible = false;
         this._tipsBackgroundBitmap.visible = false;
      }
      
      public function set useEmbedFont(b:Boolean) : void
      {
         this._tipsTextField.embedFonts = false;
      }
      
      public function set tip(txt:String) : void
      {
         this._tipsTextField.visible = true;
         this._tipsBackgroundBitmap.visible = true;
         this._tipsTextField.text = txt;
      }
      
      public function set continueCallbak(cb:Function) : void
      {
         this._btnContinueClip.visible = true;
         this.showLog(true);
         this.hideTips();
         this._continueCallBack = cb;
      }
      
      private function onLogClick(e:Event) : void
      {
         this.showLog(!this._logTf.visible);
      }
      
      private function onContinueClick(e:Event) : void
      {
         this._continueCallBack();
      }
   }
}
