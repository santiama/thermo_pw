!
! Copyright (C) 2014 Andrea Dal Corso 
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
PROGRAM plot_new_sur_states
!
!  This program reads in input a certain number of couples 
!  k point - energy band
!  and a file of planar averages of the states produced by
!  the dump_states option of thermo_pw, and produces, for each couple, 
!  a planar average of the selected states. It plots also an indication
!  of the atomic positions
!  The output is a gnuplot script and a postscript file with all the
!  requested planar averages.
!  The user can control the plot by specifying:
!  If all the cell has to be shown or only one part of it.
!  Input variables:
!  nstates        ! integer the number of ploted states.
!  For each state:
!  ik(state), ibnd(state)
!  ...
!  dump_file  : the name of the dump file that must be in the same directory
!               where this code runs
!  startz, endz : starting and ending points of the plot (from 0 to 1)
!                 0 means beginning of the cell, 1 the end of the cell
!  latoms      : .true. if you want an indication of the atomic positions
!
USE kinds, ONLY : DP
USE mp_global,        ONLY : mp_startup, mp_global_end
USE environment,      ONLY : environment_start, environment_end
USE gnuplot, ONLY : gnuplot_start, gnuplot_end, gnuplot_xlabel, &
                    gnuplot_ylabel, gnuplot_write_file_data,    &
                    gnuplot_write_header, gnuplot_write_command,&
                    gnuplot_line, gnuplot_put_label
IMPLICIT NONE

CHARACTER(LEN=256) :: dump_file, gnu_filename, filename, data_filename
REAL(DP) :: startz, endz, posz
LOGICAL :: latoms
INTEGER :: nstates, nmax, ibrav, nr3, nks, nbnd, nat, nspin, nlab
INTEGER :: istate, na, ik, i, ibnd, iks, idum, ir, ispin, ios, ierr, iun
INTEGER :: system
INTEGER, ALLOCATABLE :: nk_plot(:), ik_plot(:,:), ibnd_plot(:,:)
REAL(DP), ALLOCATABLE :: plan(:,:,:), state(:,:), tau(:,:), mag(:,:), k(:,:), e(:,:)
REAL(DP) :: xmin, xmax, ymin, ymax, dimz, delta, celldm(6), x(2), y(2), kcur(3), &
            kmod
CHARACTER(LEN=3), ALLOCATABLE :: atm(:)
CHARACTER(LEN=10), ALLOCATABLE :: label_plot(:)
CHARACTER(LEN=256) :: str, filename1
CHARACTER(LEN=30) :: xlabel, ylabel
CHARACTER(LEN=6) :: int_to_char
CHARACTER(LEN=9) :: code='plot_surf_states'

CALL mp_startup ( start_images=.true. )
CALL environment_start ( code )

WRITE(6,'(5x,"Number of states to plot and maximum number of states per group")') 
READ(5,*) nstates, nmax
WRITE(6,'(5x,i5)') nstates, nmax
ALLOCATE(nk_plot(nstates))
ALLOCATE(ik_plot(nmax,nstates))
ALLOCATE(ibnd_plot(nmax,nstates))
ALLOCATE(label_plot(nstates))
WRITE(6,'(5x,"Input all the states...")') 
DO istate=1,nstates
   write(6,*) 'istate', istate
   READ(5,*) nk_plot(istate)
   IF (nk_plot(istate)> nmax) CALL errore('plot_sur_states','increase nmax',1)
   WRITE(6,'(5x,i6)') nk_plot(istate)
   DO ik=1,nk_plot(istate)
      READ(5,*) ik_plot(ik,istate), ibnd_plot(ik,istate), label_plot(istate)
      WRITE(6,'(5x,2i7,3x,a)') ik_plot(ik,istate), ibnd_plot(ik,istate), &
                                             TRIM(label_plot(istate))
   ENDDO
