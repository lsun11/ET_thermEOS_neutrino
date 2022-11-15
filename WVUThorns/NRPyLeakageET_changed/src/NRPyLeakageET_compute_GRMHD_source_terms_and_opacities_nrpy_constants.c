#include "cctk.h"
#include "NRPyLeakageET.h"

static CCTK_REAL EnsureFinite(const CCTK_REAL x) {
  if(robust_isfinite(x))
    return x;
  else
    return 1e-15;
}

/*
 * (c) Leo Werneck
 * Compute GRMHD source terms following Ruffert et al. (1996)
 * https://adsabs.harvard.edu/pdf/1996A%26A...311..532R
 */
void NRPyLeakageET_compute_GRMHD_source_terms_and_opacities_nrpy_constants(const CCTK_REAL rho_b,
                                                                           const CCTK_REAL Y_e,
                                                                           const CCTK_REAL T,
                                                                           const CCTK_REAL *restrict tau_nue,
                                                                           const CCTK_REAL *restrict tau_anue,
                                                                           const CCTK_REAL *restrict tau_nux,
                                                                           CCTK_REAL *restrict R_source,
                                                                           CCTK_REAL *restrict Q_source,
                                                                           CCTK_REAL *restrict kappa_nue,
                                                                           CCTK_REAL *restrict kappa_anue,
                                                                           CCTK_REAL *restrict kappa_nux) {


  // Step 1: Get chemical potentials and mass
  //         fractions using the EOS
  CCTK_REAL mu_e, mu_p, mu_n, muhat, X_p, X_n;
  WVU_EOS_mue_mup_mun_muhat_Xn_and_Xp_from_rho_Ye_T(rho_b, Y_e, T, &mu_e, &mu_p, &mu_n, &muhat, &X_p, &X_n);

  // Step 2: Compute rho_b in cgs units
  const CCTK_REAL rho_b_cgs = rho_b * NRPyLeakageET_units_geom_to_cgs_D;

  // Step 3: Compute Y_{pn} and Y_{np}
  const CCTK_REAL Y_p = Y_e;
  const CCTK_REAL Y_n = 1-Y_e;
  const CCTK_REAL exp_metahat = exp(-muhat/T);
  // Step 3.a: Compute Y_{np}
  CCTK_REAL Y_np = (Y_e < 0.5) ? (2.0*Y_e-1.0)/(exp_metahat-1.0) : Y_n;

  // Step 3.b: Compute Y_{pn}
  CCTK_REAL Y_pn = (Y_e > 0.5) ? exp_metahat*(2.0*Y_e-1.0)/(exp_metahat-1.0) : Y_p;

  // Step 3.c: Make sure both Y_np and Y_pn are non-negative
  if( Y_np < 0.0 ) Y_np = Y_n;
  if( Y_pn < 0.0 ) Y_pn = Y_p;

  // Step 4: Compute the source terms
  //         Note: The code below is generated by NRPy+
  const CCTK_REAL tmp_0 = (1.0/(T));
  const CCTK_REAL tmp_1 = mu_e*tmp_0;
  const CCTK_REAL tmp_2 = NRPyLeakageET_Fermi_Dirac_integrals(4, tmp_1);
  const CCTK_REAL tmp_3 = NRPyLeakageET_Fermi_Dirac_integrals(5, tmp_1)/tmp_2;
  const CCTK_REAL tmp_4 = exp(-tau_nue[0]);
  const CCTK_REAL tmp_6 = NRPyLeakageET_eta_nue_0*tmp_4 + (1 - tmp_4)*(-muhat*tmp_0 + tmp_1);
  const CCTK_REAL tmp_7 = ((NRPyLeakageET_alpha)*(NRPyLeakageET_alpha));
  const CCTK_REAL tmp_8 = M_PI/NRPyLeakageET_hc3;
  const CCTK_REAL tmp_10 = 8*NRPyLeakageET_N_A*NRPyLeakageET_beta*((T)*(T)*(T)*(T)*(T))*rho_b_cgs*tmp_8*((3.0/8.0)*tmp_7 + 1.0/8.0);
  const CCTK_REAL tmp_11 = NRPyLeakageET_enable_beta_nue*EnsureFinite(Y_pn*tmp_10*tmp_2/(exp(-tmp_3 + tmp_6) + 1));
  const CCTK_REAL tmp_12 = NRPyLeakageET_enable_brems_nui_anui*EnsureFinite(NRPyLeakageET_Brems_C1*NRPyLeakageET_Brems_zeta*pow(T, 4.5)*rho_b_cgs*(((X_n)*(X_n)) + (28.0/3.0)*X_n*X_p + ((X_p)*(X_p))));
  const CCTK_REAL tmp_13 = exp(-tau_anue[0]);
  const CCTK_REAL tmp_15 = NRPyLeakageET_eta_anue_0*tmp_13 + (1 - tmp_13)*(muhat*tmp_0 - tmp_1);
  const CCTK_REAL tmp_16 = NRPyLeakageET_Fermi_Dirac_integrals(3, tmp_1);
  const CCTK_REAL tmp_17 = (1.0/(tmp_16));
  const CCTK_REAL tmp_18 = NRPyLeakageET_Fermi_Dirac_integrals(4, -tmp_1);
  const CCTK_REAL tmp_19 = NRPyLeakageET_Fermi_Dirac_integrals(3, -tmp_1);
  const CCTK_REAL tmp_20 = (1.0/(tmp_19));
  const CCTK_REAL tmp_21 = -1.0/2.0*tmp_17*tmp_2 - 1.0/2.0*tmp_18*tmp_20;
  const CCTK_REAL tmp_22 = ((M_PI)*(M_PI));
  const CCTK_REAL tmp_24 = (1.0/((NRPyLeakageET_hc3)*(NRPyLeakageET_hc3)));
  const CCTK_REAL tmp_25 = tmp_16*tmp_22*tmp_24;
  const CCTK_REAL tmp_26 = pow(T, 8);
  const CCTK_REAL tmp_28 = (16.0/9.0)*NRPyLeakageET_beta*tmp_19*tmp_25*tmp_26;
  const CCTK_REAL tmp_29 = NRPyLeakageET_enable_pair_nue_anue*EnsureFinite(NRPyLeakageET_C1pC2_nue_anue*tmp_28/((exp(tmp_15 + tmp_21) + 1)*(exp(tmp_21 + tmp_6) + 1)));
  const CCTK_REAL tmp_31 = (1.0/3.0)*tmp_22 + ((mu_e)*(mu_e))/((T)*(T));
  const CCTK_REAL tmp_32 = NRPyLeakageET_gamma_0*sqrt(tmp_31);
  const CCTK_REAL tmp_34 = ((NRPyLeakageET_gamma_0)*(NRPyLeakageET_gamma_0))*tmp_31/(tmp_32 + 1);
  const CCTK_REAL tmp_35 = -1.0/2.0*tmp_34 - 1;
  const CCTK_REAL tmp_36 = (1.0/3.0)*((M_PI)*(M_PI)*(M_PI))*NRPyLeakageET_beta*pow(NRPyLeakageET_gamma_0, 6)*tmp_24*tmp_26*((tmp_31)*(tmp_31)*(tmp_31))*(tmp_32 + 1)*exp(-tmp_32)/NRPyLeakageET_alpha_fs;
  const CCTK_REAL tmp_37 = NRPyLeakageET_enable_plasmon_nue_anue*EnsureFinite(((NRPyLeakageET_C_V)*(NRPyLeakageET_C_V))*tmp_36/((exp(tmp_15 + tmp_35) + 1)*(exp(tmp_35 + tmp_6) + 1)));
  const CCTK_REAL tmp_38 = tmp_12 + tmp_29 + tmp_37;
  const CCTK_REAL tmp_41 = (1 - Y_e)*((5.0/24.0)*tmp_7 + 1.0/24.0)/((2.0/3.0)*MAX(mu_n*tmp_0, 0) + 1);
  const CCTK_REAL tmp_42 = NRPyLeakageET_N_A*NRPyLeakageET_sigma_0*((T)*(T))*rho_b_cgs/((NRPyLeakageET_m_e_c2)*(NRPyLeakageET_m_e_c2));
  const CCTK_REAL tmp_43 = NRPyLeakageET_Fermi_Dirac_integrals(2, tmp_6);
  const CCTK_REAL tmp_44 = NRPyLeakageET_Fermi_Dirac_integrals(4, tmp_6);
  const CCTK_REAL tmp_45 = tmp_44/tmp_43;
  const CCTK_REAL tmp_47 = ((NRPyLeakageET_C_V - 1)*(NRPyLeakageET_C_V - 1));
  const CCTK_REAL tmp_48 = Y_e*((1.0/6.0)*tmp_47 + (5.0/24.0)*tmp_7)/((2.0/3.0)*MAX(mu_p*tmp_0, 0) + 1);
  const CCTK_REAL tmp_49 = tmp_42*tmp_48;
  const CCTK_REAL tmp_50 = (3.0/4.0)*tmp_7 + 1.0/4.0;
  const CCTK_REAL tmp_51 = NRPyLeakageET_Fermi_Dirac_integrals(5, tmp_6);
  const CCTK_REAL tmp_52 = Y_np*tmp_50/(exp(tmp_1 - tmp_51/tmp_44) + 1);
  const CCTK_REAL tmp_53 = EnsureFinite(tmp_45*tmp_49) + EnsureFinite(tmp_41*tmp_42*tmp_45) + EnsureFinite(tmp_42*tmp_45*tmp_52);
  const CCTK_REAL tmp_55 = 4*((T)*(T)*(T))*tmp_8;
  const CCTK_REAL tmp_56 = 6/NRPyLeakageET_units_geom_to_cgs_L;
  const CCTK_REAL tmp_57 = NRPyLeakageET_Fermi_Dirac_integrals(5, -tmp_1)/tmp_18;
  const CCTK_REAL tmp_58 = NRPyLeakageET_enable_beta_anue*EnsureFinite(Y_np*tmp_10*tmp_18/(exp(tmp_15 - tmp_57) + 1));
  const CCTK_REAL tmp_60 = NRPyLeakageET_Fermi_Dirac_integrals(2, tmp_15);
  const CCTK_REAL tmp_61 = NRPyLeakageET_Fermi_Dirac_integrals(4, tmp_15);
  const CCTK_REAL tmp_62 = tmp_42*tmp_61/tmp_60;
  const CCTK_REAL tmp_63 = NRPyLeakageET_Fermi_Dirac_integrals(5, tmp_15);
  const CCTK_REAL tmp_64 = Y_pn*tmp_50/(exp(-tmp_1 - tmp_63/tmp_61) + 1);
  const CCTK_REAL tmp_65 = EnsureFinite(tmp_41*tmp_62) + EnsureFinite(tmp_48*tmp_62) + EnsureFinite(tmp_62*tmp_64);
  const CCTK_REAL tmp_66 = EnsureFinite(NRPyLeakageET_Brems_C2*T*tmp_12/NRPyLeakageET_Brems_C1);
  const CCTK_REAL tmp_67 = 32*pow(T, 9);
  const CCTK_REAL tmp_68 = (1.0/64.0)*((NRPyLeakageET_hc3)*(NRPyLeakageET_hc3))*tmp_17*tmp_20*(tmp_18*tmp_25*tmp_67 + tmp_19*tmp_2*tmp_22*tmp_24*tmp_67)/(tmp_22*tmp_26);
  const CCTK_REAL tmp_69 = (1.0/2.0)*T*(tmp_34 + 2);
  const CCTK_REAL tmp_70 = NRPyLeakageET_Fermi_Dirac_integrals(3, 0);
  const CCTK_REAL tmp_71 = NRPyLeakageET_Fermi_Dirac_integrals(5, 0)/tmp_70;
  const CCTK_REAL tmp_73 = EnsureFinite(tmp_49*tmp_71) + EnsureFinite(tmp_41*tmp_42*tmp_71);
  const CCTK_REAL tmp_74 = 4*((T)*(T)*(T)*(T))*tmp_8;
  const CCTK_REAL tmp_75 = tmp_66 + EnsureFinite(tmp_29*tmp_68) + EnsureFinite(tmp_37*tmp_69);
  const CCTK_REAL tmp_76 = tmp_75 + EnsureFinite(T*tmp_11*tmp_3);
  const CCTK_REAL tmp_78 = NRPyLeakageET_Fermi_Dirac_integrals(3, tmp_6);
  const CCTK_REAL tmp_79 = tmp_51/tmp_78;
  const CCTK_REAL tmp_81 = EnsureFinite(tmp_49*tmp_79) + EnsureFinite(tmp_41*tmp_42*tmp_79) + EnsureFinite(tmp_42*tmp_52*tmp_79);
  const CCTK_REAL tmp_82 = tmp_75 + EnsureFinite(T*tmp_57*tmp_58);
  const CCTK_REAL tmp_83 = NRPyLeakageET_Fermi_Dirac_integrals(3, tmp_15);
  const CCTK_REAL tmp_84 = tmp_63/tmp_83;
  const CCTK_REAL tmp_86 = EnsureFinite(tmp_49*tmp_84) + EnsureFinite(tmp_41*tmp_42*tmp_84) + EnsureFinite(tmp_42*tmp_64*tmp_84);
  const CCTK_REAL tmp_87 = NRPyLeakageET_Fermi_Dirac_integrals(4, 0)/NRPyLeakageET_Fermi_Dirac_integrals(2, 0);
  *R_source = NRPyLeakageET_amu*NRPyLeakageET_units_cgs_to_geom_R*(-(tmp_11 + tmp_38)/(((tau_nue[0])*(tau_nue[0]))*tmp_56*(tmp_11 + tmp_38)/(tmp_53*MAX(tmp_43*tmp_55, 1.0000000000000001e-15)) + 1) + (tmp_38 + tmp_58)/(((tau_anue[0])*(tau_anue[0]))*tmp_56*(tmp_38 + tmp_58)/(tmp_65*MAX(tmp_55*tmp_60, 1.0000000000000001e-15)) + 1));
  *Q_source = NRPyLeakageET_units_cgs_to_geom_Q*(-tmp_76/(((tau_nue[1])*(tau_nue[1]))*tmp_56*tmp_76/(tmp_81*MAX(tmp_74*tmp_78, 1.0000000000000001e-15)) + 1) - tmp_82/(((tau_anue[1])*(tau_anue[1]))*tmp_56*tmp_82/(tmp_86*MAX(tmp_74*tmp_83, 1.0000000000000001e-15)) + 1) - 4*(tmp_66 + EnsureFinite(NRPyLeakageET_enable_pair_nux_anux*tmp_68*EnsureFinite(NRPyLeakageET_C1pC2_nux_anux*tmp_28/((exp(tmp_21) + 1)*(exp(tmp_21) + 1)))) + EnsureFinite(NRPyLeakageET_enable_plasmon_nux_anux*tmp_69*EnsureFinite(tmp_36*tmp_47/((exp(tmp_35) + 1)*(exp(tmp_35) + 1)))))/(((tau_nux[1])*(tau_nux[1]))*tmp_56*tmp_76/(tmp_73*MAX(tmp_70*tmp_74, 1.0000000000000001e-15)) + 1));
  kappa_nue[0] = NRPyLeakageET_units_geom_to_cgs_L*tmp_53;
  kappa_nue[1] = NRPyLeakageET_units_geom_to_cgs_L*tmp_81;
  kappa_anue[0] = NRPyLeakageET_units_geom_to_cgs_L*tmp_65;
  kappa_anue[1] = NRPyLeakageET_units_geom_to_cgs_L*tmp_86;
  kappa_nux[0] = NRPyLeakageET_units_geom_to_cgs_L*(EnsureFinite(tmp_49*tmp_87) + EnsureFinite(tmp_41*tmp_42*tmp_87));
  kappa_nux[1] = NRPyLeakageET_units_geom_to_cgs_L*tmp_73;
}
