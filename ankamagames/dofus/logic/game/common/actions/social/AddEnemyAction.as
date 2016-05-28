package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddEnemyAction implements Action
   {
       
      private var _name:String;
      
      public function AddEnemyAction()
      {
         super();
      }
      
      public static function create(name:String) : AddEnemyAction
      {
         var a:AddEnemyAction = new AddEnemyAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
