
! Copyright (C) 2013-2015 Andrea Dal Corso
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
!-------------------------------------------------------------------------
PROGRAM thermo_pw
  !-----------------------------------------------------------------------
  !
  ! ... This is a driver for the calculation of thermodynamic quantities,
  ! ... using the harmonic and/or quasiharmonic approximation and the
  ! ... plane waves pseudopotential method.
  ! ... It reads the input of pwscf and an input that specifies
  ! ... which calculations to do and the parameters for these calculations.
  ! ... It checks the scratch directories to see what has been already
  ! ... calculated. The info for the quantities that have been already
  ! ... calculated is read inside the code. The others tasks are scheduled,
  ! ... their priorities determined, and distributed to the image driver.
  ! ... If there are several available images the different tasks are
  ! ... carried out in parallel. This driver can carry out a scf 
  ! ... calculation, a non scf calculation to determine the band structure,
  ! ... or a linear response calculation at a given q and for a given
  ! ... representation. Finally the root image can carry out several
  ! ... post processing tasks. The task currently implemented are:
  ! ... 
  ! ...   scf       : a single scf calculation to determine the total energy.
  ! ...   scf_ke    : many scf calculations at different cut-offs
  ! ...   scf_nk    : many scf calculations at different numbers of k points
  ! ...   scf_bands : a band structure calculation after a scf calcul.
  ! ...   scf_2d_bands : this is as scf_bands, but the cell is assumed to be 
  ! ...                  a slab and the default path is chosen in the 2d 
  ! ...                  Brillouin zone. This option can be used also to 
  ! ...                  calculate the projected bulk band structure.
  ! ...   scf_dos : a dos calculation after a scf calcul.
  ! ...   scf_ph    : a phonon calculation after an scf run
  ! ...   scf_disp  : a phonon dispersion calculation after a scf run
  ! ...   scf_elastic_constants : elastic constants at zero temperature 
  ! ...   scf_piezoelectric_tensor : piezoelectric tensor at zero temperature
  ! ...
  ! ...   mur_lc    : lattice constant via Murnaghan equation or 
  ! ...               quadratic interpolation of the equation of state
  ! ...   mur_lc_bands  : a band structure calculation at the minimum or the
  ! ...               total energy
  ! ...   mur_lc_dos  : an electronic dos calculation at the minimum or the
  ! ...               total energy 
  ! ...   mur_lc_ph : a phonon calculation at the minimum of the total energy
  ! ...   mur_lc_disp : a dispersion calculation at the minimum of the total
  ! ...               energy with the possibility to compute the harmonic
  ! ...               thermodynamic quantities
  ! ...   mur_lc_elastic_constants : elastic constants at zero temperature 
  ! ...               at the minimum of the total energy equation 
  ! ...   mur_lc_piezoelectric_tensor : piezoelectric tensor at zero temperature
  ! ...               at the minimum of the total energy 
  ! ...
  ! ...   mur_lc_t  : lattice constant and bulk modulus as a function 
  ! ...               of temperature within the quasiharmonic approximation
  ! ...               for cubic systems or crystal parameters as a function
  ! ...               of temperature for tetragonal, hexagonal, trigonal,
  ! ...               and orthorombic systems. 
  ! ...
  USE kinds,            ONLY : DP
  USE ions_base,        ONLY : nat, atm, tau, nsp, ityp, amass
  USE check_stop,       ONLY : check_stop_init
  USE mp_global,        ONLY : mp_startup, mp_global_end
  USE mp_images,        ONLY : nimage, nproc_image, my_image_id, root_image
  USE environment,      ONLY : environment_start, environment_end
  USE mp_world,         ONLY : world_comm
  USE mp_asyn,          ONLY : with_asyn_images
  USE control_ph,       ONLY : with_ext_images, always_run, ldisp
  USE control_lr,       ONLY : lgamma
  USE io_global,        ONLY : ionode, stdout, meta_ionode_id
  USE mp,               ONLY : mp_sum, mp_bcast
  USE control_thermo,   ONLY : lev_syn_1, lev_syn_2, lpwscf_syn_1,         &
                               lbands_syn_1, lph, outdir_thermo, lq2r,     &
                               ldos_syn_1, ltherm,                         &
                               lconv_ke_test, lconv_nk_test,               &
                               spin_component, after_disp, lelastic_const, &
                               lpiezoelectric_tensor, lpolarization,       &
                               lpart2_pw, ltherm_dos, ltherm_freq
  USE postscript_files, ONLY : flpstherm, flpsdisp, flpsdos
  USE data_files,        ONLY : flevdat, fl_el_cons
  USE elastic_constants, ONLY : print_elastic_constants, &
                                compute_elastic_constants, epsilon_geo, &
                                sigma_geo, el_con, el_compliances, &
                                compute_elastic_compliances, &
                                print_elastic_compliances, read_elastic, &
                                write_elastic, print_macro_elasticity, &
                                compute_elastic_constants_adv, &
                                compute_elastic_constants_ene, &
                                print_sound_velocities
  USE debye_module, ONLY : compute_debye_temperature,  &
                           compute_debye_temperature_poisson
  USE control_debye, ONLY : debye_t
  USE control_flags, ONLY : lbands
  USE piezoelectric_tensor, ONLY : compute_piezo_tensor, &
                                compute_d_piezo_tensor, &
                                polar_geo, g_piezo_tensor, d_piezo_tensor, &
                                print_d_piezo_tensor, print_g_piezo_tensor
  USE control_elastic_constants, ONLY : ngeo_strain, frozen_ions, &
                                elastic_algorithm, rot_mat, omega0, at_save, &
                                elcpvar, tau_save, el_cons_t_available
  USE control_macro_elasticity, ONLY : macro_el, vp, vb, vg, approx_debye_t
  USE internal_files_names,  ONLY : flfrq_thermo, flvec_thermo
  USE control_paths,    ONLY : nqaux
  USE control_gnuplot,  ONLY : flgnuplot
  USE control_bands,    ONLY : nbnd_bands
  USE control_pwrun,    ONLY : ibrav_save, do_punch, amass_save
  USE control_xrdp,     ONLY : lxrdp, lambda, flxrdp, lcm
  USE control_ph,       ONLY : recover, trans
  USE xrdp_module,      ONLY : compute_xrdp
  USE thermo_sym,       ONLY : laue, code_group_save
  USE cell_base,        ONLY : omega, at, bg
  USE wvfct,            ONLY : nbnd
  USE lsda_mod,         ONLY : nspin
  USE thermodynamics,   ONLY : phdos_save
  USE ph_freq_thermodynamics, ONLY: ph_freq_save
  USE temperature,      ONLY : ntemp
  USE control_pressure, ONLY : pressure, pressure_kb
  USE phdos_module,     ONLY : destroy_phdos
  USE input_parameters, ONLY : ibrav, celldm, a, b, c, cosab, cosac, cosbc, &
                               trd_ht, rd_ht, cell_units, outdir
  USE control_mur,      ONLY : vmin, b0, b01, emin, celldm0, lmurn
  USE thermo_mod,       ONLY : what, ngeo, omega_geo, energy_geo, &
                               tot_ngeo, reduced_grid, ibrav_geo, celldm_geo, &
                               central_geo, density, no_ph, max_geometries
  USE optical,          ONLY : fru
  USE cell_base,        ONLY : ibrav_ => ibrav, celldm_ => celldm
  USE control_2d_bands, ONLY : only_bands_plot
  USE ph_restart,       ONLY : destroy_status_run
  USE save_ph,          ONLY : clean_input_variables
  USE output,           ONLY : fildyn
  USE io_files,         ONLY : tmp_dir, wfc_dir
  USE cell_base,        ONLY : cell_base_init
  !
  IMPLICIT NONE
  !
  INTEGER :: iq, irr, ierr
  CHARACTER (LEN=9)   :: code = 'THERMO_PW'
  CHARACTER (LEN=256) :: auxdyn=' '
  CHARACTER (LEN=256) :: diraux=' '
  CHARACTER(LEN=6) :: int_to_char
  CHARACTER(LEN=8) :: float_to_char
  INTEGER :: part, nwork, igeom, itemp, nspin0, exit_status, ph_geometries, &
             iaux
  LOGICAL  :: exst, parallelfs, run
  LOGICAL :: check_file_exists, check_dyn_file_exists
  CHARACTER(LEN=256) :: file_dat, filename, filelastic
  REAL(DP) :: poisson, bulkm
  ! Initialize MPI, clocks, print initial messages
  !
  CALL mp_startup ( start_images=.true. )
  CALL environment_start ( code )
  CALL start_clock( 'PWSCF' )
  with_asyn_images=(nimage > 1)
  !
  ! ... and begin with the initialization part
  !
  CALL thermo_readin()
  !
  CALL set_temperature()
  !
  CALL set_pressure()
  !
  CALL thermo_summary()
  !
  CALL check_stop_init()
  !
  part = 1
  !
  CALL initialize_thermo_work(nwork, part, iaux)
  !
  !  In this part the images work asynchronously. No communication is
  !  allowed except though the master-workers mechanism
  !
  CALL run_thermo_asynchronously(nwork, part, iaux, auxdyn)
  !
  !  In this part all images are syncronized and can communicate 
  !  their results thought the world_comm communicator
  !
  IF (nwork>0) THEN
     CALL mp_sum(energy_geo, world_comm)
     energy_geo=energy_geo / nproc_image
  ENDIF
