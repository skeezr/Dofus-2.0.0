package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenMapAction implements Action
   {
       
      private var _name:String;
      
      public function OpenMapAction()
      {
         super();
      }
      
      public static function create() : OpenMapAction
      {
         return new OpenMapAction();
      }
      
      public function get value() : String
      {
         return this._name;
      }
   }
}
