!
! Copyright (C) 2014-2015 Andrea Dal Corso 
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
MODULE elastic_constants
!
!   this module contains the support routines for the calculation
!   of the elastic constant
!
  USE kinds,     ONLY : DP
  USE constants, ONLY : ry_kbar
  USE io_global, ONLY : stdout, ionode, ionode_id
  USE mp_images, ONLY : intra_image_comm
  USE mp,        ONLY : mp_bcast 
  IMPLICIT NONE
  PRIVATE
  SAVE

  REAL(DP) :: el_con(6,6)   ! The elastic constant
  REAL(DP) :: el_compliances(6,6)   ! The elastic compliances
  REAL(DP), ALLOCATABLE :: internal_strain(:,:,:)  ! 6,3,nat internal strain
 
  REAL(DP), ALLOCATABLE :: sigma_geo(:,:,:) ! The stress tensor computed 
                                            ! for each strain
  REAL(DP), ALLOCATABLE :: epsilon_geo(:,:,:) ! The strain tensor for each
                                            ! geometry
  REAL(DP), ALLOCATABLE :: epsilon_voigt(:,:) ! the strain tensor as a 6D array
                                            ! for each geometry
  REAL(DP) :: press=0.0_DP                  ! estimated pressure


  PUBLIC trans_epsilon, el_con, sigma_geo, epsilon_geo, apply_strain, &
         epsilon_voigt, compute_elastic_constants, print_elastic_constants, &
         compute_elastic_constants_adv, compute_elastic_constants_ene,   &
         el_compliances, compute_elastic_compliances, voigt_index, &
         print_elastic_compliances, print_strain, write_elastic, read_elastic,&
         macro_elasticity, print_macro_elasticity, el_cons_voigt, press, &
         print_sound_velocities, compute_sound

CONTAINS
!
SUBROUTINE trans_epsilon(eps_voigt, eps_tensor, flag)
!
!  This routine transforms the strain tensor from a one dimensional
!  vector with 6 components, to a 3 x 3 symmetric tensor and viceversa
!
!  flag
!   1      6   --> 3 x 3
!  -1    3 x 3 --> 6 
!
USE kinds, ONLY : DP
IMPLICIT NONE
REAL(DP) :: eps_voigt(6), eps_tensor(3,3)
INTEGER :: flag
INTEGER :: i, j

IF ( flag == 1 ) THEN
   eps_tensor(1,1) = eps_voigt(1)
   eps_tensor(1,2) = eps_voigt(6) * 0.5_DP
   eps_tensor(1,3) = eps_voigt(5) * 0.5_DP
   eps_tensor(2,2) = eps_voigt(2) 
   eps_tensor(2,3) = eps_voigt(4) * 0.5_DP
   eps_tensor(3,3) = eps_voigt(3) 
   DO i = 1, 3
      DO j = 1, i-1
         eps_tensor(i,j) = eps_tensor(j,i)
      END DO
   END DO
ELSEIF ( flag == -1 ) THEN
  eps_voigt(1) = eps_tensor(1,1)
  eps_voigt(2) = eps_tensor(2,2)
  eps_voigt(3) = eps_tensor(3,3)
  eps_voigt(4) = eps_tensor(2,3) * 2.0_DP
  eps_voigt(5) = eps_tensor(1,3) * 2.0_DP
  eps_voigt(6) = eps_tensor(1,2) * 2.0_DP
ELSE
   CALL errore('trans_epsilon', 'unknown flag', 1)
ENDIF

RETURN
END SUBROUTINE trans_epsilon

SUBROUTINE print_elastic_constants(elc, frozen_ions)
!
!  This routine writes on output the elastic constants
!
IMPLICIT NONE
REAL(DP), INTENT(IN) :: elc(6,6)
LOGICAL, INTENT(IN) :: frozen_ions
INTEGER :: i, j

WRITE(stdout,'(/,20x,40("-"),/)')
IF (frozen_ions) THEN
   WRITE(stdout, '(/,5x,"Frozen ions")')
ELSE
   WRITE(stdout, *)
ENDIF

IF (press /= 0.0_DP) THEN
   WRITE(stdout,'(5x,"Estimated pressure (kbar) ",f14.5)') press * ry_kbar
   WRITE(stdout,'(5x,"Elastic constants defined from stress-strain",f14.5)')
END IF

WRITE(stdout,'(5x,"Elastic constants C_ij (kbar) ")')
WRITE(stdout,'(4x,"i j=",i9,5i12)') (i, i=1,6)

DO i=1,6
   WRITE(stdout,'(i5, 6f12.5)') i, (elc(i,j), j=1,6)
ENDDO

