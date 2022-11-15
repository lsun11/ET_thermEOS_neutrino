cp n03_JB_C010_nr64_rnsphyplot_pickup.dat rnsphyplot_all_input.dat

./exe_secular < parameters/param_1.00

mv rnsphyplot_all.dat n03_EXT_C010_nr64_rnsphyplot.dat
mv rnsphy_paper.dat   n03_secular_C010_nr64_rnsphy_paper.dat

cp n03_JB_C014_nr64_rnsphyplot_pickup.dat rnsphyplot_all_input.dat

./exe_secular < parameters/param_0.99

mv rnsphyplot_all.dat n03_EXT_C014_nr64_rnsphyplot.dat
mv rnsphy_paper.dat   n03_secular_C014_nr64_rnsphy_paper.dat

cp n03_JB_C020_nr64_rnsphyplot_pickup.dat rnsphyplot_all_input.dat

./exe_secular < parameters/param_0.99

mv rnsphyplot_all.dat n03_EXT_C020_nr64_rnsphyplot.dat
mv rnsphy_paper.dat   n03_secular_C020_nr64_rnsphy_paper.dat
