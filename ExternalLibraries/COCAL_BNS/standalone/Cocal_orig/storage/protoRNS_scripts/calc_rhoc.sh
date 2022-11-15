num_tot_seq=10   # Requested TOTAL number of sequences (TOV points). TOTAL number of vertical sequences.
num_sec=3        # Number of processors each RNS script will use. Number of initial TOV points for each node. 
direc=~/IWM/BNSnem/    # where RNS_CFpeos_rho_sec_v4.sh script is.

# Range of densities where RS solutions will be searched for.
rhoca=$(echo "0.1*10^(15)" | bc -l)  
rhocb=$(echo "2.3*10^(15)" | bc -l)

drhoc=$(echo "($rhocb-$rhoca)/($num_tot_seq-1)" | bc -l)
echo "==================================================="
echo "Requested total number of sequences  = $num_tot_seq"
echo "Number of processors for each script = $num_sec"
echo "Starting density rhoca=" $(printf "%1.5e\n" "$rhoca")
echo "Ending density rhocb  =" $(printf "%1.5e\n" "$rhocb")
echo "Step density drhoc    =" $(printf "%1.5e\n" "$drhoc")
echo "==================================================="
cd ${direc}

inode=1
for ((j=0; j < ${num_tot_seq}; j++))
do
  rhoc1=$(echo "$rhoca + ($j)*($drhoc)" | bc -l)
  rhoc=$(printf "%1.5e\n"  "$rhoc1")
  drhoc_sci=$(printf "%1.5e\n" "$drhoc")

  ii=$(echo "($j)%($num_sec)" | bc)  
  if [ $ii -eq 0 ]; then
    echo "Node=$inode ------> starts at density:" $(printf "%1.5e\n" "$rhoc")

    cp RNS_CFpeos_rho_sec_v4.sh  RNS_CFpeos_rho_sec_v4_${inode}.sh
    sed -i "s/iNODE/$inode/g"                RNS_CFpeos_rho_sec_v4_${inode}.sh
    sed -i "s/NUMBER_TOV_POINTS/$num_sec/g"  RNS_CFpeos_rho_sec_v4_${inode}.sh

    rhoc_bc=$(echo $rhoc | sed -e 's/[eE]+/\*10\^/' )
    sed -i "s/STARTING_DENSITY/$rhoc_bc/g"   RNS_CFpeos_rho_sec_v4_${inode}.sh
    drhoc_bc=$(echo $drhoc_sci | sed -e 's/[eE]+/\*10\^/' )
    sed -i "s/STEP_DENSITY/$drhoc_bc/g"      RNS_CFpeos_rho_sec_v4_${inode}.sh

    inode=$((inode+1))
  fi
  echo "  Sequence:$((j+1))  at density" $(printf "%1.5e\n" "$rhoc")

done


