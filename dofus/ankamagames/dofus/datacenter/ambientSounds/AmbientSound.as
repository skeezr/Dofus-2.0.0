package com.ankamagames.dofus.datacenter.ambientSounds
{
   import com.ankamagames.jerakine.data.GameData;
   
   public class AmbientSound
   {
      
      private static const MODULE:String = "AmbientSounds";
       
      public var id:int;
      
      public var volume:uint;
      
      public var criterionId:int;
      
      public var silenceMin:uint;
      
      public var silenceMax:uint;
      
      public var channel:int;
      
      public function AmbientSound()
      {
         super();
      }
      
      public static function create(id:int, volume:uint, criterionId:uint, silenceMin:uint, silenceMax:uint, channel:int) : AmbientSound
      {
         var o:AmbientSound = new AmbientSound();
         o.id = id;
         o.volume = volume;
         o.criterionId = criterionId;
         o.silenceMin = silenceMin;
         o.silenceMax = silenceMax;
         o.channel = channel;
         return o;
      }
      
      public static function getAmbientSoundById(id:uint) : AmbientSound
      {
         return GameData.getObject(MODULE,id) as AmbientSound;
      }
   }
}
