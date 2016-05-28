package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.Stage;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.types.data.UiModule;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import flash.utils.getTimer;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.berilia.api.SecureUiRootContainer;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Point;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.enums.LocationTypeEnum;
   import com.ankamagames.berilia.types.LocationEnum;
   import flash.events.TimerEvent;
   import com.ankamagames.berilia.managers.UiRenderManager;
   
   public class UiRootContainer extends GraphicContainer
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiRootContainer));
       
      private var _aNamedElements:Array;
      
      private var _bUsedCustomSize:Boolean = false;
      
      private var _stage:Stage;
      
      private var _root:Sprite;
      
      private var _aGraphicLocationStack:Array;
      
      private var _aSizeStack:Array;
      
      private var _aGraphicElementIndex:Array;
      
      private var _aPositionnedElement:Array;
      
      private var _linkedUi:Array;
      
      private var _aPostFinalizeElement:Array;
      
      private var _aFinalizeElements:Array;
      
      private var _uiDefinitionUpdateTimer:Timer;
      
      private var _rendering:Boolean = false;
      
      private var _ready:Boolean;
      
      private var _waitingFctCall:Array;
      
      restricted_namespace var _properties;
      
      private var _wasVisible:Boolean;
      
      public var uiClass;
      
      public var uiModule:UiModule;
      
      public var strata:int;
      
      public var depth:int;
      
      public var scalable:Boolean = true;
      
      public var modal:Boolean = false;
      
      public var giveFocus:Boolean = true;
      
      public var modalIndex:uint = 0;
      
      public var radioGroup:Array;
      
      public var cached:Boolean = false;
      
      public var hideAfterLoading:Boolean = false;
      
      private var _isNotFinalized:Boolean = true;
      
      private var _tempVisible:Boolean = true;
      
      public var constants:Array;
      
      public var tempHolder:DisplayObjectContainer;
      
      private var _lock:Boolean = true;
      
      private var _renderAsk:Boolean = false;
      
      public function UiRootContainer(stage:Stage, root:Sprite = null)
      {
         super();
         this._stage = stage;
         this._root = root;
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         this._aFinalizeElements = new Array();
         this._waitingFctCall = new Array();
         this.radioGroup = new Array();
         super.visible = false;
      }
      
      override public function set visible(value:Boolean) : void
      {
         if(this._isNotFinalized)
         {
            this._tempVisible = value;
         }
         else
         {
            super.visible = value;
         }
      }
      
      public function addElement(sName:String, oElement:Object) : void
      {
         this._aNamedElements[sName] = oElement;
      }
      
      public function removeElement(sName:String) : void
      {
         delete this._aNamedElements[sName];
      }
      
      public function getElement(sName:String) : GraphicContainer
      {
         return this._aNamedElements[sName];
      }
      
      public function getElements() : Array
      {
         return this._aNamedElements;
      }
      
      public function getConstant(name:String) : *
      {
         return this.constants[name];
      }
      
      override public function get width() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __width;
         }
         return super.width;
      }
      
      override public function set width(nW:Number) : void
      {
         this._bUsedCustomSize = true;
         __width = nW;
      }
      
      override public function get height() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __height;
         }
         return super.height;
      }
      
      override public function set height(nH:Number) : void
      {
         this._bUsedCustomSize = true;
         __height = nH;
      }
      
      public function set useCustomSize(b:Boolean) : void
      {
         this._bUsedCustomSize = b;
      }
      
      public function get useCustomSize() : Boolean
      {
         return this._bUsedCustomSize;
      }
      
      public function set disableRender(b:Boolean) : void
      {
         this._rendering = b;
      }
      
      public function get disableRender() : Boolean
      {
         return this._rendering;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function iAmFinalized(target:FinalizableUIComponent) : void
      {
         var elem:FinalizableUIComponent = null;
         var cb:Callback = null;
         if(!this._lock || Boolean(this._rendering))
         {
            return;
         }
         for each(elem in this._aFinalizeElements)
         {
            if(!elem.finalized)
            {
               return;
            }
         }
         this._lock = false;
         this.render();
         this._ready = true;
         if(this.tempHolder)
         {
            if(!this.hideAfterLoading)
            {
               this.tempHolder.parent.addChildAt(this,this.tempHolder.parent.getChildIndex(this.tempHolder));
            }
            this.tempHolder.parent.removeChild(this.tempHolder);
            this.tempHolder = null;
         }
         if(Boolean(this.uiClass) && Boolean(this.uiClass.hasOwnProperty("main")))
         {
            this._rendering = true;
            this.uiClass["main"](restricted_namespace::_properties);
            this._rendering = false;
            if(this._renderAsk)
            {
               this.render();
            }
            for each(cb in this._waitingFctCall)
            {
               cb.exec();
            }
            this._waitingFctCall = null;
         }
         dispatchEvent(new UiRenderEvent(UiRenderEvent.UIRenderComplete,false,false,this));
         this._isNotFinalized = false;
         this.visible = this._tempVisible;
      }
      
      public function render() : void
      {
         var i:int = 0;
         var ge:GraphicElement = null;
         var pfc:FinalizableUIComponent = null;
         this._renderAsk = true;
         if(Boolean(this._rendering) || Boolean(this._lock))
         {
            return;
         }
         var t1:uint = getTimer();
         this._rendering = true;
         this._aPositionnedElement = new Array();
         this.zSort(this._aSizeStack);
         this.processSize();
         for(i = 0; i < this._aGraphicLocationStack.length; i++)
         {
            if(this._aGraphicLocationStack[i] != null)
            {
               this._aGraphicLocationStack[i].render = false;
            }
         }
         for(i = 0; i < this._aGraphicLocationStack.length; i++)
         {
            if(this._aGraphicLocationStack[i] != null)
            {
               if(!this._aGraphicLocationStack[i].render)
               {
                  ge = this._aGraphicLocationStack[i];
                  if(!ge.sprite.dynamicPosition)
                  {
                     this.processLocation(this._aGraphicLocationStack[i]);
                  }
               }
            }
         }
         this.updateLinkedUi();
         for each(pfc in this._aPostFinalizeElement)
         {
            pfc.finalize();
         }
         this._aPositionnedElement = new Array();
         this._rendering = false;
      }
      
      public function registerId(sName:String, geReference:GraphicElement) : void
      {
         if(this._aGraphicElementIndex[sName] != null && this._aGraphicElementIndex[sName] != undefined)
         {
            throw new BeriliaError(sName + " name is already used");
         }
         this._aGraphicElementIndex[sName] = geReference;
         this.addElement(sName,geReference.sprite);
      }
      
      public function deleteId(sName:String) : void
      {
         if(this._aGraphicElementIndex[sName] == null)
         {
            return;
         }
         delete this._aGraphicElementIndex[sName];
         this.removeElement(sName);
      }
      
      public function getElementById(sName:String) : GraphicElement
      {
         return this._aGraphicElementIndex[sName];
      }
      
      public function removeFromRenderList(sName:String) : void
      {
         var i:uint = 0;
         var ge:GraphicElement = null;
         for(i = 0; i < this._aGraphicLocationStack.length; i++)
         {
            ge = this._aGraphicLocationStack[i];
            if(ge != null && ge.sprite.name == sName)
            {
               delete this._aGraphicLocationStack[i];
               break;
            }
         }
         for(i = 0; i < this._aSizeStack.length; i++)
         {
            if(this._aSizeStack[i] != null && this._aSizeStack[i].name == sName)
            {
               delete this._aSizeStack[i];
               break;
            }
         }
      }
      
      public function addDynamicSizeElement(geReference:GraphicElement) : void
      {
         for(var i:uint = 0; i < this._aSizeStack.length; i++)
         {
            if(this._aSizeStack[i] == geReference)
            {
               return;
            }
         }
         this._aSizeStack.push(geReference);
      }
      
      public function addDynamicElement(ge:GraphicElement) : void
      {
         for(var i:uint = 0; i < this._aGraphicLocationStack.length; i++)
         {
            if(this._aGraphicLocationStack[i] != null && this._aGraphicLocationStack[i].sprite.name == ge.sprite.name)
            {
               return;
            }
         }
         this._aGraphicLocationStack.push(ge);
      }
      
      public function addPostFinalizeComponent(fc:FinalizableUIComponent) : void
      {
         this._aPostFinalizeElement.push(fc);
      }
      
      public function addFinalizeElement(fc:FinalizableUIComponent) : void
      {
         this._aFinalizeElements.push(fc);
      }
      
      public function addRadioGroup(groupName:String) : RadioGroup
      {
         if(!this.radioGroup[groupName])
         {
            this.radioGroup[groupName] = new RadioGroup(groupName);
         }
         return this.radioGroup[groupName];
      }
      
      public function getRadioGroup(name:String) : RadioGroup
      {
         return this.radioGroup[name];
      }
      
      public function addLinkedUi(uiName:String) : void
      {
         if(uiName != name)
         {
            this._linkedUi[uiName] = uiName;
         }
         else
         {
            _log.error("Cannot add link to yourself in " + name);
         }
      }
      
      public function removeLinkedUi(uiName:String) : void
      {
         delete this._linkedUi[uiName];
      }
      
      public function updateLinkedUi() : void
      {
         var ui:String = null;
         for each(ui in this._linkedUi)
         {
            if(Berilia.getInstance().getUi(this._linkedUi[ui]))
            {
               Berilia.getInstance().getUi(this._linkedUi[ui]).render();
            }
         }
      }
      
      restricted_namespace function call(fct:Function, args:Array) : void
      {
         if(this._ready)
         {
            CallWithParameters.call(fct,args);
         }
         else
         {
            this._waitingFctCall.push(CallWithParameters.callConstructor(Callback,[fct].concat(args)));
         }
      }
      
      restricted_namespace function destroy() : void
      {
         var r:RadioGroup = null;
         for each(r in this.radioGroup)
         {
            RadioGroup(r).destroy();
         }
         this.radioGroup = null;
         this._stage = null;
         this._root = null;
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         this._aFinalizeElements = new Array();
      }
      
      override public function getSecureObject() : *
      {
         return SecureUiRootContainer.getSecureUi(this,this.uiModule.trusted);
      }
      
      private function isRegisteredId(sName:String) : Boolean
      {
         return this._aGraphicElementIndex[sName] != null;
      }
      
      private function processSize() : void
      {
         var ge:GraphicElement = null;
         for(var i:uint = 0; i < this._aSizeStack.length; i++)
         {
            ge = this._aSizeStack[i];
            if(ge != null)
            {
               if(!isNaN(ge.size.x) && ge.size.xUnit == GraphicSize.SIZE_PRC)
               {
                  if(Boolean(ge.sprite) && Boolean(ge.sprite.parent) && ge.sprite.parent.parent is UiRootContainer)
                  {
                     ge.sprite.width = int(ge.size.x * StageShareManager.startWidth);
                  }
                  else if(GraphicContainer(ge.sprite).getParent())
                  {
                     ge.sprite.width = int(ge.size.x * GraphicContainer(ge.sprite).getParent().width);
                  }
               }
               if(!isNaN(ge.size.y) && ge.size.yUnit == GraphicSize.SIZE_PRC)
               {
                  if(Boolean(ge.sprite) && Boolean(ge.sprite.parent) && ge.sprite.parent.parent is UiRootContainer)
                  {
                     ge.sprite.height = int(ge.size.y * StageShareManager.startHeight);
                  }
                  else if(GraphicContainer(ge.sprite).getParent())
                  {
                     ge.sprite.height = int(ge.size.y * GraphicContainer(ge.sprite).getParent().height);
                  }
               }
            }
         }
      }
      
      private function processLocation(geElem:GraphicElement) : void
      {
         var ptTopLeftCorner:Point = null;
         var ptBottomRightCorner:Point = null;
         var startValueX:Number = geElem.sprite.x;
         var startValueY:Number = geElem.sprite.y;
         geElem.sprite.x = 0;
         geElem.sprite.y = 0;
         if(geElem.locations.length > 1)
         {
            geElem.sprite.width = 0;
            geElem.sprite.height = 0;
            ptTopLeftCorner = this.getLocation(new Point(geElem.sprite.x,geElem.sprite.y),geElem.locations[0],geElem.sprite);
            ptBottomRightCorner = this.getLocation(new Point(geElem.sprite.x,geElem.sprite.y),geElem.locations[1],geElem.sprite);
            if(Boolean(ptTopLeftCorner) && Boolean(ptBottomRightCorner))
            {
               geElem.sprite.width = Math.floor(Math.abs(ptBottomRightCorner.x - ptTopLeftCorner.x));
               geElem.sprite.height = Math.floor(Math.abs(ptBottomRightCorner.y - ptTopLeftCorner.y));
            }
            else
            {
               _log.error("Erreur de positionement dans " + name + " avec " + geElem.name);
            }
         }
         var ptNewPos:Point = this.getLocation(new Point(geElem.sprite.x,geElem.sprite.y),geElem.location,geElem.sprite);
         if(Boolean(geElem.sprite) && Boolean(ptNewPos))
         {
            geElem.sprite.x = ptNewPos.x;
            geElem.sprite.y = ptNewPos.y;
         }
         else
         {
            geElem.sprite.x = startValueX;
            geElem.sprite.y = startValueY;
            _log.error("Erreur dans " + name + " avec " + geElem.name);
         }
      }
      
      private function getLocation(ptStart:Point, glLocation:GraphicLocation, doTarget:DisplayObject) : Point
      {
         var doRelative:DisplayObject = null;
         var ref:DisplayObject = null;
         var uiTarget:Array = null;
         var ui:UiRootContainer = null;
         var pModificator:Point = new Point();
         var pRef:Point = new Point();
         var pTarget:Point = new Point();
         if(glLocation.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE || glLocation.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
         {
            pRef = doTarget.localToGlobal(new Point(doTarget.x,doTarget.y));
            switch(glLocation.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  pModificator.x = Math.floor(GraphicContainer(doTarget).getParent().width * glLocation.getOffsetX());
                  pModificator.y = Math.floor(GraphicContainer(doTarget).getParent().height * glLocation.getOffsetY());
            }
            if(glLocation.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               ptStart.x = ptStart.x + pModificator.x;
            }
            if(glLocation.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               ptStart.y = ptStart.y + pModificator.y;
            }
         }
         if(glLocation.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE || glLocation.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
         {
            pModificator.x = 0;
            pModificator.y = 0;
            pRef = doTarget.localToGlobal(new Point(doTarget.x,doTarget.y));
            switch(glLocation.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  pModificator.x = glLocation.getOffsetX();
                  pModificator.y = glLocation.getOffsetY();
                  break;
               case GraphicLocation.REF_SCREEN:
                  pTarget = doTarget.localToGlobal(new Point(doTarget.x,doTarget.y));
                  pModificator.x = glLocation.getOffsetX() - pTarget.x;
                  pModificator.y = glLocation.getOffsetY() - pTarget.y;
                  break;
               case GraphicLocation.REF_TOP:
                  pTarget = new Point(x,y);
                  pModificator.x = glLocation.getOffsetX() + (pTarget.x - pRef.x);
                  pModificator.y = glLocation.getOffsetY() + (pTarget.y - pRef.y);
                  break;
               default:
                  if(this.isRegisteredId(glLocation.getRelativeTo()))
                  {
                     ref = this._aGraphicElementIndex[glLocation.getRelativeTo()].sprite;
                  }
                  else if(Berilia.getInstance().getUi(glLocation.getRelativeTo()))
                  {
                     ref = Berilia.getInstance().getUi(glLocation.getRelativeTo());
                     UiRootContainer(ref).addLinkedUi(name);
                     doTarget = ref;
                  }
                  else if(glLocation.getRelativeTo().indexOf(".") != -1)
                  {
                     uiTarget = glLocation.getRelativeTo().split(".");
                     ui = Berilia.getInstance().getUi(uiTarget[0]);
                     if(!ui)
                     {
                        _log.warn("[Warning] UI " + uiTarget[0] + " does not exist (found " + glLocation.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     if(!ui.getElementById(uiTarget[1]))
                     {
                        _log.warn("[Warning] UI " + uiTarget[0] + " does not contain element [" + uiTarget[1] + "] (found " + glLocation.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     ref = ui.getElementById(uiTarget[1]).sprite;
                     pRef = doTarget.localToGlobal(new Point(doTarget.x,doTarget.y));
                     GraphicContainer(ref).getUi().addLinkedUi(name);
                  }
                  else
                  {
                     _log.warn("[Warning] " + glLocation.getRelativeTo() + " is unknow graphic element reference");
                     return null;
                  }
                  pTarget = doTarget.localToGlobal(new Point(ref.x,ref.y));
                  pModificator.x = glLocation.getOffsetX() + (pTarget.x - pRef.x);
                  pModificator.y = glLocation.getOffsetY() + (pTarget.y - pRef.y);
            }
            if(glLocation.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               ptStart.x = ptStart.x + pModificator.x;
            }
            if(glLocation.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               ptStart.y = ptStart.y + pModificator.y;
            }
         }
         pModificator = this.getOffsetModificator(glLocation.getPoint(),doTarget);
         ptStart.x = ptStart.x - pModificator.x;
         ptStart.y = ptStart.y - pModificator.y;
         switch(glLocation.getRelativeTo())
         {
            case GraphicLocation.REF_PARENT:
               if(Boolean(doTarget.parent) && Boolean(doTarget.parent.parent))
               {
                  doRelative = doTarget.parent.parent;
               }
               break;
            case GraphicLocation.REF_SCREEN:
               doRelative = this._root;
               break;
            case GraphicLocation.REF_TOP:
               doRelative = this;
               break;
            default:
               doRelative = ref;
               if(doRelative == doTarget)
               {
                  _log.warn("[Warning] Wrong relative position : " + doRelative.name + " refer to himself");
               }
         }
         pModificator = this.getOffsetModificator(glLocation.getRelativePoint(),doRelative);
         ptStart.x = ptStart.x + pModificator.x;
         ptStart.y = ptStart.y + pModificator.y;
         return ptStart;
      }
      
      private function getOffsetModificator(nPoint:uint, doTarget:DisplayObject) : Point
      {
         var nWidth:uint = doTarget == null || doTarget is UiRootContainer?uint(StageShareManager.startWidth):uint(doTarget.width);
         var nHeight:uint = doTarget == null || doTarget is UiRootContainer?uint(StageShareManager.startHeight):uint(doTarget.height);
         var pModificator:Point = new Point(0,0);
         switch(nPoint)
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               pModificator.x = nWidth / 2;
               break;
            case LocationEnum.POINT_TOPRIGHT:
               pModificator.x = nWidth;
               break;
            case LocationEnum.POINT_LEFT:
               pModificator.y = nWidth / 2;
               break;
            case LocationEnum.POINT_CENTER:
               pModificator.x = nWidth / 2;
               pModificator.y = nHeight / 2;
               break;
            case LocationEnum.POINT_RIGHT:
               pModificator.x = nWidth;
               pModificator.y = nHeight / 2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               pModificator.y = nHeight;
               break;
            case LocationEnum.POINT_BOTTOM:
               pModificator.x = nWidth / 2;
               pModificator.y = nHeight;
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               pModificator.x = nWidth;
               pModificator.y = nHeight;
         }
         return pModificator;
      }
      
      private function zSort(aSort:Array) : Boolean
      {
         var ge:GraphicElement = null;
         var gl:GraphicLocation = null;
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         var bChange:Boolean = true;
         var bSwap:Boolean = false;
         while(bChange)
         {
            bChange = false;
            for(i = 0; i < aSort.length; i++)
            {
               ge = aSort[i];
               if(ge != null)
               {
                  for(j = 0; j < ge.locations.length; j++)
                  {
                     for(k = i + 1; k < aSort.length; k++)
                     {
                        gl = ge.locations[j];
                        if(aSort[k] != null)
                        {
                           if(gl.getRelativeTo().charAt(0) != "$" && gl.getRelativeTo() == aSort[k].sprite.name || gl.getRelativeTo() == GraphicLocation.REF_PARENT && aSort[k].sprite == ge.sprite.getParent())
                           {
                              bSwap = true;
                              bChange = true;
                              aSort[i] = aSort[k];
                              aSort[k] = ge;
                              break;
                           }
                        }
                     }
                  }
               }
            }
         }
         return bSwap;
      }
      
      private function onDefinitionUpdateTimer(e:TimerEvent) : void
      {
         UiRenderManager.getInstance().updateCachedUiDefinition();
         this._uiDefinitionUpdateTimer.removeEventListener(TimerEvent.TIMER,this.onDefinitionUpdateTimer);
         this._uiDefinitionUpdateTimer = null;
      }
   }
}
