1bh solution is solved for two potentials psi and alpha.  

Convergence tests are done for 
(1) incleasing r grid points only (A1-A5)
(2) incleasing theta grid points only (B1-B4)
(3) incleasing all grid points (G1-G3) (Antonios's choice)
(4) incleasing all grid points (D1-D4) (new choice)

Convergence test are done also for 
(5) incleasing phi grid points only
(6) the same as (1) and (2) but with nlg = 4
For the cases (5) and (6), values of psi and alpha didn't change at all.  

The convergence tests (1), (2), (3) are also done for an improved code 
in which the 3rd order finite difference formula is used for 
the radial derivative of the source term of volume integral for alpha. 
(The 4th order FD formula is also used but the results didn't change at all.)

From these convergence tests, we found the followings: 
- the error of psi, and the error of the asymptotic of alpha 
  is improved by increasing the number of theta grid points only.   
  see, plot_2pot_error_psi_B1234_2nd.eps 
       plot_2pot_error_psi_A12345_2nd.eps
- The error of alpha near BH 
  is improved by increasing the number of r grid points only.   
  see, plot_2pot_error_alpha_B1234_2nd.eps 
       plot_2pot_error_alpha_A12345_2nd.eps
- The error of alpha near BH systematically increase as 
  getting closer to BH.
- The error of alpha near BH decreases by replacing FD formula 
  of the radial derivatives in volume source term for alpha
  from 2nd order formula to 3rd order formula.  
  (It didn't decreased by replacing 3rd to 4th.)
- It seems reasonable to chose with 3rd order formula 
  r grid points as many as A4, and theta 
  theta grid points as many as B3.  
  Parameter sets D3 is chosen to be like that.  

Figures with name tags
'A12345' corresponds to (1) increase r grid points only 
'B1234'  corresponds to (2) increase theta grid points only 
'G123'   corresponds to (3) inclease all grid points
'D1234'   corresponds to (4) inclease all grid points

'2nd' uses 2nd order FD formula for the all deriavtives 
      in the source terms of the volume integral of alpha. 
'3rd' uses 3rd order FD formula for the radial deriavtives 
      in the source terms of the volume integral of alpha. 

---------------------------------------------------
==> A1/rnspar.dat <==
   24   48   96   12           : nrg, ntg, npg, nlg
    8   48   96   12           : nrf, ntf, npf, nlf
   30   10   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> A2/rnspar.dat <==
   48   48   96   12           : nrg, ntg, npg, nlg
   16   48   96   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> A3/rnspar.dat <==
   96   48   96   12           : nrg, ntg, npg, nlg
   32   48   96   12           : nrf, ntf, npf, nlf
   30   40   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> A4/rnspar.dat <==
  192   48   96   12           : nrg, ntg, npg, nlg
   64   48   96   12           : nrf, ntf, npf, nlf
   30   80   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> A5/rnspar.dat <==
  384   48   96   12           : nrg, ntg, npg, nlg
  128   48   96   12           : nrf, ntf, npf, nlf
   30  160   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
---------------------------------------------------
==> B1/rnspar.dat <==
   48   24   96   12           : nrg, ntg, npg, nlg
   16   24   96   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> B2/rnspar.dat <==
   48   48   96   12           : nrg, ntg, npg, nlg
   16   48   96   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> B3/rnspar.dat <==
   48   96   96   12           : nrg, ntg, npg, nlg
   16   96   96   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> B4/rnspar.dat <==
   48  192   96   12           : nrg, ntg, npg, nlg
   16  192   96   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
---------------------------------------------------
==> G1/rnspar.dat <==
   60   30   60   10           : nrg, ntg, npg, nlg
    8   30   60   10           : nrf, ntf, npf, nlf
   30   10   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> G2/rnspar.dat <==
  120   60  120   10           : nrg, ntg, npg, nlg
   16   60  120   10           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> G3/rnspar.dat <==
  240  120  240   10           : nrg, ntg, npg, nlg
   32  120  240   10           : nrf, ntf, npf, nlf
   30   40   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
---------------------------------------------------
==> D1/rnspar.dat <==
   48   24   24   12           : nrg, ntg, npg, nlg
   16   24   24   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> D2/rnspar.dat <==
   96   48   48   12           : nrg, ntg, npg, nlg
   32   48   48   12           : nrf, ntf, npf, nlf
   30   40   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> D3/rnspar.dat <==
  192   96   96   12           : nrg, ntg, npg, nlg
   64   96   96   12           : nrf, ntf, npf, nlf
   30   80   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
==> D4/rnspar.dat <==
  384  192  192   12           : nrg, ntg, npg, nlg
  128  192  192   12           : nrf, ntf, npf, nlf
   30  160   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
---------------------------------------------------
==> E1_rgout=10E6/rnspar_mpt1.dat <==
   48   24   24   12           : nrg, ntg, npg, nlg
   16   24   24   12           : nrf, ntf, npf, nlf
   30   20   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point

==> E2_rgout=10E6/rnspar_mpt1.dat <==
   96   48   48   12           : nrg, ntg, npg, nlg
   32   48   48   12           : nrf, ntf, npf, nlf
   30   40   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point

==> E3_rgout=10E6/rnspar_mpt1.dat <==
  192   96   96   12           : nrg, ntg, npg, nlg
   64   96   96   12           : nrf, ntf, npf, nlf
   30   80   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point

==> E4_rgout=10E6/rnspar_mpt1.dat <==
  384  192  192   12           : nrg, ntg, npg, nlg
  128  192  192   12           : nrf, ntf, npf, nlf
   30  160   JB   XZ           : nrf_deform, nrgin, NS_shape, EQ_point
---------------------------------------------------
