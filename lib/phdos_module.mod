	  �  5   k820309    h          14.0        6y3X                                                                                                           
       phdos_module.f90 PHDOS_MODULE              PHDOS_TYPE READ_PHDOS_DATA ZERO_POINT_ENERGY FREE_ENERGY VIB_ENERGY VIB_ENTROPY SPECIFIC_HEAT_CV INTEGRATED_DOS SET_PHDOS DESTROY_PHDOS FIND_MINIMUM_MAXIMUM                      @                              
       DP                                                     
       K_BOLTZMANN_RY RY_TO_CMM1                                                                                                                         @               @                '�                    #NUMBER_OF_POINTS    #DE    #NU    #PHDOS                 � $                                                              � $                                            
              � $                                                          
            &                                                      � $                                         X                 
            &                                           #         @                                   	                   #READ_PHDOS_DATA%ABS 
   #READ_PHDOS_DATA%TRIM    #PHDOS    #FILENAME                  @                            
     ABS               @                                 TRIM           
D                                      �               #PHDOS_TYPE              
  @                                                         #         @                                                      #ZERO_POINT_ENERGY%DOT_PRODUCT    #PHDOS    #ENER                  @                                 DOT_PRODUCT           
                                       �              #PHDOS_TYPE              D                                     
       #         @                                                     #FREE_ENERGY%LOG    #FREE_ENERGY%EXP    #PHDOS    #TEMP    #ENER                  @                                 LOG               @                                 EXP           
                                       �              #PHDOS_TYPE              
                                      
                D                                     
       #         @                                                     #VIB_ENERGY%EXP    #PHDOS    #TEMP    #ENER                  @                                 EXP           
                                       �              #PHDOS_TYPE              
                                      
                D                                     
       #         @                                                       #PHDOS    #TEMP    #ENTR               
  @                                    �              #PHDOS_TYPE              
  @                                   
                D                                      
       #         @                                   !                   #SPECIFIC_HEAT_CV%EXP "   #PHDOS #   #TEMP $   #CV %                 @                            "     EXP           
                                  #     �              #PHDOS_TYPE              
                                 $     
                D                                %     
       #         @                                   &                    #PHDOS '   #TOT_DOS (             
                                  '     �              #PHDOS_TYPE              D                                (     
       #         @                                   )                    #PHDOS *   #NDIV +   #DELTANU ,             
D                                 *     �               #PHDOS_TYPE              
                                  +                     
                                 ,     
      #         @                                   -                   #DESTROY_PHDOS%ALLOCATED .   #PHDOS /                 @                            .     ALLOCATED           
D                                 /     �               #PHDOS_TYPE    #         @                                   0                    #PHDOS 1   #FREQMIN 2   #FREQMAX 3             
                                  1     �              #PHDOS_TYPE              D                                2     
                 D                                3     
          �   &      fn#fn "   �   �   b   uapp(PHDOS_MODULE    s  C   J  KINDS    �  Z   J  CONSTANTS      p       DP+KINDS    �  �       PHDOS_TYPE ,     H   a   PHDOS_TYPE%NUMBER_OF_POINTS    I  H   a   PHDOS_TYPE%DE    �  �   a   PHDOS_TYPE%NU !   %  �   a   PHDOS_TYPE%PHDOS     �  �       READ_PHDOS_DATA $   M  <      READ_PHDOS_DATA%ABS %   �  =      READ_PHDOS_DATA%TRIM &   �  X   a   READ_PHDOS_DATA%PHDOS )     P   a   READ_PHDOS_DATA%FILENAME "   n  �       ZERO_POINT_ENERGY .   �  D      ZERO_POINT_ENERGY%DOT_PRODUCT (   2  X   a   ZERO_POINT_ENERGY%PHDOS '   �  @   a   ZERO_POINT_ENERGY%ENER    �  �       FREE_ENERGY     [  <      FREE_ENERGY%LOG     �  <      FREE_ENERGY%EXP "   �  X   a   FREE_ENERGY%PHDOS !   +	  @   a   FREE_ENERGY%TEMP !   k	  @   a   FREE_ENERGY%ENER    �	  {       VIB_ENERGY    &
  <      VIB_ENERGY%EXP !   b
  X   a   VIB_ENERGY%PHDOS     �
  @   a   VIB_ENERGY%TEMP     �
  @   a   VIB_ENERGY%ENER    :  g       VIB_ENTROPY "   �  X   a   VIB_ENTROPY%PHDOS !   �  @   a   VIB_ENTROPY%TEMP !   9  @   a   VIB_ENTROPY%ENTR !   y         SPECIFIC_HEAT_CV %   �  <      SPECIFIC_HEAT_CV%EXP '   4  X   a   SPECIFIC_HEAT_CV%PHDOS &   �  @   a   SPECIFIC_HEAT_CV%TEMP $   �  @   a   SPECIFIC_HEAT_CV%CV      `       INTEGRATED_DOS %   l  X   a   INTEGRATED_DOS%PHDOS '   �  @   a   INTEGRATED_DOS%TOT_DOS      j       SET_PHDOS     n  X   a   SET_PHDOS%PHDOS    �  @   a   SET_PHDOS%NDIV "     @   a   SET_PHDOS%DELTANU    F  p       DESTROY_PHDOS (   �  B      DESTROY_PHDOS%ALLOCATED $   �  X   a   DESTROY_PHDOS%PHDOS %   P  m       FIND_MINIMUM_MAXIMUM +   �  X   a   FIND_MINIMUM_MAXIMUM%PHDOS -     @   a   FIND_MINIMUM_MAXIMUM%FREQMIN -   U  @   a   FIND_MINIMUM_MAXIMUM%FREQMAX 