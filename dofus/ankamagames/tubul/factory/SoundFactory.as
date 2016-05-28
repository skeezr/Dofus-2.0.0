package com.ankamagames.tubul.factory
{
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.types.sounds.LocalizedSound;
   import com.ankamagames.tubul.types.sounds.UnlocalizedSound;
   import com.ankamagames.tubul.enum.EnumSoundType;
   
   public class SoundFactory
   {
      
      private static var _id:uint = 0;
       
      public function SoundFactory()
      {
         super();
      }
      
      public static function getSound(type:uint, uri:Uri, isInPlaylist:Boolean = false) : ISound
      {
         switch(type)
         {
            case EnumSoundType.LOCALIZED_SOUND:
               switch(uri.fileType.toUpperCase())
               {
                  case "MP3":
                     return new LocalizedSound(_id++,uri,isInPlaylist);
                  default:
                     throw new ArgumentError("Unknown type file " + uri.fileType.toUpperCase());
               }
            case EnumSoundType.UNLOCALIZED_SOUND:
               switch(uri.fileType.toUpperCase())
               {
                  case "MP3":
                     return new UnlocalizedSound(_id++,uri,isInPlaylist);
                  default:
                     throw new ArgumentError("Unknown type file " + uri.fileType.toUpperCase());
               }
            default:
               throw new ArgumentError("Unknown sound type " + type + ".");
         }
      }
   }
}
