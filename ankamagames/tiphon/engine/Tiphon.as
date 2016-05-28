package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.interfaces.IFLAEventHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tiphon.types.ColoredSprite;
   import com.ankamagames.tiphon.types.CarriedSprite;
   import com.ankamagames.tiphon.types.EquipmentSprite;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public final class Tiphon implements IFLAEventHandler
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.tiphon.engine.Tiphon));
      
      private static var _self:com.ankamagames.tiphon.engine.Tiphon;
      
      public static const skullLibrary:com.ankamagames.tiphon.engine.LibrariesManager = TiphonLibraries.skullLibrary;
      
      public static const skinLibrary:com.ankamagames.tiphon.engine.LibrariesManager = TiphonLibraries.skinLibrary;
       
      protected var coloredSprite:ColoredSprite;
      
      protected var carriedSprite:CarriedSprite;
      
      protected var equipmentSprite:EquipmentSprite;
      
      protected var scriptedAnimation:ScriptedAnimation;
      
      private var _rasterizedAnimationNameList:Array;
      
      private var _toOptions;
      
      public function Tiphon()
      {
         this._rasterizedAnimationNameList = new Array();
         super();
         if(_self != null)
         {
            throw new SingletonError("Tiphon is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : com.ankamagames.tiphon.engine.Tiphon
      {
         if(_self == null)
         {
            _self = new com.ankamagames.tiphon.engine.Tiphon();
         }
         return _self;
      }
      
      public function addRasterizeAnimation(animName:String) : void
      {
      }
      
      public function isRasterizeAnimation(animName:String) : Boolean
      {
         return this._rasterizedAnimationNameList[animName];
      }
      
      public function get options() : *
      {
         return this._toOptions;
      }
      
      public function init(sSwfSkullPath:String, sSwfSkinPath:String, sSwfFxPath:String, animIndexPath:String) : void
      {
         TiphonConstants.SWF_SKULL_PATH = sSwfSkullPath;
         TiphonConstants.SWF_SKIN_PATH = sSwfSkinPath;
         TiphonConstants.SWF_FX_PATH = sSwfFxPath;
         BoneIndexManager.getInstance().init(animIndexPath);
      }
      
      public function setDisplayOptions(topt:*) : void
      {
         this._toOptions = topt;
      }
      
      public function handleFLAEvent(pParams:String, pSprite:Object = null) : void
      {
         var tiphonSprite:TiphonSprite = pSprite as TiphonSprite;
         switch(pParams)
         {
            case TiphonEvent.EVENT_SHOT:
               tiphonSprite.onAnimationEvent(TiphonEvent.EVENT_SHOT);
               break;
            case TiphonEvent.EVENT_END:
               tiphonSprite.onAnimationEvent(TiphonEvent.EVENT_END);
         }
      }
      
      public function removeEntitySound(pEntityId:IEntity) : void
      {
      }
   }
}
