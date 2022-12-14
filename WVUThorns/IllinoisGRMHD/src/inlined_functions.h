#ifndef INLINED_FUNCTIONS_H_
#define INLINED_FUNCTIONS_H_

static inline void find_cp_cm(CCTK_REAL &cplus,CCTK_REAL &cminus,CCTK_REAL v02,CCTK_REAL u0,
                              CCTK_REAL vi,CCTK_REAL ONE_OVER_LAPSE_SQUARED,CCTK_REAL shifti,CCTK_REAL psim4,CCTK_REAL gupii) {
  // This computes phase speeds in the direction given by flux_dirn.
  //  Note that we replace the full dispersion relation with a simpler
  //     one, which overestimates the max. speeds by a factor of ~2.
  //     See full discussion around Eqs. 49 and 50 in
  //     http://arxiv.org/pdf/astro-ph/0503420.pdf .
  //  What follows is a complete derivation of the quadratic we solve.
  // wcm = (-k_0 u0 - k_x ux)
  // kcm^2 = K_{\mu} K^{\mu},
  // K_{\mu} K^{\mu} = (g_{\mu a} + u_{\mu} u_a) k^a * g^{\mu b} [ (g_{c b} + u_c u_b) k^c ]
  // --> g^{\mu b} (g_{c b} + u_{c} u_{b}) k^c = (\delta^{\mu}_c + u_c u^{\mu} ) k^c
  //                 = (g_{\mu a} + u_{\mu} u_a) k^a * (\delta^{\mu}_c + u_c u^{\mu} ) k^c
  //                 =[(g_{\mu a} + u_{\mu} u_a) \delta^{\mu}_c + (g_{\mu a} + u_{\mu} u_a) u_c u^{\mu} ] k^c k^a
  //                 =[(g_{c a} + u_c u_a) + (u_c u_a -  u_a u_c] k^c k^a
  //                 =(g_{c a} + u_c u_a) k^c k^a
  //                 = k_a k^a + u^c u^a k_c k_a
  // k^a = g^{\mu a} k_{\mu} = g^{0 a} k_0 + g^{x a} k_x
  // k_a k^a = k_0 g^{0 0} k_0 + k_x k_0 g^{0 x} + g^{x 0} k_0 k_x + g^{x x} k_x k_x
  //         = g^{00} (k_0)^2 + 2 g^{x0} k_0 k_x + g^{xx} (k_x)^2
  // u^c u^a k_c k_a = (u^0 k_0 + u^x k_x) (u^0 k_0 + u^x k_x) = (u^0 k_0)^2 + 2 u^x k_x u^0 k_0 + (u^x k_x)^2
  // (k_0 u0)^2  + 2 k_x ux k_0 u0 + (k_x ux)^2 = v02 [ (u^0 k_0)^2 + 2 u^x k_x u^0 k_0 + (u^x k_x)^2 + g^{00} (k_0)^2 + 2 g^{x0} k_0 k_x + g^{xx} (k_x)^2]
  // (1-v02) (u^0 k_0 + u^x k_x)^2 = v02 (g^{00} (k_0)^2 + 2 g^{x0} k_0 k_x + g^{xx} (k_x)^2)
  // (1-v02) (u^0 k_0/k_x + u^x)^2 = v02 (g^{00} (k_0/k_x)^2 + 2 g^{x0} k_0/k_x + g^{xx})
  // (1-v02) (u^0 X + u^x)^2 = v02 (g^{00} X^2 + 2 g^{x0} X + g^{xx})
  // (1-v02) (u0^2 X^2 + 2 ux u0 X + ux^2) = v02 (g^{00} X^2 + 2 g^{x0} X + g^{xx})
  // X^2 ( (1-v02) u0^2 - v02 g^{00}) + X (2 ux u0 (1-v02) - 2 v02 g^{x0}) + (1-v02) ux^2 - v02 g^{xx}
  // a = (1-v02) u0^2 - v02 g^{00} = (1-v02) u0^2 + v02/lapse^2 <-- VERIFIED
  // b = 2 ux u0 (1-v02) - 2 v02 shiftx/lapse^2 <-- VERIFIED, X->-X, because X = -w/k_1, and we are solving for -X.
  // c = (1-v02) ux^2 - v02 (gupxx*psim4 - (shiftx/lapse)^2) <-- VERIFIED
  // v02 = v_A^2 + c_s^2 (1 - v_A^2)
  CCTK_REAL u0_SQUARED=SQR(u0);


  //Find cplus, cminus:
  CCTK_REAL a = u0_SQUARED * (1.0-v02) + v02*ONE_OVER_LAPSE_SQUARED;
  CCTK_REAL b = 2.0* ( shifti*ONE_OVER_LAPSE_SQUARED * v02 - u0_SQUARED * vi * (1.0-v02) );
  CCTK_REAL c = u0_SQUARED*SQR(vi) * (1.0-v02) - v02 * ( psim4*gupii -
                                                         SQR(shifti)*ONE_OVER_LAPSE_SQUARED);

  CCTK_REAL detm = b*b - 4.0*a*c;
  //ORIGINAL LINE OF CODE:
  //if(detm < 0.0) detm = 0.0;
  //New line of code (without the if() statement) has the same effect:
  detm = sqrt(0.5*(detm + fabs(detm))); /* Based on very nice suggestion from Roland Haas */

  cplus = 0.5*(detm-b)/a;
  cminus = -0.5*(detm+b)/a;
  if (cplus < cminus) {
    CCTK_REAL cp = cminus;
    cminus = cplus;
    cplus = cp;
  }
}