!
!  In the kinetic energy test write the results
!
  IF (lconv_ke_test) THEN
     CALL write_e_ke()
     CALL plot_e_ke()
  ENDIF
!
! In the k-point test write the results
!
  IF (lconv_nk_test) THEN
     CALL write_e_nk()
     CALL plot_e_nk()
  ENDIF
!
!  In a murnaghan equation calculation determine the lattice constant,
!  bulk modulus and its derivative and write the results
!  Otherwise interpolate the energy with a quadratic or quartic polynomium.
!
  IF (lev_syn_1) THEN
     IF (lmurn) THEN
        CALL do_ev()
        CALL write_mur(vmin,b0,b01,emin)
        CALL plot_mur()
        CALL compute_celldm_geo(vmin, celldm0, &
                   celldm_geo(1,central_geo), omega_geo(central_geo))
     ELSE
        CALL write_gnuplot_energy(nwork)
        CALL quadratic_fit()
        CALL write_quadratic()
        CALL plot_multi_energy()
     ENDIF
     CALL mp_bcast(celldm0, meta_ionode_id, world_comm)
     CALL mp_bcast(emin, meta_ionode_id, world_comm)
     CALL write_minimum_energy_data()
     celldm=celldm0
     CALL cell_base_init ( ibrav, celldm0, a, b, c, cosab, cosac, cosbc, &
                      trd_ht, rd_ht, cell_units )
     CALL set_fft_mesh()
     omega0=omega
     at_save(:,:)=at(:,:)
