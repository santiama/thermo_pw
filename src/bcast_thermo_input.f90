!
! Copyright (C) 2013 Andrea Dal Corso
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!
!-----------------------------------------------------------------------
SUBROUTINE bcast_thermo_input()
  !-----------------------------------------------------------------------
  !
  !  This routine broadcasts to all the images the input of thermo_pw.
  !
  USE thermo_mod,      ONLY : what, ngeo, step_ngeo, reduced_grid, fact_ngeo, &
                              max_geometries, start_geo, jump_geo
  USE control_mur,     ONLY : vmin_input, vmax_input, deltav, nvol, lmurn
  USE control_thermo,  ONLY : outdir_thermo, after_disp, with_eigen,          &
                              do_scf_relax, ltherm_dos, ltherm_freq
  USE control_pressure, ONLY : pressure
  USE data_files,      ONLY : flevdat, flfrc, flfrq, fldos, fltherm, flanhar, &
                              filband, flkeconv, flnkconv, flgrun, flpband,   &
                              flpgrun, flenergy, flprojlayer, flpbs, flvec, &
                              flepsilon, fleldos, fleltherm, fldosfrq
  USE postscript_files, ONLY : flpsband, flpsdisp, flpsdisp, flpsdos, &
                              flpstherm,  flpsanhar, flpsmur, flpskeconv, &
                              flpsnkconv, flpsgrun, flpsenergy, flpsepsilon, &
                              flpseldos, flpseltherm
  USE temperature,     ONLY : tmin, tmax, deltat, ntemp
  USE ifc,             ONLY : zasr
  USE control_dosq,    ONLY : nq1_d, nq2_d, nq3_d, ndos_input, deltafreq, &
                              freqmin_input, freqmax_input, phdos_sigma
  USE input_parameters, ONLY : max_seconds
  USE control_paths,   ONLY : q_in_band_form, q_in_cryst_coord, q2d, &
                              point_label_type, npx
  USE control_bands,   ONLY : emin_input, emax_input, nbnd_bands, lsym
  USE control_grun,    ONLY : temp_ph, volume_ph, celldm_ph, lv0_t, lb0_t, &
                              grunmin_input, grunmax_input
  USE control_gnuplot, ONLY : flgnuplot, lgnuplot, gnuplot_command
  USE control_asy,     ONLY : flasy, lasymptote, asymptote_command
  USE control_conv,    ONLY : nke, deltake, nkeden, deltakeden, &
                              nnk, deltank, nsigma, deltasigma
  USE control_elastic_constants, ONLY : delta_epsilon, ngeo_strain, &
                              epsilon_0, frozen_ions, elastic_algorithm, &
                              poly_degree
  USE control_quadratic_energy, ONLY : show_fit
  USE control_quartic_energy, ONLY : lquartic, lquartic_ph, lsolve
  USE piezoelectric_tensor, ONLY : nppl
  USE control_2d_bands,     ONLY : lprojpbs, nkz, sym_divide, identify_sur, &
                                   gap_thr, sur_layers, sur_thr, force_bands, &
                                   only_bands_plot, dump_states, subtract_vacuum
  USE control_eldos,        ONLY : deltae, ndose, nk1_d, nk2_d, nk3_d, &
                                   k1_d, k2_d, k3_d, sigmae, legauss
  USE control_xrdp,    ONLY : lambda, flxrdp, flpsxrdp, lformf, smin, smax, &
                              nspoint, flformf, flpsformf, lcm, lxrdp, &
                              lambda_elem
  USE output,          ONLY : fildyn
  USE mp_world,        ONLY : world_comm
  USE mp,              ONLY : mp_bcast
  USE io_global,       ONLY : meta_ionode_id
  !
  IMPLICIT NONE
  !
  CALL mp_bcast( what, meta_ionode_id, world_comm )
  CALL mp_bcast( ngeo, meta_ionode_id, world_comm )
  CALL mp_bcast( fact_ngeo, meta_ionode_id, world_comm )
  CALL mp_bcast( step_ngeo, meta_ionode_id, world_comm )
  CALL mp_bcast( reduced_grid, meta_ionode_id, world_comm )
  CALL mp_bcast( start_geo, meta_ionode_id, world_comm )
  CALL mp_bcast( jump_geo, meta_ionode_id, world_comm )
  CALL mp_bcast( lsolve, meta_ionode_id, world_comm )
  CALL mp_bcast( lquartic, meta_ionode_id, world_comm )
  CALL mp_bcast( lquartic_ph, meta_ionode_id, world_comm )
  CALL mp_bcast( show_fit, meta_ionode_id, world_comm )
  CALL mp_bcast( max_seconds, meta_ionode_id, world_comm )
  CALL mp_bcast( max_geometries, meta_ionode_id, world_comm )
  CALL mp_bcast( zasr, meta_ionode_id, world_comm )
  CALL mp_bcast( flfrc, meta_ionode_id, world_comm )
  CALL mp_bcast( flfrq, meta_ionode_id, world_comm )
  CALL mp_bcast( fldos, meta_ionode_id, world_comm )
  CALL mp_bcast( fltherm, meta_ionode_id, world_comm )
  CALL mp_bcast( fldosfrq, meta_ionode_id, world_comm )
  CALL mp_bcast( fleldos, meta_ionode_id, world_comm )
  CALL mp_bcast( fleltherm, meta_ionode_id, world_comm )
  CALL mp_bcast( flanhar, meta_ionode_id, world_comm )
  CALL mp_bcast( flkeconv, meta_ionode_id, world_comm )
  CALL mp_bcast( flnkconv, meta_ionode_id, world_comm )
  CALL mp_bcast( flgrun, meta_ionode_id, world_comm )
  CALL mp_bcast( flpgrun, meta_ionode_id, world_comm )
  CALL mp_bcast( temp_ph, meta_ionode_id, world_comm )
  CALL mp_bcast( volume_ph, meta_ionode_id, world_comm )
  CALL mp_bcast( celldm_ph, meta_ionode_id, world_comm )
  CALL mp_bcast( lv0_t, meta_ionode_id, world_comm )
  CALL mp_bcast( lb0_t, meta_ionode_id, world_comm )
  CALL mp_bcast( grunmin_input, meta_ionode_id, world_comm )
  CALL mp_bcast( grunmax_input, meta_ionode_id, world_comm )
  CALL mp_bcast( after_disp, meta_ionode_id, world_comm )
  CALL mp_bcast( with_eigen, meta_ionode_id, world_comm )
  CALL mp_bcast( do_scf_relax, meta_ionode_id, world_comm )
  CALL mp_bcast( ltherm_dos, meta_ionode_id, world_comm )
  CALL mp_bcast( ltherm_freq, meta_ionode_id, world_comm )
  CALL mp_bcast( fildyn, meta_ionode_id, world_comm )
  CALL mp_bcast( nq1_d, meta_ionode_id, world_comm )
  CALL mp_bcast( nq2_d, meta_ionode_id, world_comm )
  CALL mp_bcast( nq3_d, meta_ionode_id, world_comm )
  CALL mp_bcast( nk1_d, meta_ionode_id, world_comm )
  CALL mp_bcast( nk2_d, meta_ionode_id, world_comm )
  CALL mp_bcast( nk3_d, meta_ionode_id, world_comm )
  CALL mp_bcast( k1_d, meta_ionode_id, world_comm )
  CALL mp_bcast( k2_d, meta_ionode_id, world_comm )
  CALL mp_bcast( k3_d, meta_ionode_id, world_comm )
  CALL mp_bcast( deltae, meta_ionode_id, world_comm )
  CALL mp_bcast( ndose, meta_ionode_id, world_comm )
  CALL mp_bcast( sigmae, meta_ionode_id, world_comm )
  CALL mp_bcast( legauss, meta_ionode_id, world_comm )
  CALL mp_bcast( freqmin_input, meta_ionode_id, world_comm )
  CALL mp_bcast( freqmax_input, meta_ionode_id, world_comm )
  CALL mp_bcast( phdos_sigma, meta_ionode_id, world_comm )
  CALL mp_bcast( ndos_input, meta_ionode_id, world_comm )
  CALL mp_bcast( deltafreq, meta_ionode_id, world_comm )
  CALL mp_bcast( nbnd_bands, meta_ionode_id, world_comm )
  CALL mp_bcast( lsym, meta_ionode_id, world_comm )
  CALL mp_bcast( vmin_input, meta_ionode_id, world_comm )
  CALL mp_bcast( vmax_input, meta_ionode_id, world_comm )
  CALL mp_bcast( deltav, meta_ionode_id, world_comm )
  CALL mp_bcast( nvol, meta_ionode_id, world_comm )
  CALL mp_bcast( lmurn, meta_ionode_id, world_comm )
  CALL mp_bcast( nke, meta_ionode_id, world_comm )
  CALL mp_bcast( deltake, meta_ionode_id, world_comm )
  CALL mp_bcast( nkeden, meta_ionode_id, world_comm )
  CALL mp_bcast( deltakeden, meta_ionode_id, world_comm )
  CALL mp_bcast( delta_epsilon, meta_ionode_id, world_comm )
  CALL mp_bcast( epsilon_0, meta_ionode_id, world_comm )
  CALL mp_bcast( frozen_ions, meta_ionode_id, world_comm )
  CALL mp_bcast( elastic_algorithm, meta_ionode_id, world_comm )
  CALL mp_bcast( poly_degree, meta_ionode_id, world_comm )
  CALL mp_bcast( ngeo_strain, meta_ionode_id, world_comm )
  CALL mp_bcast( nnk, meta_ionode_id, world_comm )
  CALL mp_bcast( deltank, meta_ionode_id, world_comm )
  CALL mp_bcast( nsigma, meta_ionode_id, world_comm )
  CALL mp_bcast( deltasigma, meta_ionode_id, world_comm )
  CALL mp_bcast( tmin, meta_ionode_id, world_comm )
  CALL mp_bcast( tmax, meta_ionode_id, world_comm )
  CALL mp_bcast( deltat, meta_ionode_id, world_comm )
  CALL mp_bcast( ntemp, meta_ionode_id, world_comm )
  CALL mp_bcast( pressure, meta_ionode_id, world_comm )
  CALL mp_bcast( lambda, meta_ionode_id, world_comm )
  CALL mp_bcast( lambda_elem, meta_ionode_id, world_comm )
  CALL mp_bcast( smin, meta_ionode_id, world_comm )
  CALL mp_bcast( smax, meta_ionode_id, world_comm )
  CALL mp_bcast( nspoint, meta_ionode_id, world_comm )
  CALL mp_bcast( lformf, meta_ionode_id, world_comm )
  CALL mp_bcast( lcm, meta_ionode_id, world_comm )
  CALL mp_bcast( lxrdp, meta_ionode_id, world_comm )
  CALL mp_bcast( flxrdp, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsxrdp, meta_ionode_id, world_comm )
  CALL mp_bcast( flformf, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsformf, meta_ionode_id, world_comm )
  CALL mp_bcast( nppl, meta_ionode_id, world_comm )
  CALL mp_bcast( npx, meta_ionode_id, world_comm )
  CALL mp_bcast( lprojpbs, meta_ionode_id, world_comm )
  CALL mp_bcast( nkz, meta_ionode_id, world_comm )
  CALL mp_bcast( gap_thr, meta_ionode_id, world_comm )
  CALL mp_bcast( sym_divide, meta_ionode_id, world_comm )
  CALL mp_bcast( identify_sur, meta_ionode_id, world_comm )
  CALL mp_bcast( sur_thr, meta_ionode_id, world_comm )
  CALL mp_bcast( sur_layers, meta_ionode_id, world_comm )
  CALL mp_bcast( subtract_vacuum, meta_ionode_id, world_comm )
  CALL mp_bcast( force_bands, meta_ionode_id, world_comm )
  CALL mp_bcast( dump_states, meta_ionode_id, world_comm )
  CALL mp_bcast( only_bands_plot, meta_ionode_id, world_comm )
  CALL mp_bcast( flpband, meta_ionode_id, world_comm )
  CALL mp_bcast( filband, meta_ionode_id, world_comm )
  CALL mp_bcast( flgnuplot, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsmur, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsband, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsdos, meta_ionode_id, world_comm )
  CALL mp_bcast( flpstherm, meta_ionode_id, world_comm )
  CALL mp_bcast( flpseldos, meta_ionode_id, world_comm )
  CALL mp_bcast( flpseltherm, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsanhar, meta_ionode_id, world_comm )
  CALL mp_bcast( flpskeconv, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsnkconv, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsgrun, meta_ionode_id, world_comm )
  CALL mp_bcast( flpbs, meta_ionode_id, world_comm )
  CALL mp_bcast( flvec, meta_ionode_id, world_comm )
  CALL mp_bcast( flprojlayer, meta_ionode_id, world_comm )
  CALL mp_bcast( flenergy, meta_ionode_id, world_comm )
  CALL mp_bcast( flpsenergy, meta_ionode_id, world_comm )
  CALL mp_bcast( emin_input, meta_ionode_id, world_comm )
  CALL mp_bcast( emax_input, meta_ionode_id, world_comm )
  CALL mp_bcast( flevdat, meta_ionode_id, world_comm )
  CALL mp_bcast( q_in_band_form, meta_ionode_id, world_comm )
  CALL mp_bcast( q_in_cryst_coord, meta_ionode_id, world_comm )
  CALL mp_bcast( point_label_type, meta_ionode_id, world_comm )
  CALL mp_bcast( q2d, meta_ionode_id, world_comm )
  CALL mp_bcast( lgnuplot, meta_ionode_id, world_comm )
  CALL mp_bcast( gnuplot_command, meta_ionode_id, world_comm )
  CALL mp_bcast( lasymptote, meta_ionode_id, world_comm )
  CALL mp_bcast( asymptote_command, meta_ionode_id, world_comm )
  CALL mp_bcast( flasy, meta_ionode_id, world_comm )

  RETURN
END SUBROUTINE bcast_thermo_input
