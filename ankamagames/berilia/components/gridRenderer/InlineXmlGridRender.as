package com.ankamagames.berilia.components.gridRenderer
{
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import com.ankamagames.berilia.components.Grid;
   import flash.utils.Dictionary;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.types.uiDefinition.BasicElement;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.types.uiDefinition.StateContainerElement;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.uiDefinition.ContainerElement;
   import com.ankamagames.berilia.types.uiDefinition.ButtonElement;
   
   public class InlineXmlGridRender implements IGridRenderer
   {
      
      private static var _slotCount:uint = 0;
       
      private var _grid:Grid;
      
      private var _nameReferences:Array;
      
      private var _componentReferences:Dictionary;
      
      private var _componentReferencesByInstance:Dictionary;
      
      private var _updateFunctionName:String;
      
      public function InlineXmlGridRender(args:String)
      {
         super();
         this._nameReferences = new Array();
         this._componentReferences = new Dictionary();
         this._componentReferencesByInstance = new Dictionary(true);
         this._updateFunctionName = args;
      }
      
      public function set grid(g:Grid) : void
      {
         this._grid = g;
         g.mouseEnabled = true;
      }
      
      public function render(data:*, index:uint, selected:Boolean, drawBackground:Boolean = true) : DisplayObject
      {
         var key:* = null;
         var ui:UiRootContainer = this._grid.getUi();
         var currentCtr:String = this._nameReferences.shift() as String;
         var components:Object = new Object();
         for(key in this._componentReferences[currentCtr])
         {
            components[key] = ui.getElement(this._componentReferences[currentCtr][key]);
         }
         this._componentReferences[currentCtr] = BoxingUnBoxing.box(components);
         this._componentReferencesByInstance[ui.getElement(currentCtr)] = this._componentReferences[currentCtr];
         if(ui.uiClass.hasOwnProperty(this._updateFunctionName))
         {
            Object(ui.uiClass)[this._updateFunctionName](data,this._componentReferences[currentCtr],selected);
         }
         return ui.getElement(currentCtr);
      }
      
      public function update(data:*, index:uint, target:DisplayObject, selected:Boolean, drawBackground:Boolean = true) : void
      {
         var ui:UiRootContainer = this._grid.getUi();
         if(ui.uiClass.hasOwnProperty(this._updateFunctionName))
         {
            Object(ui.uiClass)[this._updateFunctionName](data,this._componentReferencesByInstance[target],selected);
         }
      }
      
      public function remove(dispObj:DisplayObject) : void
      {
      }
      
      public function destroy() : void
      {
         this._grid = null;
      }
      
      public function renderModificator(childs:Array) : Array
      {
         var names:Object = null;
         var elem:BasicElement = null;
         if(childs.length != 1)
         {
            throw new BeriliaError("Grid declaration cannot handle more than one container");
         }
         var newChilds:Array = new Array();
         for(var i:uint = 0; i < this._grid.slotByCol * this._grid.slotByRow; i++)
         {
            names = new Object();
            elem = this.copyElement(childs[0],names);
            newChilds.push(elem);
            this._nameReferences.push(elem.name);
            this._componentReferences[elem.name] = names;
            _slotCount++;
         }
         return newChilds;
      }
      
      public function eventModificator(msg:Message, functionName:String, args:Array, target:UIComponent) : String
      {
         trace(target);
         return functionName;
      }
      
      private function copyElement(basicElement:BasicElement, names:Object) : BasicElement
      {
         var childs:Array = null;
         var elem:BasicElement = null;
         var nsce:StateContainerElement = null;
         var sce:StateContainerElement = null;
         var stateChangingProperties:Array = null;
         var state:uint = 0;
         var stateStr:* = null;
         var elemName:* = null;
         var newElement:BasicElement = new (getDefinitionByName(getQualifiedClassName(basicElement)) as Class)();
         basicElement.copy(newElement);
         if(newElement.name)
         {
            newElement.setName(newElement.name + "_" + _slotCount);
            names[basicElement.name] = newElement.name;
         }
         else
         {
            newElement.setName("elem_" + Math.floor(Math.random() * 100000000));
         }
         if(newElement is ContainerElement)
         {
            childs = new Array();
            for each(elem in ContainerElement(basicElement).childs)
            {
               childs.push(this.copyElement(elem,names));
            }
            ContainerElement(newElement).childs = childs;
         }
         if(newElement is StateContainerElement)
         {
            nsce = newElement as StateContainerElement;
            sce = basicElement as StateContainerElement;
            stateChangingProperties = new Array();
            for(stateStr in sce.stateChangingProperties)
            {
               state = parseInt(stateStr);
               for(elemName in sce.stateChangingProperties[state])
               {
                  if(!stateChangingProperties[state])
                  {
                     stateChangingProperties[state] = [];
                  }
                  stateChangingProperties[state][elemName + "_" + _slotCount] = sce.stateChangingProperties[state][elemName];
               }
            }
            nsce.stateChangingProperties = stateChangingProperties;
         }
         if(newElement is ButtonElement)
         {
            if(newElement.properties["linkedTo"])
            {
               newElement.properties["linkedTo"] = newElement.properties["linkedTo"] + "_" + _slotCount;
            }
         }
         return newElement;
      }
   }
}