!
!   strain tau uniformely
!
     CALL adjust_tau(tau_save, tau, at)
!
!  recompute the density at the minimum volume
!
     CALL compute_density(omega,density)
!
!  compute the xrdp at the minimum volume if required by the user
!
     IF (lxrdp) THEN
        filename=TRIM(flxrdp)
        IF (pressure /= 0.0_DP) &
           filename=TRIM(flxrdp)//'.'//TRIM(float_to_char(pressure_kb,1))

        CALL compute_xrdp(at,bg,celldm(1),nat,tau,nsp,ityp,atm, &
                                lambda,ibrav,lcm,filename)
        CALL plot_xrdp('')
     END IF
  END IF

  CALL deallocate_asyn()

  IF (lpwscf_syn_1) THEN
     with_asyn_images=.FALSE.
     outdir=TRIM(outdir_thermo)//'/g1/'
     tmp_dir = TRIM ( outdir )
     wfc_dir = tmp_dir
     CALL check_tempdir ( tmp_dir, exst, parallelfs )

     IF (my_image_id==root_image) THEN
!
!   do the self consistent calculation at the new lattice constant
!
        do_punch=.TRUE.
        IF (.NOT.only_bands_plot) THEN
           WRITE(stdout,'(/,2x,76("+"))')
           WRITE(stdout,'(5x,"Doing a self-consistent calculation", i5)') 
           WRITE(stdout,'(2x,76("+"),/)')
           CALL check_existence(0,1,0,run)
           IF (run) THEN
              CALL do_pwscf(exit_status, .TRUE.)
              CALL save_existence(0,1,0)
           END IF
           IF (lxrdp) THEN
              filename=TRIM(flxrdp)//'.scf'
              CALL compute_xrdp(at,bg,celldm(1),nat,tau,nsp,ityp,atm, &
                                   lambda,ibrav,lcm,filename)
              CALL plot_xrdp('.scf')
           END IF
        ENDIF
        IF (lbands_syn_1) THEN
