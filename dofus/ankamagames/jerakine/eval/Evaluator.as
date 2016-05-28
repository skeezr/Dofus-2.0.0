package com.ankamagames.jerakine.eval
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class Evaluator
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Evaluator));
      
      private static const NUMBER:uint = 0;
      
      private static const STRING:uint = 1;
       
      public function Evaluator()
      {
         super();
      }
      
      public function eval(expr:String) : *
      {
         return this.complexEval(expr);
      }
      
      private function simpleEval(expr:String) : *
      {
         var operator:Function = null;
         var currentChar:String = null;
         var partialOp:Array = null;
         var lastOp:* = undefined;
         var ok:Boolean = false;
         var wait:Boolean = false;
         var k:uint = 0;
         var currentOperator:String = "";
         var inQuote:* = false;
         var protect:Boolean = false;
         var currentParam:* = "";
         var currentType:uint = STRING;
         var op:Array = new Array();
         for(var i:uint = 0; i < expr.length; i++)
         {
            currentChar = expr.charAt(i);
            if(currentChar == "\'" && !protect)
            {
               currentType = STRING;
               inQuote = !inQuote;
            }
            else if(currentChar == "\\")
            {
               protect = true;
            }
            else if(!inQuote)
            {
               switch(currentChar)
               {
                  case "(":
                  case ")":
                  case " ":
                  case "\t":
                  case "\n":
                     break;
                  case "0":
                  case "1":
                  case "2":
                  case "3":
                  case "4":
                  case "5":
                  case "6":
                  case "7":
                  case "8":
                  case "9":
                     currentType = NUMBER;
                     currentOperator = "";
                     operator = null;
                     currentParam = currentParam + currentChar;
                     break;
                  case ".":
                     currentParam = currentParam + ".";
                     break;
                  default:
                     if(currentChar == "-" || currentChar == "+")
                     {
                        if(!currentParam.length)
                        {
                           currentParam = currentParam + currentChar;
                           break;
                        }
                     }
                     ok = true;
                     wait = false;
                     currentOperator = currentOperator + currentChar;
                     switch(currentOperator)
                     {
                        case "-":
                           operator = this.minus;
                           break;
                        case "+":
                           operator = this.plus;
                           break;
                        case "*":
                           operator = this.multiply;
                           break;
                        case "/":
                           operator = this.divide;
                           break;
                        case ">":
                           if(expr.charAt(i + 1) != "=")
                           {
                              operator = this.sup;
                           }
                           else
                           {
                              wait = true;
                              ok = false;
                           }
                           break;
                        case ">=":
                           operator = this.supOrEquals;
                           break;
                        case "<":
                           if(expr.charAt(i + 1) != "=")
                           {
                              operator = this.inf;
                           }
                           else
                           {
                              wait = true;
                              ok = false;
                           }
                           break;
                        case "<=":
                           operator = this.infOrEquals;
                           break;
                        case "&&":
                           operator = this.and;
                           break;
                        case "||":
                           operator = this.or;
                           break;
                        case "==":
                           operator = this.equals;
                           break;
                        case "!=":
                           operator = this.equals;
                           break;
                        case "?":
                           operator = this.ternary;
                           break;
                        case ":":
                           operator = this.opElse;
                           break;
                        case "|":
                        case "=":
                        case "&":
                        case "!":
                           wait = true;
                        default:
                           ok = false;
                     }
                     if(ok)
                     {
                        if(currentParam.length)
                        {
                           if(currentType == STRING)
                           {
                              op.push(currentParam);
                           }
                           else
                           {
                              op.push(parseFloat(currentParam));
                           }
                           op.push(operator);
                        }
                        else
                        {
                           _log.warn(this.showPosInExpr(i,expr));
                           _log.warn("Expecting Number at char " + i + ", but found operator " + currentChar);
                        }
                        currentParam = "";
                     }
                     else if(!wait)
                     {
                        _log.warn(this.showPosInExpr(i,expr));
                        _log.warn("Bad character at " + i);
                     }
               }
            }
            else
            {
               currentOperator = "";
               operator = null;
               currentParam = currentParam + currentChar;
               protect = false;
            }
         }
         if(currentParam.length)
         {
            if(currentType == STRING)
            {
               op.push(currentParam);
            }
            else
            {
               op.push(parseFloat(currentParam));
            }
         }
         var operatorPriority:Array = [this.divide,this.multiply,this.minus,this.plus,this.sup,this.inf,this.supOrEquals,this.infOrEquals,this.equals,this.diff,this.and,this.or,this.ternary];
         for(var j:uint = 0; j < operatorPriority.length; j++)
         {
            partialOp = new Array();
            for(k = 0; k < op.length; k++)
            {
               if(op[k] is Function && op[k] == operatorPriority[j])
               {
                  lastOp = partialOp[partialOp.length - 1];
                  if(lastOp is Number || (op[k] == this.plus || op[k] == this.ternary) && lastOp is String)
                  {
                     if(op[k + 1] is Number || (op[k] == this.plus || op[k] == this.ternary) && op[k + 1] is String)
                     {
                        if(op[k] === this.ternary)
                        {
                           if(op[k + 2] == this.opElse)
                           {
                              partialOp[partialOp.length - 1] = this.ternary(lastOp,op[k + 1],op[k + 3]);
                              k = k + 2;
                           }
                           else
                           {
                              _log.warn("operator \':\' not found");
                           }
                        }
                        else
                        {
                           partialOp[partialOp.length - 1] = op[k](lastOp,op[k + 1]);
                        }
                     }
                     else
                     {
                        _log.warn("Expect Number, but find [" + op[k + 1] + "]");
                     }
                     k++;
                  }
                  else
                  {
                     lastOp = op[k - 1];
                     if(lastOp is Number || (op[k] == this.plus || op[k] == this.ternary) && lastOp is String)
                     {
                        if(op[k + 1] is Number || (op[k] == this.plus || op[k] == this.ternary) && op[k + 1] is String)
                        {
                           if(op[k] === this.ternary)
                           {
                              if(op[k + 2] == this.opElse)
                              {
                                 partialOp[partialOp.length - 1] = this.ternary(lastOp,op[k + 1],op[k + 3]);
                              }
                              else
                              {
                                 _log.warn("operator \':\' not found");
                              }
                           }
                           else
                           {
                              partialOp.push(op[k](lastOp,op[k + 1]));
                           }
                        }
                        else
                        {
                           _log.warn("Expect Number,  but find [" + op[k + 1] + "]");
                        }
                        k++;
                     }
                  }
               }
               else
               {
                  partialOp.push(op[k]);
               }
            }
            op = partialOp;
         }
         return op[0];
      }
      
      private function complexEval(expr:String) : *
      {
         var start:int = 0;
         var res:* = undefined;
         var i:uint = 0;
         expr = this.trim(expr);
         var modif:Boolean = true;
         var parenthCount:int = 0;
         while(modif)
         {
            modif = false;
            for(i = 0; i < expr.length; i++)
            {
               if(expr.charAt(i) == "(")
               {
                  if(!parenthCount)
                  {
                     start = i;
                  }
                  parenthCount++;
               }
               if(expr.charAt(i) == ")")
               {
                  parenthCount--;
                  if(!parenthCount)
                  {
                     res = this.complexEval(expr.substr(start + 1,i - start - 1));
                     expr = expr.substr(0,start) + (res is Number?res:"\'" + res + "\'") + expr.substr(i + 1);
                     modif = true;
                     break;
                  }
               }
            }
         }
         if(parenthCount)
         {
            _log.warn("Missing right parenthesis in " + expr);
         }
         return this.simpleEval(expr);
      }
      
      private function plus(a:*, b:*) : *
      {
         return a + b;
      }
      
      private function minus(a:Number, b:Number) : Number
      {
         return a - b;
      }
      
      private function multiply(a:Number, b:Number) : Number
      {
         return a * b;
      }
      
      private function divide(a:Number, b:Number) : Number
      {
         return a / b;
      }
      
      private function sup(a:Number, b:Number) : Number
      {
         return a > b?Number(1):Number(0);
      }
      
      private function supOrEquals(a:Number, b:Number) : Number
      {
         return a >= b?Number(1):Number(0);
      }
      
      private function inf(a:Number, b:Number) : Number
      {
         return a < b?Number(1):Number(0);
      }
      
      private function infOrEquals(a:Number, b:Number) : Number
      {
         return a <= b?Number(1):Number(0);
      }
      
      private function and(a:Number, b:Number) : Number
      {
         return Boolean(a) && Boolean(b)?Number(1):Number(0);
      }
      
      private function or(a:Number, b:Number) : Number
      {
         return Boolean(a) || Boolean(b)?Number(1):Number(0);
      }
      
      private function equals(a:*, b:*) : Number
      {
         return a == b?Number(1):Number(0);
      }
      
      private function diff(a:*, b:*) : Number
      {
         return a != b?Number(1):Number(0);
      }
      
      private function ternary(cond:Number, a:*, b:*) : *
      {
         return !!cond?a:b;
      }
      
      private function opElse() : void
      {
      }
      
      private function showPosInExpr(pos:uint, expr:String) : String
      {
         var res:* = expr + "\n";
         for(var i:uint = 0; i < pos; res = res + " ",i++)
         {
         }
         return res + "^";
      }
      
      private function trim(str:String) : String
      {
         var curChar:String = null;
         var res:String = "";
         var protect:Boolean = false;
         var inQuote:* = false;
         for(var i:uint = 0; i < str.length; i++)
         {
            curChar = str.charAt(i);
            if(curChar == "\'" && !protect)
            {
               inQuote = !inQuote;
            }
            if(curChar == "\\")
            {
               protect = true;
            }
            else
            {
               protect = false;
            }
            if(curChar != " " || Boolean(inQuote))
            {
               res = res + curChar;
            }
         }
         return res;
      }
   }
}
