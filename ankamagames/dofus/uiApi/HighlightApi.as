package com.ankamagames.dofus.uiApi
{
   import flash.utils.Timer;
   import flash.events.Event;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import flash.events.TimerEvent;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   
   [InstanciedApi]
   public class HighlightApi
   {
      
      private static var _showCellTimer:Timer;
      
      private static var _cellIds:Array;
      
      private static var _currentCell:int;
       
      public function HighlightApi()
      {
         super();
      }
      
      private static function onCellTimer(e:Event) : void
      {
         HyperlinkShowCellManager.showCell(_cellIds[_currentCell]);
         _currentCell++;
         if(_currentCell >= _cellIds.length)
         {
            _currentCell = 0;
         }
      }
      
      [Untrusted]
      public function highlightUi(uiName:String, componentName:String, pos:int = 0, reverse:int = 0, strata:int = 5, loop:Boolean = false) : void
      {
         HyperlinkDisplayArrowManager.showArrow(uiName,componentName,pos,reverse,strata,!!loop?1:0);
      }
      
      [Untrusted]
      public function highlightCell(cellIds:Array, loop:Boolean = false) : void
      {
         if(loop)
         {
            if(!_showCellTimer)
            {
               _showCellTimer = new Timer(2000);
               _showCellTimer.addEventListener(TimerEvent.TIMER,onCellTimer);
            }
            _cellIds = cellIds;
            _showCellTimer.reset();
            _showCellTimer.start();
         }
         else if(_showCellTimer)
         {
            _showCellTimer.reset();
         }
         HyperlinkShowCellManager.showCell(cellIds);
      }
      
      [Untrusted]
      public function highlightAbsolute(x:uint, y:uint, pos:uint, reverse:int = 0, strata:int = 5, loop:Boolean = false) : void
      {
         HyperlinkDisplayArrowManager.showAbsoluteArrow(x,y,pos,reverse,strata,!!loop?1:0);
      }
      
      [Untrusted]
      public function highlightNpc(npcId:int, loop:Boolean = false) : void
      {
         HyperlinkShowNpcManager.showNpc(npcId,!!loop?1:0);
      }
      
      [Untrusted]
      public function highlightMonster(monsterId:int, loop:Boolean = false) : void
      {
         HyperlinkShowMonsterManager.showMonster(monsterId,!!loop?1:0);
      }
      
      [Untrusted]
      public function stop() : void
      {
         HyperlinkDisplayArrowManager.destoyArrow();
         if(_showCellTimer)
         {
            _showCellTimer.reset();
         }
      }
   }
}
