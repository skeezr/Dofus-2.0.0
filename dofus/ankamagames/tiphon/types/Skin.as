package com.ankamagames.tiphon.types
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.jerakine.types.Callback;
   import flash.display.Sprite;
   import com.ankamagames.jerakine.types.Swl;
   import flash.events.Event;
   
   public class Skin extends EventDispatcher
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(Skin));
       
      private var _ressourceCount:uint = 0;
      
      private var _ressourceLoading:uint = 0;
      
      private var _skinParts:Array;
      
      private var _skinClass:Array;
      
      private var _aSkinPartOrdered:Array;
      
      private var _validate:Boolean = true;
      
      public function Skin()
      {
         super();
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
      }
      
      public function get complete() : Boolean
      {
         var skinId:uint = 0;
         if(!this._validate)
         {
            return false;
         }
         var isComplete:Boolean = true;
         for each(skinId in this._aSkinPartOrdered)
         {
            isComplete = Boolean(isComplete) && Boolean(Tiphon.skinLibrary.isLoaded(skinId));
         }
         return isComplete;
      }
      
      public function get validate() : Boolean
      {
         return this._validate;
      }
      
      public function set validate(b:Boolean) : void
      {
         this._validate = b;
         if(Boolean(b) && Boolean(this.complete))
         {
            this.processSkin();
         }
      }
      
      public function add(gfxId:uint) : void
      {
         var parts:Array = new Array();
         for(var i:uint = 0; i < this._aSkinPartOrdered.length; i++)
         {
            if(this._aSkinPartOrdered[i] != gfxId)
            {
               parts.push(this._aSkinPartOrdered[i]);
            }
         }
         parts.push(gfxId);
         if(this._aSkinPartOrdered.length != parts.length)
         {
            this._aSkinPartOrdered = parts;
            this._ressourceLoading++;
            Tiphon.skinLibrary.addResource(gfxId,TiphonConstants.SWF_SKIN_PATH + gfxId + ".swl");
            Tiphon.skinLibrary.askResource(gfxId,null,new Callback(this.onResourceLoaded,gfxId),new Callback(this.onResourceLoaded,gfxId));
         }
         else
         {
            this._aSkinPartOrdered = parts;
         }
      }
      
      public function getPart(sName:String) : Sprite
      {
         var p:Sprite = this._skinParts[sName];
         if(Boolean(p) && !p.parent)
         {
            return p;
         }
         if(this._skinClass[sName])
         {
            p = new this._skinClass[sName]();
            this._skinParts[sName] = p;
            return p;
         }
         return null;
      }
      
      public function reset() : void
      {
         this._skinParts = new Array();
         this._skinClass = new Array();
         this._aSkinPartOrdered = new Array();
      }
      
      private function onResourceLoaded(gfxId:uint) : void
      {
         this._ressourceCount++;
         this._ressourceLoading--;
         if(this.complete)
         {
            this.processSkin();
         }
      }
      
      private function processSkin() : void
      {
         var gfxId:uint = 0;
         var lib:Swl = null;
         var classPart:Array = null;
         var className:String = null;
         for(var i:uint = 0; i < this._aSkinPartOrdered.length; i++)
         {
            gfxId = this._aSkinPartOrdered[i];
            lib = Tiphon.skinLibrary.getResourceById(gfxId);
            if(lib)
            {
               classPart = lib.getDefinitions();
               for each(className in classPart)
               {
                  this._skinClass[className] = lib.getDefinition(className);
                  delete this._skinParts[className];
               }
            }
         }
         if(this.complete)
         {
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}