ENDDO
WRITE(6,'(5x,"Name of the file with the planar averages")') 
READ(5,'(a)')  dump_file
WRITE(6,'(5x,a)')  TRIM(dump_file)
WRITE(6,'(5x,"Starting and ending points of the plot")') 
READ(5,*) startz, endz
WRITE(6,'(5x,2f15.5)') startz, endz
WRITE(6,'(5x,"Do you want to plot the atoms (.TRUE.=yes)")') 
READ(5,*) latoms
WRITE(6,'(5x,l5)') latoms
!
!  Open dump_file and read the states and the atomic positions
!
WRITE(6,'(5x,2a)') 'Reading file ', TRIM(dump_file)
iun=38
filename1=TRIM(dump_file)
OPEN(UNIT=iun, FILE=TRIM(filename1), STATUS='OLD', ERR=100, IOSTAT=ios)
100 IF (ios /= 0) THEN
       WRITE(6,'(5x,"Problem opening the dump file ",a)') TRIM(dump_file)
       STOP
ENDIF

READ(iun,*) ibrav
WRITE(6,'(5x,"Ibrav= ",i5)') ibrav
READ(iun,*) celldm
WRITE(6,'(5x,"celldm= ",6f11.6)') celldm
READ(iun,*) nat
WRITE(6,'(5x,"nat= ",i5)') nat
ALLOCATE(atm(nat))
ALLOCATE(tau(3,nat))
DO na=1,nat 
   READ(iun,*) atm(na), tau(:,na)
   WRITE(6,'(5x,a,3f15.9)') TRIM(atm(na)), tau(:,na)
ENDDO
dimz=celldm(3)*celldm(1)

READ(iun,*) nr3, nbnd, nks, nspin
WRITE(6,'(5x,"nr3=",i6," nbnd=",i6," nks=",i6," nspin=",i6)') nr3, nbnd, nks, &
                                                             nspin

CLOSE(iun)
ALLOCATE( plan(nr3,nspin,nstates) )
ALLOCATE( state(nr3,nspin) )

plan=0.0_DP
DO istate=1,nstates
   DO iks=1,nk_plot(istate)
      ik=ik_plot(iks,istate)
      filename1='state_k_'//TRIM(int_to_char(ik))
      OPEN(UNIT=iun,FILE=TRIM(filename1),STATUS='unknown',ERR=300,IOSTAT=ios)
300   IF (ios /= 0) THEN
         WRITE(6,*) 'problem opening output_band.dat'
         STOP
      ENDIF

      DO ibnd=1,nbnd
         READ(iun,*) idum, idum
         DO ir=1,nr3
            READ(iun,*) idum, (state(ir,ispin), ispin=1,nspin)
         END DO
         IF (ibnd==ibnd_plot(iks,istate)) THEN
            plan(:,:,istate)=plan(:,:,istate) + state(:,:)
         END IF
      END DO
      CLOSE(iun)
   END DO
END DO

IF (nspin>1) THEN
!
!   read the output_band file with the k points
!
   OPEN(UNIT=1,FILE='output_band.dat',FORM='formatted',STATUS='OLD',ERR=10,&
                                                  IOSTAT=ios)
10 CONTINUE
   IF (ios /= 0) THEN
      WRITE(6,*) 'problem opening output_band.dat'
      STOP
   ENDIF

   ALLOCATE(k(3,nks))
   ALLOCATE(e(nbnd,nks))
   READ(1,*)
   DO ik=1,nks
      READ(1,*,end=220,err=220,iostat=ios) (k(i,ik), i=1,3 )
      READ(1,*,end=220,err=220,iostat=ios) (e(i,ik),i=1,nbnd)
   ENDDO
220 CONTINUE
   IF (ios /= 0) THEN
      WRITE(6,*) 'problem reading output_band.dat'
      STOP
   ENDIF
   CLOSE(1)

   ALLOCATE(mag(nr3,2))
   DO istate=1,nstates
      ik = ik_plot(1,istate)
!
!   project in the direction of the path.
!
      IF (ik > 1) THEN
         kcur(:) = k(:,ik) - k(:,ik-1)
      ELSE
         kcur(:) = k(:,2) - k(:,1)
      ENDIF
      kmod = SQRT( kcur(1)**2 + kcur(2)**2 )  
      write(6,*) 'kmod', kmod
      IF (kmod > 0.0_DP) THEN
         kcur(:)=kcur(:) / kmod
      ELSE
