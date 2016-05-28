package com.ankamagames.dofus.kernel.sound
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.kernel.sound.manager.ISoundManager;
   import com.ankamagames.tubul.types.TubulOptions;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import flash.filesystem.File;
   
   public class SoundManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.kernel.sound.SoundManager));
      
      private static var _self:com.ankamagames.dofus.kernel.sound.SoundManager;
       
      public var manager:ISoundManager;
      
      private var _tuOptions:TubulOptions;
      
      public function SoundManager()
      {
         super();
         if(_self)
         {
            throw new Error("Warning : SoundManager is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.kernel.sound.SoundManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.kernel.sound.SoundManager();
         }
         return _self;
      }
      
      public function get options() : TubulOptions
      {
         return this._tuOptions;
      }
      
      public function setSoundOptions() : void
      {
         var musicMute:Boolean = false;
         var soundMute:Boolean = false;
         var ambientSoundMute:Boolean = false;
         var commonMod:Object = null;
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         try
         {
            musicMute = OptionManager.getOptionManager("tubul")["muteMusic"];
            soundMute = OptionManager.getOptionManager("tubul")["muteSound"];
            ambientSoundMute = OptionManager.getOptionManager("tubul")["muteAmbientSound"];
            this.setMusicVolume(!!musicMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeMusic"]));
            this.setSoundVolume(!!soundMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeSound"]));
            this.setAmbienceVolume(!!ambientSoundMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeAmbientSound"]));
         }
         catch(e:Error)
         {
            _log.warn("Une erreur est survenue lors de la récupération/application des paramètres audio (option audio)");
            commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            commonMod.openPopup(I18n.getText(I18nProxy.getKeyId("ui.popup.warning")),I18n.getText(I18nProxy.getKeyId("ui.common.soundsDeactivated")),[I18n.getText(I18nProxy.getKeyId("ui.common.ok"))]);
         }
      }
      
      public function setDisplayOptions(pOptions:TubulOptions) : void
      {
         this._tuOptions = pOptions;
         this._tuOptions.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this.setSoundOptions();
      }
      
      public function checkSoundDirectory() : void
      {
         var audioDirectory:File = new File(File.applicationDirectory.nativePath + "/reg/content/audio");
         if(!audioDirectory.exists)
         {
            _log.fatal("The sound directory doesn\'t exists !");
            this.manager.soundDirectoryExist = false;
         }
         else
         {
            this.manager.soundDirectoryExist = true;
         }
      }
      
      private function setMusicVolume(pVolume:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_MUSIC_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_FIGHT_MUSIC_ID,pVolume);
      }
      
      private function setSoundVolume(pVolume:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_UI_ID,pVolume);
      }
      
      private function setAmbienceVolume(pVolume:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_AMBIENT_2D_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_AMBIENT_3D_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_BARKS_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_FIGHT_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_GFX_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_NPC_FOLEYS_ID,pVolume);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_SFX_ID,pVolume);
      }
      
      private function onPropertyChanged(e:PropertyChangeEvent) : void
      {
         switch(e.propertyName)
         {
            case "muteMusic":
               this.setMusicVolume(!!e.propertyValue?Number(0):Number(this._tuOptions.volumeMusic));
               break;
            case "muteSound":
               this.setSoundVolume(!!e.propertyValue?Number(0):Number(this._tuOptions.volumeSound));
               break;
            case "muteAmbientSound":
               this.setAmbienceVolume(!!e.propertyValue?Number(0):Number(this._tuOptions.volumeAmbientSound));
               break;
            case "volumeMusic":
               if(this._tuOptions.muteMusic == false)
               {
                  this.setMusicVolume(e.propertyValue);
               }
               break;
            case "volumeSound":
               if(this._tuOptions.muteSound == false)
               {
                  this.setSoundVolume(e.propertyValue);
               }
               break;
            case "volumeAmbientSound":
               if(this._tuOptions.muteAmbientSound == false)
               {
                  this.setAmbienceVolume(e.propertyValue);
               }
         }
      }
   }
}
