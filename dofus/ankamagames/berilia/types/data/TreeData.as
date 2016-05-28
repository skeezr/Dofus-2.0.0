package com.ankamagames.berilia.types.data
{
   public class TreeData
   {
       
      public var value;
      
      public var label:String;
      
      public var expend:Boolean;
      
      public var children:Vector.<com.ankamagames.berilia.types.data.TreeData>;
      
      public var parent:com.ankamagames.berilia.types.data.TreeData;
      
      public function TreeData(value:*, label:String, expend:Boolean = false, childs:Vector.<com.ankamagames.berilia.types.data.TreeData> = null, parent:com.ankamagames.berilia.types.data.TreeData = null)
      {
         super();
         this.value = value;
         this.label = label;
         this.expend = expend;
         this.children = childs;
         this.parent = parent;
      }
      
      public static function fromArray(a:Object) : Vector.<com.ankamagames.berilia.types.data.TreeData>
      {
         var root:com.ankamagames.berilia.types.data.TreeData = new com.ankamagames.berilia.types.data.TreeData(null,null,true);
         root.children = _fromArray(a,root);
         return root.children;
      }
      
      private static function _fromArray(a:Object, parent:com.ankamagames.berilia.types.data.TreeData) : Vector.<com.ankamagames.berilia.types.data.TreeData>
      {
         var td:com.ankamagames.berilia.types.data.TreeData = null;
         var children:* = undefined;
         var data:* = undefined;
         var res:Vector.<com.ankamagames.berilia.types.data.TreeData> = new Vector.<com.ankamagames.berilia.types.data.TreeData>();
         for each(data in a)
         {
            if(Object(data).hasOwnProperty("children"))
            {
               children = data.children;
            }
            else
            {
               children = null;
            }
            td = new com.ankamagames.berilia.types.data.TreeData(data,data.label,!!Object(data).hasOwnProperty("expend")?Boolean(Object(data).expend):false);
            td.parent = parent;
            td.children = _fromArray(children,td);
            res.push(td);
         }
         return res;
      }
      
      public function get depth() : uint
      {
         if(this.parent)
         {
            return this.parent.depth + 1;
         }
         return 0;
      }
   }
}
