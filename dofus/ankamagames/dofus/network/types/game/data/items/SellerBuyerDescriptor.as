package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class SellerBuyerDescriptor implements INetworkType
   {
      
      public static const protocolId:uint = 121;
       
      public var quantities:Vector.<uint>;
      
      public var types:Vector.<uint>;
      
      public var taxPercentage:Number = 0;
      
      public var maxItemLevel:uint = 0;
      
      public var maxItemPerAccount:uint = 0;
      
      public var npcContextualId:int = 0;
      
      public var unsoldDelay:uint = 0;
      
      public function SellerBuyerDescriptor()
      {
         this.quantities = new Vector.<uint>();
         this.types = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 121;
      }
      
      public function initSellerBuyerDescriptor(quantities:Vector.<uint> = null, types:Vector.<uint> = null, taxPercentage:Number = 0, maxItemLevel:uint = 0, maxItemPerAccount:uint = 0, npcContextualId:int = 0, unsoldDelay:uint = 0) : SellerBuyerDescriptor
      {
         this.quantities = quantities;
         this.types = types;
         this.taxPercentage = taxPercentage;
         this.maxItemLevel = maxItemLevel;
         this.maxItemPerAccount = maxItemPerAccount;
         this.npcContextualId = npcContextualId;
         this.unsoldDelay = unsoldDelay;
         return this;
      }
      
      public function reset() : void
      {
         this.quantities = new Vector.<uint>();
         this.types = new Vector.<uint>();
         this.taxPercentage = 0;
         this.maxItemLevel = 0;
         this.maxItemPerAccount = 0;
         this.npcContextualId = 0;
         this.unsoldDelay = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_SellerBuyerDescriptor(output);
      }
      
      public function serializeAs_SellerBuyerDescriptor(output:IDataOutput) : void
      {
         output.writeShort(this.quantities.length);
         for(var _i1:uint = 0; _i1 < this.quantities.length; _i1++)
         {
            if(this.quantities[_i1] < 0)
            {
               throw new Error("Forbidden value (" + this.quantities[_i1] + ") on element 1 (starting at 1) of quantities.");
            }
            output.writeInt(this.quantities[_i1]);
         }
         output.writeShort(this.types.length);
         for(var _i2:uint = 0; _i2 < this.types.length; _i2++)
         {
            if(this.types[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.types[_i2] + ") on element 2 (starting at 1) of types.");
            }
            output.writeInt(this.types[_i2]);
         }
         output.writeFloat(this.taxPercentage);
         if(this.maxItemLevel < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemLevel + ") on element maxItemLevel.");
         }
         output.writeInt(this.maxItemLevel);
         if(this.maxItemPerAccount < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemPerAccount + ") on element maxItemPerAccount.");
         }
         output.writeInt(this.maxItemPerAccount);
         output.writeInt(this.npcContextualId);
         if(this.unsoldDelay < 0)
         {
            throw new Error("Forbidden value (" + this.unsoldDelay + ") on element unsoldDelay.");
         }
         output.writeShort(this.unsoldDelay);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SellerBuyerDescriptor(input);
      }
      
      public function deserializeAs_SellerBuyerDescriptor(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _val2:uint = 0;
         var _quantitiesLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _quantitiesLen; _i1++)
         {
            _val1 = input.readInt();
            if(_val1 < 0)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of quantities.");
            }
            this.quantities.push(_val1);
         }
         var _typesLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _typesLen; _i2++)
         {
            _val2 = input.readInt();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of types.");
            }
            this.types.push(_val2);
         }
         this.taxPercentage = input.readFloat();
         this.maxItemLevel = input.readInt();
         if(this.maxItemLevel < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemLevel + ") on element of SellerBuyerDescriptor.maxItemLevel.");
         }
         this.maxItemPerAccount = input.readInt();
         if(this.maxItemPerAccount < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemPerAccount + ") on element of SellerBuyerDescriptor.maxItemPerAccount.");
         }
         this.npcContextualId = input.readInt();
         this.unsoldDelay = input.readShort();
         if(this.unsoldDelay < 0)
         {
            throw new Error("Forbidden value (" + this.unsoldDelay + ") on element of SellerBuyerDescriptor.unsoldDelay.");
         }
      }
   }
}
