package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.api.SecureComponent;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.components.Texture;
   
   public class MapIconElement extends MapElement
   {
       
      public var texture:SecureComponent;
      
      public var legend:String;
      
      restricted_namespace var _texture:Texture;
      
      public function MapIconElement(id:String, x:int, y:int, layer:String, texture:Texture, legend:String)
      {
         super(id,x,y,layer);
         this.texture = new SecureComponent(texture,false);
         this.legend = legend;
         restricted_namespace::_texture = texture;
         texture.mouseEnabled = true;
      }
      
      override public function remove() : void
      {
         restricted_namespace::_texture.remove();
         if(restricted_namespace::_texture.parent)
         {
            restricted_namespace::_texture.parent.removeChild(restricted_namespace::_texture);
         }
         restricted_namespace::_texture = null;
         this.texture = null;
         super.remove();
      }
   }
}
