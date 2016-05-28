package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.ClassicSoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.RegSoundManager;
   
   public class SoundInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SoundInstructionHandler));
       
      public function SoundInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var soundId:String = null;
         var sIdm:String = null;
         var volm:Number = NaN;
         var loopm:Boolean = false;
         var sIda:String = null;
         var vola:Number = NaN;
         var loopa:Boolean = false;
         var volume:uint = 0;
         var silenceMin:uint = 0;
         var silenceMax:uint = 0;
         switch(cmd)
         {
            case "playmusic":
               if(args.length != 2)
               {
                  console.output("COMMAND FAILED ! playmusic must have followings parameters : \n-id\n-volume");
                  return;
               }
               sIdm = args[0];
               volm = args[1];
               loopm = true;
               SoundManager.getInstance().manager.playAdminSound(sIdm,volm,loopm,0);
               break;
            case "stopmusic":
               SoundManager.getInstance().manager.stopAdminSound(0);
               break;
            case "playambiance":
               if(args.length != 2)
               {
                  console.output("COMMAND FAILED ! playambiance must have followings parameters : \n-id\n-volume");
                  return;
               }
               sIda = args[0];
               vola = args[1];
               loopa = true;
               SoundManager.getInstance().manager.playAdminSound(sIda,vola,loopa,1);
               break;
            case "stopambiance":
               SoundManager.getInstance().manager.stopAdminSound(1);
               break;
            case "addsoundinplaylist":
               if(args.length != 4)
               {
                  console.output("addSoundInPLaylist must have followings parameters : \n-id\n-volume\n-silenceMin\n-SilenceMax");
                  return;
               }
               soundId = args[0];
               volume = args[1];
               silenceMin = args[2];
               silenceMax = args[3];
               if(!SoundManager.getInstance().manager.addSoundInPlaylist(soundId,volume,silenceMin,silenceMax))
               {
                  console.output("addSoundInPLaylist failed !");
               }
               break;
            case "stopplaylist":
               if(args.length != 0)
               {
                  console.output("stopplaylist doesn\'t accept any paramter");
                  return;
               }
               SoundManager.getInstance().manager.stopPlaylist();
               break;
            case "playplaylist":
               if(args.length != 0)
               {
                  console.output("removeSoundInPLaylist doesn\'t accept any paramter");
                  return;
               }
               SoundManager.getInstance().manager.playPlaylist();
               break;
            case "activesounds":
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  (SoundManager.getInstance().manager as ClassicSoundManager).forceSoundsDebugMode = true;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  (SoundManager.getInstance().manager as RegSoundManager).forceSoundsDebugMode = true;
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "playsound":
               return "Play a sound";
            default:
               return "Unknown command \'" + cmd + "\'.";
         }
      }
      
      private function getParams(data:Array, types:Array) : Array
      {
         var iStr:* = null;
         var i:uint = 0;
         var v:String = null;
         var t:String = null;
         var params:Array = [];
         for(iStr in data)
         {
            i = parseInt(iStr);
            v = data[i];
            t = types[i];
            params[i] = this.getParam(v,t);
         }
         return params;
      }
      
      private function getParam(value:String, type:String) : *
      {
         switch(type)
         {
            case "String":
               return value;
            case "Boolean":
               return value == "true" || value == "1";
            case "int":
            case "uint":
               return parseInt(value);
            default:
               _log.warn("Unsupported parameter type \'" + type + "\'.");
               return value;
         }
      }
   }
}
