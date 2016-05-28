package com.ankamagames.berilia.interfaces
{
   import com.ankamagames.jerakine.interfaces.ISecurizable;
   
   public interface IRadioItem extends ISecurizable
   {
       
      function get id() : String;
      
      function set value(param1:*) : void;
      
      function get value() : *;
      
      function set selected(param1:Boolean) : void;
      
      function get selected() : Boolean;
   }
}
