PROGRAM read_BNS_seq
  IMPLICIT NONE
  real(8)  :: pi = 3.141592653589793d+0
  real(8)  :: g = 6.67428d-08
  real(8)  :: c = 2.99792458d+10
  real(8)  :: msol   = 1.98892d+33
  real(8)  :: solmas = 1.98892d+33

  character(LEN=100) :: inputfile, cmd, tempchar1, tempchar2
  character(len=1) :: ch 
  integer :: nmaxp, ndata
  real(8), allocatable :: seqdata(:,:,:)
  integer, allocatable :: np(:)
!  real(8) :: compa, emdc, rho0, rhocgs, pre, ene, &
!         &   radi, radicgs, restmass_sph, propermass_sph,adm
  integer :: stat, i, j, k, nlines, narg, iseq, mnp
!
  narg=command_argument_count()
!  write(6,*)  narg
  if (narg.eq.0) then
    write(6,*) "Usage: $./a.out file_seq1.txt file_seq2.txt ......"
    stop
  endif
!
! number of sequences: narg
! max points for every sequence: nmaxp=100
! total number of data for every point in the sequence: ndata=17
!  write(15,'(20es14.6)') omega, radius, m_rest, j_star, m_adm, m_kom, j_adm, &
!  &  m_grav_sph, m_rest_sph, M_R_sph, rhoc, qc, rhomax, qmax, chicusp, rsurf, rgmid
!
  nmaxp=100;  ndata=17 
  allocate (seqdata(nmaxp, ndata, narg))
  allocate (np(narg))   ! stores the number of points in a sequence
  seqdata = 0.0d0
  np = 0
!
  mnp=100
  do iseq=1, narg
    call get_command_argument(iseq,inputfile)
! 
    nlines = 0
    cmd = "cat " // trim(inputfile) // " | grep '[^ ]' | wc -l > nlines.txt"
    call system(cmd)
    open(1,file='nlines.txt')
    read(1,*) nlines
    write(6,'(a21,i3,a12,a40)') "#Number of lines are ", nlines, "       file:", trim(inputfile)
    cmd = 'rm nlines.txt'
    call system(cmd) 
!
    open(3, file=inputfile, status='unknown')
    i=1
    do k=1,nlines
      read(3,'(a1)',advance='no') ch
      if (ch=='#') then
        read(3,'(a1)') ch
      else
        read(3,'(100es14.6)')  (seqdata(i,j,iseq), j=1,ndata)
        if (k==nlines)   np(iseq)=i
        i=i+1
      end if
    enddo 
    close(3)
! 
    if(np(iseq)<mnp)   mnp=np(iseq)      ! min number of points of all seq
!
    write(6,'(a17,i3)') "#Sequence number:", iseq
    do i=1,np(iseq)
      write(6,'(a1,i2,100es14.6)')  "#", i, (seqdata(i,j,iseq), j=1,ndata)
    enddo
  end do  

!  open(10, file="aaa", status='unknown')
  write(6,'(a53,a78)') "# omega, radius, m_rest, j_star, m_adm, m_kom, j_adm,", &
  &  "m_grav_sph, m_rest_sph, M_R_sph, rhoc, qc, rhomax, qmax, chicusp, rsurf, rgmid"
  
  write(6,'(a73)') "#***************** Make sure which is the first sequence *****************"
  write(6,'(a1)') "#"
  do k=1,mnp
    write(6,'(100e14.6)') (seqdata(k,1,i)/seqdata(k,2,i), i=1,narg), &     ! omega
!       &                  (seqdata(k,16,i), i=1,narg),               &     ! r_surf
       &                  (seqdata(k, 8,i), i=1,narg),               &     ! m_grav_sph
       &                  (seqdata(k, 5,i), i=1,narg),               &     ! m_adm
       &                  (seqdata(k, 7,i), i=1,narg)                      ! j_adm
  end do
!  close(10)
!
  deallocate(seqdata)
  deallocate(np)
END PROGRAM read_BNS_seq 

