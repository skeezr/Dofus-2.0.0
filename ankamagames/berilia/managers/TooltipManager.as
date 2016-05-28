package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.Berilia;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.Callback;
   import flash.geom.Point;
   import com.ankamagames.berilia.types.tooltip.TooltipRectangle;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.components.params.TooltipProperties;
   import com.ankamagames.berilia.interfaces.IApplicationContainer;
   import com.ankamagames.jerakine.logger.Log;
   
   public class TooltipManager
   {
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(TooltipManager));
      
      private static var _tooltips:Array = new Array();
      
      private static const TOOLTIP_UI_NAME_PREFIX:String = "tooltip_";
      
      public static const TOOLTIP_STANDAR_NAME:String = "standard";
      
      private static var _tooltipCache:Dictionary = new Dictionary();
      
      private static var _tooltipCacheParam:Dictionary = new Dictionary();
       
      public function TooltipManager()
      {
         super();
      }
      
      public static function show(data:*, target:*, uiModule:UiModule, autoHide:Boolean = true, name:String = "standard", point:uint = 0, relativePoint:uint = 2, offset:int = 3, usePrefix:Boolean = true, tooltipMaker:String = null, script:Class = null, makerParam:Object = null, cacheName:String = null) : void
      {
         var tooltipCache:UiRootContainer = null;
         var cacheNameInfo:Array = null;
         var baseCacheName:String = null;
         var cacheNameParam:String = null;
         name = (!!usePrefix?TOOLTIP_UI_NAME_PREFIX:"") + name;
         if(cacheName)
         {
            cacheNameInfo = cacheName.split("#");
            if(cacheNameInfo.length == 1)
            {
               tooltipCache = _tooltipCache[cacheName];
               if(tooltipCache)
               {
                  _tooltips[name] = data;
                  Berilia.getInstance().uiList[name] = tooltipCache;
                  DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_TOOLTIP + 1)).addChild(tooltipCache);
                  return;
               }
            }
            else
            {
               baseCacheName = cacheNameInfo[0];
               cacheNameParam = cacheNameInfo[1];
               tooltipCache = _tooltipCache[baseCacheName];
               if(Boolean(tooltipCache) && _tooltipCacheParam[baseCacheName] == cacheNameParam)
               {
                  _tooltips[name] = data;
                  Berilia.getInstance().uiList[name] = tooltipCache;
                  DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_TOOLTIP + 1)).addChild(tooltipCache);
                  return;
               }
            }
         }
         var tt:Tooltip = TooltipsFactory.create(data,tooltipMaker,script,makerParam);
         if(!tt)
         {
            _log.error("Erreur lors du rendu du tootltip de " + data + " (" + getQualifiedClassName(data) + ")");
            return;
         }
         _tooltips[name] = data;
         tt.askTooltip(new Callback(onTooltipReady,tt,uiModule,name,data,target,autoHide,point,relativePoint,offset,cacheName));
      }
      
      public static function hide(name:String = "standard") : void
      {
         if(name == null)
         {
            name = TOOLTIP_STANDAR_NAME;
         }
         if(name.indexOf(TOOLTIP_UI_NAME_PREFIX) == -1)
         {
            name = TOOLTIP_UI_NAME_PREFIX + name;
         }
         if(_tooltips[name])
         {
            Berilia.getInstance().unloadUi(name);
            delete _tooltips[name];
         }
      }
      
      public static function hideAll() : void
      {
         var name:* = null;
         for(name in _tooltips)
         {
            hide(name);
         }
      }
      
      private static function onTooltipReady(tt:Tooltip, uiModule:UiModule, name:String, data:*, target:*, autoHide:Boolean, point:uint, relativePoint:uint, offset:int, cacheName:String) : void
      {
         var coord:Point = null;
         var targetRect:TooltipRectangle = null;
         var realtarget:* = undefined;
         var uiData:UiData = null;
         var localCoord:Point = null;
         var sx:Number = NaN;
         var sy:Number = NaN;
         var inBerilia:Boolean = false;
         var cacheNameInfo:Array = null;
         var baseCacheName:String = null;
         var cacheNameParam:String = null;
         var cacheMode:* = cacheName != null;
         var showNow:Boolean = Boolean(_tooltips[name]) && _tooltips[name] === data;
         if(Boolean(showNow) || Boolean(cacheName))
         {
            realtarget = BoxingUnBoxing.unbox(target);
            if(realtarget)
            {
               if(realtarget is Rectangle)
               {
                  coord = new Point(realtarget.x,realtarget.y);
               }
               else
               {
                  coord = realtarget.localToGlobal(new Point(realtarget.x,realtarget.y));
               }
               localCoord = Berilia.getInstance().strataTooltip.globalToLocal(coord);
               sx = StageShareManager.stageScaleX;
               sy = StageShareManager.stageScaleY;
               inBerilia = realtarget is DisplayObject?Boolean(Berilia.getInstance().docMain.contains(realtarget)):false;
               targetRect = new TooltipRectangle(localCoord.x * (!!inBerilia?sx:1),localCoord.y * (!!inBerilia?sy:1),realtarget.width / sx,realtarget.height / sy);
            }
            uiData = new UiData(uiModule,name,null,null);
            uiData.xml = tt.content;
            uiData.uiClass = tt.scriptClass;
            tt.display = Berilia.getInstance().loadUi(uiModule,uiData,name,new TooltipProperties(tt,autoHide,targetRect,point,relativePoint,offset,data),true,tt.strata,!showNow);
            if(cacheName)
            {
               cacheNameInfo = cacheName.split("#");
               if(cacheNameInfo.length == 0)
               {
                  _tooltipCache[cacheName] = tt.display;
                  tt.display.cached = true;
                  tt.display.cacheAsBitmap = true;
               }
               else
               {
                  baseCacheName = cacheNameInfo[0];
                  cacheNameParam = cacheNameInfo[1];
                  _tooltipCache[baseCacheName] = tt.display;
                  _tooltipCacheParam[baseCacheName] = cacheNameParam;
                  tt.display.cached = true;
                  tt.display.cacheAsBitmap = true;
               }
            }
         }
      }
      
      private static function localToGlobal(t:Object, p:Point = null) : Point
      {
         if(!p)
         {
            p = new Point();
         }
         if(!t.hasOwnProperty("parent"))
         {
            return t.localToGlobal(new Point(t.x,t.y));
         }
         if(Boolean(t.parent) && !(t.parent is IApplicationContainer))
         {
            p.x = (p.x + t.x) * t.parent.scaleX;
            p.y = (p.y + t.y) * t.parent.scaleY;
            p = localToGlobal(t.parent,p);
         }
         else
         {
            p.x = p.x + t.x;
            p.y = p.y + t.y;
         }
         return p;
      }
   }
}
