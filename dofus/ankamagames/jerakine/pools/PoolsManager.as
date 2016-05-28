package com.ankamagames.jerakine.pools
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.JerakineConstants;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class PoolsManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.pools.PoolsManager));
      
      private static var _self:com.ankamagames.jerakine.pools.PoolsManager;
       
      private var _loadersPool:com.ankamagames.jerakine.pools.Pool;
      
      private var _urlLoadersPool:com.ankamagames.jerakine.pools.Pool;
      
      private var _rectanglePool:com.ankamagames.jerakine.pools.Pool;
      
      private var _pointPool:com.ankamagames.jerakine.pools.Pool;
      
      private var _soundPool:com.ankamagames.jerakine.pools.Pool;
      
      public function PoolsManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Direct initialization of singleton is forbidden. Please access PoolsManager using the getInstance method.");
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.pools.PoolsManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.jerakine.pools.PoolsManager();
         }
         return _self;
      }
      
      public function getLoadersPool() : com.ankamagames.jerakine.pools.Pool
      {
         if(this._loadersPool == null)
         {
            this._loadersPool = new com.ankamagames.jerakine.pools.Pool(PoolableLoader,JerakineConstants.LOADERS_POOL_INITIAL_SIZE,JerakineConstants.LOADERS_POOL_GROW_SIZE,JerakineConstants.LOADERS_POOL_WARN_LIMIT);
         }
         return this._loadersPool;
      }
      
      public function getURLLoaderPool() : com.ankamagames.jerakine.pools.Pool
      {
         if(this._urlLoadersPool == null)
         {
            this._urlLoadersPool = new com.ankamagames.jerakine.pools.Pool(PoolableURLLoader,JerakineConstants.URLLOADERS_POOL_INITIAL_SIZE,JerakineConstants.URLLOADERS_POOL_GROW_SIZE,JerakineConstants.URLLOADERS_POOL_WARN_LIMIT);
         }
         return this._urlLoadersPool;
      }
      
      public function getRectanglePool() : com.ankamagames.jerakine.pools.Pool
      {
         if(this._rectanglePool == null)
         {
            this._rectanglePool = new com.ankamagames.jerakine.pools.Pool(PoolableRectangle,JerakineConstants.RECTANGLE_POOL_INITIAL_SIZE,JerakineConstants.RECTANGLE_POOL_GROW_SIZE,JerakineConstants.RECTANGLE_POOL_WARN_LIMIT);
         }
         return this._rectanglePool;
      }
      
      public function getPointPool() : com.ankamagames.jerakine.pools.Pool
      {
         if(this._pointPool == null)
         {
            this._pointPool = new com.ankamagames.jerakine.pools.Pool(PoolablePoint,JerakineConstants.POINT_POOL_INITIAL_SIZE,JerakineConstants.POINT_POOL_GROW_SIZE,JerakineConstants.POINT_POOL_WARN_LIMIT);
         }
         return this._pointPool;
      }
      
      public function getSoundPool() : com.ankamagames.jerakine.pools.Pool
      {
         if(this._soundPool == null)
         {
            this._soundPool = new com.ankamagames.jerakine.pools.Pool(PoolableSound,JerakineConstants.SOUND_POOL_INITIAL_SIZE,JerakineConstants.SOUND_POOL_GROW_SIZE,JerakineConstants.SOUND_POOL_WARN_LIMIT);
         }
         return this._soundPool;
      }
   }
}
