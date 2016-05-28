package com.ankamagames.atouin.data.elements.subtypes
{
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.AtouinConstants;
   
   public class EntityGraphicalElementData extends GraphicalElementData
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EntityGraphicalElementData));
       
      public var entityLook:String;
      
      public var horizontalSymmetry:Boolean;
      
      public function EntityGraphicalElementData(elementId:int, elementType:int)
      {
         super(elementId,elementType);
      }
      
      override public function fromRaw(raw:IDataInput) : void
      {
         var entityLookLength:uint = raw.readInt();
         this.entityLook = raw.readUTFBytes(entityLookLength);
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (EntityGraphicalElementData) Entity look : " + this.entityLook);
         }
         this.horizontalSymmetry = raw.readBoolean();
         if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
         {
            _log.debug("  (EntityGraphicalElementData) Element horizontals symmetry : " + this.horizontalSymmetry);
         }
      }
   }
}
