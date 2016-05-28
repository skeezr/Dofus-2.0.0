package com.ankamagames.dofus.datacenter.documents
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Document
   {
      
      private static const MODULE:String = "Documents";
      
      private static const PAGEFEED:String = "<pagefeed/>";
       
      public var id:int;
      
      public var typeId:uint;
      
      public var titleId:uint;
      
      public var authorId:uint;
      
      public var subTitleId:uint;
      
      public var contentId:uint;
      
      public function Document()
      {
         super();
      }
      
      public static function create(id:int, typeId:uint, titleId:uint, authorId:uint, subTitleId:uint, contentId:uint) : Document
      {
         var o:Document = new Document();
         o.id = id;
         o.typeId = typeId;
         o.titleId = titleId;
         o.authorId = authorId;
         o.subTitleId = subTitleId;
         o.contentId = contentId;
         return o;
      }
      
      public static function getDocumentById(id:int) : Document
      {
         return GameData.getObject(MODULE,id) as Document;
      }
      
      public static function getDocuments() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get title() : String
      {
         return I18n.getText(this.titleId);
      }
      
      public function get author() : String
      {
         return I18n.getText(this.authorId);
      }
      
      public function get subTitle() : String
      {
         return I18n.getText(this.subTitleId);
      }
      
      public function get content() : String
      {
         return I18n.getText(this.contentId);
      }
      
      public function get pages() : Array
      {
         var temp:Array = this.content.split(PAGEFEED);
         return temp;
      }
   }
}
