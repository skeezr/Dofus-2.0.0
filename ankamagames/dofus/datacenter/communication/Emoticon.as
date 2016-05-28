package com.ankamagames.dofus.datacenter.communication
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   
   public class Emoticon
   {
      
      private static const MODULE:String = "Emoticons";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Emoticon));
       
      public var id:uint;
      
      public var nameId:uint;
      
      public var shortcut:String;
      
      public var instant:Boolean;
      
      public var eight_directions:Boolean;
      
      public var aura:Boolean;
      
      public var anims:Object;
      
      public function Emoticon()
      {
         super();
      }
      
      public static function create(id:uint, nameId:uint, shortcut:String, instant:Boolean, eight_directions:Boolean, aura:Boolean, anims:Object) : Emoticon
      {
         var e:Emoticon = new Emoticon();
         e.id = id;
         e.nameId = nameId;
         e.shortcut = shortcut;
         e.instant = instant;
         e.eight_directions = eight_directions;
         e.aura = aura;
         e.anims = anims;
         return e;
      }
      
      public static function getEmoticonById(id:int) : Emoticon
      {
         return GameData.getObject(MODULE,id) as Emoticon;
      }
      
      public static function getEmoticons() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function getAnimName(look:EntityLook) : String
      {
         var animName:* = null;
         var anim:* = undefined;
         var matchingSkin:uint = 0;
         var skin:* = undefined;
         var lookSkin:* = undefined;
         for each(anim in this.anims)
         {
            if(anim.bone == look.bonesId)
            {
               matchingSkin = 0;
               for each(skin in anim.skins)
               {
                  for each(lookSkin in look.skins)
                  {
                     if(skin == lookSkin)
                     {
                        matchingSkin++;
                     }
                  }
               }
               if(matchingSkin == anim.skins.length)
               {
                  animName = "AnimEmote" + anim.anim;
               }
            }
         }
         if(!animName)
         {
            animName = "AnimEmote" + this.shortcut.charAt(0).toUpperCase() + this.shortcut.substr(1).toLowerCase() + "_0";
         }
         return animName;
      }
   }
}
