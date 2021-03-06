package com.ankamagames.jerakine.newCache.impl
{
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.ICacheGarbageCollector;
   
   public class Cache extends InfiniteCache implements ICache
   {
      
      private static var _namedCacheIndex:Array = new Array();
       
      private var _bounds:uint;
      
      private var _gc:ICacheGarbageCollector;
      
      public function Cache(bounds:uint, gc:ICacheGarbageCollector)
      {
         super();
         this._bounds = bounds;
         this._gc = gc;
         this._gc.cache = this;
      }
      
      public static function create(bounds:uint, gc:ICacheGarbageCollector, name:String) : Cache
      {
         var cache:Cache = null;
         if(Boolean(name) && Boolean(_namedCacheIndex[name]))
         {
            return _namedCacheIndex[name];
         }
         cache = new Cache(bounds,gc);
         if(name)
         {
            _namedCacheIndex[name] = cache;
         }
         return cache;
      }
      
      override public function extract(ref:*) : *
      {
         this._gc.used(ref);
         return super.extract(ref);
      }
      
      override public function peek(ref:*) : *
      {
         this._gc.used(ref);
         return super.peek(ref);
      }
      
      override public function store(ref:*, obj:*) : void
      {
         if(_size + 1 > this._bounds)
         {
            this._gc.purge(this._bounds - 1);
         }
         super.store(ref,obj);
         this._gc.used(ref);
      }
   }
}
