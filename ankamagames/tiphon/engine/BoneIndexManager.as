package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class BoneIndexManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.tiphon.engine.BoneIndexManager));
      
      private static var _self:com.ankamagames.tiphon.engine.BoneIndexManager;
       
      private var _loader:IResourceLoader;
      
      private var _index:Dictionary;
      
      private var _transitions:Dictionary;
      
      public function BoneIndexManager()
      {
         this._index = new Dictionary();
         this._transitions = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.tiphon.engine.BoneIndexManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.tiphon.engine.BoneIndexManager();
         }
         return _self;
      }
      
      public function init(boneIndexPath:String) : void
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onXmlFailed);
         this._loader.load(new Uri(boneIndexPath));
      }
      
      public function addTransition(boneId:uint, startAnim:String, endAnim:String, direction:uint, transitionalAnim:String) : void
      {
         if(!this._transitions[boneId])
         {
            this._transitions[boneId] = new Dictionary();
         }
         this._transitions[boneId][startAnim + "_" + endAnim + "_" + direction] = transitionalAnim;
      }
      
      public function hasTransition(boneId:uint, startAnim:String, endAnim:String, direction:uint) : Boolean
      {
         return Boolean(this._transitions[boneId]) && (this._transitions[boneId][startAnim + "_" + endAnim + "_" + direction] != null || this._transitions[boneId][startAnim + "_" + endAnim + "_" + TiphonUtility.getFlipDirection(direction)] != null);
      }
      
      public function getTransition(boneId:uint, startAnim:String, endAnim:String, direction:uint) : String
      {
         if(!this._transitions[boneId])
         {
            return null;
         }
         if(this._transitions[boneId][startAnim + "_" + endAnim + "_" + direction])
         {
            return this._transitions[boneId][startAnim + "_" + endAnim + "_" + direction];
         }
         return this._transitions[boneId][startAnim + "_" + endAnim + "_" + TiphonUtility.getFlipDirection(direction)];
      }
      
      public function getBoneFile(boneId:uint, animName:String) : String
      {
         if(!this._index[boneId] || !this._index[boneId][animName])
         {
            return TiphonConstants.SWF_SKULL_PATH + boneId + ".swl";
         }
         return TiphonConstants.SWF_SKULL_PATH + this._index[boneId][animName];
      }
      
      public function hasCustomBone(boneId:uint) : Boolean
      {
         return this._index[boneId];
      }
      
      private function onXmlLoaded(e:ResourceLoadedEvent) : void
      {
         var group:XML = null;
         var uri:Uri = null;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onSubXmlLoaded);
         var folder:String = FileUtils.getFilePath(e.uri.uri);
         var xml:XML = e.resource as XML;
         var subXml:Array = new Array();
         for each(group in xml..group)
         {
            uri = new Uri(folder + "/" + group.@id.toString() + ".xml");
            uri.tag = parseInt(group.@id.toString());
            subXml.push(uri);
         }
         this._loader.load(subXml);
      }
      
      private function onSubXmlLoaded(e:ResourceLoadedEvent) : void
      {
         var className:String = null;
         var file:XML = null;
         var animClass:XML = null;
         var animInfo:Array = null;
         var xml:XML = e.resource as XML;
         for each(file in xml..file)
         {
            for each(animClass in file..resource)
            {
               className = animClass.@name.toString();
               if(className.indexOf("Anim") != -1)
               {
                  if(!this._index[e.uri.tag])
                  {
                     this._index[e.uri.tag] = new Dictionary();
                  }
                  this._index[e.uri.tag][className] = file.@name.toString();
                  if(className.indexOf("_to_") != -1)
                  {
                     animInfo = className.split("_");
                     com.ankamagames.tiphon.engine.BoneIndexManager.getInstance().addTransition(e.uri.tag,animInfo[0],animInfo[2],parseInt(animInfo[3]),animInfo[0] + "_to_" + animInfo[2]);
                  }
               }
            }
         }
      }
      
      private function onXmlFailed(e:ResourceErrorEvent) : void
      {
         _log.error("Impossible de charger ou parser le fichier d\'index d\'animation : " + e.uri);
      }
   }
}
