package com.ankamagames.tiphon.types
{
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.tiphon.engine.BoneIndexManager;
   import com.ankamagames.tiphon.TiphonConstants;
   
   public class GraphicLibrary
   {
       
      private var _swl:Dictionary;
      
      public var gfxId:uint;
      
      private var _swlCount:uint = 0;
      
      private var _isBone:Boolean;
      
      public var weight:int = 50;
      
      public function GraphicLibrary(pGfxId:uint, isBone:Boolean = false)
      {
         this._swl = new Dictionary();
         super();
         this.gfxId = pGfxId;
         this._isBone = isBone;
      }
      
      public function addSwl(swl:Swl, url:String) : void
      {
         if(!this._swl[url])
         {
            this._swlCount++;
         }
         this._swl[url] = swl;
      }
      
      public function updateSwfState(url:String) : void
      {
         if(!this._swl[url])
         {
            this._swlCount++;
         }
         this._swl[url] = false;
      }
      
      public function hasClass(className:String) : Boolean
      {
         var swlUrl:String = !!this._isBone?BoneIndexManager.getInstance().getBoneFile(this.gfxId,className):TiphonConstants.SWF_SKIN_PATH + this.gfxId + ".swl";
         return this._swl[swlUrl] != null;
      }
      
      public function hasClassAvaible(className:String = null) : Boolean
      {
         if(this.isSingleFile)
         {
            return this.getSwl() != null;
         }
         var swlUrl:String = !!this._isBone?BoneIndexManager.getInstance().getBoneFile(this.gfxId,className):TiphonConstants.SWF_SKIN_PATH + this.gfxId + ".swl";
         return this._swl[swlUrl] != null && this._swl[swlUrl] != false;
      }
      
      public function hasSwl(swlUrl:String = null) : Boolean
      {
         if(!swlUrl)
         {
            return this._swlCount != 0;
         }
         return this._swl[swlUrl] != null;
      }
      
      public function getSwl(className:String = null) : Swl
      {
         var s:* = undefined;
         var swlUrl:String = null;
         this.weight = this.weight + 5;
         if(className)
         {
            swlUrl = !!this._isBone?BoneIndexManager.getInstance().getBoneFile(this.gfxId,className):TiphonConstants.SWF_SKIN_PATH + this.gfxId + ".swl";
            return this._swl[swlUrl];
         }
         for each(s in this._swl)
         {
            if(s != false)
            {
               return s;
            }
         }
         return null;
      }
      
      public function get isSingleFile() : Boolean
      {
         return !this._isBone || !BoneIndexManager.getInstance().hasCustomBone(this.gfxId);
      }
   }
}