!
!   do the band calculation after setting the path
!
           IF (.NOT.only_bands_plot) THEN
              IF (ldos_syn_1) THEN
                 CALL set_dos_kpoints()
              ELSE
                 CALL set_paths_disp()
                 CALL set_k_points()
              ENDIF
!
!   by default in a band structure calculation we double the number of
!   computed bands
!
              IF (nbnd_bands == 0) nbnd_bands = 2*nbnd
              IF (nbnd_bands > nbnd) nbnd = nbnd_bands
              WRITE(stdout,'(/,2x,76("+"))')
              WRITE(stdout,'(5x,"Doing a non self-consistent calculation",&
                                                                    & i5)') 
              WRITE(stdout,'(2x,76("+"),/)')
              IF (ldos_syn_1) THEN
                 lbands=.FALSE.
              ELSE
                 lbands=.TRUE.
              ENDIF
              CALL do_pwscf(exit_status, .FALSE.)
              IF (ldos_syn_1) THEN
                 CALL dos_sub()
                 CALL plot_dos()
                 CALL write_el_thermo()
                 CALL plot_el_thermo()
              ELSE
                 nspin0=nspin
                 IF (nspin==4) nspin0=1
                 DO spin_component = 1, nspin0
                    CALL bands_sub()
                    CALL read_minimal_info(.FALSE.)
                    CALL plotband_sub(1,1,' ')
                 ENDDO
              ENDIF
           ELSE
              CALL read_minimal_info(.TRUE.)
              CALL plotband_sub(1,1,' ')
           ENDIF
        ENDIF
     ENDIF
     CALL mp_bcast(tau, meta_ionode_id, world_comm)
     CALL mp_bcast(celldm, meta_ionode_id, world_comm)
     CALL mp_bcast(at, meta_ionode_id, world_comm)
     CALL mp_bcast(omega, meta_ionode_id, world_comm)
     CALL set_equilibrium_conf(celldm, tau, at, omega)
     with_asyn_images=(nimage>1)
  END IF
     !
  IF (lpart2_pw) THEN
!
!   here the second part does not use the phonon code. This is for the
!   calculation of elastic constants. We allow the calculation for several
!   geometries
!
     DO igeom=1,tot_ngeo

        IF (tot_ngeo > 1) CALL set_geometry_el_cons(igeom)

        part=2
        CALL initialize_thermo_work(nwork, part, iaux)
        !
        !  Asyncronous work starts again. No communication is
        !  allowed except though the master workers mechanism
        !
        CALL run_thermo_asynchronously(nwork, part, igeom, auxdyn)
        !
        ! here we return syncronized and calculate the elastic constants 
        ! from energy or stress 
        !

        IF (lelastic_const) THEN
           IF (elastic_algorithm == 'energy') THEN
