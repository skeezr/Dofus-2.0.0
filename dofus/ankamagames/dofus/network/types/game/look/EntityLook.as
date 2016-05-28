package com.ankamagames.dofus.network.types.game.look
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class EntityLook implements INetworkType
   {
      
      public static const protocolId:uint = 55;
       
      public var bonesId:uint = 0;
      
      public var skins:Vector.<uint>;
      
      public var indexedColors:Vector.<int>;
      
      public var scales:Vector.<int>;
      
      public var subentities:Vector.<com.ankamagames.dofus.network.types.game.look.SubEntity>;
      
      public function EntityLook()
      {
         this.skins = new Vector.<uint>();
         this.indexedColors = new Vector.<int>();
         this.scales = new Vector.<int>();
         this.subentities = new Vector.<com.ankamagames.dofus.network.types.game.look.SubEntity>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 55;
      }
      
      public function initEntityLook(bonesId:uint = 0, skins:Vector.<uint> = null, indexedColors:Vector.<int> = null, scales:Vector.<int> = null, subentities:Vector.<com.ankamagames.dofus.network.types.game.look.SubEntity> = null) : EntityLook
      {
         this.bonesId = bonesId;
         this.skins = skins;
         this.indexedColors = indexedColors;
         this.scales = scales;
         this.subentities = subentities;
         return this;
      }
      
      public function reset() : void
      {
         this.bonesId = 0;
         this.skins = new Vector.<uint>();
         this.indexedColors = new Vector.<int>();
         this.scales = new Vector.<int>();
         this.subentities = new Vector.<com.ankamagames.dofus.network.types.game.look.SubEntity>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_EntityLook(output);
      }
      
      public function serializeAs_EntityLook(output:IDataOutput) : void
      {
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element bonesId.");
         }
         output.writeShort(this.bonesId);
         output.writeShort(this.skins.length);
         for(var _i2:uint = 0; _i2 < this.skins.length; _i2++)
         {
            if(this.skins[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.skins[_i2] + ") on element 2 (starting at 1) of skins.");
            }
            output.writeShort(this.skins[_i2]);
         }
         output.writeShort(this.indexedColors.length);
         for(var _i3:uint = 0; _i3 < this.indexedColors.length; _i3++)
         {
            output.writeInt(this.indexedColors[_i3]);
         }
         output.writeShort(this.scales.length);
         for(var _i4:uint = 0; _i4 < this.scales.length; _i4++)
         {
            output.writeShort(this.scales[_i4]);
         }
         output.writeShort(this.subentities.length);
         for(var _i5:uint = 0; _i5 < this.subentities.length; _i5++)
         {
            (this.subentities[_i5] as com.ankamagames.dofus.network.types.game.look.SubEntity).serializeAs_SubEntity(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_EntityLook(input);
      }
      
      public function deserializeAs_EntityLook(input:IDataInput) : void
      {
         var _val2:uint = 0;
         var _val3:int = 0;
         var _val4:int = 0;
         var _item5:com.ankamagames.dofus.network.types.game.look.SubEntity = null;
         this.bonesId = input.readShort();
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element of EntityLook.bonesId.");
         }
         var _skinsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _skinsLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of skins.");
            }
            this.skins.push(_val2);
         }
         var _indexedColorsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _indexedColorsLen; _i3++)
         {
            _val3 = input.readInt();
            this.indexedColors.push(_val3);
         }
         var _scalesLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _scalesLen; _i4++)
         {
            _val4 = input.readShort();
            this.scales.push(_val4);
         }
         var _subentitiesLen:uint = input.readUnsignedShort();
         for(var _i5:uint = 0; _i5 < _subentitiesLen; _i5++)
         {
            _item5 = new com.ankamagames.dofus.network.types.game.look.SubEntity();
            _item5.deserialize(input);
            this.subentities.push(_item5);
         }
      }
   }
}