WRITE(stdout,'(/,5x,"1 bar = 10^5 Pa; 10 kbar = 1 GPa; 1 atm = 1.01325 bar;&
             & 1 Pa = 1 N/m^2")')
WRITE(stdout,'(5x,"1 Pa = 10 dyn/cm^2; 1 Mbar = 10^11 Pa")')
WRITE(stdout,'(5x,"1 torr = 1 mm Hg = 1/760 bar = 7.5006 x 10^-3 Pa",/)')

RETURN
END SUBROUTINE print_elastic_constants

SUBROUTINE print_elastic_compliances(els, frozen_ions)
!
!  This routine writes on output the elastic compliances
!
IMPLICIT NONE
REAL(DP), INTENT(IN) :: els(6,6)
LOGICAL, INTENT(IN) :: frozen_ions
INTEGER :: i, j

WRITE(stdout,'(/,20x,40("-"),/)')
IF (frozen_ions) THEN
   WRITE(stdout, '(/,5x,"Frozen ions")')
ELSE
   WRITE(stdout, *)
ENDIF
WRITE(stdout,'(5x,"Elastic compliances  S_ij (1/Mbar) ")')
WRITE(stdout,'(4x,"i j=",i9,5i12)') (i, i=1,6)

DO i=1,6
   WRITE(stdout,'(i5, 6f12.5)') i, (els(i,j)*1.E3_DP, j=1,6)
ENDDO
WRITE(stdout,'(/,5x,"1/Mbar = 1/10^{11} Pa; 1 Pa = 1 N/m^2")')

RETURN
END SUBROUTINE print_elastic_compliances 

SUBROUTINE write_elastic(filename)
!
!  This routines writes the elastic constants and compliances on file.
!  It must be called after computing the elastic constant
!
IMPLICIT NONE
CHARACTER(LEN=*), INTENT(IN) :: filename
INTEGER :: outunit, ios, i, j

outunit=25
IF (ionode) &
OPEN(UNIT=outunit, FILE=TRIM(filename), STATUS='unknown', FORM='formatted', &
     ERR=100, IOSTAT=ios)
100 CONTINUE

IF (ionode) THEN
   DO i=1,6
      WRITE(outunit,'(4e20.10)') (el_con(i,j), j=1,6)
   ENDDO
   WRITE(outunit,*)
   DO i=1,6
      WRITE(outunit,'(4e20.10)') (el_compliances(i,j), j=1,6)
   END DO
   CLOSE(outunit)
ENDIF

RETURN
END SUBROUTINE write_elastic

SUBROUTINE read_elastic(filename, exists)
!
!  This routines reads the elastic constants and compliances from file.
!
IMPLICIT NONE
CHARACTER(LEN=*), INTENT(IN) :: filename
LOGICAL, INTENT(OUT) :: exists
INTEGER :: inunit, ios, i, j

inunit=25
IF (ionode) &
   OPEN(UNIT=inunit, FILE=TRIM(filename), STATUS='old', FORM='formatted', &
       ERR=100, IOSTAT=ios)
100 CALL mp_bcast(ios,ionode_id,intra_image_comm)
IF (ios /= 0) THEN
   exists=.FALSE.
   RETURN
ENDIF
exists=.TRUE.

IF (ionode) THEN
   DO i=1,6
      READ(inunit,'(4e20.10)') (el_con(i,j), j=1,6)
   ENDDO
   READ(inunit,*)
   DO i=1,6
      READ(inunit,'(4e20.10)') (el_compliances(i,j), j=1,6)
   END DO
   CLOSE(inunit)
ENDIF
CALL mp_bcast(el_con,ionode_id,intra_image_comm)
CALL mp_bcast(el_compliances,ionode_id,intra_image_comm)

RETURN
END SUBROUTINE read_elastic

SUBROUTINE compute_elastic_constants(sigma_geo, epsil_geo, nwork, ngeo, &
                                     ibrav, laue, m1)
!
!  This routine computes the elastic constants by fitting the stress-strain
!  relation with a second order polynomial. This is calculated
!  on the basis of the Bravais lattice and Laue type.
!
IMPLICIT NONE
REAL(DP), INTENT(IN) :: sigma_geo(3,3,nwork), epsil_geo(3,3,nwork)
INTEGER, INTENT(IN) :: nwork, ngeo, ibrav, laue, m1

el_con=0.0_DP
SELECT CASE (laue)
   CASE (16)
!
!   monoclinic case. Common components
!
!  c_11 
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
!
!  c_12
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
! c_13
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
!
! c_22
!
      CALL el_cons_ij(2, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
! c_23
!
      CALL el_cons_ij(3, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,3) = el_con(3,2)
!
! c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
!
! c_44
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                  sigma_geo(1,1,3*ngeo+1), m1)
!
! c_55
!
      CALL el_cons_ij(5, 5, ngeo, epsil_geo(1,1,4*ngeo+1), &
                                  sigma_geo(1,1,4*ngeo+1), m1)
!
! c_66
!
      CALL el_cons_ij(6, 6, ngeo, epsil_geo(1,1,5*ngeo+1), &
                                  sigma_geo(1,1,5*ngeo+1), m1)
!
!  c15
!
      IF (ibrav==-12.OR.ibrav==-13) THEN
!
!  monoclinic case unique axis b
!
!
!  c15
!
         CALL el_cons_ij(5, 1, ngeo, epsil_geo, sigma_geo, m1)
         el_con(1,5) = el_con(5,1)
!
!  c25
!
         CALL el_cons_ij(5, 2, ngeo, epsil_geo(1,1,ngeo+1), &
                                     sigma_geo(1,1,ngeo+1), m1)
         el_con(2,5) = el_con(5,2)
!
!  c35
!
         CALL el_cons_ij(5, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                     sigma_geo(1,1,2*ngeo+1), m1)
         el_con(3,5) = el_con(5,3)
!
!  c46
!
         CALL el_cons_ij(6, 4, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                     sigma_geo(1,1,3*ngeo+1), m1)
         el_con(4,6) = el_con(6,4)

      ELSE
!
!  monoclinic case unique axis c
!
!  c16
!
         CALL el_cons_ij(6, 1, ngeo, epsil_geo, sigma_geo, m1)
         el_con(1,6) = el_con(6,1)
!
!  c26
!
         CALL el_cons_ij(6, 2, ngeo, epsil_geo(1,1,ngeo+1), &
                                     sigma_geo(1,1,ngeo+1), m1)
         el_con(2,6) = el_con(6,2)
!
!  c36
!
         CALL el_cons_ij(6, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                     sigma_geo(1,1,2*ngeo+1), m1)

         el_con(3,6) = el_con(6,3)
!
!  c45
!
         CALL el_cons_ij(5, 4, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                     sigma_geo(1,1,2*ngeo+1), m1)
         el_con(4,5) = el_con(5,4)

      END IF
   CASE (20)
!
!  orthorombic case
!
!  c_11 
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
!
!  c_12
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
! c_13
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
!
! c_22
!
      CALL el_cons_ij(2, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
! c_23
!
      CALL el_cons_ij(3, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,3) = el_con(3,2)
!
! c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1, 1, 2*ngeo+1), &
                                  sigma_geo(1, 1, 2*ngeo+1), m1)
!
! c_44
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1, 1, 3*ngeo+1), &
                                  sigma_geo(1, 1, 3*ngeo+1), m1)
!
! c_55
!
      CALL el_cons_ij(5, 5, ngeo, epsil_geo(1, 1, 4*ngeo+1), &
                                  sigma_geo(1, 1, 4*ngeo+1), m1)
!
! c_66
!
      CALL el_cons_ij(6, 6, ngeo, epsil_geo(1, 1, 5*ngeo+1), &
                                  sigma_geo(1, 1, 5*ngeo+1), m1)

   CASE (18,22)
!
!  tetragonal case. We start with the 4/mmm class
!
!  c_11 = c_22
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(2,2) = el_con(1,1)
!
!  c_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
! c_13
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
      el_con(2,3) = el_con(3,1)
      el_con(3,2) = el_con(3,1)
!
! c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
! c_44 = c_55
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(5,5) = el_con(4,4)
!
! c_66 
!
      CALL el_cons_ij(6, 6, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                  sigma_geo(1,1,3*ngeo+1), m1)
