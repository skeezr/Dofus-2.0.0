package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.interfaces.IDragAndDropHandler;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import flash.utils.Timer;
   import flash.geom.Point;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.types.event.TextureLoadFailedEvent;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.api.SecureComponent;
   import flash.events.TimerEvent;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import flash.utils.getTimer;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.berilia.Berilia;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.display.Stage;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDoubleClickMessage;
   import com.ankamagames.berilia.components.messages.DropMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import gs.events.TweenEvent;
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   
   public class Slot extends GraphicContainer implements ISlotDataHolder, FinalizableUIComponent, IDragAndDropHandler
   {
      
      public static const DRAG_AND_DROP_CURSOR_NAME:String = "DragAndDrop";
       
      private var _data:ISlotData;
      
      private var _dropValidator:Function;
      
      private var _unboxedDropValidator:Function;
      
      private var _topLabel:com.ankamagames.berilia.components.Label;
      
      private var _middleLabel:com.ankamagames.berilia.components.Label;
      
      private var _bottomLabel:com.ankamagames.berilia.components.Label;
      
      private var _icon:com.ankamagames.berilia.components.Texture;
      
      private var _effect:com.ankamagames.berilia.components.Texture;
      
      private var _finalized:Boolean = false;
      
      private var _allowDrag:Boolean = true;
      
      private var _dragAndDropTriggerTimer:Timer;
      
      private var _dragStartPoint:Point;
      
      private var _dragging:Boolean = false;
      
      private var _selected:Boolean;
      
      private var _css:Uri;
      
      private var _removeDropSource:Function;
      
      private var _unboxedRemoveDropSource:Function;
      
      private var _processDrop:Function;
      
      private var _unboxedProcessDrop:Function;
      
      private var _hideTopLabel:Boolean = false;
      
      public var _emptyTexture:Uri;
      
      private var _widthHeightMax:uint = 45;
      
      public var highlightTexture:Uri;
      
      public var selectedTexture:Uri;
      
      public var acceptDragTexture:Uri;
      
      public var refuseDragTexture:Uri;
      
      public function Slot()
      {
         this._removeDropSource = this.emptyFunction;
         this._unboxedRemoveDropSource = this.emptyFunction;
         this._processDrop = this.emptyFunction;
         this._unboxedProcessDrop = this.emptyFunction;
         super();
         mouseChildren = false;
      }
      
      public function set data(o:*) : void
      {
         var nd:* = BoxingUnBoxing.unbox(o);
         if(!nd is ISlotData)
         {
            throw new TypeError("data must implement ISlotData interface.");
         }
         this._data = nd as ISlotData;
         if(this.data)
         {
            this._data.addHolder(this);
         }
         this.refresh();
      }
      
      public function get data() : *
      {
         return BoxingUnBoxing.unbox(this._data);
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
      
      public function set selected(b:Boolean) : void
      {
         this._selected = b;
         if(this._effect)
         {
            if(b)
            {
               this._effect.uri = this.selectedTexture;
            }
            else
            {
               this._effect.uri = null;
            }
         }
      }
      
      public function get allowDrag() : Boolean
      {
         return this._allowDrag;
      }
      
      public function set allowDrag(bool:Boolean) : void
      {
         this._allowDrag = bool;
      }
      
      public function set css(uri:Uri) : void
      {
         this._css = uri;
         if(this._topLabel)
         {
            this._topLabel.css = this._css;
         }
         if(this._middleLabel)
         {
            this._middleLabel.css = this._css;
         }
         if(this._bottomLabel)
         {
            this._bottomLabel.css = this._css;
         }
      }
      
      override public function set dropValidator(dv:Function) : void
      {
         this._dropValidator = dv;
         this._unboxedDropValidator = BoxingUnBoxing.getUnboxingFunction(dv);
      }
      
      override public function get dropValidator() : Function
      {
         return this._unboxedDropValidator;
      }
      
      override public function set removeDropSource(rds:Function) : void
      {
         this._removeDropSource = rds;
         this._unboxedRemoveDropSource = BoxingUnBoxing.getUnboxingFunction(rds);
      }
      
      override public function get removeDropSource() : Function
      {
         return this._unboxedRemoveDropSource;
      }
      
      override public function set processDrop(pd:Function) : void
      {
         this._processDrop = pd;
         this._unboxedProcessDrop = BoxingUnBoxing.getUnboxingFunction(pd);
      }
      
      override public function get processDrop() : Function
      {
         return this._unboxedProcessDrop;
      }
      
      public function get emptyTexture() : Uri
      {
         return this._emptyTexture;
      }
      
      public function set emptyTexture(uri:Uri) : void
      {
         this._emptyTexture = uri;
         if(this._icon != null)
         {
            this._icon.uri = this._emptyTexture;
         }
      }
      
      public function get hideTopLabel() : Boolean
      {
         return this._hideTopLabel;
      }
      
      public function set hideTopLabel(b:Boolean) : void
      {
         this._hideTopLabel = b;
         if(this._topLabel != null)
         {
            this._topLabel.visible = !b;
         }
      }
      
      public function refresh() : void
      {
         this.finalize();
         if(this._topLabel)
         {
            this._topLabel.visible = Boolean(this._data) && Boolean(this._data.info1) && !this._hideTopLabel;
            if(this._topLabel.visible)
            {
               this._topLabel.text = this._data.info1;
            }
         }
         if(width <= this._widthHeightMax && height <= this._widthHeightMax)
         {
            this._icon.uri = !!this._data?this._data.iconUri:this._emptyTexture;
         }
         else
         {
            this._icon.uri = !!this._data?this._data.fullSizeIconUri:this._emptyTexture;
         }
         this._icon.greyedOut = !!this._data?!this._data.active:false;
      }
      
      public function finalize() : void
      {
         if(!this._icon)
         {
            this._icon = new com.ankamagames.berilia.components.Texture();
            this._icon.addEventListener(TextureLoadFailedEvent.EVENT_TEXTURE_LOAD_FAILED,this.onSlotTextureFailed);
            this._icon.mouseEnabled = false;
            this._icon.width = width;
            this._icon.height = height;
            if(width <= this._widthHeightMax && height <= this._widthHeightMax)
            {
               this._icon.uri = !!this._data?this._data.iconUri:this._emptyTexture;
            }
            else
            {
               this._icon.uri = !!this._data?this._data.fullSizeIconUri:this._emptyTexture;
            }
            this._icon.finalized = true;
            this._icon.finalize();
            addChild(this._icon);
         }
         if(Boolean(!this._topLabel) && Boolean(this._data) && Boolean(this._data.info1))
         {
            this._topLabel = new com.ankamagames.berilia.components.Label();
            this._topLabel.height = 18;
            this._topLabel.useExtendWidth = true;
            this._topLabel.bgColor = 3355443;
            this._topLabel.bgAlpha = 0.6;
            this._topLabel.css = this._css;
            this._topLabel.visible = false;
            addChild(this._topLabel);
         }
         if(!this._effect)
         {
            this._effect = new com.ankamagames.berilia.components.Texture();
            this._effect.mouseEnabled = false;
            this._effect.width = width;
            this._effect.height = height;
            if(this._selected)
            {
               this._effect.uri = this.selectedTexture;
            }
            this._effect.finalize();
            this._effect.finalized = true;
            addChild(this._effect);
         }
         this._finalized = true;
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
      }
      
      override public function process(msg:Message) : Boolean
      {
         var linkCursor:LinkedCursorData = null;
         var dropTarget:* = undefined;
         var t1:uint = 0;
         var holder:* = undefined;
         var listener2:IInterfaceListener = null;
         var dragData:SlotDragAndDropData = null;
         switch(true)
         {
            case msg is MouseDownMessage:
               if(ShortcutsFrame.shiftKey)
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseShiftClick,SecureComponent.getSecureComponent(this));
               }
               else if(this._allowDrag)
               {
                  if(!this._data)
                  {
                     return false;
                  }
                  this._dragging = true;
                  this._dragAndDropTriggerTimer = new Timer(100,1);
                  this._dragAndDropTriggerTimer.addEventListener(TimerEvent.TIMER,this.onDragAndDropStart);
                  this._dragAndDropTriggerTimer.start();
                  this._dragStartPoint = new Point(-MouseDownMessage(msg).mouseEvent.localX,-MouseDownMessage(msg).mouseEvent.localY);
               }
               break;
            case msg is MouseOverMessage:
               if(this._allowDrag)
               {
                  linkCursor = LinkedCursorSpriteManager.getInstance().getItem(DRAG_AND_DROP_CURSOR_NAME);
                  if(Boolean(linkCursor) && Boolean(linkCursor.data is SlotDragAndDropData) && SlotDragAndDropData(linkCursor.data).slotData != this._data)
                  {
                     t1 = getTimer();
                     if(this.dropValidator != null && Boolean(this.dropValidator(this,SlotDragAndDropData(linkCursor.data).slotData)))
                     {
                        this._effect.uri = this.acceptDragTexture;
                     }
                     else
                     {
                        this._effect.uri = this.refuseDragTexture;
                     }
                  }
                  else
                  {
                     this._effect.uri = this.highlightTexture;
                  }
               }
               else
               {
                  this._effect.uri = this.highlightTexture;
               }
               break;
            case msg is MouseOutMessage:
               if(this._selected)
               {
                  this._effect.uri = this.selectedTexture;
               }
               else
               {
                  this._effect.uri = null;
               }
               break;
            case msg is MouseReleaseOutsideMessage && this._allowDrag:
               dropTarget = MouseReleaseOutsideMessage(msg).mouseEvent.target;
               if(Boolean(this._dragging) && !(MouseReleaseOutsideMessage(msg).mouseEvent.target is ISlotDataHolder))
               {
                  linkCursor = LinkedCursorSpriteManager.getInstance().getItem(DRAG_AND_DROP_CURSOR_NAME);
                  holder = SecureComponent.getSecureComponent(SlotDragAndDropData(linkCursor.data).currentHolder);
                  switch(true)
                  {
                     case MouseReleaseOutsideMessage(msg).mouseEvent.target is IDragAndDropHandler:
                        if((MouseReleaseOutsideMessage(msg).mouseEvent.target as IDragAndDropHandler).dropValidator != null)
                        {
                           if((MouseReleaseOutsideMessage(msg).mouseEvent.target as IDragAndDropHandler).dropValidator(this,this.data))
                           {
                              this.processDrop(this,this.data);
                           }
                           for each(listener2 in Berilia.getInstance().UISoundListeners)
                           {
                              listener2.playUISound("16053");
                           }
                        }
                        break;
                     case MouseReleaseOutsideMessage(msg).mouseEvent.target is MovieClip:
                     case MouseReleaseOutsideMessage(msg).mouseEvent.target is TextField:
                     case MouseReleaseOutsideMessage(msg).mouseEvent.target is Stage:
                        KernelEventsManager.getInstance().processCallback(BeriliaHookList.SlotDropedNorBeriliaNorWorld,holder);
                        break;
                     case getQualifiedClassName(MouseReleaseOutsideMessage(msg).mouseEvent.target.parent).indexOf("com.ankamagames.berilia") >= 0:
                        KernelEventsManager.getInstance().processCallback(BeriliaHookList.SlotDropedOnBerilia,holder,dropTarget);
                        break;
                     case MouseReleaseOutsideMessage(msg).mouseEvent.target.parent.parent is MiniMapViewer:
                     case getQualifiedClassName(MouseReleaseOutsideMessage(msg).mouseEvent.target.parent).indexOf("Dofus") >= 0:
                        KernelEventsManager.getInstance().processCallback(BeriliaHookList.SlotDropedNorBeriliaNorWorld,holder,dropTarget);
                        break;
                     default:
                        KernelEventsManager.getInstance().processCallback(BeriliaHookList.SlotDropedOnWorld,holder,dropTarget);
                  }
                  LinkedCursorSpriteManager.getInstance().removeItem(DRAG_AND_DROP_CURSOR_NAME);
                  if(linkCursor != null)
                  {
                     KernelEventsManager.getInstance().processCallback(BeriliaHookList.DropEnd,SecureComponent.getSecureComponent(SlotDragAndDropData(linkCursor.data).currentHolder));
                  }
               }
               else if(MouseReleaseOutsideMessage(msg).mouseEvent.target is Slot)
               {
                  if((MouseReleaseOutsideMessage(msg).mouseEvent.target as Slot).allowDrag == false)
                  {
                     LinkedCursorSpriteManager.getInstance().removeItem(DRAG_AND_DROP_CURSOR_NAME);
                     if(linkCursor != null)
                     {
                        KernelEventsManager.getInstance().processCallback(BeriliaHookList.DropEnd,SecureComponent.getSecureComponent(SlotDragAndDropData(linkCursor.data).currentHolder));
                     }
                  }
               }
               this.removeDrag();
               break;
            case msg is MouseClickMessage && this._allowDrag:
            case msg is MouseDoubleClickMessage && this._allowDrag:
               if(this._dragging)
               {
                  this.removeDrag();
               }
               if(Boolean(ShortcutsFrame.ctrlKey) && msg is MouseDoubleClickMessage)
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseCtrlDoubleClick,SecureComponent.getSecureComponent(this));
               }
               else if(Boolean(ShortcutsFrame.altKey) && msg is MouseDoubleClickMessage)
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseAltDoubleClick,SecureComponent.getSecureComponent(this));
               }
               break;
            case msg is MouseUpMessage && this._allowDrag:
               linkCursor = LinkedCursorSpriteManager.getInstance().getItem(DRAG_AND_DROP_CURSOR_NAME);
               if(Boolean(linkCursor) && linkCursor.data is SlotDragAndDropData)
               {
                  dragData = linkCursor.data;
                  if(dragData.slotData != this._data && Boolean(this.dropValidator(this,SlotDragAndDropData(linkCursor.data).slotData)))
                  {
                     if(dragData.currentHolder)
                     {
                        dragData.currentHolder.removeDropSource(dragData.currentHolder);
                     }
                     this.processDrop(this,dragData.slotData);
                     LinkedCursorSpriteManager.getInstance().removeItem(DRAG_AND_DROP_CURSOR_NAME);
                  }
                  else
                  {
                     LinkedCursorSpriteManager.getInstance().removeItem(DRAG_AND_DROP_CURSOR_NAME);
                  }
                  Berilia.getInstance().handler.process(new DropMessage(this,dragData.currentHolder));
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.DropEnd,SecureComponent.getSecureComponent(dragData.currentHolder));
               }
         }
         return false;
      }
      
      override public function remove() : void
      {
         this._dropValidator = null;
         if(this._topLabel)
         {
            this._topLabel.remove();
         }
         if(this._middleLabel)
         {
            this._middleLabel.remove();
         }
         if(this._bottomLabel)
         {
            this._bottomLabel.remove();
         }
         if(this._icon)
         {
            this._icon.remove();
         }
         if(this._effect)
         {
            this._effect.remove();
         }
         if(this._data)
         {
            this._data.removeHolder(this);
         }
         this._data = null;
         this._topLabel = null;
         this._middleLabel = null;
         this._bottomLabel = null;
         this._icon = null;
         this._effect = null;
      }
      
      private function removeDrag() : void
      {
         if(this._dragAndDropTriggerTimer)
         {
            this._dragAndDropTriggerTimer.stop();
            this._dragAndDropTriggerTimer.removeEventListener(TimerEvent.TIMER,this.onDragAndDropStart);
            this._dragAndDropTriggerTimer = null;
         }
         this._icon.filters = [];
         this._dragStartPoint = null;
         this._dragging = false;
      }
      
      private function emptyFunction(... args) : *
      {
         return null;
      }
      
      private function onTweenEnd(e:TweenEvent) : void
      {
         LinkedCursorSpriteManager.getInstance().removeItem(DRAG_AND_DROP_CURSOR_NAME);
      }
      
      private function onSlotTextureFailed(e:TextureLoadFailedEvent) : void
      {
         if(Boolean(this._data) && Boolean(this._data.errorIconUri))
         {
            e.behavior.cancel = true;
            this._icon.uri = this._data.errorIconUri;
         }
      }
      
      private function onDragAndDropStart(e:TimerEvent) : void
      {
         var listener:IInterfaceListener = null;
         var d:LinkedCursorData = null;
         var bd:BitmapData = null;
         var dragData:SlotDragAndDropData = null;
         var matrix:Array = null;
         if(!this._dragAndDropTriggerTimer)
         {
            return;
         }
         for each(listener in Berilia.getInstance().UISoundListeners)
         {
            listener.playUISound("16059");
         }
         this._dragAndDropTriggerTimer.stop();
         this._dragAndDropTriggerTimer.removeEventListener(TimerEvent.TIMER,this.onDragAndDropStart);
         this._dragAndDropTriggerTimer = null;
         d = new LinkedCursorData();
         bd = new BitmapData(width,height,true,0);
         this._effect.visible = false;
         bd.draw(this);
         this._effect.visible = true;
         d.sprite = new DragSprite(bd);
         d.offset = new Point(0,0);
         dragData = new SlotDragAndDropData(this,this._data);
         d.data = dragData;
         LinkedCursorSpriteManager.getInstance().addItem(DRAG_AND_DROP_CURSOR_NAME,d);
         matrix = new Array();
         matrix = matrix.concat([1 / 2,0,0,0,0]);
         matrix = matrix.concat([0,1 / 2,0,0,0]);
         matrix = matrix.concat([0,0,1 / 2,0,0]);
         matrix = matrix.concat([0,0,0,1,0]);
         this._icon.filters = [new ColorMatrixFilter(matrix)];
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.DropStart,SecureComponent.getSecureComponent(this));
      }
   }
}

import flash.display.Sprite;
import flash.display.BitmapData;
import flash.display.Bitmap;

class DragSprite extends Sprite
{
    
   function DragSprite(bitmapData:BitmapData)
   {
      super();
      alpha = 0.8;
      addChild(new Bitmap(bitmapData));
   }
}

import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
import com.ankamagames.jerakine.interfaces.ISlotData;

class SlotDragAndDropData
{
    
   public var currentHolder:ISlotDataHolder;
   
   public var slotData:ISlotData;
   
   function SlotDragAndDropData(currentHolder:ISlotDataHolder, slotData:ISlotData)
   {
      super();
      this.currentHolder = currentHolder;
      this.slotData = slotData;
   }
}
