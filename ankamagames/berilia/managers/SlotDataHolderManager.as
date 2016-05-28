package com.ankamagames.berilia.managers
{
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   
   public class SlotDataHolderManager
   {
       
      private var _weakHolderReference:Dictionary;
      
      private var _linkedSlotData:ISlotData;
      
      public function SlotDataHolderManager(linkedSlotData:ISlotData)
      {
         this._weakHolderReference = new Dictionary(true);
         super();
         this._linkedSlotData = linkedSlotData;
      }
      
      public function addHolder(h:ISlotDataHolder) : void
      {
         this._weakHolderReference[h] = true;
      }
      
      public function removeHolder(h:ISlotDataHolder) : void
      {
         delete this._weakHolderReference[h];
      }
      
      public function getHolders() : Array
      {
         var h:* = null;
         var result:Array = [];
         for(h in this._weakHolderReference)
         {
            if(h == "null")
            {
               delete this._weakHolderReference[h];
            }
            else
            {
               result.push(h);
            }
         }
         return result;
      }
      
      public function refreshAll() : void
      {
         var h:* = null;
         for(h in this._weakHolderReference)
         {
            if(h == "null")
            {
               delete this._weakHolderReference[h];
            }
            else if(Boolean(h) && ISlotDataHolder(h).data === this._linkedSlotData)
            {
               h.refresh();
            }
            else
            {
               delete this._weakHolderReference[h];
            }
         }
      }
   }
}
