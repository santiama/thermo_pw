	  ¢M  ¦   k820309    h          14.0        &y3X                                                                                                           
       isoentropic.f90 ISOENTROPIC              ISOBARIC_HEAT_CAPACITY ISOENTROPIC_BULK_MODULUS ISOSTRESS_HEAT_CAPACITY AVERAGE_GRUNEISEN THERMAL_STRESS ISOENTROPIC_ELASTIC_CONSTANTS GEN_AVERAGE_GRUNEISEN                      @                              
       DP                      @                              
       STDOUT IONODE IONODE_ID                                                     
       INTRA_IMAGE_COMM                      @                              
       MP_BCAST                                                       u #MP_BCAST_I1    #MP_BCAST_R1 	   #MP_BCAST_C1    #MP_BCAST_Z    #MP_BCAST_ZV    #MP_BCAST_IV     #MP_BCAST_RV %   #MP_BCAST_CV *   #MP_BCAST_L /   #MP_BCAST_RM 3   #MP_BCAST_CM 8   #MP_BCAST_IM =   #MP_BCAST_IT B   #MP_BCAST_RT G   #MP_BCAST_LV L   #MP_BCAST_LM Q   #MP_BCAST_R4D V   #MP_BCAST_R5D [   #MP_BCAST_CT `   #MP_BCAST_C4D e   #MP_BCAST_C5D j   #         @     @                                                #MSG    #SOURCE    #GID                                                                                                                            
                                             #         @     @                            	                    #MSG 
   #SOURCE    #GID                                              
     
                 
                                                       
                                             #         @     @                                                #MSG    #SOURCE    #GID                                                                    
                                                       
                                             #         @     @                                               #MP_BCAST_Z%LEN    #MP_BCAST_Z%ICHAR    #MP_BCAST_Z%CHAR    #MSG    #SOURCE    #GID                  @                                 LEN               @                                 ICHAR               @                                 CHAR                                                                1           
                                                       
                                             #         @     @                                               #MP_BCAST_ZV%SIZE    #MP_BCAST_ZV%LEN    #MP_BCAST_ZV%ICHAR    #MP_BCAST_ZV%CHAR    #MSG    #SOURCE    #GID                  @                                 SIZE               @                                 LEN               @                                 ICHAR               @                                 CHAR ,                                                                            &                                           1           
                                                       
                                             #         @     @                                                #MP_BCAST_IV%SIZE !   #MSG "   #SOURCE #   #GID $                 @                            !     SIZE                                           "                                  &                                                     
                                  #                     
                                  $           #         @     @                            %                   #MP_BCAST_RV%SIZE &   #MSG '   #SOURCE (   #GID )                 @                            &     SIZE                                          '                   
               &                                                     
                                  (                     
                                  )           #         @     @                            *                   #MP_BCAST_CV%SIZE +   #MSG ,   #SOURCE -   #GID .                 @                            +     SIZE                                          ,                                  &                                                     
                                  -                     
                                  .           #         @     @                            /                    #MSG 0   #SOURCE 1   #GID 2                                              0                      
                                  1                     
                                  2           #         @     @                            3                   #MP_BCAST_RM%SIZE 4   #MSG 5   #SOURCE 6   #GID 7                 @                            4     SIZE                                          5                   
 	              &                   &                                                     
                                  6                     
                                  7           #         @     @                            8                   #MP_BCAST_CM%SIZE 9   #MSG :   #SOURCE ;   #GID <                 @                            9     SIZE                                          :                                  &                   &                                                     
                                  ;                     
                                  <           #         @     @                            =                   #MP_BCAST_IM%SIZE >   #MSG ?   #SOURCE @   #GID A                 @                            >     SIZE                                           ?                                  &                   &                                                     
                                  @                     
                                  A           #         @     @                            B                   #MP_BCAST_IT%SIZE C   #MSG D   #SOURCE E   #GID F                 @                            C     SIZE                                           D                                  &                   &                   &                                                     
                                  E                     
                                  F           #         @     @                            G                   #MP_BCAST_RT%SIZE H   #MSG I   #SOURCE J   #GID K                 @                            H     SIZE                                          I                   
 
              &                   &                   &                                                     
                                  J                     
                                  K           #         @     @                            L                   #MP_BCAST_LV%SIZE M   #MSG N   #SOURCE O   #GID P                 @                            M     SIZE                                           N                                  &                                                     
                                  O                     
                                  P           #         @     @                            Q                   #MP_BCAST_LM%SIZE R   #MSG S   #SOURCE T   #GID U                 @                            R     SIZE                                           S                                  &                   &                                                     
                                  T                     
                                  U           #         @     @                            V                   #MP_BCAST_R4D%SIZE W   #MSG X   #SOURCE Y   #GID Z                 @                            W     SIZE                                          X                   
               &                   &                   &                   &                                                     
                                  Y                     
                                  Z           #         @     @                            [                   #MP_BCAST_R5D%SIZE \   #MSG ]   #SOURCE ^   #GID _                 @                            \     SIZE                                          ]                   
               &                   &                   &                   &                   &                                                     
                                  ^                     
                                  _           #         @     @                            `                   #MP_BCAST_CT%SIZE a   #MSG b   #SOURCE c   #GID d                 @                            a     SIZE                                          b                                  &                   &                   &                                                     
                                  c                     
                                  d           #         @     @                            e                   #MP_BCAST_C4D%SIZE f   #MSG g   #SOURCE h   #GID i                 @                            f     SIZE                                          g                                  &                   &                   &                   &                                                     
                                  h                     
                                  i           #         @     @                            j                   #MP_BCAST_C5D%SIZE k   #MSG l   #SOURCE m   #GID n                 @                            k     SIZE                                          l                                  &                   &                   &                   &                   &                                                     
                                  m                     
                                  n                                                        o                                                                                                    p                                                       q                                                       r            #         @                                   s                    #VOLUME t   #B0_T v   #BETA_T w   #TEMP x   #CPMCV y   #NTEMP u                                                                               
                                 t                    
    p          5  p        r u       5  p        r u                              
                                 v                    
    p          5  p        r u       5  p        r u                              
                                 w                    
    p          5  p        r u       5  p        r u                              
                                 x                    
    p          5  p        r u       5  p        r u                              