static inline void compute_cs2_and_enthalpy( const igm_eos_parameters eos,
                                             CCTK_REAL *restrict PRIMS,
                                             CCTK_REAL *restrict c_s_squared,
                                             CCTK_REAL *restrict enthalpy ) {
  if( eos.is_Hybrid ) {
    CCTK_REAL P_cold,eps_cold,dPcold_drho=0,eps_th=0,h=0,Gamma_cold=0;
    compute_P_cold__eps_cold__dPcold_drho__eps_th__h__Gamma_cold(PRIMS,eos,P_cold,eps_cold,dPcold_drho,eps_th,h,Gamma_cold);
    // Now compute cs2 squared
    *c_s_squared  = (dPcold_drho + eos.Gamma_th*(eos.Gamma_th-1.0)*eps_th)/h;
    // And set the enthalpy
    *enthalpy     = h;
  }
  else if( eos.is_Tabulated ) {

    // We have simplified the EOS calls during MHD rhs evaluation
    // so that we should have all quantities (including the temperature)
    // in the right and left faces. So let's stick with the less expensive
    // EOS call for now.
    CCTK_REAL xrho  = PRIMS[RHOB       ];
    CCTK_REAL xye   = PRIMS[YEPRIM     ];
    CCTK_REAL xtemp = PRIMS[TEMPERATURE];
    CCTK_REAL xprs  = 0.0;
    CCTK_REAL xeps  = 0.0;
    CCTK_REAL xent  = 0.0;
    CCTK_REAL xcs2  = 0.0;
    enforce_table_bounds_rho_Ye_T( eos,&xrho,&xye,&xtemp );
    WVU_EOS_P_eps_S_and_cs2_from_rho_Ye_T(xrho,xye,xtemp, &xprs,&xeps,&xent,&xcs2);

    // Now update everything, since we may have imposed limits
    PRIMS[RHOB       ] = xrho;
    PRIMS[YEPRIM     ] = xye;
    PRIMS[TEMPERATURE] = xtemp;
    PRIMS[PRESSURE   ] = xprs;
    PRIMS[EPSILON    ] = xeps;
    PRIMS[ENTROPY    ] = xent;

    // Now compute the enthalpy
    *enthalpy = 1.0 + xeps + xprs/xrho;

    // And update cs2
    *c_s_squared = xcs2;
  }
}

static inline void compute_v02( const igm_eos_parameters eos,
                                const CCTK_REAL h,
                                const CCTK_REAL c_s_squared,
                                CCTK_REAL *restrict smallb,
                                CCTK_REAL *restrict PRIMS,
                                CCTK_REAL &v02L) {
  // Check rho_b
  if(PRIMS[RHOB]<=0) { v02L=1.0; return; }
  // Compute v_A = Alfven speed = sqrt( b^2/(rho0 h + b^2) )
  CCTK_REAL v_A_squared = smallb[SMALLB2]/(smallb[SMALLB2] + PRIMS[RHOB]*(h));
  // Finally compute v02L
  v02L = v_A_squared + c_s_squared*(1.0-v_A_squared);
}

