package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public class TiphonInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function TiphonInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         switch(cmd)
         {
            case "additem":
               if(args.length != 0)
               {
                  console.output("need 1 parameter (item ID)");
               }
               (DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as TiphonSprite).look.addSkin(parseInt(args[0]));
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         return null;
      }
   }
}
