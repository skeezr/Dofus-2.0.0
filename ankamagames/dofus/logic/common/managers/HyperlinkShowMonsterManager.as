package com.ankamagames.dofus.logic.common.managers
{
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   
   public class HyperlinkShowMonsterManager
   {
       
      public function HyperlinkShowMonsterManager()
      {
         super();
      }
      
      public static function showMonster(monsterId:int, loop:int = 0) : Sprite
      {
         var monsterClip:DisplayObject = null;
         var rect:Rectangle = null;
         var list:Dictionary = null;
         var monster:Object = null;
         var abstractEntitiesFrame:AbstractEntitiesFrame = Kernel.getWorker().getFrame(AbstractEntitiesFrame) as AbstractEntitiesFrame;
         if(abstractEntitiesFrame)
         {
            list = abstractEntitiesFrame.getEntitiesDictionnary();
            for each(monster in list)
            {
               if(monster is GameRolePlayGroupMonsterInformations && monster.mainCreatureGenericId == monsterId)
               {
                  monsterClip = DofusEntities.getEntity(GameRolePlayGroupMonsterInformations(monster).contextualId) as DisplayObject;
                  if(Boolean(monsterClip) && Boolean(monsterClip.stage))
                  {
                     rect = monsterClip.getRect(Berilia.getInstance().docMain);
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(rect.x,rect.y,0,0,1,loop);
                  }
                  return null;
               }
               if(monster is GameFightMonsterInformations && monster.creatureGenericId == monsterId)
               {
                  monsterClip = DofusEntities.getEntity(GameFightMonsterInformations(monster).contextualId) as DisplayObject;
                  if(Boolean(monsterClip) && Boolean(monsterClip.stage))
                  {
                     rect = monsterClip.getRect(Berilia.getInstance().docMain);
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(rect.x,rect.y,0,0,1,loop);
                  }
                  return null;
               }
            }
         }
         return null;
      }
   }
}
