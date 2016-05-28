package com.ankamagames.tubul.types.sounds
{
   import com.ankamagames.tubul.interfaces.IUnlocalizedSound;
   import com.ankamagames.jerakine.types.Uri;
   
   public class UnlocalizedSound extends MP3SoundDofus implements IUnlocalizedSound
   {
       
      public function UnlocalizedSound(id:uint, uri:Uri, isInPlaylist:Boolean = false)
      {
         super(id,uri,isInPlaylist);
      }
   }
}
