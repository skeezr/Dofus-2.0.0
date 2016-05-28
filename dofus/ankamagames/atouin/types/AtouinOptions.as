package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.managers.OptionManager;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.jerakine.messages.MessageHandler;
   
   public dynamic class AtouinOptions extends OptionManager
   {
       
      private var _container:DisplayObjectContainer;
      
      private var _handler:MessageHandler;
      
      public function AtouinOptions(docContainer:DisplayObjectContainer, mhHandler:MessageHandler)
      {
         super("atouin");
         add("useCacheAsBitmap",true);
         add("useSmooth",true);
         add("frustum",new Frustum(),false);
         add("useMapScrolling",false);
         add("alwaysShowGrid",false);
         add("debugLayer",false);
         add("showCellIdOnOver",false);
         add("tweentInterMap",false);
         add("virtualPlayerJump",false);
         add("reloadLoadedMap",false);
         add("hideForeground",false);
         add("allowAnimatedGfx",true);
         add("allowParticlesFx",true);
         add("elementsPath");
         add("mapsPath");
         add("elementsIndexPath");
         add("particlesScriptsPath");
         add("transparentOverlayMode",false);
         add("groundOnly",false);
         add("showTransitions",false);
         this._container = docContainer;
         this._handler = mhHandler;
      }
      
      public function get container() : DisplayObjectContainer
      {
         return this._container;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
   }
}
