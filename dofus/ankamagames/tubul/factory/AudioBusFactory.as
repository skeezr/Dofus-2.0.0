package com.ankamagames.tubul.factory
{
   import com.ankamagames.tubul.interfaces.IAudioBus;
   import com.ankamagames.tubul.types.bus.LocalizedBus;
   import com.ankamagames.tubul.types.bus.UnlocalizedBus;
   import com.ankamagames.tubul.enum.EnumTypeBus;
   
   public class AudioBusFactory
   {
       
      public function AudioBusFactory()
      {
         super();
      }
      
      public static function getAudioBus(type:uint, id:uint, name:String) : IAudioBus
      {
         switch(type)
         {
            case EnumTypeBus.LOCALIZED_BUS:
               return new LocalizedBus(id,name);
            case EnumTypeBus.UNLOCALIZED_BUS:
               return new UnlocalizedBus(id,name);
            default:
               throw new ArgumentError("Unknown audio bus type " + type + ".");
         }
      }
   }
}
