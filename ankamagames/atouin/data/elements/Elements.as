package com.ankamagames.atouin.data.elements
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import com.ankamagames.atouin.data.DataFormatError;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class Elements
   {
      
      private static var _self:com.ankamagames.atouin.data.elements.Elements;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.data.elements.Elements));
       
      public var fileVersion:uint;
      
      public var elementsCount:uint;
      
      private var _parsed:Boolean;
      
      private var _failed:Boolean;
      
      private var _elementsMap:Dictionary;
      
      public function Elements()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.atouin.data.elements.Elements
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.data.elements.Elements();
         }
         return _self;
      }
      
      public function get parsed() : Boolean
      {
         return this._parsed;
      }
      
      public function get failed() : Boolean
      {
         return this._failed;
      }
      
      public function getElementData(elementId:int) : GraphicalElementData
      {
         return GraphicalElementData(this._elementsMap[elementId]);
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         var header:int = 0;
         var i:int = 0;
         var edId:int = 0;
         var edType:int = 0;
         var ed:GraphicalElementData = null;
         try
         {
            header = raw.readByte();
            if(header != 69)
            {
               throw new DataFormatError("Unknown file format");
            }
            this.fileVersion = raw.readByte();
            if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
            {
               _log.debug("File version : " + this.fileVersion);
            }
            this.elementsCount = raw.readUnsignedInt();
            if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
            {
               _log.debug("Elements count : " + this.elementsCount);
            }
            this._elementsMap = new Dictionary();
            for(i = 0; i < this.elementsCount; i++)
            {
               edId = raw.readInt();
               edType = raw.readByte();
               ed = GraphicalElementFactory.getGraphicalElementData(edId,edType);
               if(AtouinConstants.DEBUG_FILES_PARSING_ELEMENTS)
               {
                  _log.debug("Element data at index " + i + " :");
               }
               ed.fromRaw(raw);
               this._elementsMap[edId] = ed;
            }
            this._parsed = true;
         }
         catch(e:*)
         {
            _failed = true;
            throw e;
         }
      }
   }
}