/* Function    : font_fix__rhob_loop()
 * Authors     : Leo Werneck
 * Description : Determines rhob using the font fix prescription
 * Dependencies: find_polytropic_K_and_Gamma_index()
 *             : compute_P_cold__eps_cold()
 * Reference   : Etienne et al. (2011) [https://arxiv.org/pdf/1112.0568.pdf]
 *
 * Inputs      : maxits          - maximum number of iterations allowed
 *             : tol             - font fix tolerance
 *             : W               - See eq. (A26)
 *             : Sf2             - S_{fluid}^{2}, see eq. (A24)
 *             : Psim6           - This is equal to sqrt(\gamma)
 *             : sdots           - \tilde{S}_{\mu}\tilde{S}^{\mu}
 *             : BbardotS2       - (\bar{B}^{\mu}S_{\mu})^{2},
 *             : B2bar           - \bar{B}^{2}, see eq. (A28)
 *             : CONSERVS        - Array of conservative variables
 *             : eos             - Struct of EOS parameters
 *             : rhob_in         - Initial value of rhob
 *             : rhob_out        - Output variable
 *
 * Outputs     : rhob_out        - Updated value of rhob
 *             : return value: 0 - Font fix worked
 *             : return value: 1 - Font fix failed
 */
inline int font_fix__rhob_loop( const int maxits, const CCTK_REAL tol,
                                const CCTK_REAL W_in, const CCTK_REAL Sf2_in, const CCTK_REAL Psim6, const CCTK_REAL sdots, const CCTK_REAL BbardotS2, const CCTK_REAL B2bar,
                                const CCTK_REAL *restrict CONSERVS,
                                const igm_eos_parameters eos, const CCTK_REAL rhob_in, CCTK_REAL &rhob_out ) {

  /* Declare basic variables */
  bool fontcheck=true;
  int itcount = 0, j0, j1;
  CCTK_REAL W0, Sf20, rhob0, rhob1, h, P_cold, eps_cold;
  CCTK_REAL W   = W_in;
  CCTK_REAL Sf2 = Sf2_in;

  //////////////////////
  // OUTER LOOP START //
  //////////////////////
  while(fontcheck && itcount < maxits) {

    /* Set variables to their input values */
    itcount++;
    W0    = W;
    Sf20  = Sf2;
    rhob1 = rhob_in;

    /* Based on rhob_in (i.e. rhob1), determine the
     * polytropic index j1
     */
    j1 = find_polytropic_K_and_Gamma_index(eos,rhob1);

    //////////////////////
    // INNER LOOP START //
    //////////////////////
    do {

      /* Set rhob0/j0 to be equal to the rhob/j used
       * in the previous iteration, i.e. rhob1/j1.
       */
      rhob0 = rhob1;
      j0    = j1;

      /* Compute h using h_cold and our polytropic EOS
       * .------------------------------------------.
       * | h = h_cold = 1 + eps_cold + P_cold/rhob. |
       * .------------------------------------------.
       */
      compute_P_cold__eps_cold(eos,rhob0, P_cold, eps_cold);
      h = 1.0 + eps_cold + P_cold/rhob0;

      /* Update rhob using eq. (A62) in Etienne et al. (2011)
       *          https://arxiv.org/pdf/1112.0568.pdf
       * .---------------------------------------------------------------------------.
       * | rhob = rho_star * Psi^{-6} / sqrt( 1 + S_fluid^{2}/( (rho_star*h)^{2} ) ) |
       * .---------------------------------------------------------------------------.
       */
      rhob1 = CONSERVS[RHOSTAR]*Psim6/sqrt(1.0+Sf20/SQR(CONSERVS[RHOSTAR]*h));

      /* Update j1 */
      j1 = find_polytropic_K_and_Gamma_index(eos,rhob1);

    }  while( fabs(rhob1-rhob0) > rhob1*tol || j1 != j0);
    //////////////////////
    //  INNER LOOP END  //
    //////////////////////

    /* Output the last value of rhob */
    rhob_out = rhob1;

    /* Perform physical checks on the variables
     * and output the last value of h obtained
     */
    compute_P_cold__eps_cold(eos,rhob_out, P_cold, eps_cold);
    h = 1.0 + eps_cold + P_cold/rhob_out;

    /* Set W based on eq. (A60) in Etienne et al. (2011)
     *       https://arxiv.org/pdf/1112.0568.pdf
     * .-------------------------------------------------------.
     * | W = psi^{-6} * sqrt( S_fluid^{2} + (rho_star*h)^{2} ) |
     * .-------------------------------------------------------.
     */
    W = sqrt( Sf20 + SQR(CONSERVS[RHOSTAR]*h))*Psim6;

    /* Then update S_{fluid}^{2} using eq. (A61) in Etienne et al. (2011)
     *           https://arxiv.org/pdf/1112.0568.pdf
     * .---------------------------------------------------------------------------.
     * | S_fluid^{2} = ( W^{2}*S^{2} + (B.S)^2*(B^{2} + 2W) )/( ( W + B^{2} )^{2} )|
     * .---------------------------------------------------------------------------.
     */
    Sf2 = (SQR(W)*sdots + BbardotS2*(B2bar + 2.0*W))/SQR(W+B2bar);

    if ( fabs(W-W0) < W*tol && fabs(Sf20-Sf2) < Sf2*tol) fontcheck=false;

  }
  //////////////////////
  //  OUTER LOOP END  //
  //////////////////////

  /* If the code converged before the max
   * number of iterations were exceeded,
   * return 0, otherwise return 1.
   */
  if(fontcheck || itcount >= maxits) {
    return 1;
  }
  else {
    return 0;
  }
}


