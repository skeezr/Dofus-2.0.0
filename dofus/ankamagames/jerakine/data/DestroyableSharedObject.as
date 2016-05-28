package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import flash.net.SharedObject;
   
   public class DestroyableSharedObject implements IDestroyable
   {
       
      private var _so:SharedObject;
      
      public var data;
      
      public function DestroyableSharedObject(so:SharedObject)
      {
         super();
         this._so = so;
         this.data = this._so.data;
      }
      
      public static function getLocal(name:String) : DestroyableSharedObject
      {
         return new DestroyableSharedObject(SharedObject.getLocal(name));
      }
      
      public function destroy() : void
      {
         this._so.close();
         this._so = null;
      }
   }
}
