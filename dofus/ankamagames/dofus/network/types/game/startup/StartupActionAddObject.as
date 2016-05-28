package com.ankamagames.dofus.network.types.game.startup
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemMinimalInformation;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class StartupActionAddObject implements INetworkType
   {
      
      public static const protocolId:uint = 52;
       
      public var uid:uint = 0;
      
      public var title:String = "";
      
      public var text:String = "";
      
      public var descUrl:String = "";
      
      public var pictureUrl:String = "";
      
      public var items:Vector.<ObjectItemMinimalInformation>;
      
      public function StartupActionAddObject()
      {
         this.items = new Vector.<ObjectItemMinimalInformation>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 52;
      }
      
      public function initStartupActionAddObject(uid:uint = 0, title:String = "", text:String = "", descUrl:String = "", pictureUrl:String = "", items:Vector.<ObjectItemMinimalInformation> = null) : StartupActionAddObject
      {
         this.uid = uid;
         this.title = title;
         this.text = text;
         this.descUrl = descUrl;
         this.pictureUrl = pictureUrl;
         this.items = items;
         return this;
      }
      
      public function reset() : void
      {
         this.uid = 0;
         this.title = "";
         this.text = "";
         this.descUrl = "";
         this.pictureUrl = "";
         this.items = new Vector.<ObjectItemMinimalInformation>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_StartupActionAddObject(output);
      }
      
      public function serializeAs_StartupActionAddObject(output:IDataOutput) : void
      {
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element uid.");
         }
         output.writeInt(this.uid);
         output.writeUTF(this.title);
         output.writeUTF(this.text);
         output.writeUTF(this.descUrl);
         output.writeUTF(this.pictureUrl);
         output.writeShort(this.items.length);
         for(var _i6:uint = 0; _i6 < this.items.length; _i6++)
         {
            (this.items[_i6] as ObjectItemMinimalInformation).serializeAs_ObjectItemMinimalInformation(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_StartupActionAddObject(input);
      }
      
      public function deserializeAs_StartupActionAddObject(input:IDataInput) : void
      {
         var _item6:ObjectItemMinimalInformation = null;
         this.uid = input.readInt();
         if(this.uid < 0)
         {
            throw new Error("Forbidden value (" + this.uid + ") on element of StartupActionAddObject.uid.");
         }
         this.title = input.readUTF();
         this.text = input.readUTF();
         this.descUrl = input.readUTF();
         this.pictureUrl = input.readUTF();
         var _itemsLen:uint = input.readUnsignedShort();
         for(var _i6:uint = 0; _i6 < _itemsLen; _i6++)
         {
            _item6 = new ObjectItemMinimalInformation();
            _item6.deserialize(input);
            this.items.push(_item6);
         }
      }
   }
}