!
!   recover the energy calculated by all images
!
             CALL mp_sum(energy_geo, world_comm)
             energy_geo=energy_geo / nproc_image
           ELSE
!
!   recover the stress tensors calculated by all images
!
             CALL mp_sum(sigma_geo, world_comm)
             sigma_geo=sigma_geo / nproc_image
           ENDIF
!
!  the elastic constants are calculated here
!
           IF (elastic_algorithm=='standard') THEN
              CALL compute_elastic_constants(sigma_geo, epsilon_geo, nwork, &
                               ngeo_strain, ibrav_save, laue, elcpvar)
           ELSE IF (elastic_algorithm=='advanced') THEN
              CALL compute_elastic_constants_adv(sigma_geo, epsilon_geo, &
                               nwork, ngeo_strain, ibrav_save, laue, rot_mat, &
                                                   elcpvar)
           ELSE IF (elastic_algorithm=='energy') THEN
              CALL compute_elastic_constants_ene(energy_geo, epsilon_geo, &
                               nwork, ngeo_strain, ibrav_save, laue, omega0, &
                                                               elcpvar)
           END IF
           CALL print_elastic_constants(el_con, frozen_ions)
!
!  now compute the elastic compliances and prints them
!
           CALL compute_elastic_compliances(el_con,el_compliances)
           CALL print_elastic_compliances(el_compliances, frozen_ions)
           CALL print_macro_elasticity(ibrav_save,el_con,el_compliances,&
                                                   macro_el, .TRUE.)
!
!  here compute the sound velocities, using the density of the solid and
!  the elastic constants
!
           CALL print_sound_velocities( ibrav_save, el_con, el_compliances, &
                                       density, vp, vb, vg )
!
!  here we compute the Debye temperature approximatively from the
!  poisson ratio and the bulk modulus
!
           poisson=(macro_el(4)+macro_el(8) ) * 0.5_DP
           bulkm=(macro_el(1)+macro_el(5) ) * 0.5_DP
           CALL compute_debye_temperature_poisson(poisson, bulkm, &
                               density, nat, omega, approx_debye_t)
!
!  compute the Debye temperature and the thermodynamic quantities
!  within the Debye model
!
           CALL compute_debye_temperature(el_con, density, nat, omega, debye_t)
           CALL write_thermo_debye(igeom)
           CALL plot_thermo_debye(igeom)
!
!  save elastic constants and compliances on file
!
           filelastic='elastic_constants/'//TRIM(fl_el_cons)//'.g'//&
                                                     TRIM(int_to_char(igeom))
           IF (my_image_id==root_image) CALL write_elastic(filelastic)
        ENDIF

        IF (lpiezoelectric_tensor) THEN
           CALL mp_sum(polar_geo, world_comm)
           polar_geo=polar_geo / nproc_image
!
!  the elastic constants are calculated here
!
           CALL compute_piezo_tensor(polar_geo, epsilon_geo, nwork, &
                               ngeo_strain, ibrav_save, code_group_save)
           CALL print_g_piezo_tensor(frozen_ions)

           IF (my_image_id==root_image) CALL read_elastic(fl_el_cons, exst)
           CALL mp_bcast(exst, meta_ionode_id, world_comm)
           IF (exst) THEN
              CALL mp_bcast(el_con, meta_ionode_id, world_comm)
              CALL mp_bcast(el_compliances, meta_ionode_id, world_comm)
              CALL compute_d_piezo_tensor(el_compliances)
              CALL print_d_piezo_tensor(frozen_ions)
           ENDIF
        END IF
        IF (lpolarization) THEN
           CALL mp_sum(polar_geo, world_comm)
           polar_geo=polar_geo / nproc_image
           CALL print_polarization(polar_geo(:,1), .TRUE. )
        ENDIF
        CALL deallocate_asyn()
     END DO
  ENDIF

  IF (what(1:8) /= 'mur_lc_t') ngeo=1
