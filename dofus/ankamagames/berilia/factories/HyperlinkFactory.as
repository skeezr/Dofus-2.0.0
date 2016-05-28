package com.ankamagames.berilia.factories
{
   import flash.utils.Dictionary;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.events.TextEvent;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   
   public class HyperlinkFactory
   {
      
      private static var LEFT:String = "{";
      
      private static var RIGHT:String = "}";
      
      private static var SEPARATOR:String = "::";
      
      private static var PROTOCOL:Dictionary = new Dictionary();
      
      private static var PROTOCOL_TEXT:Dictionary = new Dictionary();
      
      private static var staticStyleSheet:StyleSheet;
       
      public function HyperlinkFactory()
      {
         super();
      }
      
      public static function createHyperlink(textField:TextField, styleSheet:Boolean = false) : void
      {
         var currentText:String = decode(textField.htmlText);
         if(styleSheet)
         {
            if(!staticStyleSheet)
            {
               staticStyleSheet = new StyleSheet();
               staticStyleSheet.setStyle("a:link",{
                  "color":"#ffd376",
                  "fontWeight":"bold",
                  "fontFamily":"VerdanaBold"
               });
               staticStyleSheet.setStyle("a:hover",{
                  "color":"#fb6e0d",
                  "fontWeight":"bold",
                  "fontFamily":"VerdanaBold"
               });
            }
            textField.styleSheet = staticStyleSheet;
         }
         textField.htmlText = currentText;
         textField.mouseEnabled = true;
         textField.addEventListener(TextEvent.LINK,process);
      }
      
      public static function decode(string:String, htmlMode:Boolean = true) : String
      {
         var leftIndex:int = 0;
         var rightIndex:int = 0;
         var leftBlock:String = null;
         var rightBlock:String = null;
         var middleBlock:String = null;
         var linkInfo:Array = null;
         var param:String = null;
         var paramList:Array = null;
         var protocolName:String = null;
         var getTextFunction:Function = null;
         var currentText:String = string;
         while(true)
         {
            leftIndex = currentText.indexOf(LEFT);
            if(leftIndex == -1)
            {
               break;
            }
            rightIndex = currentText.indexOf(RIGHT);
            if(rightIndex == -1)
            {
               break;
            }
            leftBlock = currentText.substring(0,leftIndex);
            rightBlock = currentText.substring(rightIndex + 1);
            middleBlock = currentText.substring(leftIndex,rightIndex);
            linkInfo = middleBlock.split("::");
            param = linkInfo[0].substr(1);
            paramList = param.split(",");
            protocolName = paramList.shift();
            if(linkInfo.length == 1)
            {
               getTextFunction = PROTOCOL_TEXT[protocolName];
               if(getTextFunction != null)
               {
                  linkInfo.push(getTextFunction.apply(getTextFunction,paramList));
               }
            }
            if(htmlMode)
            {
               currentText = leftBlock + "<b><a href=\'event:" + param + "\'>" + linkInfo[1] + "</a></b>" + rightBlock;
            }
            else
            {
               currentText = leftBlock + linkInfo[1] + rightBlock;
            }
         }
         return currentText;
      }
      
      public static function registerProtocol(name:String, callBack:Function, textCallBack:Function = null) : void
      {
         PROTOCOL[name] = callBack;
         if(textCallBack != null)
         {
            PROTOCOL_TEXT[name] = textCallBack;
         }
      }
      
      public static function process(event:TextEvent) : void
      {
         var callBack:Function = null;
         var param:Array = event.text.split(",");
         if(ShortcutsFrame.shiftKey)
         {
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.ChatHyperlink,"{" + param.join(",") + "}");
         }
         else
         {
            callBack = PROTOCOL[param.shift()];
            if(callBack != null)
            {
               callBack.apply(callBack,param);
            }
         }
      }
   }
}