// b_x = g_{\mu x} b^{\mu}
//     = g_{t x} b^t + g_{i x} b^i
//     = b^t gamma_{xj} beta^j + gamma_{ix} b^i
//     = gamma_{xj} (b^j + beta^j b^t)
static inline void lower_4vector_output_spatial_part(CCTK_REAL psi4,CCTK_REAL *METRIC,CCTK_REAL *smallb, CCTK_REAL *smallb_lower) {
  smallb_lower[SMALLBX] = psi4*( METRIC[GXX]*(smallb[SMALLBX]+smallb[SMALLBT]*METRIC[SHIFTX]) + METRIC[GXY]*(smallb[SMALLBY]+smallb[SMALLBT]*METRIC[SHIFTY]) +
                                 METRIC[GXZ]*(smallb[SMALLBZ]+smallb[SMALLBT]*METRIC[SHIFTZ]) );
  smallb_lower[SMALLBY] = psi4*( METRIC[GXY]*(smallb[SMALLBX]+smallb[SMALLBT]*METRIC[SHIFTX]) + METRIC[GYY]*(smallb[SMALLBY]+smallb[SMALLBT]*METRIC[SHIFTY]) +
                                 METRIC[GYZ]*(smallb[SMALLBZ]+smallb[SMALLBT]*METRIC[SHIFTZ]) );
  smallb_lower[SMALLBZ] = psi4*( METRIC[GXZ]*(smallb[SMALLBX]+smallb[SMALLBT]*METRIC[SHIFTX]) + METRIC[GYZ]*(smallb[SMALLBY]+smallb[SMALLBT]*METRIC[SHIFTY]) +
                                 METRIC[GZZ]*(smallb[SMALLBZ]+smallb[SMALLBT]*METRIC[SHIFTZ]) );
}


