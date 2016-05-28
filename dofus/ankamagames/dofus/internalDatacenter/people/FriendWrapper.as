package com.ankamagames.dofus.internalDatacenter.people
{
   import com.ankamagames.dofus.network.types.game.friend.FriendInformations;
   import com.ankamagames.dofus.network.types.game.friend.FriendOnlineInformations;
   
   public class FriendWrapper
   {
       
      private var _item:FriendInformations;
      
      public var name:String;
      
      public var state:int;
      
      public var lastConnection:uint;
      
      public var online:Boolean = false;
      
      public var type:String = "Friend";
      
      public var playerName:String = "";
      
      public var level:int = 0;
      
      public var alignmentSide:int = 0;
      
      public var breed:uint = 0;
      
      public var sex:uint = 2;
      
      public var guildName:String = "";
      
      public function FriendWrapper(o:FriendInformations)
      {
         super();
         this._item = o;
         this.name = o.name;
         this.state = o.playerState;
         this.lastConnection = o.lastConnection;
         if(o is FriendOnlineInformations)
         {
            this.playerName = FriendOnlineInformations(o).playerName;
            this.level = FriendOnlineInformations(o).level;
            this.alignmentSide = FriendOnlineInformations(o).alignmentSide;
            this.breed = FriendOnlineInformations(o).breed;
            this.sex = !!FriendOnlineInformations(o).sex?uint(1):uint(0);
            this.guildName = FriendOnlineInformations(o).guildName;
            this.online = true;
         }
      }
   }
}
