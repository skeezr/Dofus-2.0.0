package com.ankamagames.dofus.misc.options
{
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public dynamic class ChatOptions extends OptionManager
   {
       
      public var colors:Array;
      
      public var alertColor:int = 13977161;
      
      public function ChatOptions()
      {
         this.colors = new Array(11644845,8245463,9727923,14866307,6195157,10121023,9026438,14193737,15295385,5547488,4819250,4819250);
         super("chat");
         add("channelLocked",false);
         add("filterInsult",false);
         add("letLivingObjectTalk",true);
         add("smileysAutoclosed",false);
         add("showTime",false);
         add("showShortcut",false);
         add("channelColor0",this.colors[0]);
         add("channelColor1",this.colors[1]);
         add("channelColor2",this.colors[2]);
         add("channelColor3",this.colors[3]);
         add("channelColor4",this.colors[4]);
         add("channelColor5",this.colors[5]);
         add("channelColor6",this.colors[6]);
         add("channelColor7",this.colors[7]);
         add("channelColor8",this.colors[8]);
         add("channelColor9",this.colors[9]);
         add("channelColor10",this.colors[10]);
         add("channelColor11",this.colors[11]);
         add("alertColor",13977161);
         add("channelTabs",[[0,1,2,3,4,5,6,7,8,9,10],[11]]);
         var general:String = I18n.getText(I18nProxy.getKeyId("ui.common.general"));
         var fight:String = I18n.getText(I18nProxy.getKeyId("ui.common.fight"));
         add("tabsNames",[general,fight]);
      }
   }
}
