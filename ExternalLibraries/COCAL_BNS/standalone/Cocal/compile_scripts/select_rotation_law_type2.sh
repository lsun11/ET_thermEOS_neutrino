cp ../code/Subroutine/calc_omega_drot.f90_type1type2 \
   ../code/Subroutine/calc_omega_drot.f90
cp ../code/Subroutine/calc_omega_drot_bisection.f90_type1type2 \
   ../code/Subroutine/calc_omega_drot_bisection.f90
cp ../code/Subroutine/update_parameter_axisym_peos_drot.f90_type1type2 \
   ../code/Subroutine/update_parameter_axisym_peos_drot.f90

sed -i "s/!rotlaw_type2//g" ../code/Subroutine/calc_omega_drot.f90
sed -i "s/!rotlaw_type2//g" ../code/Subroutine/calc_omega_drot_bisection.f90
sed -i "s/!rotlaw_type2//g" ../code/Subroutine/update_parameter_axisym_peos_drot.f90
sed -i "s/!rotlaw_type12OJ//g" ../code/Subroutine/iteration_peos.f90
