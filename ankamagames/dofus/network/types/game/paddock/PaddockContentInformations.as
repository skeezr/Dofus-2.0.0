package com.ankamagames.dofus.network.types.game.paddock
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class PaddockContentInformations extends PaddockInformations implements INetworkType
   {
      
      public static const protocolId:uint = 183;
       
      public var mapId:int = 0;
      
      public var mountsInformations:Vector.<com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock>;
      
      public function PaddockContentInformations()
      {
         this.mountsInformations = new Vector.<com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 183;
      }
      
      public function initPaddockContentInformations(maxOutdoorMount:uint = 0, maxItems:uint = 0, mapId:int = 0, mountsInformations:Vector.<com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock> = null) : PaddockContentInformations
      {
         super.initPaddockInformations(maxOutdoorMount,maxItems);
         this.mapId = mapId;
         this.mountsInformations = mountsInformations;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mapId = 0;
         this.mountsInformations = new Vector.<com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock>();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_PaddockContentInformations(output);
      }
      
      public function serializeAs_PaddockContentInformations(output:IDataOutput) : void
      {
         super.serializeAs_PaddockInformations(output);
         output.writeInt(this.mapId);
         output.writeShort(this.mountsInformations.length);
         for(var _i2:uint = 0; _i2 < this.mountsInformations.length; _i2++)
         {
            (this.mountsInformations[_i2] as com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock).serializeAs_MountInformationsForPaddock(output);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PaddockContentInformations(input);
      }
      
      public function deserializeAs_PaddockContentInformations(input:IDataInput) : void
      {
         var _item2:com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock = null;
         super.deserialize(input);
         this.mapId = input.readInt();
         var _mountsInformationsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _mountsInformationsLen; _i2++)
         {
            _item2 = new com.ankamagames.dofus.network.types.game.paddock.MountInformationsForPaddock();
            _item2.deserialize(input);
            this.mountsInformations.push(_item2);
         }
      }
   }
}
