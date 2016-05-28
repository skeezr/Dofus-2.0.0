package com.ankamagames.berilia.types.tooltip
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.events.Event;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.data.ChunkData;
   
   public class Tooltip
   {
       
      protected var _log:Logger;
      
      private var _mainblock:com.ankamagames.berilia.types.tooltip.TooltipBlock;
      
      private var _blocks:Array;
      
      private var _loadedblock:uint = 0;
      
      private var _mainblockLoaded:Boolean = false;
      
      private var _callbacks:Array;
      
      private var _content:String = "";
      
      private var _useSeparator:Boolean = true;
      
      public var scriptClass:Class;
      
      public var display:UiRootContainer;
      
      public var strata:int = 4;
      
      public function Tooltip(base:Uri, container:Uri, separator:Uri = null)
      {
         this._log = Log.getLogger(getQualifiedClassName(Tooltip));
         this._callbacks = new Array();
         super();
         this._blocks = new Array();
         this._mainblock = new com.ankamagames.berilia.types.tooltip.TooltipBlock();
         this._mainblock.addEventListener(Event.COMPLETE,this.onMainChunkLoaded);
         if(!separator)
         {
            this._useSeparator = false;
            this._mainblock.initChunk([new ChunkData("main",base),new ChunkData("container",container)]);
         }
         else
         {
            this._mainblock.initChunk([new ChunkData("main",base),new ChunkData("separator",separator),new ChunkData("container",container)]);
         }
         this._mainblock.init();
      }
      
      public function addBlock(block:com.ankamagames.berilia.types.tooltip.TooltipBlock) : void
      {
         this._blocks.push(block);
         block.addEventListener(Event.COMPLETE,this.onChunkReady);
         block.init();
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function askTooltip(callback:Callback) : void
      {
         this._callbacks.push(callback);
         this.processCallback();
      }
      
      private function onMainChunkLoaded(e:Event) : void
      {
         this._mainblockLoaded = true;
         this.processCallback();
      }
      
      private function processCallback() : void
      {
         if(Boolean(this._mainblockLoaded) && this._loadedblock == this._blocks.length)
         {
            this.makeTooltip();
            while(this._callbacks.length)
            {
               Callback(this._callbacks.pop()).exec();
            }
         }
      }
      
      private function makeTooltip() : void
      {
         var block:com.ankamagames.berilia.types.tooltip.TooltipBlock = null;
         var result:Array = new Array();
         for each(block in this._blocks)
         {
            if(Boolean(block.content) && Boolean(block.content.length))
            {
               result.push(this._mainblock.getChunk("container").processContent({"content":block.content}));
            }
         }
         if(this._useSeparator)
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":result.join(this._mainblock.getChunk("separator").processContent(null))});
         }
         else
         {
            this._content = this._mainblock.getChunk("main").processContent({"content":result.join("")});
         }
      }
      
      private function onChunkReady(e:Event) : void
      {
         this._loadedblock++;
         this.processCallback();
      }
   }
}