!
!   This part makes now one or several phonon calculations, using the
!   image feature of this code and running asynchronously the images
!   different geometries are made in sequence. This should be improved,
!   there should be no need to resyncronize after each geometry
!
  IF (lph) THEN
     !
     ! ... reads the phonon input
     !
     with_ext_images=with_asyn_images
     ph_geometries=0
     always_run=.TRUE.
     CALL start_clock( 'PHONON' )
     DO igeom=1,tot_ngeo
        IF (no_ph(igeom)) CYCLE
        write(stdout,'(/,5x,40("%"))') 
        write(stdout,'(5x,"Computing geometry ", i5)') igeom
        write(stdout,'(5x,40("%"),/)') 
        outdir=TRIM(outdir_thermo)//'/g'//TRIM(int_to_char(igeom))//'/'
        !
        IF (.NOT. after_disp) CALL thermo_ph_readin()
        IF (after_disp) ldisp=.TRUE.
        CALL set_files_names(igeom)

        IF (after_disp.AND.what=='mur_lc_t') THEN
!
!  The geometry is read by thermo_ph_readin from the output files of pw.x,
!  except in the case where after_disp=.TRUE.. In this case we have to
!  set it here.
!
           ibrav_=ibrav_geo(igeom)
           celldm_(:)=celldm_geo(:,igeom)
           CALL set_bz_path()
        ENDIF
!
!  Set the BZ path for the present geometry
!
        IF (nqaux > 0) CALL set_paths_disp()
        !
        ! ... Checking the status of the calculation and if necessary initialize
        ! ... the q mesh and all the representations
        !
        auxdyn=fildyn

        IF ( .NOT. check_dyn_file_exists(auxdyn)) THEN

           ph_geometries=ph_geometries+1
           IF (ph_geometries > max_geometries) THEN
              WRITE(stdout,'(5x,"The code stops because max_geometries is",&
                               &i4)') max_geometries
              GOTO 1000
           ENDIF
           CALL check_initial_status(auxdyn)
           !
           part=2
           CALL initialize_thermo_work(nwork, part, iaux)
           !
           !  Asyncronous work starts again. No communication is
           !  allowed except though the master workers mechanism
           !
           CALL run_thermo_asynchronously(nwork, part, igeom, auxdyn)
           !  
           !   return to syncronous work. Collect the work of all images and
           !   writes the dynamical matrix
           !
           IF (trans) THEN
              CALL collect_everything(auxdyn)
           ELSE
              IF (lgamma) THEN
                 CALL plot_epsilon_omega_opt()
              ELSE
                 CALL plot_epsilon_omega_q()
              ENDIF
           ENDIF
           !
        END IF
        IF (lq2r) THEN
!
!   Compute the interatomic force constants from the dynamical matrices
!   written on file
!
           CALL q2r_sub(auxdyn) 
           amass_save(1:nsp)=amass(1:nsp)
!
!    compute interpolated dispersions
!
           CALL write_ph_dispersions()
           CALL plotband_sub(2,igeom,' ')

           IF (ltherm) THEN
!
!    the frequencies on a uniform mesh are interpolated or read from disk 
!    if available and saved in ph_freq_save 
!
              CALL write_ph_freq(igeom)
              IF (ltherm_freq.OR..NOT.ltherm_dos) CALL write_thermo_ph(igeom)
 
              IF (ltherm_dos) THEN
                 CALL write_phdos(igeom)
                 CALL plot_phdos()
                 CALL write_thermo(igeom)
              ENDIF
              CALL plot_thermo()
           ENDIF
           CALL clean_ifc_variables()
        ENDIF
        CALL deallocate_asyn()
        IF (.NOT. after_disp) THEN
           CALL clean_pw(.TRUE.)
           CALL close_phq(.FALSE.)
           CALL clean_input_variables()
           CALL destroy_status_run()
           IF (ALLOCATED(fru)) DEALLOCATE(fru)
           CALL deallocate_part()
        ENDIF
     ENDDO

     CALL restore_files_names()
