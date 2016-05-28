package com.ankamagames.atouin.entities.behaviours.movements
{
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class FantomMovementBehavior extends AnimatedMovementBehavior
   {
      
      private static const WALK_LINEAR_VELOCITY:Number = 1 / 680;
      
      private static const WALK_HORIZONTAL_DIAGONAL_VELOCITY:Number = 1 / 1020;
      
      private static const WALK_VERTICAL_DIAGONAL_VELOCITY:Number = 1 / 850;
      
      private static const WALK_ANIMATION:String = "AnimMarche";
      
      private static var _self:com.ankamagames.atouin.entities.behaviours.movements.FantomMovementBehavior;
       
      public function FantomMovementBehavior()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : FantomMovementBehavior is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : com.ankamagames.atouin.entities.behaviours.movements.FantomMovementBehavior
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.entities.behaviours.movements.FantomMovementBehavior();
         }
         return _self;
      }
      
      override protected function getLinearVelocity() : Number
      {
         return WALK_LINEAR_VELOCITY;
      }
      
      override protected function getHorizontalDiagonalVelocity() : Number
      {
         return WALK_HORIZONTAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getVerticalDiagonalVelocity() : Number
      {
         return WALK_VERTICAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getAnimation() : String
      {
         return WALK_ANIMATION;
      }
   }
}
