package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   
   public class ChatClientMultiWithObjectAction implements Action
   {
       
      private var _content:String;
      
      private var _channel:uint;
      
      private var _objects:Vector.<ObjectItem>;
      
      public function ChatClientMultiWithObjectAction()
      {
         super();
      }
      
      public static function create(content:String, channel:uint, objects:Vector.<ObjectItem> = null) : ChatClientMultiWithObjectAction
      {
         var a:ChatClientMultiWithObjectAction = new ChatClientMultiWithObjectAction();
         a._channel = channel;
         a._content = content;
         a._objects = objects;
         return a;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
      
      public function get objects() : Vector.<ObjectItem>
      {
         return this._objects;
      }
   }
}
