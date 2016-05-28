package com.ankamagames.dofus.internalDatacenter.people
{
   import com.ankamagames.dofus.network.types.game.friend.FriendSpouseInformations;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.types.game.friend.FriendSpouseOnlineInformations;
   
   public class SpouseWrapper
   {
       
      private var _item:FriendSpouseInformations;
      
      public var name:String;
      
      public var id:uint;
      
      public var entityLook:TiphonEntityLook;
      
      public var level:int;
      
      public var breed:uint;
      
      public var sex:int;
      
      public var online:Boolean = false;
      
      public var mapId:uint;
      
      public var subareaId:uint;
      
      public var inFight:Boolean;
      
      public var followSpouse:Boolean;
      
      public var guildName:String;
      
      public var alignmentSide:int;
      
      public var pvpEnabled:Boolean;
      
      public function SpouseWrapper(o:FriendSpouseInformations)
      {
         super();
         this._item = o;
         this.name = o.spouseName;
         this.id = o.spouseId;
         this.entityLook = EntityLookAdapter.fromNetwork(o.spouseEntityLook);
         this.level = o.spouseLevel;
         this.breed = o.breed;
         this.sex = o.sex;
         if(o is FriendSpouseOnlineInformations)
         {
            this.mapId = FriendSpouseOnlineInformations(o).mapId;
            this.subareaId = FriendSpouseOnlineInformations(o).subAreaId;
            this.inFight = FriendSpouseOnlineInformations(o).inFight;
            this.followSpouse = FriendSpouseOnlineInformations(o).followSpouse;
            this.guildName = FriendSpouseOnlineInformations(o).guildName;
            this.alignmentSide = FriendSpouseOnlineInformations(o).alignmentSide;
            this.pvpEnabled = FriendSpouseOnlineInformations(o).pvpEnabled;
            this.online = true;
         }
      }
   }
}
