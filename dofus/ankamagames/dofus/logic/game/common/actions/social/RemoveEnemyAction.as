package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveEnemyAction implements Action
   {
       
      private var _name:String;
      
      public function RemoveEnemyAction()
      {
         super();
      }
      
      public static function create(name:String) : RemoveEnemyAction
      {
         var a:RemoveEnemyAction = new RemoveEnemyAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
