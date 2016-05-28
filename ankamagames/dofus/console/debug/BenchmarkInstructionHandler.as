package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.dofus.types.entities.BenchmarkCharacter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.misc.BenchmarkMovementBehavior;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class BenchmarkInstructionHandler implements ConsoleInstructionHandler
   {
      
      private static var id:uint = 50000;
       
      protected var _log:Logger;
      
      public function BenchmarkInstructionHandler()
      {
         this._log = Log.getLogger(getQualifiedClassName(BenchmarkInstructionHandler));
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var animEntity:IAnimated = null;
         var dirEntity:IAnimated = null;
         var rpCharEntity:BenchmarkCharacter = null;
         switch(cmd)
         {
            case "addmovingcharacter":
               if(args.length > 0)
               {
                  rpCharEntity = new BenchmarkCharacter(id++,TiphonEntityLook.fromString(args[0]));
                  rpCharEntity.position = MapPoint.fromCellId(int(Math.random() * 300));
                  rpCharEntity.display();
                  rpCharEntity.move(BenchmarkMovementBehavior.getRandomPath(rpCharEntity));
               }
               break;
            case "setanimation":
               animEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               animEntity.setAnimation(args[0]);
               break;
            case "setdirection":
               dirEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
               dirEntity.setDirection(args[0]);
               break;
            case "showfps":
               if(StageShareManager.stage.contains(FPS.getInstance()))
               {
                  FPS.getInstance().destroy();
                  StageShareManager.stage.removeChild(FPS.getInstance());
               }
               else
               {
                  StageShareManager.stage.addChild(FPS.getInstance());
                  FPS.getInstance().init();
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "addmovingcharacter":
               return "Add a new mobile character on scene.";
            case "showfps":
               return "Displays the performance of the client.";
            default:
               return "Unknow command";
         }
      }
   }
}
