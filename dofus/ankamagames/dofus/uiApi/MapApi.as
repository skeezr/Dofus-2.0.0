package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import flash.geom.Point;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.datacenter.world.MapReference;
   
   [InstanciedApi]
   public class MapApi
   {
       
      public function MapApi()
      {
         super();
      }
      
      [Untrusted]
      public function getCurrentSubArea() : SubArea
      {
         return SubArea.getSubAreaById((Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).currentSubAreaId);
      }
      
      [Untrusted]
      public function getAllSuperArea() : Array
      {
         return SuperArea.getAllSuperArea();
      }
      
      [Untrusted]
      public function getAllArea() : Array
      {
         return Area.getAllArea();
      }
      
      [Untrusted]
      public function getAllSubArea() : Array
      {
         return SubArea.getAllSubArea();
      }
      
      [Untrusted]
      public function getSubArea(subAreaId:uint) : SubArea
      {
         return SubArea.getSubAreaById(subAreaId);
      }
      
      [Untrusted]
      public function getSubAreaMapIds(subAreaId:uint) : Vector.<uint>
      {
         return SubArea.getSubAreaById(subAreaId).mapIds;
      }
      
      [Untrusted]
      public function getWorldPoint(mapId:uint) : WorldPoint
      {
         return WorldPoint.fromMapId(mapId);
      }
      
      [Untrusted]
      public function getMapCoords(mapId:uint) : Point
      {
         var mapPosition:MapPosition = MapPosition.getMapPositionById(mapId);
         return new Point(mapPosition.posX,mapPosition.posY);
      }
      
      [Untrusted]
      public function getSubAreaShape(subAreaId:uint) : Vector.<int>
      {
         var subArea:SubArea = SubArea.getSubAreaById(subAreaId);
         if(subArea)
         {
            return subArea.shape;
         }
         return null;
      }
      
      [Untrusted]
      public function getHintIds() : Array
      {
         var hint:Hint = null;
         var h:Object = null;
         var mp:MapPosition = null;
         var hints:Array = Hint.getHints() as Array;
         var res:Array = new Array();
         var i:int = 0;
         for each(hint in hints)
         {
            if(hint)
            {
               i++;
               h = new Object();
               h.id = hint.id;
               h.category = hint.categoryId;
               h.name = hint.name;
               h.mapId = hint.mapId;
               h.gfx = hint.gfx;
               h.subarea = SubArea.getSubAreaByMapId(hint.mapId);
               mp = MapPosition.getMapPositionById(hint.mapId);
               if(!mp)
               {
                  trace("Coordonnée invalideuh");
               }
               else
               {
                  h.x = mp.posX;
                  h.y = mp.posY;
                  h.outdoor = mp.outdoor;
                  res.push(h);
               }
            }
         }
         return res;
      }
      
      [Untrusted]
      public function subAreaByMapId(mapId:uint) : SubArea
      {
         return SubArea.getSubAreaByMapId(mapId);
      }
      
      [Untrusted]
      public function getMapIdByCoord(x:int, y:int) : Array
      {
         return MapPosition.getMapIdByCoord(x,y);
      }
      
      [Untrusted]
      public function getMapPositionById(mapId:uint) : MapPosition
      {
         return MapPosition.getMapPositionById(mapId);
      }
      
      [Untrusted]
      public function intersects(rect1:Object, rect2:Object) : Boolean
      {
         if(!rect1 || !rect2)
         {
            return false;
         }
         var r1:Rectangle = Rectangle(BoxingUnBoxing.unbox(rect1));
         var r2:Rectangle = Rectangle(BoxingUnBoxing.unbox(rect2));
         if(Boolean(r1) && Boolean(r2))
         {
            return r1.intersects(r2);
         }
         return false;
      }
      
      [Trusted]
      public function movePlayer(x:int, y:int) : void
      {
         var aqcmsg:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         aqcmsg.initAdminQuietCommandMessage("move * " + x + "," + y);
         if(PlayerManager.getInstance().hasRights)
         {
            ConnectionsHandler.getConnection().send(aqcmsg);
         }
      }
      
      [Untrusted]
      public function getMapReference(refId:uint) : Object
      {
         return MapReference.getMapReferenceById(refId);
      }
   }
}
