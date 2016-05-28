package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class IgnoredInformations implements INetworkType
   {
      
      public static const protocolId:uint = 106;
       
      public var name:String = "";
      
      public function IgnoredInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 106;
      }
      
      public function initIgnoredInformations(name:String = "") : IgnoredInformations
      {
         this.name = name;
         return this;
      }
      
      public function reset() : void
      {
         this.name = "";
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_IgnoredInformations(output);
      }
      
      public function serializeAs_IgnoredInformations(output:IDataOutput) : void
      {
         output.writeUTF(this.name);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IgnoredInformations(input);
      }
      
      public function deserializeAs_IgnoredInformations(input:IDataInput) : void
      {
         this.name = input.readUTF();
      }
   }
}