D                                y                    
     p          5  p        r u       5  p        r u                                                                u            #         @                                   z                    #VOLUME {   #B0_T }   #BETA_T ~   #CP_T    #TEMP    #BSMBT    #NTEMP |                                                                                   
                                 {                    
    p          5  p        r |       5  p        r |                              
                                 }                    
    p          5  p        r |       5  p        r |                              
                                 ~                    
    p          5  p        r |       5  p        r |                              
                                                     
 	   p          5  p        r |       5  p        r |                              
                                                     
 
   p          5  p        r |       5  p        r |                              
D                                                    
     p          5  p        r |       5  p        r |                               
                                  |           #         @                                                       #VOLUME    #EL_CON_T    #ALPHA_T    #TEMP    #CPMCV    #NTEMP                                                                                  
                                                     
    p          5  p        r        5  p        r                               
                                                     
    p +         p          p          5  p        r        p          p          5  p        r                               
@ @                                                  
    p          p          5  p        r        p          5  p        r                               
                                                     
    p          5  p        r        5  p        r                               D                                                    
     p          5  p        r        5  p        r                                
                                             #         @                                                       #VOLUME    #B0_T    #BETA_T    #CV_T    #TEMP    #GAMMA_T    #NTEMP                                                                      
                                                     
    p          5  p        r        5  p        r                               
                                                     
    p          5  p        r        5  p        r                               
                                                     
    p          5  p        r        5  p        r                               
                                                     
    p          5  p        r        5  p        r                               
                                                     
    p          5  p        r        5  p        r                               D                                                    
     p          5  p        r        5  p        r                                
                                             #         @                                                       #EL_CON_T    #ALPHA_T    #BTHS    #NTEMP                                                                
                                                     
    p +         p          p          5  p        r        p          p          5  p        r                               
