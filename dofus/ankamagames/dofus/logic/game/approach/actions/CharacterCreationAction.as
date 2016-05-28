package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterCreationAction implements Action
   {
       
      private var _name:String;
      
      private var _breed:uint;
      
      private var _sex:Boolean;
      
      private var _colors:Array;
      
      public function CharacterCreationAction()
      {
         super();
      }
      
      public static function create(name:String, breed:uint, sex:Boolean, colors:Array) : CharacterCreationAction
      {
         var a:CharacterCreationAction = new CharacterCreationAction();
         a._name = name;
         a._breed = breed;
         a._sex = sex;
         a._colors = colors;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get breed() : uint
      {
         return this._breed;
      }
      
      public function get sex() : Boolean
      {
         return this._sex;
      }
      
      public function get colors() : Array
      {
         return this._colors;
      }
   }
}
