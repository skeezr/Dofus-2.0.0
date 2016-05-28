package com.ankamagames.dofus.network.types.version
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class Version implements INetworkType
   {
      
      public static const protocolId:uint = 11;
       
      public var major:uint = 0;
      
      public var minor:uint = 0;
      
      public var revision:uint = 0;
      
      public var buildType:uint = 0;
      
      public function Version()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 11;
      }
      
      public function initVersion(major:uint = 0, minor:uint = 0, revision:uint = 0, buildType:uint = 0) : Version
      {
         this.major = major;
         this.minor = minor;
         this.revision = revision;
         this.buildType = buildType;
         return this;
      }
      
      public function reset() : void
      {
         this.major = 0;
         this.minor = 0;
         this.revision = 0;
         this.buildType = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_Version(output);
      }
      
      public function serializeAs_Version(output:IDataOutput) : void
      {
         if(this.major < 0)
         {
            throw new Error("Forbidden value (" + this.major + ") on element major.");
         }
         output.writeByte(this.major);
         if(this.minor < 0)
         {
            throw new Error("Forbidden value (" + this.minor + ") on element minor.");
         }
         output.writeByte(this.minor);
         if(this.revision < 0)
         {
            throw new Error("Forbidden value (" + this.revision + ") on element revision.");
         }
         output.writeByte(this.revision);
         output.writeByte(this.buildType);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_Version(input);
      }
      
      public function deserializeAs_Version(input:IDataInput) : void
      {
         this.major = input.readByte();
         if(this.major < 0)
         {
            throw new Error("Forbidden value (" + this.major + ") on element of Version.major.");
         }
         this.minor = input.readByte();
         if(this.minor < 0)
         {
            throw new Error("Forbidden value (" + this.minor + ") on element of Version.minor.");
         }
         this.revision = input.readByte();
         if(this.revision < 0)
         {
            throw new Error("Forbidden value (" + this.revision + ") on element of Version.revision.");
         }
         this.buildType = input.readByte();
         if(this.buildType < 0)
         {
            throw new Error("Forbidden value (" + this.buildType + ") on element of Version.buildType.");
         }
      }
   }
}
