package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   
   public class ChatClientPrivateWithObjectAction implements Action
   {
       
      private var _content:String;
      
      private var _receiver:String;
      
      private var _objects:Vector.<ObjectItem>;
      
      public function ChatClientPrivateWithObjectAction()
      {
         super();
      }
      
      public static function create(content:String, receiver:String, objects:Vector.<ObjectItem> = null) : ChatClientPrivateWithObjectAction
      {
         var a:ChatClientPrivateWithObjectAction = new ChatClientPrivateWithObjectAction();
         a._receiver = receiver;
         a._content = content;
         a._objects = objects;
         return a;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get receiver() : String
      {
         return this._receiver;
      }
      
      public function get objects() : Vector.<ObjectItem>
      {
         return this._objects;
      }
   }
}
