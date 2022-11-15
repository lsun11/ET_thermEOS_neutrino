subroutine sourceterm_HaC_peos_spin(sou)
  use phys_constant, only : long, pi
  use grid_parameter, only : nrg, ntg, npg
  use def_metric
  use def_matter, only : emdg, jomeg_int, vepxg, vepyg, vepzg
  use def_matter_parameter, only : ome, ber, radi, confpow
  use def_velocity_rot
  use def_vector_phi
  use interface_interpo_linear_type0
  implicit none
  real(long), pointer :: sou(:,:,:)
  real(long) :: emdgc, rhogc, pregc, hhgc, utgc, rhoHc, zfac
  real(long) :: psigc, alpgc, alpsigc, aijaij, ene, jomeg_intgc
  real(long) :: vphig(3), ovdgc(3), bvxdgc, bvydgc, bvzdgc
  real(long) :: vepxgc, vepygc, vepzgc, lam
  real(long) :: wxgc, wygc, wzgc, psigc4, psigcp, alpgc2, dvep2, wdvep, w2, &
       &        wterm, uih2, hut  
  integer    :: irg, itg, ipg
!
! --- Source of the Hamiltonian constraint to compute 
!     the conformal factor psi.
!
  do ipg = 1, npg
    do itg = 1, ntg
      do irg = 1, nrg
        call interpo_linear_type0(emdgc,emdg,irg,itg,ipg)
        call interpo_linear_type0(vepxgc ,vepxg ,irg,itg,ipg)
        call interpo_linear_type0(vepygc ,vepyg ,irg,itg,ipg)
        call interpo_linear_type0(vepzgc ,vepzg ,irg,itg,ipg)
        call interpo_linear_type0(jomeg_intgc,jomeg_int,irg,itg,ipg)
        call interpo_linear_type0(psigc,psi,irg,itg,ipg)
        call interpo_linear_type0(alpgc,alph,irg,itg,ipg)
        call interpo_linear_type0(bvxdgc,bvxd,irg,itg,ipg)
        call interpo_linear_type0(bvydgc,bvyd,irg,itg,ipg)
        call interpo_linear_type0(bvzdgc,bvzd,irg,itg,ipg)
        call interpo_linear_type0(wxgc,wxspg,irg,itg,ipg)
        call interpo_linear_type0(wygc,wyspg,irg,itg,ipg)
        call interpo_linear_type0(wzgc,wzspg,irg,itg,ipg)

        aijaij = tfkijkij(irg,itg,ipg)
        zfac = 1.0d0
        if (emdgc <= 1.0d-15) then 
          emdgc = 1.0d-15
          zfac  = 0.0d0
        end if
        call peos_q2hprho(emdgc, hhgc, pregc, rhogc, ene)

        vphig(1) = hvec_phig(irg,itg,ipg,1)
        vphig(2) = hvec_phig(irg,itg,ipg,2)
        vphig(3) = hvec_phig(irg,itg,ipg,3)
        ovdgc(1) = bvxdgc + ome*vphig(1)
        ovdgc(2) = bvydgc + ome*vphig(2)
        ovdgc(3) = bvzdgc + ome*vphig(3)
        lam      = ber + ovdgc(1)*vepxgc + ovdgc(2)*vepygc + ovdgc(3)*vepzgc  
        psigc4   = psigc**4
        psigcp   = psigc**confpow
        alpgc2   = alpgc**2

        dvep2    = (vepxgc**2 + vepygc**2 + vepzgc**2)/psigc4
        wdvep    = (wxgc*vepxgc + wygc*vepygc + wzgc*vepzgc)*psigcp
        w2       = psigc4*(wxgc*wxgc + wygc*wygc + wzgc*wzgc)*psigcp**2.0d0

        wterm    = wdvep + w2
        uih2     = dvep2 + 2.0d0*wdvep + w2

        if ( (lam*lam + 4.0d0*alpgc2*wterm)<0.0d0 ) then
          write(6,*)  "hut imaginary....exiting"
          stop
        end if
        hut = (lam + sqrt(lam*lam + 4.0d0*alpgc2*wterm))/(2.0d0*alpgc2)

        utgc = hut/hhgc
   
        rhoHc = hhgc*rhogc*(alpgc*utgc)**2 - pregc
!
        sou(irg,itg,ipg) = - 0.125d0*psigc**5*aijaij &
      &                    - radi**2*2.0d0*pi*psigc**5*rhoHc*zfac
      end do
    end do
  end do
end subroutine sourceterm_HaC_peos_spin

