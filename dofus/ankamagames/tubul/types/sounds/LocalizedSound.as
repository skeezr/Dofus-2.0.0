package com.ankamagames.tubul.types.sounds
{
   import com.ankamagames.tubul.interfaces.ILocalizedSound;
   import flash.geom.Point;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.Tubul;
   
   public class LocalizedSound extends MP3SoundDofus implements ILocalizedSound
   {
       
      private var _pan:Number;
      
      private var _position:Point;
      
      private var _range:Number;
      
      private var _saturationRange:Number;
      
      private var _observerPosition:Point;
      
      private var _volumeMax:Number;
      
      public function LocalizedSound(id:uint, uri:Uri, isInPlaylist:Boolean = false)
      {
         super(id,uri,isInPlaylist);
         this._pan = 0;
         this.updateObserverPosition(Tubul.getInstance().earPosition);
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(pan:Number) : void
      {
         if(pan < -1)
         {
            this._pan = -1;
            return;
         }
         if(pan > 1)
         {
            this._pan = 1;
            return;
         }
         this._pan = pan;
      }
      
      public function get range() : Number
      {
         return this._range;
      }
      
      public function set range(range:Number) : void
      {
         if(range < this._saturationRange)
         {
            range = this._saturationRange;
         }
         this._range = range;
      }
      
      public function get saturationRange() : Number
      {
         return this._saturationRange;
      }
      
      public function set saturationRange(saturationRange:Number) : void
      {
         if(saturationRange >= this._range)
         {
            saturationRange = this._range;
         }
         this._saturationRange = saturationRange;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function set position(position:Point) : void
      {
         this._position = position;
         if(this._observerPosition)
         {
            this.updateSound();
         }
      }
      
      public function get volumeMax() : Number
      {
         return this._volumeMax;
      }
      
      public function set volumeMax(pVolumeMax:Number) : void
      {
         if(pVolumeMax > 1)
         {
            pVolumeMax = 1;
         }
         if(pVolumeMax < 0)
         {
            pVolumeMax = 0;
         }
         this._volumeMax = pVolumeMax;
      }
      
      public function updateObserverPosition(point:Point) : void
      {
         this._observerPosition = point;
         if(this.position)
         {
            this.updateSound();
         }
      }
      
      override protected function applyParam() : void
      {
         _soundTransform = _soundChannel.soundTransform;
         _soundTransform.volume = effectiveVolume;
         _soundTransform.pan = this._pan;
         _soundChannel.soundTransform = _soundTransform;
      }
      
      private function updateSound() : void
      {
         var _newPositionY:Number = NaN;
         var difference:Number = NaN;
         var dist_diff:Number = NaN;
         var newVolume:Number = NaN;
         _newPositionY = this._position.y + (this._position.y - this._observerPosition.y) * 2;
         var distx:Number = Math.abs(this._observerPosition.x - this._position.x);
         var disty:Number = Math.abs(this._observerPosition.y - _newPositionY);
         var dist1Square:Number = distx * distx;
         var dist2Square:Number = disty * disty;
         var distRangeSquare:Number = this._range * this._range;
         var distSaturationRangeSquare:Number = this._saturationRange * this._saturationRange;
         if(distSaturationRangeSquare >= dist1Square + dist2Square)
         {
            volume = this.volumeMax;
         }
         else if(distRangeSquare >= dist1Square + dist2Square)
         {
            difference = this._range - this._saturationRange;
            dist_diff = Math.sqrt(dist1Square + dist2Square) - this._saturationRange;
            newVolume = (difference - dist_diff) / difference * this.volumeMax;
            volume = newVolume;
         }
         else
         {
            volume = 0;
         }
         var posXMapCenter:Number = 640;
         this.pan = this._position.x / posXMapCenter - 1;
         if(_soundLoaded)
         {
            this.applyParam();
         }
      }
   }
}