static inline void impose_speed_limit_output_u0(CCTK_REAL *METRIC,CCTK_REAL *U,CCTK_REAL psi4,CCTK_REAL ONE_OVER_LAPSE,output_stats &stats, CCTK_REAL &u0_out) {

#ifndef ENABLE_STANDALONE_IGM_C2P_SOLVER
  DECLARE_CCTK_PARAMETERS;
#endif


  // Derivation of first equation:
  // \gamma_{ij} (v^i + \beta^i)(v^j + \beta^j)/(\alpha)^2
  //   = \gamma_{ij} 1/(u^0)^2 ( \gamma^{ik} u_k \gamma^{jl} u_l /(\alpha)^2 <- Using Eq. 53 of arXiv:astro-ph/0503420
  //   = 1/(u^0 \alpha)^2 u_j u_l \gamma^{jl}  <- Since \gamma_{ij} \gamma^{ik} = \delta^k_j
  //   = 1/(u^0 \alpha)^2 ( (u^0 \alpha)^2 - 1 ) <- Using Eq. 56 of arXiv:astro-ph/0503420
  //   = 1 - 1/(u^0 \alpha)^2 <= 1
  CCTK_REAL one_minus_one_over_alpha_u0_squared = psi4*(METRIC[GXX]* SQR(U[VX] + METRIC[SHIFTX]) +
                                                        2.0*METRIC[GXY]*(U[VX] + METRIC[SHIFTX])*(U[VY] + METRIC[SHIFTY]) +
                                                        2.0*METRIC[GXZ]*(U[VX] + METRIC[SHIFTX])*(U[VZ] + METRIC[SHIFTZ]) +
                                                        METRIC[GYY]* SQR(U[VY] + METRIC[SHIFTY]) +
                                                        2.0*METRIC[GYZ]*(U[VY] + METRIC[SHIFTY])*(U[VZ] + METRIC[SHIFTZ]) +
                                                        METRIC[GZZ]* SQR(U[VZ] + METRIC[SHIFTZ]) )*SQR(ONE_OVER_LAPSE);


  /*** Limit velocity to GAMMA_SPEED_LIMIT ***/
  const CCTK_REAL ONE_MINUS_ONE_OVER_GAMMA_SPEED_LIMIT_SQUARED = 1.0-1.0/SQR(GAMMA_SPEED_LIMIT);
  if(one_minus_one_over_alpha_u0_squared > ONE_MINUS_ONE_OVER_GAMMA_SPEED_LIMIT_SQUARED) {
    CCTK_REAL correction_fac = sqrt(ONE_MINUS_ONE_OVER_GAMMA_SPEED_LIMIT_SQUARED/one_minus_one_over_alpha_u0_squared);
    U[VX] = (U[VX] + METRIC[SHIFTX])*correction_fac-METRIC[SHIFTX];
    U[VY] = (U[VY] + METRIC[SHIFTY])*correction_fac-METRIC[SHIFTY];
    U[VZ] = (U[VZ] + METRIC[SHIFTZ])*correction_fac-METRIC[SHIFTZ];
    one_minus_one_over_alpha_u0_squared=ONE_MINUS_ONE_OVER_GAMMA_SPEED_LIMIT_SQUARED;
    stats.failure_checker+=1000;
  }


  // A = 1.0-one_minus_one_over_alpha_u0_squared = 1-(1-1/(al u0)^2) = 1/(al u0)^2
  // 1/sqrt(A) = al u0
  //CCTK_REAL alpha_u0_minus_one = 1.0/sqrt(1.0-one_minus_one_over_alpha_u0_squared)-1.0;
  //u0_out          = (alpha_u0_minus_one + 1.0)*ONE_OVER_LAPSE;
  CCTK_REAL alpha_u0 = 1.0/sqrt(1.0-one_minus_one_over_alpha_u0_squared);
  if(std::isnan(alpha_u0*ONE_OVER_LAPSE)) {
    CCTK_VINFO("*********************************************");
    CCTK_VINFO("Metric/psi4: %e %e %e %e %e %e / %e",METRIC[GXX],METRIC[GXY],METRIC[GXZ],METRIC[GYY],METRIC[GYZ],METRIC[GZZ],psi4);
    CCTK_VINFO("Lapse/shift: %e (=1/%e) / %e %e %e",1.0/ONE_OVER_LAPSE,ONE_OVER_LAPSE,METRIC[SHIFTX],METRIC[SHIFTY],METRIC[SHIFTZ]);
    CCTK_VINFO("Velocities : %e %e %e",U[VX],U[VY],U[VZ]);
    CCTK_VINFO("Found nan while computing u^{0} in function %s (file: %s)",__func__,__FILE__);
    CCTK_VINFO("*********************************************");
    stats.nan_found=1;
  }
  u0_out = alpha_u0*ONE_OVER_LAPSE;
}

