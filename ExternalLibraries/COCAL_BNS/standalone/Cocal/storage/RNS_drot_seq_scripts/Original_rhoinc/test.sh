name_flag=H2
param_dir_name=../parameter_sample/RNS_CF
work_dir_name=work_area_RNS
ctrl_dir_name=ctrl_area_RNS

num_seq_ini=1
num_seq_end=45
num_seq_inc=1
dir_flag=(`seq -f %02g $num_seq_ini $num_seq_inc $num_seq_end`)
echo "${dir_flag[@]}"
num_deform_ini=60
num_deform_end=44
num_deform_inc=-4
deform_par=(`seq -f %02g $num_deform_ini $num_deform_inc $num_deform_end`)
num_deform_ini=40
num_deform_end=1
num_deform_inc=-1
deform_par+=(`seq -f %02g $num_deform_ini $num_deform_inc $num_deform_end`)
echo "${deform_par[@]}"
