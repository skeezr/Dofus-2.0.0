package com.ankamagames.atouin.data.elements.subtypes
{
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.AtouinConstants;
   
   public class NormalGraphicalElementData extends GraphicalElementData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(NormalGraphicalElementData));
       
      public var gfxId:int;
      
      public var height:uint;
      
      public var horizontalSymmetry:Boolean;
      
      public var origin:Point;
      
      public var size:Point;
      
      public function NormalGraphicalElementData(elementId:int, elementType:int)
      {
         super(elementId,elementType);
      }
      
      override public function fromRaw(raw:IDataInput) : void
      {
         this.gfxId = raw.readInt();
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (ElementData) Element gfx id : " + this.gfxId);
         }
         this.height = raw.readByte();
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (ElementData) Element height : " + this.height);
         }
         this.horizontalSymmetry = raw.readBoolean();
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (ElementData) Element horizontals symmetry : " + this.horizontalSymmetry);
         }
         this.origin = new Point(raw.readShort(),raw.readShort());
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (ElementData) Origin : (" + this.origin.x + ";" + this.origin.y + ")");
         }
         this.size = new Point(raw.readShort(),raw.readShort());
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (ElementData) Size : (" + this.size.x + ";" + this.size.y + ")");
         }
      }
   }
}
