package com.ankamagames.jerakine.utils.parser
{
   import com.ankamagames.jerakine.types.SoundEventParamWrapper;
   
   public class FLAEventLabelParser
   {
      
      private static var BALISE_PARAM_DELIMITER:String = ";";
      
      private static var BALISE_PARAM_ASSIGN:String = "=";
      
      private static var BALISE_PARAM_NEXT_PARAM:String = ",";
      
      private static var PARAM_ID:String = "id";
      
      private static var PARAM_VOLUME:String = "vol";
      
      private static var PARAM_ROLLOFF:String = "rollOff";
      
      private static var PARAM_BERCEAU_DUREE:String = "berceauDuree";
      
      private static var PARAM_BERCEAU_VOL:String = "berceauVol";
      
      private static var PARAM_BERCEAU_FADE_IN:String = "berceauFadeIn";
      
      private static var PARAM_BERCEAU_FADE_OUT:String = "berceauFadeOut";
      
      private static var PARAM_NO_CUT_SILENCE:String = "noCutSilence";
       
      public function FLAEventLabelParser()
      {
         super();
      }
      
      public static function parseSoundLabel(pParams:String) : Array
      {
         var rollOff:uint = 0;
         var berceauDuree:uint = 0;
         var berceauVol:uint = 0;
         var berceauFadeIn:uint = 0;
         var berceauFadeOut:uint = 0;
         var paramName:String = null;
         var r:RegExp = null;
         var temp:String = null;
         var valueParams:Array = null;
         var id:String = null;
         var vol:uint = 0;
         var sepw:SoundEventParamWrapper = null;
         var returnSEPW:Array = new Array();
         var params:Array = pParams.split(BALISE_PARAM_DELIMITER);
         var tabLength:uint = params.length;
         var aIds:Vector.<String> = new Vector.<String>();
         var aVols:Vector.<uint> = new Vector.<uint>();
         var noCutSilence:Boolean = false;
         for(var i:uint = 0; i < tabLength; i++)
         {
            paramName = params[i].split(BALISE_PARAM_ASSIGN)[0];
            r = /^\s*(.*?)\s*$/g;
            paramName = paramName.replace(r,"$1");
            temp = params[i].split(BALISE_PARAM_ASSIGN)[1];
            valueParams = temp.split(BALISE_PARAM_NEXT_PARAM);
            switch(paramName.toUpperCase())
            {
               case PARAM_ID.toUpperCase():
                  for each(id in valueParams)
                  {
                     id = id.replace(r,"$1");
                     aIds.push(id);
                  }
                  break;
               case PARAM_VOLUME.toUpperCase():
                  for each(vol in valueParams)
                  {
                     aVols.push(vol);
                  }
                  break;
               case PARAM_ROLLOFF.toUpperCase():
                  rollOff = valueParams[0];
                  break;
               case PARAM_BERCEAU_DUREE.toUpperCase():
                  berceauDuree = valueParams[0];
                  break;
               case PARAM_BERCEAU_VOL.toUpperCase():
                  berceauVol = valueParams[0];
                  break;
               case PARAM_BERCEAU_FADE_IN.toUpperCase():
                  berceauFadeIn = valueParams[0];
                  break;
               case PARAM_BERCEAU_FADE_OUT.toUpperCase():
                  berceauFadeOut = valueParams[0];
                  break;
               case PARAM_NO_CUT_SILENCE.toUpperCase():
                  noCutSilence = valueParams[0];
            }
         }
         var size:uint = aIds.length;
         if(aIds.length != aVols.length)
         {
            throw new Error("The number of sound id and volume are differents");
         }
         for(var compt:uint = 0; compt < size; compt++)
         {
            sepw = new SoundEventParamWrapper();
            sepw.id = aIds[compt];
            sepw.volume = aVols[compt];
            sepw.rollOff = rollOff;
            sepw.berceauDuree = berceauDuree;
            sepw.berceauVol = berceauVol;
            sepw.berceauFadeIn = berceauFadeIn;
            sepw.berceauFadeOut = berceauFadeOut;
            sepw.noCutSilence = noCutSilence;
            returnSEPW.push(sepw);
         }
         return returnSEPW;
      }
   }
}
