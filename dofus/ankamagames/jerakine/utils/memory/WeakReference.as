package com.ankamagames.jerakine.utils.memory
{
   import flash.utils.Dictionary;
   
   public class WeakReference
   {
       
      private var dictionary:Dictionary;
      
      public function WeakReference(p_object:Object)
      {
         super();
         this.dictionary = new Dictionary(true);
         this.dictionary[p_object] = null;
      }
      
      public function get object() : Object
      {
         var n:* = null;
         for(n in this.dictionary)
         {
            return n;
         }
         return null;
      }
   }
}
