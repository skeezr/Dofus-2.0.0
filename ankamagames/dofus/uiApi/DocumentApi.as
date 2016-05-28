package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.documents.Document;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class DocumentApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function DocumentApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DocumentApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getDocument(pDocId:uint) : Object
      {
         return Document.getDocumentById(pDocId);
      }
      
      [Untrusted]
      public function getType(pDocId:uint) : Object
      {
         return Document.getDocumentById(pDocId).typeId;
      }
   }
}
