package com.ankamagames.dofus.network.enums
{
   public class PartyJoinErrorEnum
   {
      
      public static const PARTY_JOIN_ERROR_UNKNOWN:uint = 0;
      
      public static const PARTY_JOIN_ERROR_PLAYER_NOT_FOUND:uint = 1;
      
      public static const PARTY_JOIN_ERROR_PARTY_NOT_FOUND:uint = 2;
      
      public static const PARTY_JOIN_ERROR_PARTY_FULL:uint = 3;
      
      public static const PARTY_JOIN_ERROR_PLAYER_BUSY:uint = 4;
      
      public static const PARTY_JOIN_ERROR_PLAYER_IS_ALREADY_BEING_INVITED:uint = 5;
      
      public static const PARTY_JOIN_ERROR_PLAYER_ALREADY_IN_A_PARTY:uint = 6;
       
      public function PartyJoinErrorEnum()
      {
         super();
      }
   }
}
