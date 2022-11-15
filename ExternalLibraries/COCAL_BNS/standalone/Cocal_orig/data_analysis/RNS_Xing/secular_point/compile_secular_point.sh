#! /usr/bin/tcsh -f
#g77 -fno-automatic -O -o ahotest GR_IRDR_ver4.f
#pgf77 -Bstatic -fastsse -tp k8-64 -o ahotest GR_KEH_NS_ver1.f

cd ../../code
/opt/intel/fce/9.1.040/bin/ifort -fast -o exe_secular find_secular_point.f90

mv exe_secular ../analysis/secular_point/.
rm *.mod
