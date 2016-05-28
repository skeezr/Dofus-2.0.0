package com.ankamagames.dofus.datacenter.communication
{
   public class SmileyItem
   {
       
      public var smileyId:int = 0;
      
      public var iconId:int = 0;
      
      public function SmileyItem(id:int = 0, icon:int = 0)
      {
         super();
         this.smileyId = id;
         this.iconId = icon;
      }
      
      public function initSmileyItem(id:int = 0, icon:int = 0) : SmileyItem
      {
         this.smileyId = id;
         this.iconId = icon;
         return this;
      }
   }
}