!
!   At the gamma point we take the k parallel to x, so the plot will be m_x, m_y, m_z
!
         kcur(1)=1.0_DP
      ENDIF 
      write(6,*) 'istate,ik, kcur(1), kcur(2)', istate, ik, kcur(1), kcur(2)
!
!  and now project the magnetization in the direction of k (1) or in the 
!  perpendicular direction (2). NB: k must be parallel to the surface
!
      mag(:,1) = kcur(1) * plan(:,2,istate) + kcur(2) * plan(:,3,istate) 
      mag(:,2) = - kcur(2) * plan(:,2,istate) + kcur(1) * plan(:,3,istate) 
      plan(:,2,istate)=mag(:,1)
      plan(:,3,istate)=mag(:,2)
   END DO
END IF

iun=38
ymax=0.0_DP
ymin=0.0_DP
DO istate=1,nstates
   DO ispin=1,nspin
      IF (ispin > 1) THEN
         data_filename='state_'//TRIM(int_to_char(istate))//'_' &
                               //TRIM(int_to_char(ispin))
      ELSE
         data_filename='state_'//TRIM(int_to_char(istate))
      END IF
      OPEN(UNIT=iun, FILE=TRIM(data_filename), STATUS='UNKNOWN', &
                                            ERR=200, IOSTAT=ios)
200   IF (ios /= 0) THEN
         WRITE(6,'(5x,"Problem opening the output file",a)') TRIM(data_filename)
         STOP
      ENDIF

      DO ir=1,nr3
         WRITE(iun, '(2f20.10)') ((ir - 1) * dimz / nr3), plan(ir,ispin,istate) 
         IF (plan(ir,ispin,istate)> ymax) ymax=plan(ir,ispin,istate)
         IF (plan(ir,ispin,istate)< ymin) ymin=plan(ir,ispin,istate)
      ENDDO
      CLOSE(iun)
   END DO
ENDDO
!
!  Initialize gnuplot and make the minimal plot for each state
!
gnu_filename='gnuplot.tmp_file'
CALL gnuplot_start(gnu_filename)

filename='output_states.ps'
xmin=dimz * startz
xmax=dimz * endz
CALL gnuplot_write_header(filename, xmin, xmax, 0.0_DP, ymax, 1.0_DP )
CALL gnuplot_write_command('set size 1.0,0.7 ',.FALSE.)

ylabel='|{/Symbol y}(z)|^2 (a.u.^{-1})'
xlabel='z (a.u.)'
CALL gnuplot_ylabel(TRIM(ylabel), .FALSE.)
CALL gnuplot_xlabel(TRIM(xlabel), .FALSE.)
CALL gnuplot_write_command('plot_width=3',.FALSE.)
!
!  put the positions of the atoms
!
IF (latoms) THEN
   DO na=1,nat
      posz=tau(3,na)
      IF (posz < 0.0_DP) posz=posz+celldm(3) 
      IF (posz > celldm(3)) posz=posz-celldm(3) 
      IF (posz*celldm(1) > xmin .AND. posz*celldm(1) < xmax) THEN 
         x(1)=posz*celldm(1)
         y(1)=0.0_DP
         x(2)=x(1)
         y(2)=ymax/23.0_DP
         CALL gnuplot_line(x,y,'2','front','"black"')
         CALL gnuplot_put_label(x(1),y(2)*1.5_DP,10000+na,atm(na),.FALSE.)
      END IF
   END DO
END IF

DO istate=1,nstates
   CALL gnuplot_put_label(0.9_DP*xmax,0.9_DP*ymax,istate,&
                                                label_plot(istate),.FALSE.) 
   data_filename='state_'//TRIM(int_to_char(istate))

   CALL gnuplot_write_file_data(data_filename,'plot_width','"red"',.TRUE.,&
                                                       .TRUE.,.FALSE.)
   str='unset label '//TRIM(int_to_char(istate))
   CALL gnuplot_write_command(str,.FALSE.) 
END DO

CALL gnuplot_end()

