package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   
   public class HyperlinkShowPlayerMenuManager
   {
       
      public function HyperlinkShowPlayerMenuManager()
      {
         super();
      }
      
      public static function showPlayerMenu(playerName:String, playerId:int = 0, timestamp:Number = 0, fingerprint:String = null) : void
      {
         var playerInfo:GameRolePlayCharacterInformations = null;
         var _commonMod:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         var roleplayEntitiesFrame:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(Boolean(roleplayEntitiesFrame) && Boolean(playerId))
         {
            playerInfo = roleplayEntitiesFrame.getEntityInfos(playerId) as GameRolePlayCharacterInformations;
            if(!playerInfo)
            {
               playerInfo = new GameRolePlayCharacterInformations();
               playerInfo.contextualId = playerId;
               playerInfo.name = playerName;
            }
            _commonMod.createContextMenu(MenusFactory.create(playerInfo,null,[{
               "id":playerId,
               "fingerprint":fingerprint,
               "timestamp":timestamp
            }]));
         }
         else if(PlayedCharacterManager.getInstance().infos.name != playerName)
         {
            _commonMod.createContextMenu(MenusFactory.create(playerName));
         }
      }
      
      public static function getPlayerName(playerName:String, playerId:int = 0, timestamp:Number = 0, fingerprint:String = null) : String
      {
         return playerName;
      }
   }
}