@ @                                                  
    p          p          5  p        r        p          5  p        r                               D                                                    
     p          p          p          5  p        r        p          p          5  p        r                                
                                             #         @                                                       #VOLUME    #BTHS    #CV_T    #TEMP    #CSMCT    #NTEMP                                                                                              
                                                     
     p          5  p        r        5  p        r                               
                                                     
 !   p          p          p          5  p        r        p          p          5  p        r                               
                                                     
 "   p          5  p        r        5  p        r                               
                                                     
 #   p          5  p        r        5  p        r                               
D @                                                  
 $    p +         p          p          5  p        r        p          p          5  p        r                                
                                             #         @                                                       #VOLUME    #BTHS     #CV_T ¡   #TEMP ¢   #GGAMMA_T £   #NTEMP                                           
                                                     
 &   p          5  p        r        5  p        r                               
                                                      
 '   p          p          p          5  p        r        p          p          5  p        r                               
                                 ¡                    
 (   p          5  p        r        5  p        r                               
                                 ¢                    
 )   p          5  p        r        5  p        r                               
D                                £                    
 *    p          p          p          5  p        r        p          p          5  p        r                                
                                                    $      fn#fn !   Ä   ­   b   uapp(ISOENTROPIC    q  C   J  KINDS    ´  X   J  IO_GLOBAL      Q   J  MP_IMAGES    ]  I   J  MP     ¦  §      gen@MP_BCAST+MP    M  f      MP_BCAST_I1+MP #   ³  @   a   MP_BCAST_I1%MSG+MP &   ó  @   a   MP_BCAST_I1%SOURCE+MP #   3  @   a   MP_BCAST_I1%GID+MP    s  f      MP_BCAST_R1+MP #   Ù  @   a   MP_BCAST_R1%MSG+MP &     @   a   MP_BCAST_R1%SOURCE+MP #   Y  @   a   MP_BCAST_R1%GID+MP      f      MP_BCAST_C1+MP #   ÿ  @   a   MP_BCAST_C1%MSG+MP &   ?  @   a   MP_BCAST_C1%SOURCE+MP #     @   a   MP_BCAST_C1%GID+MP    ¿  ¥      MP_BCAST_Z+MP &   d  <      MP_BCAST_Z%LEN+MP=LEN *      >      MP_BCAST_Z%ICHAR+MP=ICHAR (   Þ  =      MP_BCAST_Z%CHAR+MP=CHAR "   	  L   a   MP_BCAST_Z%MSG+MP %   g	  @   a   MP_BCAST_Z%SOURCE+MP "   §	  @   a   MP_BCAST_Z%GID+MP    ç	  ¾      MP_BCAST_ZV+MP )   ¥
  =      MP_BCAST_ZV%SIZE+MP=SIZE '   â
  <      MP_BCAST_ZV%LEN+MP=LEN +     >      MP_BCAST_ZV%ICHAR+MP=ICHAR )   \  =      MP_BCAST_ZV%CHAR+MP=CHAR #        a   MP_BCAST_ZV%MSG+MP &   )  @   a   MP_BCAST_ZV%SOURCE+MP #   i  @   a   MP_BCAST_ZV%GID+MP    ©  |      MP_BCAST_IV+MP )   %  =      MP_BCAST_IV%SIZE+MP=SIZE #   b     a   MP_BCAST_IV%MSG+MP &   î  @   a   MP_BCAST_IV%SOURCE+MP #   .  @   a   MP_BCAST_IV%GID+MP    n  |      MP_BCAST_RV+MP )   ê  =      MP_BCAST_RV%SIZE+MP=SIZE #   '     a   MP_BCAST_RV%MSG+MP &   ³  @   a   MP_BCAST_RV%SOURCE+MP #   ó  @   a   MP_BCAST_RV%GID+MP    3  |      MP_BCAST_CV+MP )   ¯  =      MP_BCAST_CV%SIZE+MP=SIZE #   ì     a   MP_BCAST_CV%MSG+MP &   x  @   a   MP_BCAST_CV%SOURCE+MP #   ¸  @   a   MP_BCAST_CV%GID+MP    ø  f      MP_BCAST_L+MP "   ^  @   a   MP_BCAST_L%MSG+MP %     @   a   MP_BCAST_L%SOURCE+MP "   Þ  @   a   MP_BCAST_L%GID+MP      |      MP_BCAST_RM+MP )     =      MP_BCAST_RM%SIZE+MP=SIZE #   ×  ¤   a   MP_BCAST_RM%MSG+MP &   {  @   a   MP_BCAST_RM%SOURCE+MP #   »  @   a   MP_BCAST_RM%GID+MP    û  |      MP_BCAST_CM+MP )   w  =      MP_BCAST_CM%SIZE+MP=SIZE #   ´  ¤   a   MP_BCAST_CM%MSG+MP &   X  @   a   MP_BCAST_CM%SOURCE+MP #     @   a   MP_BCAST_CM%GID+MP    Ø  |      MP_BCAST_IM+MP )   T  =      MP_BCAST_IM%SIZE+MP=SIZE #     ¤   a   MP_BCAST_IM%MSG+MP &   5  @   a   MP_BCAST_IM%SOURCE+MP #   u  @   a   MP_BCAST_IM%GID+MP    µ  |      MP_BCAST_IT+MP )   1  =      MP_BCAST_IT%SIZE+MP=SIZE #   n  ¼   a   MP_BCAST_IT%MSG+MP &   *  @   a   MP_BCAST_IT%SOURCE+MP #   j  @   a   MP_BCAST_IT%GID+MP    ª  |      MP_BCAST_RT+MP )   &  =      MP_BCAST_RT%SIZE+MP=SIZE #   c  ¼   a   MP_BCAST_RT%MSG+MP &     @   a   MP_BCAST_RT%SOURCE+MP #   _  @   a   MP_BCAST_RT%GID+MP      |      MP_BCAST_LV+MP )     =      MP_BCAST_LV%SIZE+MP=SIZE #   X     a   MP_BCAST_LV%MSG+MP &   ä  @   a   MP_BCAST_LV%SOURCE+MP #   $  @   a   MP_BCAST_LV%GID+MP    d  |      MP_BCAST_LM+MP )   à  =      MP_BCAST_LM%SIZE+MP=SIZE #     ¤   a   MP_BCAST_LM%MSG+MP &   Á  @   a   MP_BCAST_LM%SOURCE+MP #      @   a   MP_BCAST_LM%GID+MP     A   }      MP_BCAST_R4D+MP *   ¾   =      MP_BCAST_R4D%SIZE+MP=SIZE $   û   Ô   a   MP_BCAST_R4D%MSG+MP '   Ï!  @   a   MP_BCAST_R4D%SOURCE+MP $   "  @   a   MP_BCAST_R4D%GID+MP     O"  }      MP_BCAST_R5D+MP *   Ì"  =      MP_BCAST_R5D%SIZE+MP=SIZE $   	#  ì   a   MP_BCAST_R5D%MSG+MP '   õ#  @   a   MP_BCAST_R5D%SOURCE+MP $   5$  @   a   MP_BCAST_R5D%GID+MP    u$  |      MP_BCAST_CT+MP )   ñ$  =      MP_BCAST_CT%SIZE+MP=SIZE #   .%  ¼   a   MP_BCAST_CT%MSG+MP &   ê%  @   a   MP_BCAST_CT%SOURCE+MP #   *&  @   a   MP_BCAST_CT%GID+MP     j&  }      MP_BCAST_C4D+MP *   ç&  =      MP_BCAST_C4D%SIZE+MP=SIZE $   $'  Ô   a   MP_BCAST_C4D%MSG+MP '   ø'  @   a   MP_BCAST_C4D%SOURCE+MP $   8(  @   a   MP_BCAST_C4D%GID+MP     x(  }      MP_BCAST_C5D+MP *   õ(  =      MP_BCAST_C5D%SIZE+MP=SIZE $   2)  ì   a   MP_BCAST_C5D%MSG+MP '   *  @   a   MP_BCAST_C5D%SOURCE+MP $   ^*  @   a   MP_BCAST_C5D%GID+MP    *  p       DP+KINDS !   +  @       STDOUT+IO_GLOBAL !   N+  @       IONODE+IO_GLOBAL $   +  @       IONODE_ID+IO_GLOBAL '   Î+  Í       ISOBARIC_HEAT_CAPACITY .   ,  ´   a   ISOBARIC_HEAT_CAPACITY%VOLUME ,   O-  ´   a   ISOBARIC_HEAT_CAPACITY%B0_T .   .  ´   a   ISOBARIC_HEAT_CAPACITY%BETA_T ,   ·.  ´   a   ISOBARIC_HEAT_CAPACITY%TEMP -   k/  ´   a   ISOBARIC_HEAT_CAPACITY%CPMCV -   0  @   a   ISOBARIC_HEAT_CAPACITY%NTEMP )   _0  Û       ISOENTROPIC_BULK_MODULUS 0   :1  ´   a   ISOENTROPIC_BULK_MODULUS%VOLUME .   î1  ´   a   ISOENTROPIC_BULK_MODULUS%B0_T 0   ¢2  ´   a   ISOENTROPIC_BULK_MODULUS%BETA_T .   V3  ´   a   ISOENTROPIC_BULK_MODULUS%CP_T .   
