package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.types.tooltip.TooltipBlock;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.jerakine.utils.misc.CheckCompatibility;
   import com.ankamagames.berilia.interfaces.ITooltipMaker;
   import com.ankamagames.berilia.types.data.ChunkData;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   
   [InstanciedApi]
   public class TooltipApi
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TooltipApi));
       
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      public function TooltipApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(value:UiRootContainer) : void
      {
         this._currentUi = value;
      }
      
      [Untrusted]
      public function setDefaultTooltipUiScript(module:String, ui:String) : void
      {
         var m:UiModule = UiModuleManager.getInstance().getModule(module);
         if(!m)
         {
            throw new ApiError("Module " + module + " doesn\'t exist");
         }
         var uiData:UiData = m.getUi(ui);
         if(!uiData)
         {
            throw new ApiError("UI " + ui + " doesn\'t exist in module " + module);
         }
         UiApi.api_namespace::defaultTooltipUiScript = uiData.uiClass;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltip(baseUri:String, containerUri:String, separatorUri:String = null) : Tooltip
      {
         var t:Tooltip = null;
         if(baseUri.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + baseUri);
         }
         if(containerUri.substr(-4,4) != ".txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + containerUri);
         }
         if(separatorUri)
         {
            if(separatorUri.substr(-4,4) != ".txt")
            {
               throw new ApiError("ChunkData support only [.txt] file, found " + separatorUri);
            }
            t = new Tooltip(new Uri(this._module.rootPath + "/" + baseUri),new Uri(this._module.rootPath + "/" + containerUri),new Uri(this._module.rootPath + "/" + separatorUri));
         }
         else
         {
            t = new Tooltip(new Uri(this._module.rootPath + "/" + baseUri),new Uri(this._module.rootPath + "/" + containerUri));
         }
         return t;
      }
      
      [NoBoxing]
      [Untrusted]
      public function createTooltipBlock(onAllChunkLoadedCallback:Function, contentGetter:Function) : TooltipBlock
      {
         var tb:TooltipBlock = new TooltipBlock();
         tb.onAllChunkLoadedCallback = onAllChunkLoadedCallback;
         tb.contentGetter = contentGetter;
         return tb;
      }
      
      [Untrusted]
      public function registerTooltipAssoc(targetClass:*, makerName:String) : void
      {
         TooltipsFactory.registerAssoc(targetClass,makerName);
      }
      
      [Untrusted]
      public function registerTooltipMaker(makerName:String, makerClass:Class, scriptClass:Class = null) : void
      {
         if(CheckCompatibility.isCompatible(ITooltipMaker,makerClass))
         {
            TooltipsFactory.registerMaker(makerName,makerClass,scriptClass);
            return;
         }
         throw new ApiError(makerName + " maker class is not compatible with ITooltipMaker");
      }
      
      [NoBoxing]
      [Untrusted]
      public function createChunkData(name:String, uri:String) : ChunkData
      {
         var newUri:Uri = new Uri(this._module.rootPath + "/" + uri);
         if(newUri.fileType.toLowerCase() != "txt")
         {
            throw new ApiError("ChunkData support only [.txt] file, found " + uri);
         }
         return new ChunkData(name,newUri);
      }
      
      [Untrusted]
      public function place(target:*, point:uint = 6.0, relativePoint:uint = 0.0, offset:int = 3) : void
      {
         if(Boolean(target) && Boolean(CheckCompatibility.isCompatible(IRectangle,target)))
         {
            TooltipPlacer.place(this._currentUi,target,point,relativePoint,offset);
         }
      }
      
      [Untrusted]
      public function placeArrow(target:*) : Object
      {
         if(Boolean(target) && Boolean(CheckCompatibility.isCompatible(IRectangle,target)))
         {
            return TooltipPlacer.placeWithArrow(this._currentUi,target);
         }
         return null;
      }
   }
}
