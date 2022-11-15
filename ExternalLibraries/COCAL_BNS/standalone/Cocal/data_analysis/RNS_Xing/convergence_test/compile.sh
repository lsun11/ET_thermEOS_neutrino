#! /usr/bin/tcsh -f
#pgf77 -Bstatic -fastsse -tp athlonxp -r8 -o ahotest GR_IRDR_ver4.f
#g77 -fno-automatic -O -o ahotest GR_IRDR_ver4.f
#pgf77 -Bstatic -fastsse -tp k8-64 -o ahotest GR_KEH_NS_ver1.f
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_2nd extrapolate_2ndod.f90
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_3rd extrapolate_3rdod.f90
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_4th extrapolate_4thod.f90
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_index conv_index_NR.f90
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_conv simple_convtest.f90
cd ../../code
/opt/intel/fce/9.1.040/bin/ifort -fast -o ahotest_take_data take_data.f90
mv ahotest_take_data ../analysis/convergence_test/.
##mv ahotest ../work_area/.