!
!     Here the Helmholtz free energy at each lattice constant is available.
!     We can write on file the free energy as a function of the volume at
!     any temperature. For each temperature we can fit the free energy
!     or the Gibbs energy if we have a finite pressure with a 
!     Murnaghan equation or with a quadratic or quartic polynomial. 
!     We save the minimum volume or crystal parameters. With the Murnaghan fit
!     we save also the bulk modulus and its pressure derivative for each 
!     temperature.
!
     IF (lev_syn_2) THEN
        IF (lmurn) THEN
           DO itemp = 1, ntemp
              IF (ltherm_dos) CALL do_ev_t(itemp)
              IF (ltherm_freq) CALL do_ev_t_ph(itemp)
           ENDDO
!
!    here we calculate several anharmonic quantities 
!
           IF (ltherm_dos) CALL write_anharmonic()
           IF (ltherm_freq) CALL write_ph_freq_anharmonic()
!
!    here we calculate and plot the gruneisen parameters along the given path.
!
           CALL write_gruneisen_band(flfrq_thermo,flvec_thermo)
           CALL plotband_sub(3,1,flfrq_thermo)
           CALL plotband_sub(4,1,flfrq_thermo)
!
!    here we compute the gruneisen parameters on the dos mesh
!
           CALL compute_gruneisen()
!
!    here we calculate several anharmonic quantities and plot them.
!
           CALL write_grun_anharmonic()
           CALL plot_anhar() 
        ELSE
!
!    Anisotropic solid. Compute only the crystal parameters as a function
!    of temperature and the thermal expansion tensor
!
           DO itemp = 1, ntemp
              IF (ltherm_dos) CALL quadratic_fit_t(itemp)
              IF (ltherm_freq) CALL quadratic_fit_t_ph(itemp)
           ENDDO
!
!  Check if the elastic constants are on file. If they are, the code
!  computes the elastic constants as a function of temperature interpolating
!  at the crystal parameters found in the quadratic/quartic fit
!
           CALL check_el_cons()
           CALL write_elastic_t()
           CALL plot_elastic_t()

           IF (ltherm_dos) CALL write_anhar_anis()
           IF (ltherm_freq) CALL write_ph_freq_anhar_anis()
!
!    here we calculate and plot the gruneisen parameters along the given path.
!
           CALL write_gruneisen_band_anis(flfrq_thermo,flvec_thermo)
!
!    plotband_sub writes the interpolated phonon at the requested temperature
!
           CALL plotband_sub(4,1,flfrq_thermo)
!
!   and the next driver plots all the gruneisen parameters depending on the
!   lattice.
!
           CALL plot_gruneisen_band_anis(flfrq_thermo)
!
!   here we calculate the gruneisen parameters on a mesh and then recompute
!   the thermal expansion from the gruneisen parameters
!
           CALL fit_frequencies_anis()

           CALL write_grun_anharmonic_anis()
           CALL plot_anhar_anis()
        ENDIF
     ENDIF
1000 CONTINUE
     IF (ltherm.AND.ltherm_dos) THEN
        DO igeom=1,tot_ngeo
           CALL destroy_phdos(phdos_save(igeom))
        ENDDO
        DEALLOCATE(phdos_save)
     ENDIF
  ENDIF
  !
  CALL deallocate_thermo()
  !
  CALL environment_end( code )
  !
  CALL mp_global_end ()
  !
  STOP
  !
END PROGRAM thermo_pw