!
!   This part is non zero only on the 4/m Laue class
!
      IF (laue==18) THEN
!
! c_16, c_26
!
         CALL el_cons_ij(6, 1, ngeo, epsil_geo, sigma_geo, m1)
         el_con(1,6) = el_con(6,1)
         el_con(2,6) = - el_con(1,6)
         el_con(6,2) = el_con(2,6)
     END IF
   CASE (25,27)
!
!  trigonal case. We start with the common components
!
!
!  c_11 = c_22
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(2,2) = el_con(1,1)
!
!  c_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
!  c_13 
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
!
!  c_14 
!
      CALL el_cons_ij(4, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,4) = el_con(4,1)
      el_con(2,4) = -el_con(1,4)
      el_con(4,2) = el_con(2,4)
      el_con(5,6) = el_con(1,4)
      el_con(6,5) = el_con(5,6)
!
!  c_33 
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,ngeo+1), &
                                  sigma_geo(1,1,ngeo+1), m1)
!
!  c_44 = c_55
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(5,5) = el_con(4,4)

      el_con(6,6) = 0.5_DP * ( el_con(1,1) - el_con(1,2) )
!
!   This part need to be computed only in the -3 class
!
!
!  c_15 
!
      IF (laue==27) THEN
         CALL el_cons_ij(1, 5, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                     sigma_geo(1,1,3*ngeo+1), m1)
         el_con(5,1) = el_con(1,5)
         el_con(2,5) = -el_con(1,5)
         el_con(5,2) = el_con(2,5)
         el_con(4,6) = el_con(2,5)
         el_con(6,4) = el_con(4,6)
      END IF

   CASE (19,23)
!
!  hexagonal case, all classes
!
!  c_11 = c_22
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(2,2) = el_con(1,1)
!
!  c_12
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
!  c_13
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
      el_con(2,3) = el_con(1,3)
      el_con(3,2) = el_con(2,3)
!
!  c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
!  c_44
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(5,5)=el_con(4,4) 
      el_con(6,6)=0.5_DP*(el_con(1,1)-el_con(1,2))

   CASE (29,32)
!
!  cubic case
!
!  c_11 = c_22 = c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,1) = el_con(3,3)
      el_con(2,2) = el_con(3,3)
