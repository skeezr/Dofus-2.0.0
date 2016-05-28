package com.ankamagames.dofus.misc
{
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.look.SubEntity;
   
   public class EntityLookAdapter
   {
       
      public function EntityLookAdapter()
      {
         super();
      }
      
      public static function fromNetwork(n:EntityLook) : TiphonEntityLook
      {
         var skin:uint = 0;
         var i:uint = 0;
         var se:SubEntity = null;
         var index:uint = 0;
         var color:uint = 0;
         var o:TiphonEntityLook = new TiphonEntityLook();
         o.lock();
         o.setBone(n.bonesId);
         for each(skin in n.skins)
         {
            o.addSkin(skin);
         }
         for(i = 0; i < n.indexedColors.length; i++)
         {
            index = n.indexedColors[i] >> 24 & 255;
            color = n.indexedColors[i] & 16777215;
            o.setColor(index,color);
         }
         if(n.scales.length == 1)
         {
            o.setScales(n.scales[0] / 100,n.scales[0] / 100);
         }
         else if(n.scales.length == 2)
         {
            o.setScales(n.scales[0] / 100,n.scales[1] / 100);
         }
         for each(se in n.subentities)
         {
            o.addSubEntity(se.bindingPointCategory,se.bindingPointIndex,EntityLookAdapter.fromNetwork(se.subEntityLook));
         }
         o.unlock(true);
         return o;
      }
      
      public static function toNetwork(o:TiphonEntityLook) : EntityLook
      {
         var colorIndexStr:* = null;
         var subEntities:Array = null;
         var catStr:* = null;
         var colorIndex:uint = 0;
         var color:uint = 0;
         var indexedColor:uint = 0;
         var cat:uint = 0;
         var indStr:* = null;
         var ind:uint = 0;
         var se:SubEntity = null;
         var n:EntityLook = new EntityLook();
         n.bonesId = o.getBone();
         n.skins = o.getSkins(true);
         var colors:Array = o.getColors(true);
         for(colorIndexStr in colors)
         {
            colorIndex = parseInt(colorIndexStr);
            color = colors[colorIndexStr];
            indexedColor = (colorIndex & 255) << 24 | color & 16777215;
            n.indexedColors.push(indexedColor);
         }
         n.scales.push(uint(o.getScaleX() * 100));
         n.scales.push(uint(o.getScaleY() * 100));
         subEntities = o.getSubEntities(true);
         for(catStr in subEntities)
         {
            cat = parseInt(catStr);
            for(indStr in subEntities[catStr])
            {
               ind = parseInt(indStr);
               se = new SubEntity();
               se.initSubEntity(cat,ind,EntityLookAdapter.toNetwork(subEntities[catStr][indStr]));
               n.subentities.push(se);
            }
         }
         return n;
      }
   }
}
