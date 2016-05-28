package com.ankamagames.berilia.components.params
{
   import com.ankamagames.berilia.utils.UiProperties;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   
   public class TooltipProperties extends UiProperties
   {
       
      public var position:IRectangle;
      
      public var tooltip:Tooltip;
      
      public var autoHide:Boolean;
      
      public var point:uint = 0;
      
      public var relativePoint:uint = 2;
      
      public var offset:int = 3;
      
      public var data = null;
      
      public function TooltipProperties(tooltip:Tooltip, autoHide:Boolean, position:IRectangle, point:uint = 0, relativePoint:uint = 2, offset:int = 3, data:* = null)
      {
         super();
         this.position = position;
         this.tooltip = tooltip;
         this.autoHide = autoHide;
         this.point = point;
         this.relativePoint = relativePoint;
         this.offset = offset;
         this.data = data;
      }
   }
}
