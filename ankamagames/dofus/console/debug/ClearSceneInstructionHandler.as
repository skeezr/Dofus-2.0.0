package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import flash.display.DisplayObjectContainer;
   
   public class ClearSceneInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function ClearSceneInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var scene:DisplayObjectContainer = null;
         switch(cmd)
         {
            case "clearscene":
               if(args.length > 0)
               {
                  console.output("No arguments needed.");
               }
               scene = Dofus.getInstance().getWorldContainer();
               while(scene.numChildren > 0)
               {
                  scene.removeChildAt(0);
               }
               console.output("Scene cleared.");
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "clearscene":
               return "Clear the World Scene.";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
