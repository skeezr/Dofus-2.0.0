package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class BidHouseStringSearchAction implements Action
   {
       
      private var _searchString:String;
      
      public function BidHouseStringSearchAction()
      {
         super();
      }
      
      public static function create(pSearchString:String) : BidHouseStringSearchAction
      {
         var a:BidHouseStringSearchAction = new BidHouseStringSearchAction();
         a._searchString = pSearchString;
         return a;
      }
      
      public function get searchString() : String
      {
         return this._searchString;
      }
   }
}