4  ´   a   ISOENTROPIC_BULK_MODULUS%TEMP /   ¾4  ´   a   ISOENTROPIC_BULK_MODULUS%BSMBT /   r5  @   a   ISOENTROPIC_BULK_MODULUS%NTEMP (   ²5  Ô       ISOSTRESS_HEAT_CAPACITY /   6  ´   a   ISOSTRESS_HEAT_CAPACITY%VOLUME 1   :7  ô   a   ISOSTRESS_HEAT_CAPACITY%EL_CON_T 0   .8  Ô   a   ISOSTRESS_HEAT_CAPACITY%ALPHA_T -   9  ´   a   ISOSTRESS_HEAT_CAPACITY%TEMP .   ¶9  ´   a   ISOSTRESS_HEAT_CAPACITY%CPMCV .   j:  @   a   ISOSTRESS_HEAT_CAPACITY%NTEMP "   ª:  Ï       AVERAGE_GRUNEISEN )   y;  ´   a   AVERAGE_GRUNEISEN%VOLUME '   -<  ´   a   AVERAGE_GRUNEISEN%B0_T )   á<  ´   a   AVERAGE_GRUNEISEN%BETA_T '   =  ´   a   AVERAGE_GRUNEISEN%CV_T '   I>  ´   a   AVERAGE_GRUNEISEN%TEMP *   ý>  ´   a   AVERAGE_GRUNEISEN%GAMMA_T (   ±?  @   a   AVERAGE_GRUNEISEN%NTEMP    ñ?  «       THERMAL_STRESS (   @  ô   a   THERMAL_STRESS%EL_CON_T '   A  Ô   a   THERMAL_STRESS%ALPHA_T $   dB  ô   a   THERMAL_STRESS%BTHS %   XC  @   a   THERMAL_STRESS%NTEMP .   C  Ù       ISOENTROPIC_ELASTIC_CONSTANTS 5   qD  ´   a   ISOENTROPIC_ELASTIC_CONSTANTS%VOLUME 3   %E  ô   a   ISOENTROPIC_ELASTIC_CONSTANTS%BTHS 3   F  ´   a   ISOENTROPIC_ELASTIC_CONSTANTS%CV_T 3   ÍF  ´   a   ISOENTROPIC_ELASTIC_CONSTANTS%TEMP 4   G  ô   a   ISOENTROPIC_ELASTIC_CONSTANTS%CSMCT 4   uH  @   a   ISOENTROPIC_ELASTIC_CONSTANTS%NTEMP &   µH  ©       GEN_AVERAGE_GRUNEISEN -   ^I  ´   a   GEN_AVERAGE_GRUNEISEN%VOLUME +   J  ô   a   GEN_AVERAGE_GRUNEISEN%BTHS +   K  ´   a   GEN_AVERAGE_GRUNEISEN%CV_T +   ºK  ´   a   GEN_AVERAGE_GRUNEISEN%TEMP /   nL  ô   a   GEN_AVERAGE_GRUNEISEN%GGAMMA_T ,   bM  @   a   GEN_AVERAGE_GRUNEISEN%NTEMP 