// The two lines of code below are written to reduce roundoff error and were in the above function. I don't think they reduce error.
// one_over_alpha_u0  = sqrt(1.0-one_minus_one_over_alpha_u0_squared);
/* Proof of following line: */
/*   [        1-1/(alphau0)^2         ] / [ 1/(alphau0) (1 + 1/(alphau0)) ] */
/* = [ (alphau0)^2 - 1)/((alphau0)^2) ] / [ 1/(alphau0) + 1/(alphau0)^2   ] */
/* = [ (alphau0)^2 - 1)/((alphau0)^2) ] / [  (alphau0 + 1)/(alphau0)^2    ] */
/* = [        (alphau0)^2 - 1)        ] / [        (alphau0 + 1)          ] */
/*   [   (alphau0 + 1) (alphau0 - 1)  ] / [        (alphau0 + 1)          ] */
/* =                              alphau0 - 1                               */
//alpha_u0_minus_one = one_minus_one_over_alpha_u0_squared/one_over_alpha_u0/(1.0+one_over_alpha_u0);
//u0_out = (alpha_u0_minus_one+1.0)*ONE_OVER_LAPSE;

static inline void compute_smallba_b2_and_u_i_over_u0_psi4(CCTK_REAL *METRIC,CCTK_REAL *METRIC_LAP_PSI4,CCTK_REAL *U,CCTK_REAL u0L,CCTK_REAL ONE_OVER_LAPSE_SQRT_4PI,
                                                           CCTK_REAL &u_x_over_u0_psi4,CCTK_REAL &u_y_over_u0_psi4,CCTK_REAL &u_z_over_u0_psi4,CCTK_REAL *smallb) {

  // NOW COMPUTE b^{\mu} and b^2 = b^{\mu} b^{\nu} g_{\mu \nu}
  CCTK_REAL ONE_OVER_U0 = 1.0/u0L;
  CCTK_REAL shiftx_plus_vx = (METRIC[SHIFTX]+U[VX]);
  CCTK_REAL shifty_plus_vy = (METRIC[SHIFTY]+U[VY]);
  CCTK_REAL shiftz_plus_vz = (METRIC[SHIFTZ]+U[VZ]);

  // Eq. 56 in http://arxiv.org/pdf/astro-ph/0503420.pdf:
  //  u_i = gamma_{ij} u^0 (v^j + beta^j), gamma_{ij} is the physical metric, and gamma_{ij} = Psi4 * METRIC[Gij], since METRIC[Gij] is the conformal metric.
  u_x_over_u0_psi4 =  METRIC[GXX]*shiftx_plus_vx + METRIC[GXY]*shifty_plus_vy + METRIC[GXZ]*shiftz_plus_vz;
  u_y_over_u0_psi4 =  METRIC[GXY]*shiftx_plus_vx + METRIC[GYY]*shifty_plus_vy + METRIC[GYZ]*shiftz_plus_vz;
  u_z_over_u0_psi4 =  METRIC[GXZ]*shiftx_plus_vx + METRIC[GYZ]*shifty_plus_vy + METRIC[GZZ]*shiftz_plus_vz;

  // Eqs. 23 and 31 in http://arxiv.org/pdf/astro-ph/0503420.pdf:
  //   Compute alpha sqrt(4 pi) b^t = u_i B^i
  CCTK_REAL alpha_sqrt_4pi_bt = ( u_x_over_u0_psi4*U[BX_CENTER] + u_y_over_u0_psi4*U[BY_CENTER] + u_z_over_u0_psi4*U[BZ_CENTER] ) * METRIC_LAP_PSI4[PSI4]*u0L;

  // Eq. 24 in http://arxiv.org/pdf/astro-ph/0503420.pdf:
  // b^i = B^i_u / sqrt(4 pi)
  // b^i = ( B^i/alpha + B^0_u u^i ) / ( u^0 sqrt(4 pi) )
  // b^i = ( B^i/alpha +  sqrt(4 pi) b^t u^i ) / ( u^0 sqrt(4 pi) )
  // b^i = ( B^i +  alpha sqrt(4 pi) b^t u^i ) / ( alpha u^0 sqrt(4 pi) )
  // b^i = ( B^i/u^0 +  alpha sqrt(4 pi) b^t u^i/u^0 ) / ( alpha sqrt(4 pi) )
  // b^i = ( B^i/u^0 +  alpha sqrt(4 pi) b^t v^i ) / ( alpha sqrt(4 pi) )
  smallb[SMALLBX] = (U[BX_CENTER]*ONE_OVER_U0 + U[VX]*alpha_sqrt_4pi_bt)*ONE_OVER_LAPSE_SQRT_4PI;
  smallb[SMALLBY] = (U[BY_CENTER]*ONE_OVER_U0 + U[VY]*alpha_sqrt_4pi_bt)*ONE_OVER_LAPSE_SQRT_4PI;
  smallb[SMALLBZ] = (U[BZ_CENTER]*ONE_OVER_U0 + U[VZ]*alpha_sqrt_4pi_bt)*ONE_OVER_LAPSE_SQRT_4PI;
  // Eq. 23 in http://arxiv.org/pdf/astro-ph/0503420.pdf, with alpha sqrt (4 pi) b^2 = u_i B^i already computed above
  smallb[SMALLBT] = alpha_sqrt_4pi_bt * ONE_OVER_LAPSE_SQRT_4PI;


  // b^2 = g_{\mu \nu} b^{\mu} b^{\nu}
  //     = gtt bt^2 + gxx bx^2 + gyy by^2 + gzz bz^2 + 2 (gtx bt bx + gty bt by + gtz bt bz + gxy bx by + gxz bx bz + gyz by bz)
  //     = (-al^2 + gamma_{ij} betai betaj) bt^2 + b^i b^j gamma_{ij} + 2 g_{t i} b^t b^i
  //     = - (alpha b^t)^2 + (b^t)^2 gamma_{ij} beta^i beta^j + b^i b^j gamma_{ij} + 2 b^t g_{t i} b^i
  //     = - (alpha b^t)^2 + (b^t)^2 gamma_{ij} beta^i beta^j + b^i b^j gamma_{ij} + 2 b^t (gamma_{ij} beta^j) b^i
  //     = - (alpha b^t)^2 + gamma_{ij} ((b^t)^2 beta^i beta^j + b^i b^j + 2 b^t beta^j b^i)
  //     = - (alpha b^t)^2 + gamma_{ij} ((b^t)^2 beta^i beta^j + 2 b^t beta^j b^i + b^i b^j)
  //     = - (alpha b^t)^2 + gamma_{ij} (b^i + b^t beta^i) (b^j + b^t beta^j)
  CCTK_REAL bx_plus_shiftx_bt = smallb[SMALLBX]+METRIC[SHIFTX]*smallb[SMALLBT];
  CCTK_REAL by_plus_shifty_bt = smallb[SMALLBY]+METRIC[SHIFTY]*smallb[SMALLBT];
  CCTK_REAL bz_plus_shiftz_bt = smallb[SMALLBZ]+METRIC[SHIFTZ]*smallb[SMALLBT];
  smallb[SMALLB2] = -SQR(METRIC_LAP_PSI4[LAPSE]*smallb[SMALLBT]) +
    (  METRIC[GXX]*SQR(bx_plus_shiftx_bt) + METRIC[GYY]*SQR(by_plus_shifty_bt) + METRIC[GZZ]*SQR(bz_plus_shiftz_bt) +
       2.0*( METRIC[GXY]*(bx_plus_shiftx_bt)*(by_plus_shifty_bt) +
             METRIC[GXZ]*(bx_plus_shiftx_bt)*(bz_plus_shiftz_bt) +
             METRIC[GYZ]*(by_plus_shifty_bt)*(bz_plus_shiftz_bt) )  ) * METRIC_LAP_PSI4[PSI4]; // mult by psi4 because METRIC[GIJ] is the conformal metric.
  /***********************************************************/
}

// Robust functions to check for nans and infinities even when
// the --ffast-math compilation flag (e.g., -Ofast) is enabled.
// Special thanks to Roland Haas for providing the code for
// robust_isnan(). robust_isfinite() is based on robust_isnan(),
// with modifications inspired by chux's reply to this question:
// https://stackoverflow.com/questions/36150514/check-if-a-number-is-inf-or-nan
static inline int robust_isnan(double x) {
  unsigned long *pbits = (unsigned long *)&x;
  return( (*pbits & 0x7ff0000000000000UL) == 0x7ff0000000000000UL &&
          (*pbits & 0x000fffffffffffffUL) );
}

static inline int robust_isfinite(double x) {
  unsigned long *pbits = (unsigned long *)&x;
  return( !((*pbits & 0x7ff0000000000000UL) == 0x7ff0000000000000UL &&
           ((*pbits & 0x7ff0000000000000UL) || (*pbits & 0xfff0000000000000UL))) );
}

#endif // INLINED_FUNCTIONS_H_
