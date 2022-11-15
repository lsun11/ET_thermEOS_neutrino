MODULE FUNC
  IMPLICIT NONE
  CONTAINS
  FUNCTION fun(x,c0,c1,c2,c3)
    REAL(8) :: fun   ! function type
    REAL(8), INTENT( IN ) :: x,c3,c2,c1,c0
    fun = c3*x**3 + c2*x**2 + c1*x + c0
  END FUNCTION fun
END MODULE FUNC

module secant
  use func
  IMPLICIT NONE
  contains 
  function seca(c0,c1,c2,c3)
    real(8) :: seca
    real(8), intent(in) :: c0,c1,c2,c3
    real(8) :: f1,f2, xa,xb,fa,fb,eps,delta
    integer :: i, j, iter, Nmax=50
    eps= 5.0d-07
    xa = 1.0d+00;   xb =2.0d+00
    fa = fun(xa,c0,c1,c2,c3); fb = fun(xb,c0,c1,c2,c3)
!    write(6,*) c0,c1,c2,c3
    if ( dabs(fa)>dabs(fb) ) then  ! interchange xa,xb  and fa,fb
      f1 = xa
      xa = xb
      xb = f1
      f1 = fa
      fa = fb
      fb = f1
    endif
!   write(6,*) '------------------------------------------------------------------------------------------'
!   write(6,*) '          n','          ','xn','                    ','fn'
!   write(6,*) 0,xa,fa
!   write(6,*) 1,xb,fb
    do i = 2,Nmax
      if ( dabs(fa)>dabs(fb) ) then
        f1 = xa
        xa = xb
        xb = f1
        f1 = fa
        fa = fb
        fb = f1
      end if
      delta = (xb-xa)/(fb-fa)
      xb = xa
      fb = fa
      delta = delta*fa
      if ( dabs(delta) < eps ) then
        seca = xa
        write(6,*) c0,c1,c2,c3, seca
!       write(6,*) 'Convergence'
!       write(6,*) '------------------------------------------------------------------------------------------'
        return
      end if
      xa = xa - delta
      fa = fun(xa,c0,c1,c2,c3)
!     write(6,*) i,xa,fa
    end do
    write(6,*) 'No convergence after ',Nmax,' iterations.'
    seca = -1.0
  end function seca
end module secant


PROGRAM construct_seq
  use secant
  IMPLICIT NONE
  real(8)  :: pi = 3.141592653589793d+0
  real(8)  :: g = 6.67428d-08
  real(8)  :: c = 2.99792458d+10
  real(8)  :: msol   = 1.98892d+33
  real(8)  :: solmas = 1.98892d+33
  character(LEN=100) :: inputfile, cmd, tempchar1, tempchar2
  character(len=5) :: chy,chx
  character(len=1) :: char1
  integer  :: Norb, stat, i, j, k, nlines, narg
  real (8) :: sf, dmdj, ds, ome
  real (8) :: omega(50), radius(50), m_rest(50), j_star(50), m_adm(50), m_kom(50), j_adm(50), &
           &  m_grav_sph(50), m_rest_sph(50), M_R_sph(50), rhoc(50), qc(50), rhomax(50), qmax(50), &
           &  chicusp(50), rsurf(50), rgmid(50)
  real (8) :: c0,c1,c2,c3 
!
  narg=command_argument_count()
!  write(6,*)  narg
  if (narg.ne.1) then
    write(6,*) "The argument must be 1: filename "
    stop
  endif
!
! we want the max of column ycol.
  call get_command_argument(1,inputfile)
  write(6,'(a8,a20,i3,i3)')  "#Input: ", inputfile
  nlines = 0
  cmd = "cat " // trim(inputfile) // " | grep '[^ ]' | wc -l > nlines.txt"
  call system(cmd)
  open(1,file='nlines.txt')
  read(1,*) nlines
  write(6,'(a21,i3)') "#Number of lines are ", nlines
  cmd = 'rm nlines.txt'
  call system(cmd)

  i=1
  open(1,file=inputfile,status='old')
  do j=1,nlines
    read(1,'(a1)') char1
    if ( char1.ne."#" ) then
      backspace(1)
      read(  1,'(20es14.6)') omega(i), radius(i), m_rest(i), j_star(i), m_adm(i), m_kom(i), j_adm(i), &
         &  m_grav_sph(i), m_rest_sph(i), M_R_sph(i), rhoc(i), qc(i), rhomax(i), qmax(i), chicusp(i), &
         &  rsurf(i), rgmid(i)
      i=i+1
    end if
  end do
  close(1)
  Norb=i-1
  write(6,'(a5,i3)') "Norb=", Norb
!
  do i=1,Norb
    write( 6,'(20es14.6)') omega(i), radius(i), m_rest(i), j_star(i), m_adm(i), m_kom(i), j_adm(i), &
       &  m_grav_sph(i), m_rest_sph(i), M_R_sph(i), rhoc(i), qc(i), rhomax(i), qmax(i), chicusp(i), &
       &  rsurf(i), rgmid(i)
  end do
  write(6,*) '------------------------------------------------------------------------------------------'
  cmd = "dmdj_" // trim(inputfile)
  open(2,file=cmd,status='unknown')
  do i=2,Norb-1
    dmdj = (m_adm(i+1)-m_adm(i-1))/(j_adm(i+1)-j_adm(i-1))
    ds   = 2.0d0*rgmid(i)/rsurf(i)
    ome  = omega(i)/radius(i)
    write(2,'(i3,3es14.6)') i, ds, dmdj, ome
  end do 
  close(2)

!
!  do i=1,Norb-1
!    c3 = new_omega(i)*ang_mom_inf(i+1)
!    c2 = omega(i+1)*ang_mom_inf(i+1) - 2.0d0*adm_inf(i+1)
!    c1 = 2.0d0*new_adm_inf(i) - new_omega(i)*new_ang_mom_inf(i)
!    c0 = -omega(i+1)*new_ang_mom_inf(i)
!    sf = seca(c0,c1,c2,c3)
!    if (sf.le.0) then
!      write(6,*) 'Scaling factor <= 0'
!      exit
!    end if
!  end do 

  write(6,'(17a14)') "omega","radius","m_rest","j_star","m_adm","m_kom","j_adm",  &
   & "m_grav_sph","m_rest_sph","M_R_sph","rhoc","qc","rhomax","qmax","chicusp","rsurf","rgmid" 
!
END PROGRAM construct_seq


