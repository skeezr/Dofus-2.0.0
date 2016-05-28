package com.ankamagames.tiphon.types.look
{
   public class EntityLookParser
   {
      
      private static const CURRENT_FORMAT_VERSION:uint = 0;
      
      private static const DEFAULT_NUMBER_BASE:uint = 10;
       
      public function EntityLookParser()
      {
         super();
      }
      
      public static function fromString(str:String, pFormatVersion:uint = 0, pNumberBase:uint = 10) : TiphonEntityLook
      {
         var headersStr:String = null;
         var headers:Array = null;
         var skins:Array = null;
         var skin:String = null;
         var colors:Array = null;
         var color:String = null;
         var colorPair:Array = null;
         var colorIndex:uint = 0;
         var colorValue:uint = 0;
         var scales:Array = null;
         var commonScale:Number = NaN;
         var subEntitiesStr:String = null;
         var i:uint = 0;
         var subEntities:Array = null;
         var subEntity:String = null;
         var subEntityHeader:String = null;
         var subEntityBody:String = null;
         var subEntityBinding:Array = null;
         var bindingCategory:uint = 0;
         var bindingIndex:uint = 0;
         var el:TiphonEntityLook = new TiphonEntityLook();
         el.lock();
         var formatVersion:uint = CURRENT_FORMAT_VERSION;
         var numberBase:uint = DEFAULT_NUMBER_BASE;
         if(str.charAt(0) == "[")
         {
            headersStr = str.substring(1,str.indexOf("]"));
            if(headersStr.indexOf(",") > 0)
            {
               headers = headersStr.split(",");
               if(headers.length != 2)
               {
                  throw new Error("Malformated headers in an Entity Look string.");
               }
               formatVersion = uint(headers[0]);
               numberBase = getNumberBase(headers[1]);
            }
            else
            {
               formatVersion = uint(headersStr);
            }
            str = str.substr(str.indexOf("]") + 1);
         }
         if(str.charAt(0) != "{" || str.charAt(str.length - 1) != "}")
         {
            throw new Error("Malformed body in an Entity Look string.");
         }
         str = str.substring(1,str.length - 1);
         var body:Array = str.split("|");
         el.setBone(parseInt(body[0],numberBase));
         if(body.length > 1 && body[1].length > 0)
         {
            skins = body[1].split(",");
            for each(skin in skins)
            {
               el.addSkin(parseInt(skin,numberBase));
            }
         }
         if(body.length > 2 && body[2].length > 0)
         {
            colors = body[2].split(",");
            for each(color in colors)
            {
               colorPair = color.split("=");
               if(colorPair.length != 2)
               {
                  throw new Error("Malformed color in an Entity Look string.");
               }
               colorIndex = parseInt(colorPair[0],numberBase);
               colorValue = 0;
               if(colorPair[1].charAt(0) == "#")
               {
                  colorValue = parseInt(colorPair[1].substr(1),16);
               }
               else
               {
                  colorValue = parseInt(colorPair[1],numberBase);
               }
               el.setColor(colorIndex,colorValue);
            }
         }
         if(body.length > 3 && body[3].length > 0)
         {
            scales = body[3].split(",");
            if(scales.length == 1)
            {
               commonScale = parseInt(scales[0],numberBase) / 100;
               el.setScales(commonScale,commonScale);
            }
            else if(scales.length == 2)
            {
               el.setScales(parseInt(scales[0],numberBase) / 100,parseInt(scales[1],numberBase) / 100);
            }
            else
            {
               throw new Error("Malformed scale in an Entity Look string.");
            }
         }
         else
         {
            el.setScales(1,1);
         }
         if(body.length > 4 && body[4].length > 0)
         {
            subEntitiesStr = "";
            for(i = 4; i < body.length; i++)
            {
               subEntitiesStr = subEntitiesStr + (body[i] + "|");
            }
            subEntitiesStr = subEntitiesStr.substr(0,subEntitiesStr.length - 1);
            subEntities = subEntitiesStr.split(",");
            for each(subEntity in subEntities)
            {
               subEntityHeader = subEntity.substring(0,subEntity.indexOf("="));
               subEntityBody = subEntity.substr(subEntity.indexOf("=") + 1);
               subEntityBinding = subEntityHeader.split("@");
               if(subEntityBinding.length != 2)
               {
                  throw new Error("Malformed subentity binding in an Entity Look string.");
               }
               bindingCategory = parseInt(subEntityBinding[0],numberBase);
               bindingIndex = parseInt(subEntityBinding[1],numberBase);
               el.addSubEntity(bindingCategory,bindingIndex,EntityLookParser.fromString(subEntityBody,formatVersion,numberBase));
            }
         }
         el.unlock(true);
         return el;
      }
      
      public static function toString(el:TiphonEntityLook) : String
      {
         var isFirstSkin:Boolean = false;
         var skin:uint = 0;
         var isFirstColor:Boolean = false;
         var colorIndex:* = null;
         var isFirstSubEntity:Boolean = false;
         var subEntitiesCategory:* = null;
         var subEntityIndex:* = null;
         var subEntityLook:TiphonEntityLook = null;
         var out:* = "{";
         out = out + el.getBone().toString(DEFAULT_NUMBER_BASE);
         out = out + "|";
         var skins:Vector.<uint> = el.getSkins(true);
         if(skins != null)
         {
            isFirstSkin = true;
            for each(skin in skins)
            {
               if(isFirstSkin)
               {
                  isFirstSkin = false;
               }
               else
               {
                  out = out + ",";
               }
               out = out + skin.toString(DEFAULT_NUMBER_BASE);
            }
         }
         out = out + "|";
         var colors:Array = el.getColors(true);
         if(colors != null)
         {
            isFirstColor = true;
            for(colorIndex in colors)
            {
               if(isFirstColor)
               {
                  isFirstColor = false;
               }
               else
               {
                  out = out + ",";
               }
               out = out + (uint(colorIndex).toString(DEFAULT_NUMBER_BASE) + "=" + uint(colors[colorIndex]).toString(DEFAULT_NUMBER_BASE));
            }
         }
         out = out + "|";
         var scaleX:Number = el.getScaleX();
         var scaleY:Number = el.getScaleY();
         if(scaleX != 1 || scaleY != 1)
         {
            out = out + Math.round(scaleX * 100).toString(DEFAULT_NUMBER_BASE);
            if(scaleY != scaleX)
            {
               out = out + ("," + Math.round(scaleY * 100).toString(DEFAULT_NUMBER_BASE));
            }
         }
         out = out + "|";
         var subEntities:Array = el.getSubEntities(true);
         if(subEntities != null)
         {
            isFirstSubEntity = true;
            for(subEntitiesCategory in subEntities)
            {
               for(subEntityIndex in subEntities[subEntitiesCategory])
               {
                  subEntityLook = subEntities[subEntitiesCategory][subEntityIndex];
                  if(isFirstSubEntity)
                  {
                     isFirstSubEntity = false;
                  }
                  else
                  {
                     out = out + ",";
                  }
                  out = out + (uint(subEntitiesCategory).toString(DEFAULT_NUMBER_BASE) + "@" + uint(subEntityIndex).toString(DEFAULT_NUMBER_BASE) + "=" + subEntityLook.toString());
               }
            }
         }
         while(out.charAt(out.length - 1) == "|")
         {
            out = out.substr(0,out.length - 1);
         }
         return out + "}";
      }
      
      private static function getNumberBase(l:String) : uint
      {
         switch(l)
         {
            case "A":
               return 10;
            case "G":
               return 16;
            case "Z":
               return 36;
            default:
               throw new Error("Unknown number base type \'" + l + "\' in an Entity Look string.");
         }
      }
   }
}