!
! c_12 = c_13 = c_23
!
      CALL el_cons_ij(1, 3, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(1,3)
      el_con(2,1) = el_con(1,2)
      el_con(3,1) = el_con(1,3)
      el_con(2,3) = el_con(1,2)
      el_con(3,2) = el_con(2,3)
!
! c_44 = c_55 = c_66
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(5,5)=el_con(4,4)
      el_con(6,6)=el_con(4,4)

   CASE DEFAULT
!
!  generic implementation, quite slow but should work with any lattice.
!  Computes all the elements of the elastic constants matrix, requires
!  6 * ngeo_strain self consistent calculations
!
!  c_11 
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
!
!  c_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
!  c_13 
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
!
!  c_14 
!
      CALL el_cons_ij(4, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,4) = el_con(4,1)
!
!  c_15 
!
      CALL el_cons_ij(5, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,5) = el_con(5,1)
!
!  c_16 
!
      CALL el_cons_ij(6, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,6) = el_con(6,1)
!
!  c_22 
!
      CALL el_cons_ij(2, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
!  c_23 
!
      CALL el_cons_ij(3, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,3) = el_con(3,2)
!  
!  c_24 
!
      CALL el_cons_ij(4, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,4) = el_con(4,2)
!  
!  c_25 
!
      CALL el_cons_ij(5, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,5) = el_con(5,2)
!  
!  c_26 
!
      CALL el_cons_ij( 6, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,6) = el_con(6,2)
!  
!  c_33 
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
!  
!  c_34 
!
      CALL el_cons_ij(4, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(3,4) = el_con(4,3)
!  
!  c_35 
!
      CALL el_cons_ij(5, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(3,5) = el_con(5,3)
!  
!  c_36 
!
      CALL el_cons_ij(6, 3, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
      el_con(3,6) = el_con(6,3)
!  
!  c_44
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                  sigma_geo(1,1,3*ngeo+1), m1)
!  
!  c_45 
!
      CALL el_cons_ij(5, 4, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                sigma_geo(1,1,3*ngeo+1), m1)
      el_con(4,5) = el_con(5,4)
!  
!  c_46 
!
      CALL el_cons_ij(6, 4, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                  sigma_geo(1,1,3*ngeo+1), m1)
      el_con(4,6) = el_con(6,4)
!  
!  c_55 
!
      CALL el_cons_ij(5, 5, ngeo, epsil_geo(1,1,4*ngeo+1), &
                                  sigma_geo(1,1,4*ngeo+1), m1)
!  
!  c_56 
!
      CALL el_cons_ij(6, 5, ngeo, epsil_geo(1,1,4*ngeo+1), &
                                  sigma_geo(1,1,4*ngeo+1), m1)
      el_con(5,6) = el_con(6,5)
!  
!  c_66 
!
      CALL el_cons_ij(6, 6, ngeo, epsil_geo(1,1,5*ngeo+1), &
                                  sigma_geo(1,1,5*ngeo+1), m1)
END SELECT
el_con = el_con * ry_kbar

RETURN
END SUBROUTINE compute_elastic_constants

SUBROUTINE compute_elastic_constants_adv(sigma_geo, epsil_geo, nwork, ngeo, &
                                              ibrav, laue, rot_mat, m1)
!
!  This routine computes the elastic constants by fitting the stress-strain
!  relation with a second order polynomial. This is calculated
!  on the basis of the Bravais lattice and Laue type.
!
USE rotate, ONLY : rotate_tensors2
IMPLICIT NONE
REAL(DP), INTENT(IN) :: epsil_geo(3,3,nwork),  rot_mat(3,3,nwork)
REAL(DP), INTENT(INOUT) :: sigma_geo(3,3,nwork)
INTEGER, INTENT(IN) :: nwork, ngeo, ibrav, laue, m1
REAL(DP) :: sigma_aux(3,3)
INTEGER :: i, j, igeo, iwork

el_con=0.0_DP
!
!  If the sigma_geo tensor is not in the cartesian axis of the unperturbed
!  solid, bring it to this basis.
!
DO iwork=1,nwork
   sigma_aux(:,:)=sigma_geo(:,:,iwork)
   CALL rotate_tensors2(rot_mat(1,1,iwork), 1, sigma_aux, &
                                              sigma_geo(1,1,iwork),-1)
END DO

SELECT CASE (laue)
   CASE (29,32)
!
!  cubic case
!
!  c_11 = c_22 = c_33
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,1) = el_con(3,3)
      el_con(2,2) = el_con(3,3)
!
! c_12 = c_13 = c_23
!
      CALL el_cons_ij(1, 3, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(1,3)
      el_con(2,1) = el_con(1,2)
      el_con(3,1) = el_con(1,3)
      el_con(2,3) = el_con(1,2)
      el_con(3,2) = el_con(2,3)
!
! c_44 = c_55 = c_66
!
      CALL el_cons_ij(4, 4, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(5,5)=el_con(4,4)
      el_con(6,6)=el_con(4,4)
   CASE(23)
!
!  hexagonal case
!
!     C_11 = C_22

      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(2,2) = el_con(1,1)
!
!     C_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
      el_con(6,6) = 0.5_DP * (el_con(1,1) - el_con(1,2))
!
!     C_31 = C_32
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
      el_con(2,3) = el_con(3,1)
      el_con(3,2) = el_con(2,3)
!
!   C_33,
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!      CALL el_cons_ij(1, 3, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!      CALL el_cons_ij(2, 3, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
!   C_44
!
      CALL el_cons_ij(5, 5, ngeo, epsil_geo(1,1,2*ngeo+1), sigma_geo(1,1,2*ngeo+1), m1)
      el_con(4,4) = el_con(5,5)

   CASE(18,22)
!
!  tetragonal case
!
!     C_33 
!
      CALL el_cons_ij(3, 3, ngeo, epsil_geo, sigma_geo, m1)
!
!     C_11 = C_22 
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,2) = el_con(1,1)
!
!     C_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(1,2) = el_con(2,1)
!
!     C_13 = C_23
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(1,3) = el_con(3,1)
      el_con(2,3) = el_con(3,1)
      el_con(3,2) = el_con(2,3)
!
!     C_66 
!
      CALL el_cons_ij(6, 6, ngeo, epsil_geo(1,1,2*ngeo+1), &
                                  sigma_geo(1,1,2*ngeo+1), m1)
!
!     C_55 = C_44
!
      CALL el_cons_ij(5, 5, ngeo, epsil_geo(1,1,3*ngeo+1), &
                                  sigma_geo(1,1,3*ngeo+1), m1)
      el_con(4,4) = el_con(5,5)

      IF (laue==18) THEN
!
! c_16, c_26
!
         CALL el_cons_ij(6, 1, ngeo, epsil_geo, sigma_geo, m1)
         el_con(1,6) = el_con(6,1)
         el_con(2,6) = - el_con(1,6)
         el_con(6,2) = el_con(2,6)
     END IF

   CASE(20,0)
!
!  orthorombic case
!
!     C_11 
!
      CALL el_cons_ij(1, 1, ngeo, epsil_geo, sigma_geo, m1)
!
!     C_12 
!
      CALL el_cons_ij(2, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,2) = el_con(2,1)
!
!     C_13 
!
      CALL el_cons_ij(3, 1, ngeo, epsil_geo, sigma_geo, m1)
      el_con(1,3) = el_con(3,1)
!
!     C_22 
!
      CALL el_cons_ij(2, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
!
!     C_23 
!
      CALL el_cons_ij(3, 2, ngeo, epsil_geo(1,1,ngeo+1), sigma_geo(1,1,ngeo+1), m1)
      el_con(2,3) = el_con(3,2)
!
!     C_33 
!
      CALL el_cons_ij(3,3,ngeo,epsil_geo(1,1,2*ngeo+1),sigma_geo(1,1,2*ngeo+1), m1)
!
!     C_66
!
      CALL el_cons_ij(6,6,ngeo,epsil_geo(1,1,3*ngeo+1),sigma_geo(1,1,3*ngeo+1), m1)
!
!     C_55
!
      CALL el_cons_ij(5,5,ngeo,epsil_geo(1,1,4*ngeo+1),sigma_geo(1,1,4*ngeo+1), m1)
!
!     C_44
!
      CALL el_cons_ij(4,4,ngeo,epsil_geo(1,1,5*ngeo+1),sigma_geo(1,1,5*ngeo+1), m1)

   CASE DEFAULT
      CALL errore('compute_elastic_constants_adv',&
                                   'advanced case not available',1)
END SELECT
el_con = el_con * ry_kbar

RETURN
END SUBROUTINE compute_elastic_constants_adv

SUBROUTINE compute_elastic_constants_ene(energy_geo, epsil_geo, nwork, ngeo, &
                                              ibrav, laue, omega, m1)
!
!  This routine computes the elastic constants by fitting the total
!  energy-strain relation with a second order polynomial. This is calculated
!  on the basis of the Bravais lattice and Laue type.
!  The pressure is estimated and the calculated elastic constants are
!  corrected to keep into account for the difference between stress-strain
!  coefficients and energy coefficients. The output of this routine are
!  the elastic constants defined from the linear relationship between
!  stress and strain.
!
USE quadratic_surfaces, ONLY : polifit, write_poli
IMPLICIT NONE
REAL(DP), INTENT(IN) :: epsil_geo(3,3,nwork), omega
REAL(DP), INTENT(IN) :: energy_geo(nwork)
INTEGER, INTENT(IN) :: nwork, ngeo, ibrav, laue, m1
REAL(DP) :: alpha(m1)
REAL(DP) :: x(ngeo), y(ngeo), b0, a0, x0(6), der(6), aux
INTEGER :: i, j, idata, iwork, base_data

el_con=0.0_DP

SELECT CASE (laue)
   CASE (29,32)
!
!  cubic case
!
!
!   first part: uniform strain
!   alpha(3) is multiplied by 2 because of the definition of the quadratic
!   interpolating polynomial. The second derivative of the polynomial with
!   respect to x is 2.0 * alpha(3)
!
      WRITE(stdout,'(/,5x,"Fitting ",i3," functions,",i4," data per function,&
                          & number of data =",i5)') nwork/ngeo, ngeo, nwork
      WRITE(stdout,'(/,5x,"C_11+2C_12")') 
      WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
      DO idata=1,ngeo
         x(idata)=epsil_geo(1,1,idata)
         y(idata)=energy_geo(idata) 
         WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
      ENDDO
      
      CALL polifit( x, y, ngeo, alpha, m1 )
      CALL write_poli(alpha,m1)

      press=- alpha(2) / 3.0_DP / omega
      WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
      b0 = 1.0_DP / 3.0_DP / omega * ( 2.0_DP * alpha(3) ) +  &
           2.0_DP * press

      WRITE(stdout,'(5x,"Bulk Modulus",f18.5," kbar")') b0/3.0_DP*ry_kbar
!
!   second part: epsilon_3
!
      WRITE(stdout,'(/,5x,"C_11")') 
      WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
      DO idata=1,ngeo
         x(idata)=epsil_geo(3,3,ngeo+idata)
         y(idata)=energy_geo(ngeo+idata) 
         WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
      ENDDO

      CALL polifit( x, y, ngeo, alpha, m1 )
      CALL write_poli(alpha,m1)

      el_con(1,1) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )
      el_con(2,2) = el_con(1,1)
      el_con(3,3) = el_con(1,1)
!
! c_12 = c_13 = c_23
!
      el_con(1,2) = 0.5_DP* (b0 - el_con(1,1)) 
      el_con(2,1) = el_con(1,2)
      el_con(3,1) = el_con(1,2)
      el_con(1,3) = el_con(1,2)
      el_con(2,3) = el_con(1,2)
      el_con(3,2) = el_con(1,2)
!
! c_44 = c_55 = c_66  For these components \epsilon_4 is twice the strain
! tensor
!
      WRITE(stdout,'(/,5x,"C_44")') 
      WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
      DO idata=1,ngeo
         x(idata)=epsil_geo(2,3,2*ngeo+idata)
         y(idata)=energy_geo(2*ngeo+idata) 
         WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
      ENDDO

      CALL polifit( x, y, ngeo, alpha, m1 )
      CALL write_poli(alpha,m1)

      el_con(4,4) = 0.25_DP / 3.0_DP / omega * ( 2.0_DP * alpha(3) ) &
                        - 0.5_DP * press

      el_con(5,5)=el_con(4,4)
      el_con(6,6)=el_con(4,4)

   CASE (23)
!
!  hexagonal case
!
         WRITE(stdout,'(/,5x,"Fitting ",i3," functions,",i4, &
                          &" data per function, number of data =",i5)') &
                                                       nwork/ngeo, ngeo, nwork
         WRITE(stdout,'(5x,"C_11")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,idata)
            y(idata)=energy_geo(idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(1,1) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )
         el_con(2,2) = el_con(1,1)

         WRITE(stdout,'(5x,"C_33")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(3,3,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(3,3) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )

         WRITE(stdout,'(5x,"C_13")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=2*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega / 2.0_DP
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         aux = 1.0_DP / omega * ( 2.0_DP * alpha(3) )
         el_con(1,3) = (aux - el_con(1,1) - el_con(3,3)) * 0.5_DP + press
         el_con(3,1) = el_con(1,3)
         el_con(2,3) = el_con(1,3)
         el_con(3,2) = el_con(2,3)

         WRITE(stdout,'(5x,"C_12")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=3*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega / 3.0_DP
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         aux = 1.0_DP / omega * ( 2.0_DP * alpha(3) )
!
!  pressure is subtracted added 3 times because in the expression we should
!  use C, while el_con(1,3) is B_13. To bring it to C_13 we must subtract P
!  so adding 2P we get C_12, to print in output B_12 we add another P.
!
         el_con(1,2) = (aux - 2.0_DP * el_con(1,1) - el_con(3,3) &
                            - 4.0_DP * el_con(1,3) ) * 0.5_DP + 3.0_DP * press
         el_con(2,1) = el_con(1,2)


         WRITE(stdout,'(5x,"C_55")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=4*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,3,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(5,5) = 0.25_DP / omega * ( 2.0_DP * alpha(3) ) - 0.5_DP * press
         el_con(4,4) = el_con(5,5)

         el_con(6,6) = (el_con(1,1) - el_con(1,2)) * 0.5_DP

   CASE(18,22)
!
!  tetragonal case
!
!     C_33 
!
         WRITE(stdout,'(/,5x,"Fitting ",i3," functions,",i4,&
                         &" data per function, number of data =",i5)') &
                                                  nwork/ngeo, ngeo, nwork
         WRITE(stdout,'(5x,"C_33")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         DO idata=1,ngeo
            x(idata)=epsil_geo(3,3,idata)
            y(idata)=energy_geo(idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(3,3) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )

         WRITE(stdout,'(5x,"C_11")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         el_con(1,1) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )
         el_con(2,2) = el_con(1,1)

         WRITE(stdout,'(5x,"C_12")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=2*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         el_con(1,2) = 1.0_DP/omega*( 2.0_DP*alpha(3) )*0.5_DP-el_con(1,1) + &
                                                                     press 
         el_con(2,1) = el_con(1,2)

         WRITE(stdout,'(5x,"C_13")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=3*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(1,3) = (1.0_DP/omega*(2.0_DP*alpha(3)) - el_con(3,3) &
                                              -el_con(1,1)) * 0.5_DP + press
         el_con(3,1) = el_con(1,3)
         el_con(2,3) = el_con(1,3)
         el_con(3,2) = el_con(2,3)


         WRITE(stdout,'(5x,"C_66")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=4*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,2,base_data+idata) 
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(6,6) = 0.25_DP/omega*(2.0_DP*alpha(3)) - 0.5_DP * press

         WRITE(stdout,'(5x,"C_55")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 5 * ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,3,base_data+idata) 
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(5,5) = 0.25_DP/omega*(2.0_DP*alpha(3)) - 0.5_DP * press
         el_con(4,4) = el_con(5,5)
   CASE(20)
         WRITE(stdout,'(/,5x,"Fitting ",i3," functions,",i4, &
                       &" data per function, number of data =",i5)') &
                                                      nwork/ngeo, ngeo, nwork
         WRITE(stdout,'(5x,"C_11")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,idata)
            y(idata)=energy_geo(idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(1,1) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )

         WRITE(stdout,'(5x,"C_22")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(2,2,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(2,2) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )

         WRITE(stdout,'(5x,"C_33")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data=2*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(3,3,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(3,3) = 1.0_DP / omega * ( 2.0_DP * alpha(3) )

         WRITE(stdout,'(5x,"C_12")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 3*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(1,2) = (1.0_DP / omega * ( 2.0_DP * alpha(3) ) - el_con(1,1) &
                                   - el_con(2,2) ) * 0.5_DP + press
         el_con(2,1)=el_con(1,2)

         WRITE(stdout,'(5x,"C_13")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 4*ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,1,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(1,3) = (1.0_DP / omega * ( 2.0_DP * alpha(3) ) - el_con(1,1) &
                                   - el_con(3,3) ) * 0.5_DP + press
         el_con(3,1)=el_con(1,3)

         WRITE(stdout,'(5x,"C_23")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 5 * ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(2,2,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         press=- alpha(2) / omega
         WRITE(stdout,'(/,5x,"Estimated pressure",f12.5," kbar")') press*ry_kbar
         el_con(2,3) = (1.0_DP / omega * ( 2.0_DP * alpha(3) ) - el_con(2,2) &
                                   - el_con(3,3) ) * 0.5_DP + press
         el_con(3,2)=el_con(2,3)

         WRITE(stdout,'(5x,"C_66")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 6 * ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,2,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(6,6) = 0.25_DP / omega * ( 2.0_DP * alpha(3) ) - 0.5_DP * press

         WRITE(stdout,'(5x,"C_55")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 7 * ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(1,3,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(5,5) = 0.25_DP / omega * ( 2.0_DP * alpha(3) ) - 0.5_DP * press

         WRITE(stdout,'(5x,"C_44")')
         WRITE(stdout,'(8x,"strain",7x,"Energy (Ry)")') 
         base_data = 8 * ngeo
         DO idata=1,ngeo
            x(idata)=epsil_geo(2,3,base_data+idata)
            y(idata)=energy_geo(base_data+idata)
            WRITE(stdout,'(5x,f10.6,f20.13)') x(idata), y(idata)
         ENDDO

         CALL polifit( x, y, ngeo, alpha, m1 )
         CALL write_poli(alpha,m1)

         el_con(4,4) = 0.25_DP / omega * ( 2.0_DP * alpha(3) ) - 0.5_DP * press

   CASE DEFAULT
      CALL errore('compute_elastic_constants_ene',&
                                   'energy case not available',1)
END SELECT
el_con = el_con * ry_kbar

RETURN
END SUBROUTINE compute_elastic_constants_ene


SUBROUTINE apply_strain(a, b, epsil)
!
!  This routine receives as input a vector a and a strain tensor \epsil and
!  gives as output a vector b = a + \epsil a 
!
IMPLICIT NONE
REAL(DP), INTENT(IN) :: a(3), epsil(3,3)
REAL(DP), INTENT(OUT) :: b(3)
INTEGER :: i

b = a 
DO i=1,3
   b(:)=b(:) + epsil(:,i) * a(i)
ENDDO

RETURN
END SUBROUTINE apply_strain

SUBROUTINE compute_elastic_compliances(cmn,smn)
!
! This routine receives as input the elastic constants matrix and computes 
! its inverse, the elastic compliance matrix
!
USE kinds, ONLY : DP
USE matrix_inversion, ONLY : invmat
IMPLICIT NONE

REAL(DP), INTENT(INOUT) :: cmn(6,6)
REAL(DP), INTENT(INOUT) :: smn(6,6)

CALL invmat(6, cmn, smn)

RETURN
END SUBROUTINE compute_elastic_compliances

SUBROUTINE print_strain(strain)
IMPLICIT NONE
REAL(DP), INTENT(IN) :: strain(3,3)
INTEGER :: i, j

WRITE(stdout,'(/,5x,"Applying the following strain")')  
DO i=1,3
   WRITE(stdout,'(5x, "(",2(f12.5,","),f12.5,"  )")') (strain(i,j), j=1,3)
ENDDO
WRITE(stdout,'(/)')

RETURN
END SUBROUTINE print_strain

SUBROUTINE voigt_index(m, n, mn, flag)
!
!  If flag is .true., this routine receives two indeces 1<= m, n <=3 and
!  gives the voigt index 1<=mn<=6 corresponding to these two indices,
!  If flag is .false. it receive mn and gives as output m and n, m<=n
!
IMPLICIT NONE
INTEGER, INTENT(INOUT) :: m, n, mn
LOGICAL, INTENT(IN) :: flag 
INTEGER :: voigt(3,3)
DATA voigt / 1,  6,  5, 6, 2, 4, 5, 4, 3 / 

IF (flag) THEN
   IF (m<1.OR.m>3.OR.n<1.OR.n>3) &
      CALL errore('voigt_index','m or n out or range',1)
   mn=voigt(m,n) 
ELSE
   SELECT CASE (mn)
      CASE(1)
         m=1
         n=1
      CASE(2)
         m=2
         n=2
      CASE(3)
         m=3
         n=3
      CASE(4)
         m=2
         n=3
      CASE(5)
         m=1
         n=3
      CASE(6)
         m=1
         n=2
      CASE DEFAULT
         CALL errore('voigt_index','mn out of range',1)
   END SELECT
ENDIF

RETURN
END SUBROUTINE voigt_index

SUBROUTINE el_cons_ij(pq, mn, ngeo, epsil_geo, sigma_geo, m1)
USE kinds, ONLY : DP
USE quadratic_surfaces, ONLY : polifit, write_poli

IMPLICIT NONE
INTEGER, INTENT(IN) :: mn, pq, ngeo
REAL(DP), INTENT(IN) :: epsil_geo(3,3,ngeo), sigma_geo(3,3,ngeo)
INTEGER :: igeo, m, n, p, q, mnin, pqin
INTEGER :: m1                  ! number of polynomial coefficients
REAL(DP) :: alpha(m1)          ! the polynomial coefficients
REAL(DP) :: x(ngeo), y(ngeo)

WRITE(stdout,'(/,20x,40("-"),/)')
mnin=mn
CALL voigt_index(m,n,mnin,.FALSE.)
pqin=pq
CALL voigt_index(p,q,pqin,.FALSE.)
WRITE(stdout,'(/,5x,"Elastic constant ",2i5)') pq, mn
WRITE(stdout,'(/,10x,"strain",7x,"stress (kbar)")') 
DO igeo=1,ngeo
   x(igeo)=epsil_geo(m,n,igeo)
   y(igeo)=sigma_geo(p,q,igeo)
   WRITE(stdout,'(2f18.10)') x(igeo), y(igeo)*ry_kbar
ENDDO
CALL polifit( x, y, ngeo, alpha, m1 )
CALL write_poli(alpha,m1)
el_con(pq, mn) = -alpha(2)
!
!  The elastic constant tensor relates the stress to the strain in voigt
!  notation. Since e_23 = 0.5 e_4, e_13 = 0.5 e_5, e_12 = 0.5 e_6 we have
!  to divide by 2 the elements of the elastic constant calculated with 
!  off diagonal strain components
!
IF (m /= n) el_con(pq, mn) = el_con(pq, mn) * 0.5_DP

RETURN
END SUBROUTINE el_cons_ij

SUBROUTINE el_cons_voigt(elconv, elcon, flag)
!
!  This routine transform an elastic constant tensor in the 6x6 Voigt
!  form into a four index tensor 3x3x3x3 (flag=.false.) or viceversa 
!  (flag=.true.)
!
USE kinds, ONLY : DP
IMPLICIT NONE

REAL(DP), INTENT(INOUT) :: elcon(3,3,3,3)
REAL(DP), INTENT(INOUT) :: elconv(6,6)
LOGICAL, INTENT(IN) :: flag

INTEGER :: ij, mn, i, j, m, n

IF (flag) THEN
   elconv=0.0_DP
   DO ij=1,6
      CALL voigt_index(i,j,ij,.FALSE.)
      DO mn=1,6
         CALL voigt_index(m,n,mn,.FALSE.)
         elconv(ij,mn) = elcon(i,j,m,n) 
      ENDDO
   ENDDO
ELSE
   elcon=0.0_DP
   DO i=1,3
      DO j=1,3
         CALL voigt_index(i,j,ij,.TRUE.)
         DO m=1,3
            DO n=1,3
               CALL voigt_index(m,n,mn,.TRUE.)
               elcon(i,j,m,n) = elconv(ij,mn)
            ENDDO
         ENDDO
      ENDDO
   ENDDO
ENDIF

RETURN
END SUBROUTINE el_cons_voigt

SUBROUTINE macro_elasticity( ibrav, cmn, smn, b0v,  &
                             e0v, g0v, nuv, b0r, e0r, g0r, nur )
!
!  This routine collects some relationships that link the elastic constants 
!  to the parameters of the macroscopic elasticity and to
!  the polycristalline averages.
!  
!  It receives as input the elastic constants and compliances and gives
!  as output:
!
!  b0v : The Voigt average of the bulk modulus
!  e0v : The Voigt average Young modulus
!  g0v : The Voigt average Shear modulus
!  nuv : The Voigt average Poisson ratio 
!  b0r : The Reuss average of the bulk modulus
!  e0r : The Reuss average Young modulus
!  g0r : The Reuss average Shear modulus
!  nur : The Reuss average Poisson ratio 
!  
USE kinds, ONLY : DP
IMPLICIT NONE
INTEGER, INTENT(IN) :: ibrav
REAL(DP), INTENT(IN) :: cmn(6,6), smn(6,6)
REAL(DP), INTENT(OUT) :: b0v, e0v, g0v, nuv, b0r, e0r, g0r, nur
REAL(DP) :: c11v, c12v, c44v


c11v= (3.0_DP / 15.0_DP)*(cmn(1,1) + cmn(2,2) + cmn(3,3)) +   &
      (2.0_DP / 15.0_DP)*(cmn(1,2) + cmn(2,3) + cmn(1,3)) +   &
      (4.0_DP / 15.0_DP)*(cmn(4,4) + cmn(5,5) + cmn(6,6)) 
c12v= (1.0_DP / 15.0_DP)*(cmn(1,1) + cmn(2,2) + cmn(3,3)) +   &
      (4.0_DP / 15.0_DP)*(cmn(1,2) + cmn(2,3) + cmn(1,3)) -   &
      (2.0_DP / 15.0_DP)*(cmn(4,4) + cmn(5,5) + cmn(6,6)) 
c44v= (c11v-c12v)*0.5_DP
b0v=( c11v + 2.0_DP * c12v) / 3.0_DP
e0v = (c11v - c12v)*(c11v+2.0_DP*c12v) / (c11v+c12v)
g0v = c44v
nuv = e0v/ (2.0_DP * g0v) - 1.0_DP
b0r=1.0_DP/(smn(1,1) + smn(2,2) + smn(3,3) + &
    2.0_DP*smn(1,2) + 2.0_DP*smn(1,3)+ 2.0_DP*smn(2,3))
e0r = 15.0_DP /( 3.0_DP *(smn(1,1) + smn(2,2) + smn(3,3)) +  &
                 2.0_DP *(smn(1,2) + smn(2,3) + smn(1,3)) +  &
                         (smn(4,4) + smn(5,5) + smn(6,6)) )
g0r = 15.0_DP /( 4.0_DP *(smn(1,1) + smn(2,2) + smn(3,3)) - &
                 4.0_DP *(smn(1,2) + smn(2,3) + smn(1,3)) + &
                 3.0_DP *(smn(4,4) + smn(5,5) + smn(6,6)) )
nur = e0r/ (2.0_DP * g0r) - 1.0_DP

RETURN
END SUBROUTINE macro_elasticity

SUBROUTINE print_macro_elasticity(ibrav, cmn, smn, macro_el, flag)
!
! If flag is .true. print the macroscopic elastic properties. If it
! is false it only computes them
!
USE kinds, ONLY : DP
IMPLICIT NONE
REAL(DP), INTENT(IN) :: cmn(6,6), smn(6,6)
REAL(DP), INTENT(INOUT) :: macro_el(8)
INTEGER, INTENT(IN) :: ibrav
LOGICAL, INTENT(IN) :: flag
REAL(DP) :: b0v, e0v, g0v, nuv, b0r, e0r, g0r, nur

CALL macro_elasticity( ibrav, cmn, smn, b0v, &
                             e0v, g0v, nuv, b0r, e0r, g0r, nur )

IF (flag) THEN
   WRITE(stdout,'(/,20x,40("-"),/)')

   WRITE(stdout, '(/,5x, "Voigt approximation:")') 

   WRITE(stdout, '(5x, "Bulk modulus  B = ",f12.5," kbar")') b0v
   WRITE(stdout, '(5x, "Young modulus E = ",f12.5," kbar")') e0v
   WRITE(stdout, '(5x, "Shear modulus G = ",f12.5," kbar")') g0v
   WRITE(stdout, '(5x,"Poisson Ratio n = ",f12.5)') nuv

   WRITE(stdout, '(/,5x, "Reuss approximation:")') 
   WRITE(stdout, '(5x, "Bulk modulus  B = ",f12.5," kbar")') b0r
   WRITE(stdout, '(5x, "Young modulus E = ",f12.5," kbar")') e0r
   WRITE(stdout, '(5x, "Shear modulus G = ",f12.5," kbar")') g0r
   WRITE(stdout, '(5x,"Poisson Ratio n = ",f12.5)') nur

   WRITE(stdout, '(/,5x, "Voigt-Reuss-Hill average of the two &
                                                         &approximations:")') 
   WRITE(stdout, '(5x, "Bulk modulus  B = ",f12.5," kbar")') (b0v+b0r)*0.5_DP
   WRITE(stdout, '(5x, "Young modulus E = ",f12.5," kbar")') (e0v+e0r)*0.5_DP
   WRITE(stdout, '(5x, "Shear modulus G = ",f12.5," kbar")') (g0v+g0r)*0.5_DP
   WRITE(stdout, '(5x,"Poisson Ratio n = ",f12.5)') (e0v+e0r)/    &
                                                 (2.d0*(g0v+g0r))-1.0_DP
END IF

macro_el(1)=b0v
macro_el(2)=e0v
macro_el(3)=g0v
macro_el(4)=nuv
macro_el(5)=b0r
macro_el(6)=e0r
macro_el(7)=g0r
macro_el(8)=nur

RETURN
END SUBROUTINE print_macro_elasticity

SUBROUTINE print_sound_velocities(ibrav, cmn, smn, density, vp, vb, vg)
!
!  In input the elastic constants are in kbar, the elastic compliances 
!  in kbar^-1 and the density in Kg/m^3. The sound velocity is printed
!  in m/sec
!
USE kinds, ONLY : DP
IMPLICIT NONE
INTEGER, INTENT(IN) :: ibrav
REAL(DP), INTENT(IN) :: cmn(6,6), smn(6,6), density
REAL(DP), INTENT(OUT) :: vp, vb, vg 
REAL(DP) :: b0v, e0v, g0v, nuv, b0r, e0r, g0r, nur

REAL(DP) :: g0, b0

CALL macro_elasticity( ibrav, cmn, smn, b0v, e0v, g0v, nuv, b0r, e0r, g0r, nur )

WRITE(stdout, '(/,5x, "Voigt-Reuss-Hill average; sound velocities:",/)') 

g0 = ( g0r + g0v ) * 0.5_DP
b0 = ( b0r + b0v ) * 0.5_DP

IF (b0 + 4.0_DP * g0 / 3.0_DP > 0.0_DP) THEN
   vp = SQRT( ( b0 + 4.0_DP * g0 / 3.0_DP ) * 1.D8 / density )
   WRITE(stdout, '(5x, "Compressional V_P = ",f12.3," m/s")') vp
ELSE
   vp=0.0_DP
   WRITE(stdout, '(5x, "The system is unstable for compressional deformations")') 
ENDIF
IF (b0 > 0.0_DP) THEN
   vb = SQRT( b0 * 1.D8 / density )
   WRITE(stdout, '(5x, "Bulk          V_B = ",f12.3," m/s")') vb
ELSE
   vb =0.0_DP
   WRITE(stdout, '(5x, "The system is unstable")') 
END IF
IF (g0 > 0.0_DP) THEN
   vg = SQRT( g0 * 1.D8 / density )
   WRITE(stdout, '(5x, "Shear         V_G = ",f12.3," m/s")') vg
ELSE
   vg = 0.0_DP
   WRITE(stdout, '(5x, "The system is unstable for shear deformations")') 
ENDIF


RETURN
END SUBROUTINE print_sound_velocities

SUBROUTINE set_sound_mat(elcon, qvec, soundmat)
!
!  This routine receives the elastic constants in the format C_{ijkl}
!  a direction for the propagation of the sound waves and gives as
!  output the matrix that has to be diagonalized to obtain the sound
!  speed in the input direction
!
USE kinds, ONLY : DP
IMPLICIT NONE
REAL(DP), INTENT(IN) :: elcon(3,3,3,3)   ! the elastic constants
REAL(DP), INTENT(IN) :: qvec(3)           ! the direction of the sound waves
REAL(DP), INTENT(INOUT) :: soundmat(3,3)  ! the matrix that must be 
                                          ! diagonalized to compute the 
                                          ! sound speed
INTEGER :: i,j,k,l

DO i=1,3
   DO l=1,3
      soundmat(i,l)=0.0_DP
      DO j=1,3
         DO k=1,3
            soundmat(i,l) = soundmat(i,l) + elcon(i,j,k,l)*qvec(j)*qvec(k)
         END DO
      END DO
   END DO
END DO

RETURN
END SUBROUTINE set_sound_mat

SUBROUTINE compute_sound(elcon, qvec, density, sound_speed, sound_disp)
!
!  This routine receives as input the elastic constants in Voigt notation 
!  C_{ij}, the direction of propagation of the sound, and the
!  density of the solid. It gives as output the sound velocity and the
!  eigenvectors that give the polarization of the sound wave.
!  
!  In input the density is in kg/m^3 and the elastic constants in kbar.
!  On output the speed of sound is in m/s.
!
USE kinds, ONLY : DP
IMPLICIT NONE

REAL(DP), INTENT(IN) :: elcon(3,3,3,3)
REAL(DP), INTENT(IN) :: qvec(3)
REAL(DP), INTENT(IN) :: density

REAL(DP), INTENT(INOUT) :: sound_speed(3)
REAL(DP), INTENT(INOUT) :: sound_disp(3,3)

REAL(DP) :: soundmat(3,3)
INTEGER :: i
!
!  set up the matrix to diagonalize
!
CALL set_sound_mat(elcon, qvec, soundmat)
!
!  and diagonalize it
!
!WRITE(6,*) soundmat(1,1), soundmat(1,2), soundmat(1,3)
!WRITE(6,*) soundmat(2,1), soundmat(2,2), soundmat(2,3)
!WRITE(6,*) soundmat(3,1), soundmat(3,2), soundmat(3,3)

CALL rdiagh( 3, soundmat, 3, sound_speed, sound_disp )
!
!  the factor 1D8 converts from kbar to N/m^2
!
DO i=1,3
   IF (sound_speed(i) > 0.0_DP) THEN
      sound_speed(i) = SQRT( sound_speed(i) * 1.D8 / density )
   ELSE
      sound_speed(i) = 0.0_DP
   ENDIF
ENDDO

RETURN
END SUBROUTINE compute_sound

END MODULE elastic_constants