ierr=system('gnuplot '//TRIM(gnu_filename))
!
!   If this file contains also the magnetization information plot it in
!   another postscript file
!
!  Initialize gnuplot and make the minimal plot for each state
!
IF (nspin > 1) THEN

   gnu_filename='gnuplot.tmp_mag_file'
   CALL gnuplot_start(gnu_filename)

   filename='output_mag_states.ps'
   xmin=dimz * startz
   xmax=dimz * endz
   CALL gnuplot_write_header(filename, xmin, xmax, ymin, ymax, 1.0_DP )
   CALL gnuplot_write_command('set size 1.0,0.7 ',.FALSE.)

   ylabel='m(z) ({/Symbol m}_B / a.u.)'
   xlabel='z (a.u.)'
   CALL gnuplot_ylabel(TRIM(ylabel), .FALSE.)
   CALL gnuplot_xlabel(TRIM(xlabel), .FALSE.)
   CALL gnuplot_write_command('plot_width=3',.FALSE.)
   x(1)=0.87_DP*xmax
   x(2)=0.90_DP*xmax
   y(1)=0.72_DP*ymax
   y(2)=y(1)
   delta=0.025_DP*(xmax-xmin)
!   CALL gnuplot_line(x,y,'2','front','"red"')
!   CALL gnuplot_put_label(x(2)+delta,y(2),998,'m_{/Symbol \174 \174 }',.FALSE.,'left')
   y(1)=0.72_DP*ymax
   y(2)=y(1)
   CALL gnuplot_line(x,y,'2','front','"green"')
   CALL gnuplot_put_label(x(2)+delta,y(2),999,'m_{/Symbol \\136 }',.FALSE.,'left')
   y(1)=0.61_DP*ymax
   y(2)=y(1)
   CALL gnuplot_line(x,y,'2','front','"blue"')
   CALL gnuplot_put_label(x(2)+delta,y(2),997,'m_z',.FALSE.,'left')
!
!  put the positions of the atoms
!
   IF (latoms) THEN
      DO na=1,nat
         posz=tau(3,na)
         IF (posz < 0.0_DP) posz=posz+celldm(3) 
         IF (posz > celldm(3)) posz=posz-celldm(3) 
         IF (posz*celldm(1) > xmin .AND. posz*celldm(1) < xmax) THEN 
            x(1)=posz*celldm(1)
            y(1)=0.0_DP
            x(2)=x(1)
            y(2)=(ymax - ymin)/23.0_DP
            CALL gnuplot_line(x,y,'2','front','"black"')
            CALL gnuplot_put_label(x(1),y(2)*1.5_DP,10000+na,atm(na),.FALSE.)
         END IF
      END DO
   END IF

   DO istate=1,nstates
      DO ispin=2,nspin
         IF (ispin==2) THEN
            CALL gnuplot_put_label(0.9_DP*xmax,0.87_DP*ymax,istate,&
                                                label_plot(istate),.FALSE.) 
         END IF
         data_filename='state_'//TRIM(int_to_char(istate))//'_' &
                                  //TRIM(int_to_char(ispin))

         IF (ispin==2) THEN
            CALL gnuplot_write_file_data(data_filename,'plot_width','"red"',.TRUE.,&
                                                       .FALSE.,.FALSE.)
         ELSEIF (ispin==3) THEN
            CALL gnuplot_write_file_data(data_filename,'plot_width','"green"',&
                                                      .FALSE.,.FALSE.,.FALSE.)
         ELSEIF (ispin==4) THEN
            CALL gnuplot_write_file_data(data_filename,'plot_width','"blue"',.FALSE.,&
                                                       .TRUE.,.FALSE.)
         ENDIF

         IF (ispin==nspin) THEN
            str='unset label '//TRIM(int_to_char(istate))
            CALL gnuplot_write_command(str,.FALSE.) 
         ENDIF
      END DO
   END DO

   CALL gnuplot_end()

   ierr=system('gnuplot '//TRIM(gnu_filename))

   DEALLOCATE(mag)
   DEALLOCATE(k)
   DEALLOCATE(e)
END IF

DEALLOCATE(atm)
DEALLOCATE(tau)
DEALLOCATE(nk_plot)
DEALLOCATE(ik_plot)
DEALLOCATE(ibnd_plot)
DEALLOCATE(label_plot)
DEALLOCATE(plan)
DEALLOCATE(state)

CALL environment_end( code )
!
CALL mp_global_end ()

END PROGRAM plot_new_sur_states
