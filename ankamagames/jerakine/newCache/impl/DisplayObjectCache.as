package com.ankamagames.jerakine.newCache.impl
{
   import com.ankamagames.jerakine.newCache.ICache;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.resources.CacheableResource;
   import com.ankamagames.jerakine.types.ASwf;
   
   public class DisplayObjectCache implements ICache
   {
       
      private var _cache:Dictionary;
      
      private var _size:uint = 0;
      
      private var _bounds:uint;
      
      private var _useCount:Dictionary;
      
      public function DisplayObjectCache(bound:uint)
      {
         this._cache = new Dictionary(true);
         this._useCount = new Dictionary(true);
         super();
         this._bounds = bound;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function contains(ref:*) : Boolean
      {
         var d:CacheableResource = null;
         var a:Array = this._cache[ref];
         for each(d in a)
         {
            if(Boolean(d.resource) && (d.resource is ASwf || !d.resource.parent))
            {
               return true;
            }
         }
         return false;
      }
      
      public function extract(ref:*) : *
      {
         return this.peek(ref);
      }
      
      public function peek(ref:*) : *
      {
         var d:CacheableResource = null;
         var a:Array = this._cache[ref];
         for each(d in a)
         {
            if(Boolean(d.resource) && (d.resource is ASwf || !d.resource.parent))
            {
               this._useCount[ref]++;
               return d;
            }
         }
         return null;
      }
      
      public function store(ref:*, obj:*) : void
      {
         if(!this._cache[ref])
         {
            this._cache[ref] = new Array();
            this._useCount[ref] = 0;
            this._size++;
            if(this._size > this._bounds)
            {
               this.garbage();
            }
         }
         this._useCount[ref]++;
         this._cache[ref].push(obj);
      }
      
      private function garbage() : void
      {
         var o:* = undefined;
         var bound:uint = 0;
         var l:uint = 0;
         var a:Array = null;
         var b:Boolean = false;
         var i:uint = 0;
         var ref:* = undefined;
         var orderedUse:Array = new Array();
         for(o in this._cache)
         {
            if(this._cache[o] != null && Boolean(this._useCount[ref]))
            {
               orderedUse.push({
                  "ref":o,
                  "useCount":this._useCount[ref]
               });
            }
         }
         orderedUse.sortOn("useCount",Array.NUMERIC);
         bound = this._bounds * 0.1;
         l = orderedUse.length;
         i = 0;
         while(i < l && this._size > bound)
         {
            b = false;
            a = this._cache[orderedUse[i].ref];
            for each(ref in a)
            {
               if(Boolean(ref) && Boolean(ref.resource) && (Boolean(!(ref.resource is ASwf)) || Boolean(ref.resource.parent)))
               {
                  b = true;
                  break;
               }
            }
            if(!b)
            {
               delete this._cache[orderedUse[i].ref];
               delete this._useCount[orderedUse[i].ref];
               this._size--;
            }
            i++;
         }
      }
   }
}
