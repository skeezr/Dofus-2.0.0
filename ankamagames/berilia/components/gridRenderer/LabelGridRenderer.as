package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.components.Grid;
   import flash.geom.ColorTransform;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.Dictionary;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.components.Label;
   import flash.events.MouseEvent;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.UIComponent;
   import flash.display.Shape;
   import flash.geom.Transform;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class LabelGridRenderer implements IGridRenderer
   {
       
      protected var _log:Logger;
      
      private var _grid:Grid;
      
      private var _bgColor1:ColorTransform;
      
      private var _bgColor2:ColorTransform;
      
      private var _selectedColor:ColorTransform;
      
      private var _overColor:ColorTransform;
      
      private var _cssUri:Uri;
      
      private var _shapeIndex:Dictionary;
      
      public function LabelGridRenderer(strParams:String)
      {
         var params:Array = null;
         this._log = Log.getLogger(getQualifiedClassName(LabelGridRenderer));
         this._shapeIndex = new Dictionary(true);
         super();
         if(strParams)
         {
            params = !!strParams.length?strParams.split(","):null;
            if(Boolean(params[0]) && Boolean(params[0].length))
            {
               this._cssUri = new Uri(params[0]);
            }
            if(Boolean(params[1]) && Boolean(params[1].length))
            {
               this._bgColor1 = new ColorTransform();
               this._bgColor1.color = parseInt(params[1],16);
            }
            if(Boolean(params[2]) && Boolean(params[2].length))
            {
               this._bgColor2 = new ColorTransform();
               this._bgColor2.color = parseInt(params[2],16);
            }
            if(Boolean(params[3]) && Boolean(params[3].length))
            {
               this._overColor = new ColorTransform();
               this._overColor.color = parseInt(params[3],16);
            }
            if(Boolean(params[4]) && Boolean(params[4].length))
            {
               this._selectedColor = new ColorTransform();
               this._selectedColor.color = parseInt(params[4],16);
            }
         }
      }
      
      public function set grid(g:Grid) : void
      {
         this._grid = g;
      }
      
      public function render(data:*, index:uint, selected:Boolean, drawBackground:Boolean = true) : DisplayObject
      {
         var label:Label = null;
         label = new Label();
         label.mouseEnabled = true;
         label.useHandCursor = true;
         label.width = this._grid.slotWidth;
         label.height = this._grid.slotHeight;
         label.verticalAlign = "CENTER";
         if(data is String || data == null)
         {
            label.text = data;
         }
         else
         {
            label.text = data.label;
         }
         if(this._cssUri)
         {
            label.css = this._cssUri;
         }
         if(drawBackground)
         {
            this.updateBackground(label,index,selected);
         }
         label.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         label.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         return label;
      }
      
      public function update(data:*, index:uint, dispObj:DisplayObject, selected:Boolean, drawBackground:Boolean = true) : void
      {
         var label:Label = null;
         if(dispObj is Label)
         {
            label = dispObj as Label;
            if(data is String || data == null)
            {
               label.text = data;
            }
            else
            {
               label.text = data.label;
            }
            if(drawBackground)
            {
               this.updateBackground(label,index,selected);
            }
         }
         else
         {
            this._log.warn("Can\'t update, " + dispObj.name + " is not a Label component");
         }
      }
      
      public function remove(dispObj:DisplayObject) : void
      {
         var label:Label = null;
         if(dispObj is Label)
         {
            label = dispObj as Label;
            if(label.parent)
            {
               label.parent.removeChild(dispObj);
            }
            label.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
            label.removeEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         }
      }
      
      public function destroy() : void
      {
         this._grid = null;
         this._shapeIndex = null;
      }
      
      public function renderModificator(childs:Array) : Array
      {
         return childs;
      }
      
      public function eventModificator(msg:Message, functionName:String, args:Array, target:UIComponent) : String
      {
         return functionName;
      }
      
      private function updateBackground(label:Label, index:uint, selected:Boolean) : void
      {
         var shape:Shape = null;
         if(!this._shapeIndex[label])
         {
            shape = new Shape();
            shape.graphics.beginFill(16777215);
            shape.graphics.drawRect(0,0,this._grid.slotWidth,this._grid.slotHeight + 1);
            label.getStrata(0).addChild(shape);
            this._shapeIndex[label] = {
               "trans":new Transform(shape),
               "shape":shape
            };
         }
         var t:ColorTransform = !!(index % 2)?this._bgColor1:this._bgColor2;
         if(Boolean(selected) && Boolean(this._selectedColor))
         {
            t = this._selectedColor;
         }
         this._shapeIndex[label].currentColor = t;
         DisplayObject(this._shapeIndex[label].shape).visible = t != null;
         if(t)
         {
            Transform(this._shapeIndex[label].trans).colorTransform = t;
         }
      }
      
      private function onRollOver(e:MouseEvent) : void
      {
         var label:Label = e.currentTarget as Label;
         if(Boolean(this._overColor) && label.text.length > 0)
         {
            Transform(this._shapeIndex[label].trans).colorTransform = this._overColor;
            DisplayObject(this._shapeIndex[label].shape).visible = true;
         }
      }
      
      private function onRollOut(e:MouseEvent) : void
      {
         var label:Label = e.currentTarget as Label;
         if(label.text.length > 0)
         {
            if(this._shapeIndex[label].currentColor)
            {
               Transform(this._shapeIndex[label].trans).colorTransform = this._shapeIndex[label].currentColor;
            }
            DisplayObject(this._shapeIndex[label].shape).visible = this._shapeIndex[label].currentColor != null;
         }
      }
   }
}
