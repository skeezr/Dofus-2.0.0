package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.misc.ReadOnlyObject;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import flash.geom.Point;
   import com.ankamagames.berilia.interfaces.IClonable;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import gs.TweenMax;
   import gs.easing.Quart;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.UIComponent;
   import gs.events.TweenEvent;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class SlotGridRenderer implements IGridRenderer
   {
       
      protected var _log:Logger;
      
      private var _grid:Grid;
      
      private var _emptyTexture:Uri;
      
      private var _overTexture:Uri;
      
      private var _selectedTexture:Uri;
      
      private var _acceptDragTexture:Uri;
      
      private var _refuseDragTexture:Uri;
      
      private var _cssUri:Uri;
      
      private var _allowDrop:Boolean;
      
      public var dropValidatorFunction:Function;
      
      public var processDropFunction:Function;
      
      public var removeDropSourceFunction:Function;
      
      public function SlotGridRenderer(strParams:String)
      {
         this._log = Log.getLogger(getQualifiedClassName(SlotGridRenderer));
         super();
         var params:Array = !!strParams?strParams.split(","):[];
         this._emptyTexture = Boolean(params[0]) && Boolean(params[0].length)?new Uri(params[0]):null;
         this._overTexture = Boolean(params[1]) && Boolean(params[1].length)?new Uri(params[1]):null;
         this._selectedTexture = Boolean(params[2]) && Boolean(params[2].length)?new Uri(params[2]):null;
         this._acceptDragTexture = Boolean(params[3]) && Boolean(params[3].length)?new Uri(params[3]):null;
         this._refuseDragTexture = Boolean(params[4]) && Boolean(params[4].length)?new Uri(params[4]):null;
         this._cssUri = Boolean(params[5]) && Boolean(params[5].length)?new Uri(params[5]):null;
         this._allowDrop = Boolean(params[6]) && Boolean(params[6].length)?params[6] == "true":true;
      }
      
      public function set allowDrop(pAllow:Boolean) : void
      {
         this._allowDrop = pAllow;
      }
      
      public function get allowDrop() : Boolean
      {
         return this._allowDrop;
      }
      
      public function get acceptDragTexture() : Uri
      {
         return this._acceptDragTexture;
      }
      
      public function set acceptDragTexture(uri:Uri) : void
      {
         this._acceptDragTexture = uri;
      }
      
      public function get refuseDragTexture() : Uri
      {
         return this._refuseDragTexture;
      }
      
      public function set refuseDragTexture(uri:Uri) : void
      {
         this._refuseDragTexture = uri;
      }
      
      public function set grid(g:Grid) : void
      {
         this._grid = g;
      }
      
      public function render(data:*, index:uint, selected:Boolean, drawBackground:Boolean = true) : DisplayObject
      {
         var slotData:* = undefined;
         slotData = ReadOnlyObject.restricted_namespace::unSecure(data);
         var slot:Slot = new Slot();
         slot.mouseEnabled = true;
         slot.emptyTexture = this._emptyTexture;
         slot.highlightTexture = this._overTexture;
         slot.selectedTexture = this._selectedTexture;
         slot.acceptDragTexture = this._acceptDragTexture;
         slot.refuseDragTexture = this._refuseDragTexture;
         slot.css = this._cssUri;
         slot.allowDrag = this._allowDrop;
         slot.width = this._grid.slotWidth;
         slot.height = this._grid.slotHeight;
         slot.selected = selected;
         slot.data = slotData;
         slot.processDrop = this._processDrop;
         slot.removeDropSource = this._removeDropSourceFunction;
         slot.dropValidator = this._dropValidatorFunction;
         slot.finalize();
         return slot;
      }
      
      public function _removeDropSourceFunction(target:*) : void
      {
         var data:* = undefined;
         if(this.removeDropSourceFunction != null)
         {
            this.removeDropSourceFunction(target);
            return;
         }
         var dp:Array = new Array();
         var addData:Boolean = true;
         for each(data in this._grid.dataProvider)
         {
            if(data != target.data)
            {
               dp.push(data);
            }
         }
         this._grid.dataProvider = dp;
      }
      
      public function _dropValidatorFunction(target:Object, iSlotData:*) : Boolean
      {
         if(this.dropValidatorFunction != null)
         {
            return this.dropValidatorFunction(target,iSlotData);
         }
         return true;
      }
      
      public function update(data:*, index:uint, dispObj:DisplayObject, selected:Boolean, drawBackground:Boolean = true) : void
      {
         var slot:Slot = null;
         if(dispObj is Slot)
         {
            slot = Slot(dispObj);
            slot.data = ReadOnlyObject.restricted_namespace::unSecure(data) as ISlotData;
            slot.selected = selected;
            slot.allowDrag = this._allowDrop;
            slot.dropValidator = this._dropValidatorFunction;
            slot.removeDropSource = this._removeDropSourceFunction;
            slot.processDrop = this._processDrop;
         }
         else
         {
            this._log.warn("Can\'t update, " + dispObj.name + " is not a Slot component");
         }
      }
      
      public function remove(dispObj:DisplayObject) : void
      {
         if(dispObj is Slot && Boolean(dispObj.parent))
         {
            Slot(dispObj).remove();
         }
      }
      
      public function destroy() : void
      {
         this._grid = null;
         this._emptyTexture = null;
         this._overTexture = null;
         this._selectedTexture = null;
         this._acceptDragTexture = null;
         this._refuseDragTexture = null;
         this._cssUri = null;
      }
      
      public function _processDrop(target:*, data:*) : void
      {
         var linkCursor:LinkedCursorData = null;
         var pt:Point = null;
         var tweenTarget:DisplayObject = null;
         if(this.processDropFunction != null)
         {
            this.processDropFunction(target,data);
            return;
         }
         var sameGrid:Boolean = false;
         if(DisplayObject(data.holder).parent != this._grid)
         {
            if(data is IClonable)
            {
               this._grid.dataProvider.push((data as IClonable).clone());
            }
            else
            {
               this._grid.dataProvider.push(data);
            }
            this._grid.dataProvider = this._grid.dataProvider;
         }
         else
         {
            sameGrid = true;
         }
         linkCursor = LinkedCursorSpriteManager.getInstance().getItem(Slot.DRAG_AND_DROP_CURSOR_NAME);
         if(Boolean(sameGrid) || !this._grid.indexIsInvisibleSlot(this._grid.dataProvider.length - 1))
         {
            tweenTarget = DisplayObject(data.holder);
            pt = tweenTarget.localToGlobal(new Point(tweenTarget.x,tweenTarget.y));
            TweenMax.to(linkCursor.sprite,0.5,{
               "x":pt.x,
               "y":pt.y,
               "alpha":0,
               "ease":Quart.easeOut,
               "onCompleteListener":this.onTweenEnd
            });
         }
         else
         {
            pt = this._grid.localToGlobal(new Point(this._grid.x,this._grid.y));
            linkCursor.sprite.stopDrag();
            TweenMax.to(linkCursor.sprite,0.5,{
               "x":pt.x + this._grid.width / 2,
               "y":pt.y + this._grid.height,
               "alpha":0,
               "scaleX":0.1,
               "scaleY":0.1,
               "ease":Quart.easeOut,
               "onCompleteListener":this.onTweenEnd
            });
         }
      }
      
      public function renderModificator(childs:Array) : Array
      {
         return childs;
      }
      
      public function eventModificator(msg:Message, functionName:String, args:Array, target:UIComponent) : String
      {
         return functionName;
      }
      
      private function onTweenEnd(e:TweenEvent) : void
      {
         LinkedCursorSpriteManager.getInstance().removeItem(Slot.DRAG_AND_DROP_CURSOR_NAME);
      }
   }
}
