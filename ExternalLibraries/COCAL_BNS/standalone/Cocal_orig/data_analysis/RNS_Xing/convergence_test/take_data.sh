rm data.dat.tmp
cp raw_data/C0296_AR0875_nr16_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0875_nr24_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0875_nr32_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0875_nr48_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0875_nr64_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp data.dat.tmp data.dat.all.0.875_rtsimpson

rm data.dat.tmp
cp raw_data/C0296_AR0750_nr16_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0750_nr24_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0750_nr32_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0750_nr48_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0750_nr64_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp data.dat.tmp data.dat.all.0.750_rtsimpson

rm data.dat.tmp
cp raw_data/C0296_AR0625_nr16_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0625_nr24_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0625_nr32_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0625_nr48_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp raw_data/C0296_AR0625_nr64_rnsphyplot_all.dat rnsphyplot_all_input.dat
./ahotest_take_data < param_take_data.dat
cat data.dat >> data.dat.tmp
cp data.dat.tmp data.dat.all.0.625_rtsimpson
