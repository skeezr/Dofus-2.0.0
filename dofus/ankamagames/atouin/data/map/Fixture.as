package com.ankamagames.atouin.data.map
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.geom.Point;
   import flash.utils.IDataInput;
   
   public class Fixture
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Fixture));
       
      public var fixtureId:int;
      
      public var offset:Point;
      
      public var hue:int;
      
      public var redMultiplier:int;
      
      public var greenMultiplier:int;
      
      public var blueMultiplier:int;
      
      public var alpha:uint;
      
      public var xScale:int;
      
      public var yScale:int;
      
      public var rotation:int;
      
      private var _map:com.ankamagames.atouin.data.map.Map;
      
      public function Fixture(map:com.ankamagames.atouin.data.map.Map)
      {
         super();
         this._map = map;
      }
      
      public function get map() : com.ankamagames.atouin.data.map.Map
      {
         return this._map;
      }
      
      public function fromRaw(raw:IDataInput) : void
      {
         try
         {
            this.fixtureId = raw.readInt();
            _log.debug("  (Fixture) Id : " + this.fixtureId);
            this.offset = new Point();
            this.offset.x = raw.readShort();
            this.offset.y = raw.readShort();
            _log.debug("  (Fixture) Offset : (" + this.offset.x + ";" + this.offset.y + ")");
            this.rotation = raw.readShort();
            _log.debug("  (Fixture) Rotation : " + this.rotation);
            this.xScale = raw.readShort();
            _log.debug("  (Fixture) Scale X : " + this.xScale);
            this.yScale = raw.readShort();
            _log.debug("  (Fixture) Scale Y : " + this.yScale);
            this.redMultiplier = raw.readByte();
            this.greenMultiplier = raw.readByte();
            this.blueMultiplier = raw.readByte();
            this.hue = this.redMultiplier | this.greenMultiplier | this.blueMultiplier;
            _log.debug("  (Fixture) Hue : 0x" + this.hue.toString(16));
            this.alpha = raw.readUnsignedByte();
            _log.debug("  (Fixture) Alpha : " + this.alpha);
         }
         catch(e:*)
         {
            throw e;
         }
      }
   }
}
