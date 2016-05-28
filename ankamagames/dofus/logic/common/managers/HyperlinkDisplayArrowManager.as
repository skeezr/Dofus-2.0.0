package com.ankamagames.dofus.logic.common.managers
{
   import flash.display.MovieClip;
   import flash.utils.Timer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import com.ankamagames.berilia.Berilia;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.TimerEvent;
   
   public class HyperlinkDisplayArrowManager
   {
      
      private static const ARROW_CLIP:Class = HyperlinkDisplayArrowManager_ARROW_CLIP;
      
      private static var _arrowClip:MovieClip;
      
      private static var _arrowTimer:Timer;
      
      private static var _displayLastArrow:Boolean = false;
      
      private static var _lastArrowX:int;
      
      private static var _lastArrowY:int;
      
      private static var _lastArrowPos:int;
      
      private static var _lastStrata:int;
      
      private static var _lastReverse:int;
       
      public function HyperlinkDisplayArrowManager()
      {
         super();
      }
      
      public static function showArrow(uiName:String, componentName:String, pos:int = 0, reverse:int = 0, strata:int = 5, loop:int = 0) : MovieClip
      {
         var uirc:UiRootContainer = null;
         var displayObject:DisplayObject = null;
         var rect:Rectangle = null;
         var arrow:MovieClip = getArrow(loop == 1);
         var container:DisplayObjectContainer = Berilia.getInstance().docMain.getChildAt(strata) as DisplayObjectContainer;
         container.addChild(arrow);
         if(isNaN(Number(uiName)))
         {
            uirc = Berilia.getInstance().getUi(uiName);
            if(uirc)
            {
               displayObject = uirc.getElement(componentName);
               if(displayObject)
               {
                  rect = displayObject.getRect(container);
                  place(_arrowClip,rect,pos);
               }
            }
            if(reverse == 1)
            {
               _arrowClip.scaleX = _arrowClip.scaleX * -1;
            }
            if(loop)
            {
               _displayLastArrow = true;
               _lastArrowX = arrow.x;
               _lastArrowY = arrow.y;
               _lastArrowPos = pos;
               _lastStrata = strata;
               _lastReverse = _arrowClip.scaleX;
            }
            return _arrowClip;
         }
         return showAbsoluteArrow(int(uiName),int(componentName),pos,reverse,strata,loop);
      }
      
      public static function showAbsoluteArrow(x:int, y:int, pos:int = 0, reverse:int = 0, strata:int = 5, loop:int = 0) : MovieClip
      {
         var arrow:MovieClip = getArrow(loop == 1);
         DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(strata)).addChild(arrow);
         place(arrow,new Rectangle(x,y),pos);
         if(reverse == 1)
         {
            _arrowClip.scaleX = _arrowClip.scaleX * -1;
         }
         if(loop)
         {
            _displayLastArrow = true;
            _lastArrowX = arrow.x;
            _lastArrowY = arrow.y;
            _lastArrowPos = pos;
            _lastStrata = strata;
            _lastReverse = _arrowClip.scaleX;
         }
         return arrow;
      }
      
      public static function destoyArrow(E:Event = null) : void
      {
         if(E)
         {
            if(_displayLastArrow)
            {
               (Berilia.getInstance().docMain.getChildAt(_lastStrata) as DisplayObjectContainer).addChild(_arrowClip);
               place(_arrowClip,new Rectangle(_lastArrowX,_lastArrowY),_lastArrowPos);
               _arrowClip.scaleX = _lastReverse;
               return;
            }
         }
         else
         {
            _displayLastArrow = false;
         }
         if(_arrowClip)
         {
            _arrowClip.gotoAndStop(1);
            if(_arrowClip.parent)
            {
               _arrowClip.parent.removeChild(_arrowClip);
            }
         }
      }
      
      private static function getArrow(loop:Boolean = false) : MovieClip
      {
         if(_arrowClip)
         {
            _arrowClip.gotoAndPlay(1);
         }
         else
         {
            _arrowClip = new ARROW_CLIP() as MovieClip;
            _arrowClip.mouseEnabled = false;
            _arrowClip.mouseChildren = false;
         }
         if(loop)
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
            }
         }
         else
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
            }
            else
            {
               _arrowTimer = new Timer(2000,1);
               _arrowTimer.addEventListener(TimerEvent.TIMER,destoyArrow);
            }
            _arrowTimer.start();
         }
         return _arrowClip;
      }
      
      public static function place(arrow:MovieClip, rect:Rectangle, pos:int) : void
      {
         if(pos == 0)
         {
            arrow.scaleX = 1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x);
            arrow.y = int(rect.y);
         }
         else if(pos == 1)
         {
            arrow.scaleX = 1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x + rect.width / 2);
            arrow.y = int(rect.y);
         }
         else if(pos == 2)
         {
            arrow.scaleX = -1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x + rect.width);
            arrow.y = int(rect.y);
         }
         else if(pos == 3)
         {
            arrow.scaleX = 1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x);
            arrow.y = int(rect.y + rect.height / 2);
         }
         else if(pos == 4)
         {
            arrow.scaleX = 1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x + rect.width / 2);
            arrow.y = int(rect.y + rect.height / 2);
         }
         else if(pos == 5)
         {
            arrow.scaleX = -1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x + rect.width);
            arrow.y = int(rect.y + rect.height / 2);
         }
         else if(pos == 6)
         {
            arrow.scaleX = 1;
            arrow.scaleY = -1;
            arrow.x = int(rect.x);
            arrow.y = int(rect.y + rect.height);
         }
         else if(pos == 7)
         {
            arrow.scaleX = 1;
            arrow.scaleY = -1;
            arrow.x = int(rect.x + rect.width / 2);
            arrow.y = int(rect.y + rect.height);
         }
         else if(pos == 8)
         {
            arrow.scaleY = -1;
            arrow.scaleX = -1;
            arrow.x = int(rect.x + rect.width);
            arrow.y = int(rect.y + rect.height);
         }
         else
         {
            arrow.scaleX = 1;
            arrow.scaleY = 1;
            arrow.x = int(rect.x);
            arrow.y = int(rect.y);
         }
      }
   }
}
