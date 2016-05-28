package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.geom.Rectangle;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.jerakine.types.ASwf;
   import com.ankamagames.jerakine.resources.ResourceType;
   import flash.display.Bitmap;
   import com.ankamagames.jerakine.resources.ResourceErrorCode;
   import flash.errors.IllegalOperationError;
   import com.ankamagames.berilia.Berilia;
   import flash.events.Event;
   import com.ankamagames.berilia.components.messages.TextureReadyMessage;
   import flash.display.Shape;
   import com.ankamagames.jerakine.types.DynamicSecureObject;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.api.SecureComponent;
   import com.ankamagames.berilia.types.event.TextureLoadFailedEvent;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class Texture extends GraphicContainer implements FinalizableUIComponent, IRectangle
   {
       
      private var _log:Logger;
      
      private var _finalized:Boolean;
      
      private var _uri:Uri;
      
      private var _realUri:Uri;
      
      private var _child:DisplayObject;
      
      private var _startedWidth:Number;
      
      private var _startedHeight:Number;
      
      private var _forcedHeight:Number;
      
      private var _forcedWidth:Number;
      
      private var _keepRatio:Boolean;
      
      private var _dispatchMessages:Boolean;
      
      private var _autoGrid:Boolean;
      
      private var _forceReload:Boolean = false;
      
      private var _gotoFrame:String;
      
      private var _loader:IResourceLoader;
      
      private var _startBounds:Rectangle;
      
      private var _return2:Boolean;
      
      private var rle_uri_path;
      
      public function Texture()
      {
         this._log = Log.getLogger(getQualifiedClassName(Texture));
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(value:Boolean) : void
      {
         this._finalized = value;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function set uri(value:Uri) : void
      {
         if(value != this._uri || Boolean(this._forceReload))
         {
            this._uri = value;
            if(this._finalized)
            {
               this.reload();
            }
            return;
         }
      }
      
      override public function get height() : Number
      {
         return !isNaN(this._forcedHeight)?Number(this._forcedHeight):!!this._child?Number(this._child.height):Number(0);
      }
      
      override public function set height(value:Number) : void
      {
         if(this._forcedHeight == value)
         {
            return;
         }
         this._forcedHeight = value;
         if(this._finalized)
         {
            this.organize();
         }
      }
      
      override public function get width() : Number
      {
         return !isNaN(this._forcedWidth)?Number(this._forcedWidth):!!this._child?Number(this._child.width):Number(0);
      }
      
      override public function set width(value:Number) : void
      {
         if(this._forcedWidth == value)
         {
            return;
         }
         this._forcedWidth = value;
         if(this._finalized)
         {
            this.organize();
         }
      }
      
      public function get keepRatio() : Boolean
      {
         return this._keepRatio;
      }
      
      public function set keepRatio(value:Boolean) : void
      {
         this._keepRatio = value;
         if(this._finalized)
         {
            this.organize();
         }
      }
      
      override public function get scale9Grid() : Rectangle
      {
         if(this._child)
         {
            return this._child.scale9Grid;
         }
         return null;
      }
      
      override public function set scale9Grid(value:Rectangle) : void
      {
         if(this._child)
         {
            this._child.scale9Grid = value;
         }
      }
      
      public function vFlip() : void
      {
         var tempX:Number = x;
         var tempY:Number = y;
         scaleX = -1;
         x = tempX + this.width;
      }
      
      public function hFlip() : void
      {
         var tempX:Number = x;
         var tempY:Number = y;
         scaleY = -1;
         y = tempY + this.height;
      }
      
      public function get autoGrid() : Boolean
      {
         return this._autoGrid;
      }
      
      public function set autoGrid(value:Boolean) : void
      {
         if(value)
         {
            this._autoGrid = true;
         }
         else
         {
            this._autoGrid = false;
            if(this._child)
            {
               this._child.scale9Grid = null;
            }
         }
         if(this._finalized)
         {
            this.organize();
         }
      }
      
      public function set gotoAndStop(value:String) : void
      {
         if(Boolean(this._child) && this._child is MovieClip)
         {
            if(value)
            {
               (this._child as MovieClip).gotoAndStop(value);
            }
            else
            {
               (this._child as MovieClip).gotoAndStop(1);
            }
         }
         this._gotoFrame = value;
      }
      
      public function get gotoAndStop() : String
      {
         if(Boolean(this._child) && this._child is MovieClip)
         {
            return (this._child as MovieClip).currentFrame.toString();
         }
         return this._gotoFrame;
      }
      
      public function set gotoAndPlay(value:String) : void
      {
         if(Boolean(this._child) && this._child is MovieClip)
         {
            if(value)
            {
               (this._child as MovieClip).gotoAndPlay(value);
            }
            else
            {
               (this._child as MovieClip).gotoAndPlay(1);
            }
         }
      }
      
      public function get totalFrames() : uint
      {
         if(Boolean(this._child) && this._child is MovieClip)
         {
            return (this._child as MovieClip).totalFrames;
         }
         return 1;
      }
      
      public function get currentFrame() : uint
      {
         if(Boolean(this._child) && this._child is MovieClip)
         {
            return (this._child as MovieClip).currentFrame;
         }
         return 1;
      }
      
      public function get dispatchMessages() : Boolean
      {
         return this._dispatchMessages;
      }
      
      public function set dispatchMessages(value:Boolean) : void
      {
         this._dispatchMessages = value;
      }
      
      public function get forceReload() : Boolean
      {
         return this._forceReload;
      }
      
      public function set forceReload(value:Boolean) : void
      {
         this._forceReload = value;
      }
      
      public function get loading() : Boolean
      {
         return this._loader != null;
      }
      
      public function get child() : DisplayObject
      {
         return this._child;
      }
      
      public function colorTransform(colorTransform:ColorTransform, depth:int = 0) : void
      {
         var currentChild:DisplayObjectContainer = null;
         var i:int = 0;
         var child:DisplayObject = null;
         if(depth == 0)
         {
            transform.colorTransform = colorTransform;
         }
         else if(this._child is DisplayObjectContainer)
         {
            currentChild = this._child as DisplayObjectContainer;
            for(i = 0; i < depth; )
            {
               if(currentChild.numChildren > 0)
               {
                  child = currentChild.getChildAt(0);
                  if(child is DisplayObjectContainer)
                  {
                     currentChild = child as DisplayObjectContainer;
                     i++;
                     continue;
                  }
                  break;
               }
               break;
            }
            currentChild.transform.colorTransform = colorTransform;
         }
         else
         {
            transform.colorTransform = colorTransform;
         }
      }
      
      public function finalize() : void
      {
         this.reload();
      }
      
      override public function free() : void
      {
         super.free();
         this._finalized = false;
         this._uri = null;
         this._child = null;
         this._startedWidth = 0;
         this._startedHeight = 0;
         this._forcedHeight = 0;
         this._forcedWidth = 0;
         this._keepRatio = false;
         this._dispatchMessages = false;
         this._autoGrid = false;
         this._forceReload = false;
         this._gotoFrame = null;
         this._loader = null;
         this._startBounds = null;
      }
      
      private function reload() : void
      {
         var realUri:Uri = null;
         var forcedAdapter:Class = null;
         if(this._uri)
         {
            if(!this._loader)
            {
               this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
               this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoaded,false,0,true);
               this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onFailed,false,0,true);
            }
            else
            {
               this._loader.cancel();
            }
            if(this._uri.subPath)
            {
               if(this._uri.protocol == "mod")
               {
                  realUri = new Uri(this._uri.normalizedUri);
               }
               else
               {
                  realUri = new Uri(this._uri.path);
               }
               this._realUri = realUri;
               forcedAdapter = AdvancedSwfAdapter;
            }
            else
            {
               realUri = this._uri;
            }
            this._loader.load(realUri,UriCacheFactory.getCacheFromUri(realUri),forcedAdapter);
         }
         else
         {
            if(this._child)
            {
               this._child.parent.removeChild(this._child);
               this._child = null;
            }
            this._finalized = true;
            if(getUi())
            {
               getUi().iAmFinalized(this);
            }
         }
      }
      
      private function organize() : void
      {
         var rec:Rectangle = null;
         var ratio:Number = NaN;
         var rerender:Boolean = false;
         if(Boolean(this._gotoFrame) && this._child is MovieClip)
         {
            this.gotoAndStop = this._gotoFrame;
         }
         else
         {
            this.gotoAndStop = "0";
         }
         if(this._autoGrid)
         {
            rec = new Rectangle(this._startedWidth / 3,int(this._startedHeight / 3),this._startedWidth / 3,int(this._startedHeight / 3));
            try
            {
               this._child.scale9Grid = rec;
            }
            catch(e:Error)
            {
               _log.error("Erreur de scale9grid avec " + _uri + ", rect : " + rec);
            }
         }
         if(this._keepRatio)
         {
            ratio = 1;
            if(Boolean(isNaN(this._forcedWidth)) && Boolean(isNaN(this._forcedHeight)))
            {
               this._log.warn("Cannot keep the ratio with no forced dimension.");
            }
            else
            {
               if(isNaN(this._forcedWidth))
               {
                  ratio = this._forcedHeight / this._child.height;
               }
               else if(isNaN(this._forcedHeight))
               {
                  ratio = this._forcedWidth / this._child.width;
               }
               else if(this._forcedHeight > this._forcedWidth)
               {
                  ratio = this._child.width / this._forcedWidth;
               }
               else if(this._forcedHeight < this._forcedWidth)
               {
                  ratio = this._child.height / this._forcedHeight;
               }
               this._child.scaleX = this._child.scaleY = ratio;
            }
         }
         else
         {
            if(!isNaN(this._forcedHeight) && this._forcedHeight != 0 && this._forcedHeight != this._child.height)
            {
               this._child.height = this._forcedHeight;
            }
            else
            {
               rerender = true;
            }
            if(!isNaN(this._forcedWidth))
            {
               this._child.width = this._forcedWidth;
            }
            else
            {
               rerender = true;
            }
         }
         if(!this._finalized)
         {
            this._finalized = true;
            if(getUi())
            {
               getUi().iAmFinalized(this);
            }
         }
         else if(Boolean(rerender) || true)
         {
            if(getUi())
            {
               getUi().iAmFinalized(this);
            }
         }
      }
      
      private function onLoaded(rle:ResourceLoadedEvent) : void
      {
         var aswf:ASwf = null;
         var error:ResourceErrorEvent = null;
         this._return2 = false;
         if(__removed)
         {
            return;
         }
         this._loader = null;
         if(!this._uri || this._uri.path != rle.uri.path && this._uri.normalizedUri != rle.uri.path)
         {
            this._return2 = true;
            this.rle_uri_path = rle.uri.path;
            return;
         }
         if(Boolean(this._child) && Boolean(this._child.parent))
         {
            this._child.parent.removeChild(this._child);
            this._child = null;
         }
         if(rle.resourceType == ResourceType.RESOURCE_SWF)
         {
            if(!rle.resource)
            {
               this._log.warn("Empty SWF : " + rle.uri + " in " + getUi().name);
               return;
            }
            this._child = addChild(rle.resource);
            if(this._child is MovieClip)
            {
               (this._child as MovieClip).stop();
            }
         }
         else if(rle.resourceType == ResourceType.RESOURCE_BITMAP)
         {
            this._child = addChild(new Bitmap(rle.resource,"auto",true));
         }
         else if(rle.resourceType == ResourceType.RESOURCE_ASWF)
         {
            if(this._uri.subPath)
            {
               aswf = ASwf(rle.resource);
               try
               {
                  this._child = addChild(new (aswf.applicationDomain.getDefinition(this._uri.subPath) as Class)() as DisplayObject);
               }
               catch(e:Error)
               {
                  error = new ResourceErrorEvent(ResourceErrorEvent.ERROR);
                  error.errorCode = ResourceErrorCode.SUB_RESOURCE_NOT_FOUND;
                  error.uri = _uri;
                  error.errorMsg = "Sub ressource \'" + _uri.subPath + "\' not found";
                  onFailed(error);
                  return;
               }
            }
         }
         else
         {
            throw new IllegalOperationError("A Texture component can\'t display a non-displayable resource.");
         }
         this._startBounds = this._child.getBounds(this);
         this._startedWidth = this._child.width;
         this._startedHeight = this._child.height;
         this.organize();
         if(Boolean(this._dispatchMessages) && Boolean(Berilia.getInstance()) && Boolean(Berilia.getInstance().handler))
         {
            dispatchEvent(new Event(Event.COMPLETE));
            Berilia.getInstance().handler.process(new TextureReadyMessage(this));
         }
      }
      
      private function onFailed(ree:ResourceErrorEvent) : void
      {
         var shp:Shape = null;
         if(__removed)
         {
            return;
         }
         var behavior:DynamicSecureObject = new DynamicSecureObject();
         behavior.cancel = false;
         if(KernelEventsManager.getInstance().isRegisteredEvent(BeriliaHookList.TextureLoadFailed.name))
         {
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.TextureLoadFailed,SecureComponent.getSecureComponent(this,getUi().uiModule.trusted),behavior);
         }
         else
         {
            this._log.error("UI " + (!!getUi()?getUi().name:"unknow") + ", texture resource not found: " + (!!ree?ree.errorMsg:"No ressource specified.") + ", requested uri : " + ree.uri);
         }
         dispatchEvent(new TextureLoadFailedEvent(this,behavior));
         if(!behavior.cancel)
         {
            if(this._child)
            {
               this._child.parent.removeChild(this._child);
               this._child = null;
            }
            this._loader = null;
            shp = new Shape();
            shp.graphics.beginFill(16711935);
            shp.graphics.drawRect(0,0,!isNaN(this._forcedWidth) && this._forcedWidth != 0?Number(this._forcedWidth):Number(10),!isNaN(this._forcedHeight) && this._forcedHeight != 0?Number(this._forcedHeight):Number(10));
            shp.graphics.endFill();
            this._child = addChild(shp);
         }
         this._finalized = true;
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
      }
      
      override public function remove() : void
      {
         __removed = true;
         if(this._child)
         {
            this._child.width = this._startedWidth;
            this._child.height = this._startedHeight;
            this._child.scaleX = 1;
            this._child.scaleY = 1;
            if(this._child is MovieClip)
            {
               MovieClip(this._child).gotoAndStop(0);
            }
            if(this._child.parent)
            {
               this._child.parent.removeChild(this._child);
            }
         }
         if(Boolean(parent) && Boolean(parent.contains(this)))
         {
            parent.removeChild(this);
         }
         super.remove();
      }
   }
}
